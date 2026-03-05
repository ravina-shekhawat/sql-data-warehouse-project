/*
=========================================================================================================
Quality Checks
=========================================================================================================
Script Purpose:
   This script performs various quality checks for data consistency , accuracy, and standardization across 
   the 'silver' schema. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
- Run these checks after data loading Silver Layer.
- Investigate and resolve any discrepancies found during the checks.

=========================================================================================================
*/
-- =======================================================================================
-- Checking 'silver.crm_cust_info'
-- =======================================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation : No Results
SELECT cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 
OR cst_id is null

-- Checking Unwanted spaces 
SELECT 
cst_firstname
FROM silver.crm_cust_info
where cst_firstname != trim(cst_firstname)
;
SELECT 
cst_lasttname
FROM silver.crm_cust_info
where cst_lastname != trim(cst_lastname)
;

-- Data Standardization & Consistency
SELECT DISTINCT
cst_marital_status
FROM silver.crm_cust_info
;
SELECT DISTINCT
cst_gndr
FROM silver.crm_cust_info;

-- =======================================================================================
-- Checking 'silver.crm_prd_info'
-- =======================================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation : No Results

SELECT prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) > 1 
OR prd_id is null

-- Checking Unwanted spaces 
SELECT 
cat_id
FROM silver.crm_prd_info
where cat_id != trim(cat_id)
;
SELECT 
prd_key
FROM silver.crm_prd_info
where prd_key != trim(prd_key)
;

-- Data Standardization & Consistency
SELECT DISTINCT
prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
SELECT * FROM 
silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt
;

-- =======================================================================================
-- Checking 'silver.crm_sales_details_info'
-- =======================================================================================
-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_sales_details_info
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- =======================================================================================
-- Checking 'silver.erp_cust_az12'
-- =======================================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation : No Results
SELECT cid,
COUNT(*)
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1 
OR cid is null;
-- Check for Invalid Birthday Dates
SELECT bdate
FROM silver.erp_cust_az12
WHERE  bdate > GETDATE()

-- Data Standardization & Consistency
select distinct
gen
FROM silver.erp_cust_az12;

-- =======================================================================================
-- Checking 'silver.erp_loc_a101'
-- =======================================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation : No Results
SELECT cid,
COUNT(*)
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1 
OR cid is null;

-- Data Standardization & Consistency
SELECT DISTINCT
cntry
FROM silver.erp_loc_a101;

-- =======================================================================================
-- Checking 'silver.erp_px_cat_g1v2;'
-- =======================================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation : No Results
SELECT id,
COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1 
OR id is null;

-- Data Standardization & Consistency
select distinct
cat
FROM silver.erp_px_cat_g1v2
;
select distinct
maintenance
FROM silver.erp_px_cat_g1v2
;




















