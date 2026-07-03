/*
======================================================================
SCRIPT - Load Clean Layer 
======================================================================
Project     : NAVA Data Warehouse
Script      : load_clean.sql

Description :

Truncates all clean tables and loads standardized data from the raw layer.

The clean layer applies data quality rules including:

- Column name standardization
- Text normalization
- Data cleansing
- Duplicate removal

WARNING:

Existing clean data will be permanently deleted before loading new data.
======================================================================
*/

-- ====================================================================
-- 01 Sales Performance tables
-- ====================================================================

-- Truncate and Reload NAVA_clean.fact_sales table
TRUNCATE TABLE NAVA_clean.fact_sales;

INSERT INTO NAVA_clean.fact_sales (
    order_id,
    order_line_id,
    order_date,
    customer_id,
    product_id,
    postal_code,
    ship_date,
    delivery_date,
    ship_mode,
    quantity,
    unit_price,
    discount,
    discount_type,
    net_sales
)
SELECT
	TRIM(Order_ID),
	TRIM(Order_Line_ID),
	Order_Date,
	TRIM(Customer_ID),
	TRIM(Product_ID),
	TRIM(REPLACE(REPLACE(Postal_Code, CHAR(13), ''), CHAR(10), '')), -- Remove carriage returns from Postal_Code to ensure reliable joins
	Ship_Date,
	Delivery_Date,
	CASE
		WHEN TRIM(Ship_Mode) = 'Std' THEN 'Standard'
		WHEN TRIM(Ship_Mode) = 'Exp' THEN 'Express'
		ELSE TRIM(Ship_Mode)  
	END, -- Normalize Ship_Mode values to readable format
	Quantity,
	Unit_Price,
	Discount,
	CASE
		WHEN TRIM(Discount_Type) IN ('Percent', '%')
		THEN 'Percentage'
		ELSE TRIM(Discount_Type)
	END, -- Normalize Discount_Type values to readable format
	Net_Sales
FROM NAVA_raw.fact_sales
WHERE Order_Line_ID IS NOT NULL; -- Remove NULL Order_Line_ID values

-- Truncate and Reload NAVA_clean.fact_returns table
TRUNCATE TABLE NAVA_clean.fact_returns;

INSERT INTO NAVA_clean.fact_returns (
	return_id,
	order_id,
	order_line_id,
	return_date,
	return_reason,
	return_amount,
	return_quantity
)
SELECT
	TRIM(Return_ID),
	TRIM(Order_ID),
	TRIM(Order_Line_ID),
	Return_Date,
	LOWER(TRIM(Return_Reason)), -- Normalize Return_Reason values
	Return_Amount,
	Return_Quantity
FROM NAVA_raw.fact_returns
WHERE Return_ID IS NOT NULL; -- Remove NULL Return_ID values 

-- Truncate and Reload NAVA_clean.dim_customers table
TRUNCATE TABLE NAVA_clean.dim_customers;

INSERT INTO NAVA_clean.dim_customers (
	customer_id,
	customer_name,
	customer_segment,
	customer_first_order_date,
	postal_code
)
SELECT
	TRIM(Customer_ID),
	TRIM(Customer_Name),
	UPPER(TRIM(Customer_Segment)), -- Normalize Customer_Segment values
	Customer_First_Order_Date,
	TRIM(REPLACE(REPLACE(Postal_Code, CHAR(13), ''), CHAR(10), '')) -- Remove carriage returns from Postal_Code to ensure reliable joins
FROM (
	SELECT
		*,
		ROW_NUMBER() OVER (
		PARTITION BY TRIM(Customer_ID)
	ORDER BY Customer_First_Order_Date ASC) AS flag_cstID
	FROM NAVA_raw.dim_customers
WHERE Customer_ID IS NOT NULL) t -- Remove NULL Customer_ID values
WHERE flag_cstID = 1; -- Select the earliest record per customer

-- Truncate and Reload NAVA_clean.dim_location table
TRUNCATE TABLE NAVA_clean.dim_location;

INSERT INTO NAVA_clean.dim_location (
	postal_code,
	city,
	region,
	country
)
SELECT
	TRIM(REPLACE(REPLACE(Postal_Code, CHAR(13), ''), CHAR(10), '')), -- Remove carriage returns from Postal_Code to ensure reliable joins
	TRIM(City),
	TRIM(Region), 
	UPPER(TRIM(REPLACE(REPLACE(Country, CHAR(13), ''), CHAR(10), ''))) -- Clean and Normalize Country values
FROM NAVA_raw.dim_location
WHERE Postal_Code IS NOT NULL; -- Remove NULL Postal_Code values

-- Truncate and Reload NAVA_clean.dim_products table
TRUNCATE TABLE NAVA_clean.dim_products;

INSERT INTO NAVA_clean.dim_products (
	product_id,
	product_name,
	category,
	sub_category,
	product_tier,
	is_top_seller,
	standard_cost
)
SELECT
	TRIM(Product_ID),
	TRIM(Product_Name),
	TRIM(Category),
	TRIM(Sub_Category),
	TRIM(Product_Tier),
	TRIM(Is_Top_Seller),
	Standard_Cost
FROM NAVA_raw.dim_products
WHERE Product_ID IS NOT NULL; -- Remove NULL Product_ID values

-- ====================================================================
-- 02 Budget Performance tables
-- ====================================================================

-- Truncate and Reload NAVA_clean.fact_budget table
TRUNCATE TABLE NAVA_clean.fact_budget;

INSERT INTO NAVA_clean.fact_budget (
	budget_month,
	country,
	budget_type,
	budget_amount
)
SELECT
	Budget_Month,
	UPPER(TRIM(REPLACE(REPLACE(Country, CHAR(13), ''), CHAR(10), ''))),  -- Clean and Normalize Country values
	LOWER(TRIM(REPLACE(REPLACE(Budget_Type, CHAR(13), ''), CHAR(10), ''))), -- Clean and Normalize Budget_Type values
	Budget_Amount
FROM NAVA_raw.fact_budget
WHERE Budget_Month IS NOT NULL; -- Remove NULL Budget_Month values

-- Truncate and Reload NAVA_clean.fact_expenses table
TRUNCATE TABLE NAVA_clean.fact_expenses;

INSERT INTO NAVA_clean.fact_expenses (
	expense_id,
	invoice_date,
	department,
	cost_category,
	vendor_name,
	amount_actual,
	country
)
SELECT
	TRIM(Expense_ID),
	Invoice_Date,
	LOWER(TRIM(REPLACE(REPLACE(Department, CHAR(13), ''), CHAR(10), ''))), -- Clean and Normalize Department values
	LOWER(TRIM(REPLACE(REPLACE(Cost_Category, CHAR(13), ''), CHAR(10), ''))),-- Clean and Normalize Cost_Category values
	TRIM(Vendor_Name),
	Amount_Actual,
	UPPER(TRIM(REPLACE(REPLACE(Country, CHAR(13), ''), CHAR(10), ''))) -- Clean and Normalize Country values
FROM NAVA_raw.fact_expenses
WHERE Expense_ID IS NOT NULL; -- Remove NULL Expense_ID values

-- ====================================================================
-- 03 Marketing Performance tables
-- ====================================================================

-- Truncate and Reload NAVA_clean.fact_marketing table
TRUNCATE TABLE NAVA_clean.fact_marketing;

INSERT INTO NAVA_clean.fact_marketing (
	marketing_id,
	`date`,
	country,
	`channel`,
	campaign_id,
	campaign_name,
	spend,
	impressions,
	clicks
)
SELECT
	TRIM(Marketing_ID),
	`Date`,
	UPPER(TRIM(REPLACE(REPLACE(Country, CHAR(13), ''), CHAR(10), ''))), -- Clean and Normalize Country values
	CASE
		WHEN TRIM(`Channel`) = 'GoogleAds' THEN 'Google Ads'
		WHEN TRIM(`Channel`) = 'MetaAds' THEN 'Meta Ads'
		ELSE TRIM(`Channel`)
	END, -- Normalize Channel values to readable format
	TRIM(Campaign_ID),
	TRIM(Campaign_Name),
	Spend,
	Impressions,
	Clicks
FROM NAVA_raw.fact_marketing
WHERE Marketing_ID IS NOT NULL; -- Remove NULL Marketing_ID values

-- Truncate and Reload NAVA_clean.fact_marketing_conversion table
TRUNCATE TABLE NAVA_clean.fact_marketing_conversion;

INSERT INTO NAVA_clean.fact_marketing_conversion (
	conversion_id,
	order_id,
	order_date,
	country,
	channel,
	campaign_id,
	campaign_name,
	customer_id,
	conversion_type,
	attributed_revenue
)
	
WITH deduplicated AS (
SELECT
	conversion_id,
	order_id,
	order_date,
	country,
	channel,
	campaign_id,
	campaign_name,
	customer_id,
	conversion_type,
	attributed_revenue,
	ROW_NUMBER() OVER (
	PARTITION BY conversion_id
	ORDER BY order_date DESC) AS rn -- Keep the latest record when duplicate conversions exist
FROM NAVA_raw.fact_marketing_conversion
)

SELECT
	conversion_id,
	order_id,
	order_date,
	CASE
		WHEN TRIM(country) = 'FR' THEN 'FRANCE'
		WHEN TRIM(country) = 'ES' THEN 'SPAIN'
		WHEN TRIM(country) = 'PT' THEN 'PORTUGAL'
		ELSE UPPER(TRIM(country)) 
	END, -- Normalize Country values to standardized country names
	CASE
		WHEN TRIM(channel) = 'GoogleAds' THEN 'Google Ads'
		WHEN TRIM(channel) = 'Email' THEN 'Email Marketing'
		ELSE TRIM(channel)
	END, -- Normalize Channel values to readable format
	TRIM(campaign_id),
	TRIM(campaign_name),
	customer_id,
	CASE
		WHEN conversion_type IS NULL OR TRIM(conversion_type) = ''
		THEN 'Purchase'
		ELSE TRIM(conversion_type)
		END, -- Replace missing Conversion_Type values with default purchase event
	attributed_revenue 
FROM deduplicated
WHERE rn = 1; -- Keep one record per Conversion_ID
