/*====================================================================
Investigation 15
Product Sales Performance Analysis

Business Objective
------------------
Analyse product sales performance by evaluating product demand,
revenue generation, category performance, and seller contribution.

Tables Used
-----------
- products
- order_items
- sellers

Relationship Path

products
(product_id)
      │
      ▼
order_items
(order_id, seller_id)
      │
      ▼
sellers

NOTE
----
Product revenue is calculated using order_items.price.

The order_payments table stores order-level payments. Joining
payment_value directly to order_items would duplicate revenue for
orders containing multiple products.

====================================================================*/



/*===============================================================
SECTION A – PRODUCT DEMAND
===============================================================*/


/*---------------------------------------------------------------
Q1. Which products have been sold the most times?
---------------------------------------------------------------*/

SELECT
    p.product_id AS product,
    COUNT(oi.order_item_id) AS total_units_sold
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_units_sold DESC;



/*---------------------------------------------------------------
Q2. Top 10 best-selling products
---------------------------------------------------------------*/

SELECT
    p.product_id AS product,
    COUNT(oi.order_item_id) AS total_units_sold
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_units_sold DESC
LIMIT 10;



/*---------------------------------------------------------------
Q3. Which product categories contain the largest number of products?
---------------------------------------------------------------*/

SELECT
    p.product_category_name AS category,
    COUNT(p.product_id) AS total_products
FROM products AS p
GROUP BY p.product_category_name
ORDER BY total_products DESC;



/*---------------------------------------------------------------
Q4. Which product categories have sold the most items?
---------------------------------------------------------------*/

SELECT
    p.product_category_name AS category,
    COUNT(oi.order_item_id) AS units_sold
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY units_sold DESC;



/*---------------------------------------------------------------
Q5. Which products have never been sold?
---------------------------------------------------------------*/

SELECT
    p.product_id AS product,
    COUNT(oi.order_item_id) AS total_sales
FROM products AS p
LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id
HAVING COUNT(oi.order_item_id) = 0;





/*===============================================================
SECTION B – PRODUCT REVENUE
===============================================================*/


/*---------------------------------------------------------------
Q6. Which products generated the highest revenue?
---------------------------------------------------------------*/

SELECT
    p.product_id AS product,
    ROUND(SUM(oi.price),2) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC;



/*---------------------------------------------------------------
Q7. Top 10 highest revenue products
---------------------------------------------------------------*/

SELECT
    p.product_id AS product,
    ROUND(SUM(oi.price),2) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 10;



/*---------------------------------------------------------------
Q8. Average revenue generated per product
---------------------------------------------------------------*/

SELECT
    p.product_id AS product,
    ROUND(AVG(oi.price),2) AS average_revenue
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY average_revenue DESC;



/*---------------------------------------------------------------
Q9. Which product categories generate the highest revenue?
---------------------------------------------------------------*/

SELECT
    p.product_category_name AS category,
    ROUND(SUM(oi.price),2) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;



/*---------------------------------------------------------------
Q10. Average revenue per product category
---------------------------------------------------------------*/

SELECT
    p.product_category_name AS category,
    ROUND(AVG(oi.price),2) AS average_revenue
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY average_revenue DESC;





/*===============================================================
SECTION C – SELLER & PRODUCT RELATIONSHIPS
===============================================================*/


/*---------------------------------------------------------------
Q11. Which sellers offer the largest number of unique products?
---------------------------------------------------------------*/

SELECT
    s.seller_id AS seller,
    COUNT(DISTINCT oi.product_id) AS unique_products
FROM sellers AS s
INNER JOIN order_items AS oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY unique_products DESC;



/*---------------------------------------------------------------
Q12. Which products are sold by the largest number of sellers?
---------------------------------------------------------------*/

SELECT
    p.product_id AS product,
    COUNT(DISTINCT oi.seller_id) AS total_sellers
FROM products AS p
INNER JOIN order_items AS oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_sellers DESC;



/*---------------------------------------------------------------
Q13. Which seller generated the highest product revenue?
---------------------------------------------------------------*/

SELECT
    s.seller_id AS seller,
    ROUND(SUM(oi.price),2) AS total_revenue
FROM sellers AS s
INNER JOIN order_items AS oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC;





/*===============================================================
SECTION D – BUSINESS INSIGHTS
===============================================================*/


/*---------------------------------------------------------------
Q14. Which product categories should receive additional
inventory investment?

Business Insight

Based on the analysis, categories such as:

- cama_mesa_banho
- beleza_saude

demonstrate consistently high sales volume and revenue generation,
making them strong candidates for additional inventory investment.

---------------------------------------------------------------*/



/*---------------------------------------------------------------
Q15. Business Recommendations

• Increase inventory allocation for high-performing categories.

• Strengthen relationships with top-performing sellers.

• Investigate lower-performing categories to determine whether
  pricing, visibility, or demand is limiting performance.

• Monitor category performance regularly to support inventory
  planning and seasonal forecasting.

• Validate table granularity before performing revenue analysis
  to avoid duplicate aggregation.

---------------------------------------------------------------*/