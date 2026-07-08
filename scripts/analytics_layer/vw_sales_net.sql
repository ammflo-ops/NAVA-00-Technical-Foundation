/*
======================================================================
SCRIPT - Create Analytics Views 
======================================================================
Project     : NAVA Sales Performance
Script      : NAVA_analytics.vw_sales_net.sql

Description :

Creates the business-ready view used by the Sales Performance dashboard.

This view is part of the shared SQL architecture of the
NAVA Business Intelligence Portfolio.

WARNING:

Existing view will be dropped and recreated before execution.
======================================================================
*/

CREATE OR REPLACE VIEW NAVA_analytics.vw_sales_net AS
  
SELECT
  s.order_id,
  s.order_line_id,
  s.order_date,
  s.customer_id,
  s.product_id,
  l.country,
  s.ship_date,
  s.delivery_date,
  s.ship_mode,
  s.quantity,
  s.unit_price,
  s.discount,
  s.quantity * s.unit_price AS gross_sales, -- Calculate gross sales before discounts
  (s.quantity * s.unit_price) * s.discount AS discount_amount, -- Calculate discount amount
  s.net_sales,
  s.quantity * p.standard_cost AS cogs, -- Calculate cost of goods sold
  COALESCE(r.return_amount, 0) AS return_amount,
  COALESCE(r.return_quantity, 0) AS return_quantity,
  s.net_sales - COALESCE(r.return_amount, 0) AS net_revenue_after_returns,  -- Calculate net revenue after returns
  (s.net_sales - COALESCE(r.return_amount, 0)) - (s.quantity * p.standard_cost) AS adjusted_gross_profit -- Calculate gross profit after returns
FROM NAVA_clean.fact_sales s
LEFT JOIN NAVA_clean.dim_products p
  ON s.product_id = p.product_id
LEFT JOIN NAVA_clean.fact_returns r
  ON s.order_line_id = r.order_line_id
LEFT JOIN NAVA_clean.dim_location l
  ON s.postal_code = l.postal_code;


