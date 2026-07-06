/*
======================================================================
SCRIPT - Load Clean Layer 
======================================================================
Project     : NAVA Data Warehouse
Script      : data_quality.sql

Description :

Runs data quality checks across the clean and analytics layers.

These checks validate:
  - Null or duplicate primary keys.
  - Unwanted spaces in string fields.
  - Data standardization and consistency.
  - Invalid date ranges and orders.
  - Data consistency between related fields.

The script is designed for review and validation purposes.
It does not modify, insert, update or delete any data.
======================================================================
*/

-- ===================================================================
-- Checking 'fact_sales'
-- ===================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT 
  order_line_id,
  COUNT(*) 
FROM NAVA_clean.sales
GROUP BY order_line_id
HAVING COUNT(*) > 1 OR order_line_id IS NULL;

-- Check for Unwanted Spaces and carriage returns
-- Expectation: No Results

SELECT 
  postal_code
FROM NAVA_clean.sales
WHERE postal_code != TRIM(postal_code)
  OR postal_code LIKE CONCAT('%', CHAR(13), '%')
  OR postal_code LIKE CONCAT('%', CHAR(10), '%');

-- Data Standardization & Consistency
-- Expectation: No Results

SELECT DISTINCT ship_mode
FROM NAVA_clean.sales;

SELECT DISTINCT discount_type
FROM NAVA_clean.sales;

-- Check for Invalid Date Orders (Order Date > Shipping > delivery)
-- Expectation: No Results

SELECT 
  * 
FROM NAVA_clean.sales
WHERE order_date > ship_date
   OR ship_date > delivery_date;

-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No Results

SELECT DISTINCT
  quantity,
  unit_price,
  net_sales,
  ROUND(net_sales,1),
  ROUND(quantity * (unit_price * (1- discount)),1)
FROM NAVA_clean.sales
WHERE (ROUND(net_sales,0) - ROUND(quantity * (unit_price * (1- discount)),0))>1
  OR net_sales IS NULL 
  OR quantity IS NULL 
  OR unit_price IS NULL
  OR net_sales <= 0 
  OR quantity <= 0 
  OR unit_price <= 0
ORDER BY net_sales, quantity, unit_price;

-- ===================================================================
-- Checking 'fact_returns'
-- ===================================================================
