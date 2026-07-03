/*
======================================================================
DDL Script - Create Clean Tables
======================================================================
Project     : NAVA Data Warehouse
Script      : ddl_clean.sql

Description :

Creates all clean tables in the NAVA_clean database.

The clean layer standardizes column names, data types and table
structures used throughout the ETL process.

WARNING:

Existing clean tables will be dropped and recreated.
======================================================================
*/

-- ====================================================================
-- 01 Sales Performance tables
-- ====================================================================

-- Drop and recreate NAVA_clean.fact_sales table
DROP TABLE IF EXISTS NAVA_clean.fact_sales;

CREATE TABLE NAVA_clean.fact_sales (
order_id                      VARCHAR(50),
order_line_i                  VARCHAR(50),
order_date                    DATE,
customer_id                   VARCHAR(50),
product_id                    VARCHAR(50),
postal_code                   VARCHAR(10),
ship_date                     DATE,
delivery_date                 DATE,
ship_mode                     VARCHAR(50),
quantity                      INT,
unit_price                    DECIMAL(10,2),
discount                      DECIMAL(10,2),
discount_type                 VARCHAR(20),
net_sales                     DECIMAL(10,2)
);


-- Drop and recreate NAVA_clean.fact_returns table
DROP TABLE IF EXISTS NAVA_clean.fact_returns;

CREATE TABLE NAVA_clean.fact_returns (
return_id                     VARCHAR(50),
order_id                      VARCHAR(50),
order_line_id                 VARCHAR(50),
return_date                   DATE,
return_reason                 VARCHAR(100),
return_amount                 DECIMAL(10,2),
return_quantity               INT
);


-- Drop and recreate NAVA_clean.dim_location table
DROP TABLE IF EXISTS NAVA_clean.dim_location;

CREATE TABLE NAVA_clean.dim_location(
postal_code                   VARCHAR(10),
city                          VARCHAR(50),
region                        VARCHAR(50),
country                       VARCHAR(50)
);

-- Drop and recreate NAVA_clean.dim_customers table
DROP TABLE IF EXISTS NAVA_clean.dim_customers;

CREATE TABLE NAVA_clean.dim_customers (
customer_id                   VARCHAR(50),
customer_name                 VARCHAR(100),
customer_segment              VARCHAR(50),
customer_first_order_date     DATE,
postal_code                   VARCHAR(10)
);

-- Drop and recreate NAVA_clean.dim_products table
DROP TABLE IF EXISTS NAVA_clean.dim_products;

CREATE TABLE NAVA_clean.dim_products (
product_id                    VARCHAR(50),
product_name                  VARCHAR(100),
category                      VARCHAR(50),
sub_category                  VARCHAR(50),
product_tier                  VARCHAR(50),
is_top_seller                 VARCHAR(10),
standard_cost                 DECIMAL(10,2)
);

-- ====================================================================
-- 02 Budget Performance tables
-- ====================================================================

-- Drop and recreate NAVA_clean.fact_budget table
DROP TABLE IF EXISTS NAVA_clean.fact_budget;

CREATE TABLE NAVA_clean.fact_budget (
budget_month                  DATE,
country                       VARCHAR(50),
budget_type                   VARCHAR(50),
budget_amount                 DECIMAL(10,2)
);

-- Drop and recreate NAVA_clean.fact_expenses table
DROP TABLE IF EXISTS NAVA_clean.fact_expenses;

CREATE TABLE NAVA_clean.fact_expenses (
expense_id                    VARCHAR(50),
invoice_date                  DATE,
department                    VARCHAR(50),
cost_category                 VARCHAR(50),
vendor_name                   VARCHAR(100),
amount_actual                 DECIMAL(10,2),
country                       VARCHAR(50)
);

-- ====================================================================
-- 03 Marketing Performance tables
-- ====================================================================

-- Drop and recreate NAVA_clean.marketing table
DROP TABLE IF EXISTS NAVA_clean.marketing;

CREATE TABLE NAVA_clean.marketing (
marketing_id                  VARCHAR(50),
date                          DATE,
country                       VARCHAR(50),
channel                       VARCHAR(50),
campaign_id                   VARCHAR(50),
campaign_name                 VARCHAR(100),
spend                         DECIMAL(10,2),
impressions                   INT,
clicks                        INT
);

-- Drop and recreate NAVA_clean.fact_marketing_conversion table
DROP TABLE IF EXISTS NAVA_clean.fact_marketing_conversion;

CREATE TABLE NAVA_clean.fact_marketing_conversion (
conversion_id                 VARCHAR(50),
order_id                      VARCHAR(50),
order_date                    DATE,
country                       VARCHAR(50),
channel                       VARCHAR(50),
campaign_id                   VARCHAR(50),
campaign_name                 VARCHAR(50),
customer_id                   VARCHAR(50),
conversion_type               VARCHAR(50),
attributed_revenue            INT
);
