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

-- Check for Unwanted Spaces or Carriage Returns
-- Expectation: No Results

SELECT 
  postal_code
FROM NAVA_clean.sales
WHERE postal_code != TRIM(postal_code)
  OR postal_code LIKE CONCAT('%', CHAR(13), '%')
  OR postal_code LIKE CONCAT('%', CHAR(10), '%');

-- Data Standardization & Consistency

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

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT 
  return_id,
  COUNT(*) 
FROM NAVA_clean.returns
GROUP BY return_id
HAVING COUNT(*) > 1 OR return_id IS NULL;

-- Check for Unwanted Spaces or Carriage Returns
-- Expectation: No Results

SELECT 
  order_id
FROM NAVA_clean.returns
WHERE order_id != TRIM(order_id)
  OR order_id LIKE CONCAT('%', CHAR(13), '%')
  OR order_id LIKE CONCAT('%', CHAR(10), '%');

-- Data Standardization & Consistency
-- Expectation: No Results

SELECT DISTINCT return_reason
FROM NAVA_clean.returns;

-- Check Data Consistency
-- Expectation: No Results

SELECT DISTINCT
  return_quantity,
  return_amount
FROM NAVA_clean.returns
WHERE return_amount IS NULL 
  OR return_quantity IS NULL ;

-- ===================================================================
-- Checking 'dim_location'
-- ===================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT 
  postal_code,
  COUNT(*) 
FROM NAVA_clean.location
GROUP BY postal_code
HAVING COUNT(*) > 1 OR postal_code IS NULL;

-- Check for Unwanted Spaces or Carriage Returns
-- Expectation: No Results

SELECT 
  postal_code
FROM NAVA_clean.location
WHERE postal_code != TRIM(postal_code)
  OR postal_code LIKE CONCAT('%', CHAR(13), '%')
  OR postal_code LIKE CONCAT('%', CHAR(10), '%');

-- Data Standardization & Consistency

SELECT DISTINCT country
FROM NAVA_clean.location;

-- ===================================================================
-- Checking 'dim_customers'
-- ===================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT 
  customer_id,
  COUNT(*) 
FROM NAVA_clean.customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- Check for Unwanted Spaces or Carriage Returns
-- Expectation: No Results

SELECT 
  postal_code
FROM NAVA_clean.customers
WHERE postal_code != TRIM(postal_code)
  OR postal_code LIKE CONCAT('%', CHAR(13), '%')
  OR postal_code LIKE CONCAT('%', CHAR(10), '%');

-- ===================================================================
-- Checking 'dim_products'
-- ===================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT 
  product_id,
  COUNT(*) 
FROM NAVA_clean.products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;

-- Data Standardization & Consistency

SELECT DISTINCT category
FROM NAVA_clean.products;

-- ===================================================================
-- Checking 'fact_budget'
-- ===================================================================

-- Identify Out-of-Range Dates
-- Expectation: Budget Period between 2024-01-01 and 2025-12-01

SELECT DISTINCT 
budget_month
FROM NAVA_clean.budget
WHERE budget_month < '2024-01-01' 
   OR budget_month > '2025-12-01';

-- Data Standardization & Consistency

SELECT DISTINCT country
FROM NAVA_clean.budget;

SELECT DISTINCT budget_type
FROM NAVA_clean.budget;

-- Check Data Consistency
-- Expectation: No Results

SELECT DISTINCT
  budget_amount
FROM NAVA_clean.budget
WHERE budget_amount IS NULL;

-- ===================================================================
-- Checking 'fact_expenses'
-- ===================================================================

-- Identify Out-of-Range Dates
-- Expectation: Expenses Period between 2024-01-01 and 2025-12-31

SELECT DISTINCT 
invoice_date
FROM NAVA_clean.expenses
WHERE invoice_date < '2024-01-01' 
   OR invoice_date > '2025-12-31';

-- Data Standardization & Consistency

SELECT DISTINCT country
FROM NAVA_clean.expenses;

SELECT DISTINCT department
FROM NAVA_clean.expenses;

SELECT DISTINCT cost_category
FROM NAVA_clean.expenses;

-- Check Data Consistency
-- Expectation: No Results

SELECT DISTINCT
  amount_actual
FROM NAVA_clean.expenses
WHERE amount_actual IS NULL;

-- ===================================================================
-- Checking 'fact_marketing'
-- ===================================================================


