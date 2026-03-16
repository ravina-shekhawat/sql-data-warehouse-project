CREATE VIEW  gold.report_products AS 
WITH base_query AS (
SELECT 
  f.product_key,
  f.order_number,
  f.sales_amount,
  f.quantity,
  f.customer_key,
  f.order_date,
  p.product_name,
  p.category ,
  p.subcategory,
  p.cost
  FROM gold.fact_sales AS f
  LEFT JOIN gold.dim_product AS p
  ON p.product_key = f.product_key
  WHERE order_date IS NOT NULL
)
, product_aggregation AS (
SELECT 
  product_key,
  product_name,
  category,
  subcategory,
  cost,
  COUNT(DISTINCT order_number) AS total_order,
  sum(sales_amount) AS total_sales,
  sum(quantity) AS total_quantity,
  COUNT(DISTINCT customer_key) AS total_customers,
  max(order_date) AS last_sale_date,
  DATEDIFF(month ,min(order_date),max(order_date)) AS lifespan
  FROM cte
  GROUP BY 
  product_key,
  product_name,
  category,
  subcategory,
  cost
)
SELECT
  product_key,
  product_name,
  category,
  subcategory,
  total_order,
  total_sales,
  total_quantity,
  total_customers,
  cost,
  last_sale_date,
  CASE 
    WHEN total_order = 0 THEN 0 ELSE 
  total_sales/ total_order 
  END AS avrage_order_revenue,
  CASE
    WHEN lifespan = 0 THEN total_sales 
  ELSE total_sales / lifespan 
  END AS avrage_monthly_revenue ,
  DATEDIFF(month,last_sale_date,GETDATE()) AS recency,
  CASE 
    WHEN total_sales > 50000 THEN 'High-Performer'
    WHEN total_sales >= 10000 THEN 'Mid-Range'
  ELSE 'Low-performer'
  END AS product_segment,
  lifespan
FROM product_aggregation
