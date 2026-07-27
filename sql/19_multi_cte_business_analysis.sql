/*
===============================================================================
Investigation 26: Multi-CTE Business Analysis
File: 19_multi_cte_business_analysis.sql
Project: Retail-SQL-Business-Analysis
Database: PostgreSQL
Dataset: Brazilian E-Commerce Public Dataset by Olist
Author: Atsali Akolo
===============================================================================

BUSINESS OBJECTIVE
------------------
Demonstrate how multiple Common Table Expressions (CTEs) can be combined to
build modular business analyses.

Rather than writing one large SQL statement, this investigation decomposes the
analysis into logical steps, where each CTE performs a single business task and
passes its result to the next CTE.

This mirrors how SQL is commonly written in production analytics environments.

BUSINESS QUESTIONS
------------------
1. Build a reusable customer orders CTE.
2. Build a reusable customer revenue CTE.
3. Combine both CTEs into a customer summary.
4. Identify the highest revenue customers.
5. Calculate average customer orders and revenue.
6. Classify customers into business segments.
7. Analyse the number of customers in each segment.
8. Analyse revenue contribution by customer segment.
9. Analyse average revenue by customer segment.
10. Build a reusable seller summary CTE.
11. Identify the highest revenue sellers.
12. Summarise seller performance statistics.
13. Interpret customer segmentation results.
14. Evaluate advantages of multiple CTEs.
15. Recommend business applications.

RELATIONSHIP PATHS
------------------
Questions 1–9

customers
    ↓
orders
    ↓
order_payments

Questions 10–12

sellers
    ↓
order_items
    ↓
orders

KEY SQL CONCEPTS
----------------
• Multiple CTEs
• Sequential CTE references
• Multi-stage business transformations
• Aggregate analysis
• CASE expressions
• Business segmentation
• Modular SQL design
===============================================================================
*/


/*=============================================================================
Question 1
Business Objective:
Create a reusable CTE that calculates the total number of orders placed by
each unique customer.
=============================================================================*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(o.order_id) AS no_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer
);


/*=============================================================================
Question 2
Business Objective:
Create separate reusable CTEs for customer order volume and customer revenue.
=============================================================================*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(o.order_id) AS no_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY customer
);


/*=============================================================================
Question 3
Business Objective:
Merge multiple CTEs into one business-ready customer summary containing both
order frequency and total revenue.
=============================================================================*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(o.order_id) AS no_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY customer
),

customer_summary AS
(
    SELECT
        co.customer,
        co.no_of_orders,
        cr.revenue
    FROM customer_orders co
    JOIN customer_revenue cr
        ON co.customer = cr.customer
)

SELECT *
FROM customer_summary
ORDER BY revenue DESC;


/*=============================================================================
Question 4
Business Objective:
Identify the ten highest revenue customers using the customer summary CTE.
=============================================================================*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(o.order_id) AS no_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY customer
),

customer_summary AS
(
    SELECT
        co.customer,
        co.no_of_orders,
        cr.revenue
    FROM customer_orders co
    JOIN customer_revenue cr
        ON co.customer = cr.customer
)

SELECT *
FROM customer_summary
ORDER BY revenue DESC
LIMIT 10;


/*=============================================================================
Question 5
Business Objective:
Calculate average customer revenue and average number of orders using the
combined customer summary.
=============================================================================*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(o.order_id) AS no_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY customer
),

customer_summary AS
(
    SELECT
        co.customer,
        co.no_of_orders,
        cr.revenue
    FROM customer_orders co
    JOIN customer_revenue cr
        ON co.customer = cr.customer
)

SELECT
    ROUND(AVG(revenue), 2) AS avg_revenue,
    ROUND(AVG(no_of_orders), 2) AS avg_no_of_orders
FROM customer_summary;


/*=============================================================================
Question 6
Business Objective:
Create customer business segments based on purchasing behaviour using
multiple chained CTEs.
=============================================================================*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(o.order_id) AS no_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY customer
),

customer_summary AS
(
    SELECT
        co.customer,
        co.no_of_orders,
        cr.revenue
    FROM customer_orders co
    JOIN customer_revenue cr
        ON co.customer = cr.customer
),

customer_segments AS
(
    SELECT
        *,
        CASE
            WHEN no_of_orders = 1 THEN 'One-Time Customer'
            WHEN no_of_orders BETWEEN 2 AND 4 THEN 'Repeat Customer'
            WHEN no_of_orders >= 5 THEN 'Loyal Customer'
        END AS customer_classification
    FROM customer_summary
)

SELECT *
FROM customer_segments;

/*=============================================================================
Question 7
Business Objective:
Determine how many customers belong to each customer segment created in the
previous CTE pipeline.
=============================================================================*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(o.order_id) AS no_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY customer
),

customer_summary AS
(
    SELECT
        co.customer,
        co.no_of_orders,
        cr.revenue
    FROM customer_orders co
    JOIN customer_revenue cr
        ON co.customer = cr.customer
),

customer_segments AS
(
    SELECT
        *,
        CASE
            WHEN no_of_orders = 1 THEN 'One-Time Customer'
            WHEN no_of_orders BETWEEN 2 AND 4 THEN 'Repeat Customer'
            ELSE 'Loyal Customer'
        END AS customer_classification
    FROM customer_summary
)

SELECT
    customer_classification,
    COUNT(*) AS total_customers
FROM customer_segments
GROUP BY customer_classification
ORDER BY total_customers DESC;


/*=============================================================================
Question 8
Business Objective:
Calculate total revenue generated by each customer segment.
=============================================================================*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(o.order_id) AS no_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY customer
),

customer_summary AS
(
    SELECT
        co.customer,
        co.no_of_orders,
        cr.revenue
    FROM customer_orders co
    JOIN customer_revenue cr
        ON co.customer = cr.customer
),

customer_segments AS
(
    SELECT
        *,
        CASE
            WHEN no_of_orders = 1 THEN 'One-Time Customer'
            WHEN no_of_orders BETWEEN 2 AND 4 THEN 'Repeat Customer'
            ELSE 'Loyal Customer'
        END AS customer_classification
    FROM customer_summary
)

SELECT
    customer_classification,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM customer_segments
GROUP BY customer_classification
ORDER BY total_revenue DESC;


/*=============================================================================
Question 9
Business Objective:
Calculate the average customer revenue within each customer segment.
=============================================================================*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(o.order_id) AS no_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY customer
),

customer_summary AS
(
    SELECT
        co.customer,
        co.no_of_orders,
        cr.revenue
    FROM customer_orders co
    JOIN customer_revenue cr
        ON co.customer = cr.customer
),

customer_segments AS
(
    SELECT
        *,
        CASE
            WHEN no_of_orders = 1 THEN 'One-Time Customer'
            WHEN no_of_orders BETWEEN 2 AND 4 THEN 'Repeat Customer'
            ELSE 'Loyal Customer'
        END AS customer_classification
    FROM customer_summary
)

SELECT
    customer_classification,
    ROUND(AVG(revenue), 2) AS average_customer_revenue
FROM customer_segments
GROUP BY customer_classification
ORDER BY average_customer_revenue DESC;


/*=============================================================================
Question 10
Business Objective:
Create a reusable seller summary CTE that combines seller order volume and
revenue into a single business dataset.
=============================================================================*/

WITH seller_summary AS
(
    SELECT
        s.seller_id AS seller,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY seller
);


/*=============================================================================
Question 11
Business Objective:
Identify the highest-performing sellers based on total revenue.
=============================================================================*/

WITH seller_summary AS
(
    SELECT
        s.seller_id AS seller,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY seller
)

SELECT *
FROM seller_summary
ORDER BY revenue DESC
LIMIT 10;


/*=============================================================================
Question 12
Business Objective:
Generate summary statistics describing seller revenue performance across the
entire marketplace.
=============================================================================*/

WITH seller_summary AS
(
    SELECT
        s.seller_id AS seller,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY seller
)

SELECT
    ROUND(AVG(revenue), 2) AS average_seller_revenue,
    MAX(revenue) AS highest_seller_revenue,
    MIN(revenue) AS lowest_seller_revenue
FROM seller_summary;


/*=============================================================================
Question 13
Business Interpretation

Findings:
• One-Time Customers contributed the largest share of total revenue.
• Repeat Customers generated substantially less revenue.
• Loyal Customers represented only a very small proportion of the customer base.

Business Insight:
Although one-time customers currently drive most sales, increasing the
conversion rate from one-time to repeat customers could significantly improve
long-term customer lifetime value and reduce future customer acquisition costs.
=============================================================================*/


/*=============================================================================
Question 14
Analyst Reflection

Multiple CTEs significantly improve SQL readability by separating complex
business logic into smaller, meaningful analytical steps.

Benefits observed:
• Easier debugging
• Better maintainability
• Improved readability
• Reusable intermediate datasets
=============================================================================*/


/*=============================================================================
Question 15
Business Recommendation

The modular design provided by chained CTEs makes complex business analysis
more maintainable for collaborative analytics teams.

Recommended applications include:

• Customer segmentation pipelines
• Executive KPI reporting
• Sales performance dashboards
• Revenue analysis workflows
• Customer lifetime value modelling
• Monthly operational reporting

Analyst Note:
This investigation demonstrates how multiple CTEs can be combined to create
production-quality SQL that is easier to understand, extend, and maintain than
large monolithic queries.
=============================================================================*/