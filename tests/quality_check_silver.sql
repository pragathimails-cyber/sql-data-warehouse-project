
/*
===============================================================================
Script: Quality Checks - Silver Layer
===============================================================================
Script Purpose:
    This script performs comprehensive data quality validation checks to ensure 
    consistency, accuracy, and structural integrity across the 'silver' schema.

    Validation scope includes:
    - Identifying NULL or duplicate values in primary keys.
    - Detecting trailing or leading whitespaces within string fields.
    - Validating data standardization and structural compliance.
    - Verifying chronological integrity (e.g., invalid date ranges and order sequences).
    - Cross-checking business rule logic across related database fields.

Usage Notes:
    - Execute this script immediately following the Silver layer ETL load process.
    - Investigate and resolve any data anomalies or discrepancies flagged by these queries.
===============================================================================
*/

-- Cust Info
SELECT
    *
FROM silver.crm_cust_info;

SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;


SELECT
    DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT
    cst_firstname,
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname) AND cst_lastname != TRIM(cst_lastname)

SELECT *
FROM silver.crm_cust_info


-- prod info

SELECT *
FROM silver.crm_prd_info;

SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

SELECT
    prd_id
FROM silver.crm_prd_info
WHERE prd_id IS NULL;

SELECT
    prd_nm,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_nm
HAVING COUNT(*) > 1 AND prd_nm IS NULL;

SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization and Consistency

SELECT
    prd_line
FROM silver.crm_prd_info
WHERE prd_line IS NULL

-- Check for invalid catch orders
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Sales info

USE DataWarehouse;

SELECT *
FROM silver.crm_sales_details;

SELECT
    sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL;

SELECT
    sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- CHECK FOR DATE
SELECT
    sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <=0;


SELECT
    NULLIF(sls_due_dt,0) AS sls_order_dt
FROM silver.crm_sales_details
WHERE sls_due_dt <=0 OR LEN(sls_due_dt) != 8
    OR sls_due_dt > 20500101 OR sls_due_dt < 19000101;

SELECT
    *
FROM silver.crm_sales_details
WHERE  sls_order_dt > sls_due_dt OR sls_order_dt > sls_ship_dt
;


--Business Rules

-- sales = quantity * price
-- Negative, zeros, nulls are not allowed

SELECT DISTINCT
    sls_quantity,
    sls_sales,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0 OR
    sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
    OR sls_sales != sls_quantity * sls_price
ORDER BY sls_sales,sls_quantity,sls_price

USE DataWarehouse;

--silver.erp_cust_az12

SELECT * FROM bronze.erp_cust_az12;

SELECT
    cid,
    COUNT(*)
FROM bronze.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;

SELECT
    cid
FROM bronze.erp_cust_az12
WHERE cid IS NULL;

-- REMOVING THE UNWANTED CHAR
SELECT
    cid,
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid,
    bdate,
    gen
FROM silver.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
    ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

-- bdate manipulate 

SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE() ;

--GENDER

SELECT
    DISTINCT gen
FROM silver.erp_cust_az12;

SELECT
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')   THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;

SELECT
    CASE
        WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) IN ('M', 'MALE')   THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;

SELECT * FROM silver.erp_cust_az12

-- erp_loc_101

SELECT * FROM bronze.erp_loc_a101;


WITH CleanedData AS (
    SELECT 
        -- Phase 1: Strip out hidden line breaks and extra spaces
        TRIM(
            REPLACE(
                REPLACE(cntry, CHAR(13), ''), 
                CHAR(10), ''
            )
        ) AS cleaned_cntry
    FROM bronze.erp_loc_a101
)
SELECT
    -- Phase 2: Standardize the variations and handle blank rows
    CASE 
        WHEN cleaned_cntry IN ('USA', 'US', 'United States') THEN 'United States'
        WHEN cleaned_cntry IN ('DE', 'Germany')             THEN 'Germany'
        WHEN cleaned_cntry = '' OR cleaned_cntry IS NULL     THEN 'n/a'
        ELSE cleaned_cntry -- Leaves France, Canada, Australia as-is
    END AS cntry
FROM CleanedData;

SELECT DISTINCT
cntry FROM silver.erp_loc_a101

-- g1v2 Data manipulating 

SELECT
    cat
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat);

SELECT
    subcat
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);


SELECT
    DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2;

WITH CleanedData AS (
    SELECT 
        
        TRIM(
            REPLACE(
                REPLACE(maintenance, CHAR(13), ''), 
                CHAR(10), ''
            )
        ) AS cleaned_maintenance
FROM bronze.erp_px_cat_g1v2
)
SELECT
    CASE 
        WHEN cleaned_maintenance IN ('Yes') THEN 'Yes'
        WHEN cleaned_maintenance IN ('No') THEN 'No'
        ELSE 'n/a'
    END AS maintenance
FROM CleanedData;




