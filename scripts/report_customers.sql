/*
===============================================================================
Customer Report
===============================================================================
Purpose : 
    - This report consolidates key customer metrics and behaviors.
Highlights:
1. Gathers essential fields such as customer name, age, customer number .
2. Segments customers by revenue to identify VIP, Regular or New
3. Aggregates customer-level metrics:
- total orders
- total sales
- total quantity 
- total products 
- lifespan 
4. Calculates valuable KPIs :
- recency (months since last sale)
- avg_order_value 
- avg_monthly_sales
======================================================================
*/

CREATE VIEW gold.report_customers AS 
WITH base_query AS (
SELECT
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	DATEDIFF(year,c.birthdate,GETDATE()) AS age
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL)
  
, customer_aggregation AS (
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	sum(sales_amount) AS total_sales,
	sum(quantity) AS total_quantity,
	COUNT(product_key) AS total_products,
	max(order_date) AS last_order,
	DATEDIFF(month ,min(order_date),max(order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
	)
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
CASE 
  WHEN age < 20 THEN 'Under 20'
  WHEN age BETWEEN 20 AND 29 THEN '20-29'
	WHEN age BETWEEN 30 and 39 THEN '30-39'
	WHEN age BETWEEN 40 and 49  THEN'40-49'
ELSE '50 and above'
END AS age_group,
CASE 
  WHEN total_sales > 5000 AND lifespan >= 12 THEN 'VIP'
  WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'Regular'
ELSE 'New'
END AS customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order,
	DATEDIFF(month,last_order,GETDATE()) AS recency,
	lifespan,
CASE 
  WHEN  total_orders = 0 THEN 0 
	ELSE total_sales/total_orders 
	END AS avg_order_value,
CASE 
  WHEN lifespan = 0 THEN total_sales
	ELSE total_sales / lifespan 
	END AS  avg_monthly_sales
FROM  customer_aggregation
