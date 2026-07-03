/*
======================================================================
DDL SCRIPT - Create Raw Tables
======================================================================
Project     : NAVA Data Warehouse
Script      : ddl_raw.sql

Description :

Creates all raw tables in the NAVA_raw database.

The raw layer preserves the source file structure.
No cleaning, standardization, deduplication, or business transformation
is applied at this stage.

WARNING:
Existing raw tables will be dropped and recreated.
All existing raw data will be permanently deleted.
======================================================================
*/


-- ====================================================================
-- 01 Sales Performance tables
-- ====================================================================

-- Drop and recreate NAVA_raw.fact_sales table
DROP TABLE IF EXISTS NAVA_raw.fact_sales;

CREATE TABLE NAVA_raw.fact_sales (
Order_ID                      VARCHAR(50),
Order_Line_ID                 VARCHAR(50),
Order_Date                    DATE,
Customer_ID                   VARCHAR(50),
Product_ID                    VARCHAR(50),
Postal_Code                   VARCHAR(10),
Ship_Date                     DATE,
Delivery_Date                 DATE,
Ship_Mode                     VARCHAR(50),
Quantity                      INT,
Unit_Price                    DECIMAL(10,2),
Discount                      DECIMAL(10,2),
Discount_Type                 VARCHAR(50),
Net_Sales                     DECIMAL(10,2)
);

-- Drop and recreate NAVA_raw.fact_returns table
DROP TABLE IF EXISTS NAVA_raw.fact_returns;

CREATE TABLE NAVA_raw.fact_returns (
Return_ID                     VARCHAR(50),
Order_ID                      VARCHAR(50),
Order_Line_ID                 VARCHAR(50),
Return_Date                   DATE,
Return_Reason                 VARCHAR(100),
Return_Amount                 DECIMAL(10,2),
Return_Quantity               INT
);

-- Drop and recreate NAVA_raw.dim_location table
DROP TABLE IF EXISTS NAVA_raw.dim_location;

CREATE TABLE NAVA_raw.dim_location(
Postal_Code                   VARCHAR(10),
City                          VARCHAR(50),
Region                        VARCHAR(50),
Country                       VARCHAR(50)
);

-- Drop and recreate NAVA_raw.dim_customers table
DROP TABLE IF EXISTS NAVA_raw.dim_customers;

CREATE TABLE NAVA_raw.dim_customers (
Customer_ID                   VARCHAR(50),
Customer_Name                 VARCHAR(100),
Customer_Segment              VARCHAR(50),
Customer_First_Order_Date     DATE,
Postal_Code                   VARCHAR(10)
);

-- Drop and recreate NAVA_raw.dim_products table
DROP TABLE IF EXISTS NAVA_raw.dim_products;

CREATE TABLE NAVA_raw.dim_products (
Product_ID                    VARCHAR(50),
Product_Name                  VARCHAR(100),
Category                      VARCHAR(50),
Sub_Category                  VARCHAR(50),
Product_Tier                  VARCHAR(50),
Is_Top_Seller                 VARCHAR(10),
Standard_Cost                 DECIMAL(10,2)
);

-- ====================================================================
-- 02 Budget Performance tables
-- ====================================================================

-- Drop and recreate NAVA_raw.fact_budget table
DROP TABLE IF EXISTS NAVA_raw.fact_budget;

CREATE TABLE NAVA_raw.fact_budget (
Budget_Month                  DATE,
Country                       VARCHAR(50),
Budget_Type                   VARCHAR(50),
Budget_Amount                 DECIMAL(10,2)
);

-- Drop and recreate NAVA_raw.fact_expenses table
DROP TABLE IF EXISTS NAVA_raw.fact_expenses;

CREATE TABLE NAVA_raw.fact_expenses(
Expense_ID                    VARCHAR(50),
Invoice_Date                  DATE,
Department                    VARCHAR(50),
Cost_Category                 VARCHAR(50),
Vendor_Name                   VARCHAR(50),
Amount_Actual                 DECIMAL(10,2),
Country                       VARCHAR(50)
);

-- ====================================================================
-- 03 Marketing Performance tables
-- ====================================================================

-- Drop and recreate NAVA_raw.fact_marketing table
DROP TABLE IF EXISTS NAVA_raw.fact_marketing;

CREATE TABLE NAVA_raw.fact_marketing (
Marketing_ID                  VARCHAR(50),
Date                          DATE,
Country                       VARCHAR(50),
Channel                       VARCHAR(50),
Campaign_ID                   VARCHAR(50),
Campaign_Name                 VARCHAR(100),
Spend                         DECIMAL(10,2),
Impressions                   INT,
Clicks                        INT
);

-- Drop and recreate NAVA_raw.fact_marketing_conversion table
DROP TABLE IF EXISTS NAVA_raw.fact_marketing_conversion;

CREATE TABLE NAVA_raw.fact_marketing_conversion (
Conversion_ID                 VARCHAR(50),
Order_ID                      VARCHAR(50),
Order_Date                    DATE,
Country                       VARCHAR(50),
Channel                       VARCHAR(50),
Campaign_ID                   VARCHAR(50),
Campaign_Name                 VARCHAR(50),
Customer_ID                   VARCHAR(50),
Conversion_Type               VARCHAR(50),
Attributed_Revenue            DECIMAL(10,2)
);
