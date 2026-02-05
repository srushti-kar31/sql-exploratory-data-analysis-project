-- TotalSales, TotalCustomers and TotalQuantity for each month in the data
SELECT 
DATE_TRUNC('month', order_date) AS months,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY months
ORDER BY months ASC


-- Running total of sales, AVG Price for each month in the data
SELECT 
months,
total_sales,
SUM(total_sales) OVER (ORDER BY months ) AS running_total,
AVG(avg_price) OVER (ORDER BY months) AS avg_total
FROM 
(
SELECT 
DATE_TRUNC('month', order_date) AS months,
SUM(sales_amount) AS total_sales,
AVG(price) AS avg_price
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
)


-- AVG price of each category over year
SELECT
    p.category,
    EXTRACT(YEAR FROM s.order_date) AS year,
    AVG(p.cost) AS avg_price_per_category_year
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
    ON s.product_key = p.product_key
WHERE EXTRACT(YEAR FROM s.order_date) IS NOT NULL
GROUP BY p.category, EXTRACT(YEAR FROM s.order_date)
ORDER BY p.category, year;






































































































































































































