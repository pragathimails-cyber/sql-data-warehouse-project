/*
================================================================================
Quality Checks
================================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
================================================================================
*/


USE Datawarehouse;
SELECT
    cst_id,
    COUNT(*)
FROM (
SELECT
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_materialstatus,
        ci.cst_gndr,
        ci.cst_create_date,
        ca.bdate,
        ca.gen,
        la.cntry
    FROM silver.crm_cust_info ci
        LEFT JOIN silver.erp_cust_az12 ca
        ON  ci.cst_key = ca.cid
        LEFT JOIN silver.erp_loc_a101 la
        ON  ci.cst_key = la.cid)t
GROUP BY cst_id
HAVING COUNT(*) > 1;


-- data integration because we have two columns in the same values so we have to do data integration (gender)

SELECT DISTINCT
    ci.cst_gndr,
    ca.gen,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS new_gen
FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
    ON  ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 la
    ON  ci.cst_key = la.cid
ORDER BY 1,2

SELECT DISTINCT gender FROM gold.dim_customers;
SELECT * FROM gold.dim_customers
  


--- Prod_info Join

SELECT
    prd_id,
    COUNT(*)
FROM(SELECT
    pi.prd_id,
    pi.cat_id,
    pi.prd_key,
    pi.prd_nm,
    pi.prd_cost,
    pi.prd_line,
    pi.prd_start_dt,
    ga.cat,
    ga.subcat,
    ga.maintenance
FROM silver.crm_prd_info pi
LEFT JOIN silver.erp_px_cat_g1v2 ga
ON  pi.cat_id = ga.id
WHERE prd_end_dt IS NULL)tab
GROUP BY prd_id
HAVING COUNT(*) > 1;

-- sales_plus_fact
SELECT * FROM gold.fact_sales
WHERE customer_key IS NULL

SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL

SELECT COUNT(*) FROM silver.crm_sales_details
SELECT * FROM gold.crm_sales_details
