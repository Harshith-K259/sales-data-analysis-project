-- =====================================================
-- 📊 SALES DATA ANALYSIS PROJECT - SQL QUERIES
-- =====================================================

-- 🔹 Table: sales_data
-- Columns: product_id, product_name, category, price,
--          units_sold, rating, in_stock,
--          price_category, sales_category

--------------------------------------------------------
-- 🔸 BASIC QUERIES
--------------------------------------------------------

-- 1. View Full Dataset
SELECT * FROM DATA_ANALYSIS_PROJECT;

-- 2. Total Revenue
SELECT SUM(total_revenue) AS revenue
FROM DATA_ANALYSIS_PROJECT;

--------------------------------------------------------
-- 🔸 INTERMEDIATE QUERIES
--------------------------------------------------------

-- 3. Revenue by Category
SELECT category, SUM(total_revenue) AS revenue
FROM DATA_ANALYSIS_PROJECT
GROUP BY category;

-- 4. Top 5 Products by Revenue
SELECT product_name, SUM(total_revenue) AS revenue
FROM DATA_ANALYSIS_PROJECT
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 5;

-- 5. Top Selling Products
SELECT product_name, SUM(units_sold) AS total_units
FROM DATA_ANALYSIS_PROJECT
GROUP BY product_name
ORDER BY total_units DESC;

-- 6. Average Rating by Category
SELECT category, AVG(rating) AS avg_rating
FROM DATA_ANALYSIS_PROJECT
GROUP BY category;

--------------------------------------------------------
-- 🔸 BUSINESS INSIGHTS QUERIES
--------------------------------------------------------

-- 7. Products Out of Stock
SELECT product_name, units_sold
FROM DATA_ANALYSIS_PROJECT
WHERE in_stock = 'FALSE';

-- 8. High Demand but Out of Stock
SELECT product_name, units_sold
FROM DATA_ANALYSIS_PROJECT
WHERE units_sold > 300 AND in_stock = 'FALSE';

-- 9. Sales by Price Category
SELECT price_category, SUM(units_sold) AS total_sales
FROM DATA_ANALYSIS_PROJECT
GROUP BY price_category;

--------------------------------------------------------
-- 🔸 ADVANCED QUERIES
--------------------------------------------------------

-- 10. Rank Products by Revenue
SELECT product_name,
       total_revenue AS revenue,
       RANK() OVER (ORDER BY total_revenue DESC) AS rank
FROM DATA_ANALYSIS_PROJECT
LIMIT 10;

-- 11. Revenue Contribution %
SELECT product_name,
       total_revenue AS revenue,
       total_revenue * 100.0 / SUM(total_revenue) OVER() AS revenue_percentage
FROM DATA_ANALYSIS_PROJECT;

-- 12. Price Categorization using CASE
SELECT product_name,
       price,
       CASE
           WHEN price < 200 THEN 'Low'
           WHEN price < 800 THEN 'Medium'
           ELSE 'High'
       END AS price_category
FROM DATA_ANALYSIS_PROJECT;

-- 13. Top Product in Each Category
SELECT *
FROM (
    SELECT category,
           product_name,
           total_revenue AS revenue,
           RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank
    FROM DATA_ANALYSIS_PROJECT
) ranked
WHERE rank = 1;

-- 14. CTE Example
WITH revenue_table AS (
    SELECT product_name,
           total_revenue AS revenue
    FROM DATA_ANALYSIS_PROJECT
)
SELECT AVG(revenue) AS avg_revenue
FROM revenue_table;