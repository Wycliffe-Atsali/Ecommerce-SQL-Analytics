/*
=====================================================================
Investigation 23: Subqueries for Business Analysis
File: 17_subqueries_business_analysis.sql
Phase 6 – Advanced Query Design
=====================================================================

BUSINESS OBJECTIVE
------------------
The objective of this investigation is to introduce SQL subqueries
through practical business scenarios. Rather than hardcoding values,
subqueries allow SQL to calculate dynamic benchmarks and use those
results within another query.

This investigation focuses on identifying above-average performers
across customers, sellers, products, categories, states, and monthly
sales.

---------------------------------------------------------------------
CONCEPT SUMMARY
---------------------------------------------------------------------

What is a Subquery?
-------------------
A subquery is a SQL query nested inside another SQL query.

The inner query executes first and returns a result that is used by
the outer query.

Subqueries are commonly used when solving business questions that
depend on calculated values such as averages, totals, minimums,
maximums, or filtered datasets.

Examples include:

• Products priced above the average price.
• Customers spending more than the average customer.
• Sellers generating above-average revenue.
• States producing above-average sales.
• Months outperforming the average monthly revenue.

---------------------------------------------------------------------
SUBQUERY PATTERNS DEMONSTRATED
---------------------------------------------------------------------

✓ Scalar Subqueries
✓ Derived Tables (Subqueries in FROM)
✓ Aggregate Comparisons
✓ Nested Queries
✓ Business Benchmark Analysis

---------------------------------------------------------------------
DATABASE RELATIONSHIPS
---------------------------------------------------------------------

Customer Revenue

customers
    │
customer_id
    │
orders
    │
order_id
    │
order_payments

-----------------------------------------------------

Seller Revenue

sellers
    │
seller_id
    │
order_items

-----------------------------------------------------

Product Revenue

products
    │
product_id
    │
order_items

-----------------------------------------------------

Monthly Revenue

orders
    │
order_id
    │
order_payments

---------------------------------------------------------------------
BUSINESS GRAIN
---------------------------------------------------------------------

Customer
Seller
Product
Product Category
Customer State
Purchase Month

=====================================================================
*/


/*=============================================================
Question 1
Business Question:
How many products are priced above the average product price?
=============================================================*/

SELECT
    COUNT(DISTINCT product_id) AS products_above_average_price
FROM order_items
WHERE price >
(
    SELECT AVG(price)
    FROM order_items
);

/*
Analyst Observation
-------------------
Determines the number of distinct products whose selling price is
greater than the overall average product price.

Business Value
--------------
Identifies premium-priced products within the catalogue.
*/


/*=============================================================
Question 2
Business Question:
List all products priced above the average product price.
=============================================================*/

SELECT DISTINCT
    product_id
FROM order_items
WHERE price >
(
    SELECT AVG(price)
    FROM order_items
)
ORDER BY product_id;

/*
Analyst Observation
-------------------
Returns every distinct product that exceeds the average selling
price.

Business Value
--------------
Useful when analysing premium product portfolios.
*/


/*=============================================================
Question 3
Business Question:
How many payment records have a payment value greater than the
average payment value?
=============================================================*/

SELECT
    COUNT(*) AS payments_above_average
FROM order_payments
WHERE payment_value >
(
    SELECT AVG(payment_value)
    FROM order_payments
);

/*
Business Value
--------------
Measures the frequency of high-value payment transactions.
*/


/*=============================================================
Question 4
Business Question:
List all payment records whose payment value exceeds the overall
average payment value.
=============================================================*/

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM order_payments
WHERE payment_value >
(
    SELECT AVG(payment_value)
    FROM order_payments
)
ORDER BY payment_value DESC;

/*
Analyst Observation
-------------------
Displays every payment exceeding the company's average payment
value.

Business Value
--------------
Supports identification of high-value transactions.
*/


/*=============================================================
Question 5
Business Question:
Which customers have spent more than the average customer?
=============================================================*/

SELECT
    customer_unique_id,
    revenue
FROM
(
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY c.customer_unique_id
) AS revenue_summary
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM
    (
        SELECT
            c.customer_unique_id,
            SUM(op.payment_value) AS revenue
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        JOIN order_payments op
            ON o.order_id = op.order_id
        GROUP BY c.customer_unique_id
    ) AS customer_revenue
)
ORDER BY revenue DESC;

/*
Business Value
--------------
Identifies customers whose lifetime spending exceeds the company
average.
*/


/*=============================================================
Question 6
Business Question:
List the Top 10 customers spending more than the average customer.
=============================================================*/

SELECT
    customer_unique_id,
    revenue
FROM
(
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY c.customer_unique_id
) AS revenue_summary
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM
    (
        SELECT
            c.customer_unique_id,
            SUM(op.payment_value) AS revenue
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        JOIN order_payments op
            ON o.order_id = op.order_id
        GROUP BY c.customer_unique_id
    ) AS customer_revenue
)
ORDER BY revenue DESC
LIMIT 10;

/*
Analyst Observation
-------------------
Highlights the highest-value customers after filtering to only
those above the average customer revenue.

Business Recommendation
-----------------------
These customers should be prioritised for loyalty programmes,
personalised offers, and premium customer retention initiatives.
*/

/*=============================================================
Question 7
Business Question:
Which sellers generated more revenue than the average seller?
=============================================================*/

SELECT
    seller_id,
    revenue
FROM
(
    SELECT
        s.seller_id,
        SUM(oi.price) AS revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    GROUP BY s.seller_id
) AS revenue_summary
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM
    (
        SELECT
            s.seller_id,
            SUM(oi.price) AS revenue
        FROM sellers s
        JOIN order_items oi
            ON s.seller_id = oi.seller_id
        GROUP BY s.seller_id
    ) AS seller_revenue
)
ORDER BY revenue DESC;

/*
Analyst Observation
-------------------
Identifies sellers whose cumulative sales revenue exceeds the
average seller revenue.

Business Value
--------------
Supports performance benchmarking and seller partnership
strategies.
*/


/*=============================================================
Question 8
Business Question:
List the Top 10 sellers generating more revenue than the
average seller.
=============================================================*/

SELECT
    seller_id,
    revenue
FROM
(
    SELECT
        s.seller_id,
        SUM(oi.price) AS revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    GROUP BY s.seller_id
) AS revenue_summary
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM
    (
        SELECT
            s.seller_id,
            SUM(oi.price) AS revenue
        FROM sellers s
        JOIN order_items oi
            ON s.seller_id = oi.seller_id
        GROUP BY s.seller_id
    ) AS seller_revenue
)
ORDER BY revenue DESC
LIMIT 10;

/*
Business Recommendation
-----------------------
Top-performing sellers can be used as internal benchmarks to
identify operational practices that can be replicated across the
seller network.
*/


/*=============================================================
Question 9
Business Question:
Which products have been sold more times than the average
product?
=============================================================*/

SELECT
    product,
    no_of_times_ordered
FROM
(
    SELECT
        p.product_id AS product,
        COUNT(DISTINCT oi.order_id) AS no_of_times_ordered
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY product
) AS order_summary
WHERE no_of_times_ordered >
(
    SELECT AVG(no_of_times_ordered)
    FROM
    (
        SELECT
            p.product_id AS product,
            COUNT(DISTINCT oi.order_id) AS no_of_times_ordered
        FROM products p
        JOIN order_items oi
            ON p.product_id = oi.product_id
        GROUP BY product
    ) AS product_order_summary
)
ORDER BY no_of_times_ordered DESC;

/*
Business Value
--------------
Highlights products with above-average customer demand.
*/


/*=============================================================
Question 10
Business Question:
Which product categories generate above-average revenue?
=============================================================*/

SELECT
    category,
    revenue
FROM
(
    SELECT
        p.product_category_name AS category,
        SUM(oi.price) AS revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY category
) AS revenue_summary
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM
    (
        SELECT
            p.product_category_name AS category,
            SUM(oi.price) AS revenue
        FROM order_items oi
        JOIN products p
            ON oi.product_id = p.product_id
        GROUP BY category
    ) AS category_revenue
)
ORDER BY revenue DESC;

/*
Analyst Observation
-------------------
Uses product-level revenue to identify high-performing
categories.

Business Note
-------------
Revenue is calculated using order_items.price because revenue
belongs at the product level.
*/


/*=============================================================
Question 11
Business Question:
Which customer states generate above-average revenue?
=============================================================*/

SELECT
    states,
    revenue
FROM
(
    SELECT
        c.customer_state AS states,
        SUM(op.payment_value) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY states
) AS revenue_summary
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM
    (
        SELECT
            c.customer_state AS states,
            SUM(op.payment_value) AS revenue
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        JOIN order_payments op
            ON o.order_id = op.order_id
        GROUP BY states
    ) AS state_revenue
)
ORDER BY revenue DESC;

/*
Business Value
--------------
Identifies geographical markets that outperform the company
average.
*/


/*=============================================================
Question 12
Business Question:
Which months recorded above-average monthly revenue?
=============================================================*/

SELECT
    purchase_month,
    revenue
FROM
(
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)
            AS purchase_month,
        SUM(op.payment_value) AS revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY purchase_month
) AS revenue_summary
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM
    (
        SELECT
            DATE_TRUNC('month', o.order_purchase_timestamp)
                AS purchase_month,
            SUM(op.payment_value) AS revenue
        FROM orders o
        JOIN order_payments op
            ON o.order_id = op.order_id
        GROUP BY purchase_month
    ) AS monthly_revenue
)
ORDER BY purchase_month;

/*
Business Value
--------------
Supports seasonality analysis and long-term sales planning.
*/


/*=============================================================
Question 13
Business Question:
How many customers contribute to the top 20% of customer
revenue?
=============================================================*/

/*
Analyst Note
------------
This KPI was intentionally attempted but not finalised during
this investigation.

Determining the top 20% revenue contributors requires ranking
customers by cumulative revenue and calculating running totals,
which is more naturally solved using SQL Window Functions.

The completed solution will be revisited during Phase 7.
*/


/*=============================================================
Question 14
Business Question:
Compare above-average performers across customers, sellers,
products, categories and customer states.
=============================================================*/

/*
Key Findings
------------

• Approximately 32,128 products were priced above the average.
• Approximately 27,889 customers spent more than the average
  customer.
• Approximately 628 sellers generated above-average revenue.
• Approximately 20 product categories generated above-average
  revenue.
• Approximately 13 months exceeded the average monthly revenue.

Business Interpretation
-----------------------
The distribution of above-average performers differs across
business dimensions. Comparing percentages rather than raw
counts provides a fairer assessment because each entity group
contains a different number of records.
*/


/*=============================================================
Question 15
Business Question:
Provide strategic recommendations based on the investigation.
=============================================================*/

/*
Recommendations
---------------

1. Identify the characteristics of above-average customers and
   replicate successful engagement strategies across lower-value
   customer segments.

2. Analyse the operational practices of high-performing sellers
   and encourage adoption across the wider seller network.

3. Continue investing in high-performing product categories while
   investigating the causes of weaker category performance.

4. Prioritise inventory planning around consistently
   above-average products.

5. Allocate marketing resources toward customer states that
   consistently generate above-average revenue.

6. Investigate the drivers behind high-performing months and use
   those insights when planning seasonal promotions.
*/


/*
=====================================================================
INVESTIGATION SUMMARY
=====================================================================

SQL Concepts Demonstrated
-------------------------
✓ Scalar Subqueries
✓ Derived Tables
✓ Aggregate Comparisons
✓ Nested Queries
✓ Dynamic Benchmark Analysis
✓ Business Performance Evaluation

Key Business Insights
---------------------
• Dynamic benchmarks eliminate hardcoded comparison values.
• Above-average analysis provides meaningful performance
  benchmarking across multiple business entities.
• Subqueries allow analysts to answer complex business questions
  without manually calculating intermediate values.
• Repeated derived-table logic highlights the need for Common
  Table Expressions (CTEs), which will be introduced in the next
  investigation.

Analyst Reflection
------------------
This investigation marked the transition from basic SQL querying
to advanced analytical query design. By using subqueries to create
dynamic business benchmarks, the analysis demonstrated how SQL can
perform layered calculations while maintaining query flexibility.

Although several solutions required repeating the same derived
table, this limitation provides a natural introduction to Common
Table Expressions (CTEs), which simplify query structure by
defining reusable intermediate result sets.

=====================================================================
END OF INVESTIGATION 23
=====================================================================
```