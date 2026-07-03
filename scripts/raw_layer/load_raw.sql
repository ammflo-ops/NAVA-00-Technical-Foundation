/*
======================================================================
SCRIPT - Load Raw Data
======================================================================
Project     : NAVA Data Warehouse
Script      : load_raw.sql

Description :

Truncates all raw tables and loads source data from CSV files.

The raw layer preserves the original source structure.
No cleaning, validation or transformation is performed during this step.

WARNING:

Existing raw data will be permanently deleted before loading new data.
======================================================================
*/

-- ====================================================================
-- 01 Sales Performance tables
-- ====================================================================

-- Truncate and Reload NAVA_raw.fact_sales table
TRUNCATE TABLE NAVA_raw.fact_sales;

LOAD DATA LOCAL INFILE
'/path/to/project/datasets/Sales/FACT_SALES.csv'
INTO TABLE NAVA_raw.fact_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Truncate and Reload NAVA_raw.fact_returns table
TRUNCATE TABLE NAVA_raw.fact_returns;

LOAD DATA LOCAL INFILE
'/path/to/project/datasets/Sales/FACT_RETURNS.csv'
INTO TABLE NAVA_raw.fact_returns
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Truncate and Reload NAVA_raw.dim_location table
TRUNCATE TABLE NAVA_raw.dim_location;

LOAD DATA LOCAL INFILE
'/path/to/project/datasets/Sales/DIM_LOCATION.csv'
INTO TABLE NAVA_raw.dim_location
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Truncate and Reload NAVA_raw.dim_customers table
TRUNCATE TABLE NAVA_raw.dim_customers;

LOAD DATA LOCAL INFILE
'/path/to/project/datasets/Sales/DIM_CUSTOMERS.csv'
INTO TABLE NAVA_raw.dim_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Truncate and Reload NAVA_raw.dim_products table
TRUNCATE TABLE NAVA_raw.dim_products;

LOAD DATA LOCAL INFILE
'/path/to/project/datasets/Sales/DIM_PRODUCTS.csv'
INTO TABLE NAVA_raw.dim_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ====================================================================
-- 02 Budget Performance tables
-- ====================================================================

-- Truncate and Reload NAVA_raw.fact_budget table
TRUNCATE TABLE NAVA_raw.fact_budget;

LOAD DATA LOCAL INFILE
'/path/to/project/datasets/Budget/FACT_BUDGET.csv'
INTO TABLE NAVA_raw.fact_budget
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Truncate and Reload NAVA_raw.fact_expenses table
TRUNCATE TABLE NAVA_raw.fact_expenses;

LOAD DATA LOCAL INFILE
'/path/to/project/datasets/Budget/FACT_EXPENSES.csv'
INTO TABLE NAVA_raw.fact_expenses
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ====================================================================
-- 03 Marketing Performance tables
-- ====================================================================

-- Truncate and Reload NAVA_raw.fact_marketing table
TRUNCATE TABLE NAVA_raw.fact_marketing;

LOAD DATA LOCAL INFILE
'/path/to/project/datasets/Marketing/FACT_MARKETING.csv'
INTO TABLE NAVA_raw.fact_marketing
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Truncate and Reload NAVA_raw.fact_marketing_conversion table
TRUNCATE TABLE NAVA_raw.fact_marketing_conversion;

LOAD DATA LOCAL INFILE '/path/to/project/datasets/Marketing/FACT_MARKETING_CONVERSIONS.csv'
INTO TABLE NAVA_raw.fact_marketing_conversion
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
