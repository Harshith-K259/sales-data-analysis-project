-- =====================================================
-- 📊 RETAIL SALES PERFORMANCE & BUSINESS INSIGHTS DASHBOARD
-- =====================================================

-- Table: SALES_DATA
-- Columns:
-- product_id, product_name, category, price,
-- units_sold, rating, in_stock,
-- total_revenue, price_category, sales_category

--------------------------------------------------------
-- 🟢 1. BASIC BUSINESS OVERVIEW
--------------------------------------------------------

-- Total Revenue
SELECT SUM(total_revenue) AS total_revenue
FROM SALES_DATA;

-- Total Units Sold
SELECT SUM(units_sold) AS total_units_sold
FROM SALES_DATA;

-- Average Product Rating
SELECT AVG(rating) AS avg_rating
FROM SALES_DATA;

--------------------------------------------------------
-- 🟡 2. CATEGORY LEVEL BUSINESS ANALYSIS
--------------------------------------------------------

-- Revenue by Category
SELECT category,
       SUM(total_revenue) AS revenue
FROM SALES_DATA
GROUP BY category
ORDER BY revenue DESC;

-- Units Sold by Category
SELECT category,
       SUM(units_sold) AS total_units
FROM SALES_DATA
GROUP BY category
ORDER BY total_units DESC;

-- Average Rating by Category
SELECT category,
       AVG(rating) AS avg_rating
FROM SALES_DATA
GROUP BY category
ORDER BY avg_rating DESC;

--------------------------------------------------------
-- 🟡 3. PRODUCT PERFORMANCE ANALYSIS
--------------------------------------------------------

-- Top 5 Products by Revenue
SELECT product_name,
       SUM(total_revenue) AS revenue
FROM SALES_DATA
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 5;

-- Top 5 Products by Units Sold
SELECT product_name,
       SUM(units_sold) AS total_units
FROM SALES_DATA
GROUP BY product_name
ORDER BY total_units DESC
LIMIT 5;

-- Products with High Sales but Low Rating
SELECT product_name,
       units_sold,
       rating
FROM SALES_DATA
WHERE units_sold > 300 AND rating < 3.5
ORDER BY units_sold DESC;

--------------------------------------------------------
-- 🔴 4. BUSINESS PROBLEM DETECTION
--------------------------------------------------------

-- Out of Stock Products with High Demand
SELECT product_name,
       units_sold
FROM SALES_DATA
WHERE in_stock = 'FALSE'
AND units_sold > 300
ORDER BY units_sold DESC;

-- Low Revenue but High Stock Products
SELECT product_name,
       total_revenue,
       units_sold
FROM SALES_DATA
WHERE total_revenue < 1000
OR units_sold > 200;

-- Price vs Demand Analysis
SELECT price_category,
       AVG(units_sold) AS avg_demand
FROM SALES_DATA
GROUP BY price_category
ORDER BY avg_demand DESC;

--------------------------------------------------------
-- 🔥 5. ADVANCED BUSINESS INSIGHTS
--------------------------------------------------------

-- Rank Products by Revenue
SELECT product_name,
       total_revenue,
       RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM SALES_DATA;

-- Top Product per Category
SELECT *
FROM (
    SELECT category,
           product_name,
           total_revenue,
           RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rnk
    FROM SALES_DATA
) t
WHERE rnk = 1;

-- Revenue Contribution (Pareto)
SELECT product_name,
       total_revenue,
       total_revenue * 100.0 / SUM(total_revenue) OVER() AS revenue_percentage
FROM SALES_DATA
ORDER BY total_revenue DESC;

--------------------------------------------------------
-- 🔥 6. BUSINESS PERFORMANCE SCORE
--------------------------------------------------------

-- Performance Score (Revenue + Rating)
SELECT product_name,
       total_revenue,
       rating,
       (total_revenue * rating) AS performance_score
FROM SALES_DATA
ORDER BY performance_score DESC;

-- Demand vs Price Category
SELECT price_category,
       SUM(units_sold) AS demand
FROM SALES_DATA
GROUP BY price_category
ORDER BY demand DESC;

--------------------------------------------------------
-- 🧠 7. SUMMARY METRICS
--------------------------------------------------------

-- Total Products
SELECT COUNT(*) AS total_products
FROM SALES_DATA;

-- Out of Stock Count
SELECT COUNT(*) AS out_of_stock_products
FROM SALES_DATA
WHERE in_stock = 'FALSE';

-- High Rating Products
SELECT COUNT(*) AS high_rating_products
FROM SALES_DATA
WHERE rating >= 4;