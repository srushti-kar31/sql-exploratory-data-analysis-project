--Performance Analysis : Analyze the yearly performance of products by comparing
--their sales to both the average sales performance of the product and the previous years sales
WITH yearly_product_sales AS (
    SELECT
        EXTRACT(YEAR FROM s.order_date) AS order_year,
        p.product_name,
        SUM(s.sales_amount) AS current_sales
    FROM gold_fact_sales s
    LEFT JOIN gold_dim_products p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY
        EXTRACT(YEAR FROM s.order_date),
        p.product_name
)
SELECT 
order_year,
product_name,
current_sales,
ROUND(AVG(current_sales) OVER (PARTITION BY product_name)) AS avg_sales,
current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name)) AS performance,
CASE WHEN current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name)) > 0 THEN 'Above Average'
     WHEN current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name)) < 0 THEN 'Below Average'
	 ELSE 'Average'
END avg_change,
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS PY_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increasse'
     WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 ELSE 'No_Change'
END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year


