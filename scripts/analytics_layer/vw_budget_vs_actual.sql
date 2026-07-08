/*
======================================================================
SCRIPT - Create Analytics Views 
======================================================================
Project     : NAVA Data Warehouse
Script      : NAVA_analytics.vw_budget_vs_actual.sql

Description :

Creates the business-ready view used by the Budget Overview dashboard.

This view is part of the shared SQL architecture of the
NAVA Business Intelligence Portfolio.

WARNING:

Existing analytics views will be dropped and recreated.
======================================================================
*/

CREATE OR REPLACE VIEW NAVA_analytics.vw_budget_vs_actual AS

WITH actuals AS ( -- Combine revenue and expense actuals into a single monthly dataset
SELECT
  DATE_FORMAT(order_date, '%Y-%m-01') AS budget_month,
  country,
  'revenue' AS budget_type,
  NULL AS cost_category,
  SUM(net_sales) AS actual_amount
FROM NAVA_analytics.v_sales_net
WHERE order_date >= '2025-01-01' -- Include actual revenue from FY2025 onwards
GROUP BY
DATE_FORMAT(order_date, '%Y-%m-01'),
country

UNION ALL

SELECT
  DATE_FORMAT(invoice_date, '%Y-%m-01') AS budget_month,
  country,
  department AS budget_type,
  cost_category,
  SUM(amount_actual) AS actual_amount
FROM NAVA_clean.fact_expenses
GROUP BY 
DATE_FORMAT(invoice_date, '%Y-%m-01'),
country,
department,
cost_category
)

SELECT
  b.budget_month,
  b.country,
  b.budget_type,
  a.cost_category,
  b.budget_amount,
  COALESCE(a.actual_amount, 0) AS actual_amount, -- Replace missing actuals with zero
  COALESCE(a.actual_amount, 0) - b.budget_amount AS variance_amount -- Calculate budget variance
FROM NAVA_clean.fact_budget b
LEFT JOIN actuals a
  ON CAST(b.budget_month AS DATE) = a.budget_month
  AND b.country = a.country
  AND b.budget_type = a.budget_type; -- Match budget and actual values by month, country and budget type


