/*
====================================================================================
DDL Script: Create Gold Views
====================================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema).

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
====================================================================================
*/

-- ====================================================================================
-- Create Dimension Table: gold.dim_customers
-- ====================================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE OR ALTER VIEW gold.dim_customers
AS
    SELECT
      
        ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
        ci.cst_id             AS customer_id,
        TRIM(ci.cst_key)      AS customer_number,
        TRIM(ci.cst_firstname) AS first_name,
        TRIM(ci.cst_lastname)  AS last_name,
        ISNULL(la.cntry, 'n/a') AS country,
        ci.cst_materialstatus  AS marital_status,
        CASE 
            WHEN ci.cst_gndr IS NOT NULL AND ci.cst_gndr != 'n/a' THEN ci.cst_gndr
            ELSE ISNULL(ca.gen, 'n/a')
        END                   AS gender,
        ca.bdate              AS birthdate,
        ci.cst_create_date    AS create_date
    FROM silver.crm_cust_info ci
   
    LEFT JOIN silver.erp_cust_az12 ca
        ON TRIM(ci.cst_key) = TRIM(ca.cid)
    LEFT JOIN silver.erp_loc_a101 la
        ON TRIM(ci.cst_key) = TRIM(la.cid);
GO

-- ====================================================================================
-- Create Dimension Table: gold.dim_products
-- ====================================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE OR ALTER VIEW gold.dim_products 
AS
    SELECT
        ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key,
        pi.prd_id            AS product_id,
        TRIM(pi.prd_key)     AS product_number,
        TRIM(pi.prd_nm)      AS product_name,
        TRIM(pi.cat_id)      AS category_id,
        ISNULL(pc.cat, 'n/a') AS category,
        ISNULL(pc.subcat, 'n/a') AS subcategory,
        ISNULL(pc.maintenance, 'n/a') AS maintenance,
        pi.prd_line          AS product_line,
        ISNULL(pi.prd_cost, 0) AS cost,
        pi.prd_start_dt      AS start_date
    FROM silver.crm_prd_info pi
    LEFT JOIN silver.erp_px_cat_g1v2 pc
        ON TRIM(pi.cat_id) = TRIM(pc.id)
    WHERE pi.prd_end_dt IS NULL;
GO

-- ====================================================================================
-- Create Fact Table: gold.fact_sales
-- ====================================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE OR ALTER VIEW gold.fact_sales
AS
  SELECT 
      sd.sls_ord_num AS order_number,
      p.product_key AS product_key,
      c.customer_key AS customer_key, 
      sd.sls_order_dt AS order_date,
      sd.sls_ship_dt AS ship_date,
      sd.sls_due_dt AS due_date,
      sd.sls_sales AS sales_amount,
      sd.sls_quantity AS quantity,
      sd.sls_price AS price
  FROM silver.crm_sales_details sd
  LEFT JOIN gold.dim_customers c
      ON sd.sls_cust_id = c.customer_id
  LEFT JOIN gold.dim_products p
      ON sd.sls_prod_key = p.product_number;
