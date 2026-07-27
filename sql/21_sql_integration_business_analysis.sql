/*
===============================================================================
Investigation 27: SQL Integration Business Analysis
File: 21_sql_integration_business_analysis.sql
Phase: 6 – Advanced SQL Techniques
Author: Atsali Akolo
Database: Brazilian E-Commerce Public Dataset (Olist)
===============================================================================

BUSINESS OBJECTIVE

This investigation demonstrates how Subqueries, Common Table Expressions (CTEs),
and Views can be integrated to solve real-world business problems.

The investigation focuses on building reusable analytical SQL by leveraging
previously created Views and combining them with CTEs and analytical queries.

SQL Concepts Covered

• CREATE OR REPLACE VIEW
• Common Table Expressions (CTEs)
• CASE expressions
• Aggregate Functions
• Scalar Subqueries
• Business KPI Development
• Reusable SQL Components
===============================================================================
*/


/*=============================================================================
Question 1
Business Question:
List all customers whose revenue is above the average customer revenue using
the reusable customer_revenue_view.
=============================================================================*/

CREATE OR REPLACE VIEW customer_revenue_view AS
SELECT
    c.customer_unique_id AS customer,
    SUM(op.payment_value) AS revenue
FROM order_payments op
JOIN orders o
    ON op.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY customer;

SELECT *
FROM customer_revenue_view
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM customer_revenue_view
);

-- Business Insight:
-- Identifies customers generating above-average revenue for the marketplace.
-- These customers represent potential high-value customers for retention
-- campaigns and loyalty initiatives.



/*=============================================================================
Question 2
Business Question:
Classify customers into Premium and Standard segments using a CTE built from
customer_revenue_view.
=============================================================================*/

CREATE OR REPLACE VIEW customer_revenue_view AS
SELECT
    c.customer_unique_id AS customer,
    SUM(op.payment_value) AS revenue
FROM order_payments op
JOIN orders o
    ON op.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY customer;

WITH customer_segments AS
(
    SELECT
        *,
        CASE
            WHEN revenue >
            (
                SELECT AVG(revenue)
                FROM customer_revenue_view
            )
            THEN 'Premium Customer'
            ELSE 'Standard Customer'
        END AS customer_classification
    FROM customer_revenue_view
)

SELECT *
FROM customer_segments;

-- Business Insight:
-- Creates a reusable customer segmentation that can support CRM,
-- marketing campaigns and customer lifetime value analysis.



/*=============================================================================
Question 3
Business Question:
Determine how many customers belong to each customer classification.
=============================================================================*/

CREATE OR REPLACE VIEW customer_revenue_view AS
SELECT
    c.customer_unique_id AS customer,
    SUM(op.payment_value) AS revenue
FROM order_payments op
JOIN orders o
    ON op.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY customer;

WITH customer_segments AS
(
    SELECT
        *,
        CASE
            WHEN revenue >
            (
                SELECT AVG(revenue)
                FROM customer_revenue_view
            )
            THEN 'Premium Customer'
            ELSE 'Standard Customer'
        END AS customer_classification
    FROM customer_revenue_view
)

SELECT
    customer_classification,
    COUNT(*) AS no_of_customers
FROM customer_segments
GROUP BY customer_classification;

-- Business Insight:
-- Provides an overview of customer distribution across revenue segments,
-- helping management understand customer composition.



/*=============================================================================
Question 4
Business Question:
Calculate the percentage of Premium Customers within the marketplace.
=============================================================================*/

CREATE OR REPLACE VIEW customer_revenue_view AS
SELECT
    c.customer_unique_id AS customer,
    SUM(op.payment_value) AS revenue
FROM order_payments op
JOIN orders o
    ON op.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY customer;

WITH customer_segments AS
(
    SELECT
        *,
        CASE
            WHEN revenue >
            (
                SELECT AVG(revenue)
                FROM customer_revenue_view
            )
            THEN 'Premium Customer'
            ELSE 'Standard Customer'
        END AS customer_classification
    FROM customer_revenue_view
)

SELECT
    COUNT(*) AS premium_customers,
    (
        SELECT COUNT(*)
        FROM customer_segments
    ) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM customer_segments
        ),
        2
    ) AS premium_customer_percentage
FROM customer_segments
WHERE customer_classification = 'Premium Customer';

-- Business Insight:
-- Measures the proportion of customers contributing above-average revenue,
-- providing an important KPI for customer value segmentation.



/*=============================================================================
Question 5
Business Question:
List all sellers generating above-average marketplace revenue.
=============================================================================*/

CREATE OR REPLACE VIEW seller_revenue_view AS
SELECT
    s.seller_id AS seller,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY seller;

SELECT *
FROM seller_revenue_view
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM seller_revenue_view
);

-- Business Insight:
-- Highlights sellers outperforming the marketplace average,
-- supporting seller partnership and incentive programmes.



/*=============================================================================
Question 6
Business Question:
Identify the Top 10 highest-revenue sellers.
=============================================================================*/

CREATE OR REPLACE VIEW seller_revenue_view AS
SELECT
    s.seller_id AS seller,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY seller;

SELECT *
FROM seller_revenue_view
ORDER BY revenue DESC
LIMIT 10;

-- Business Insight:
-- Identifies the marketplace's strongest-performing sellers and
-- supports recognition, strategic partnerships and seller benchmarking.



/*=============================================================================
Question 7
Business Question:
Calculate summary statistics for seller revenue.
=============================================================================*/

CREATE OR REPLACE VIEW seller_revenue_view AS
SELECT
    s.seller_id AS seller,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY seller;

SELECT
    ROUND(AVG(revenue), 2) AS avg_revenue,
    MAX(revenue) AS max_seller_revenue,
    MIN(revenue) AS min_seller_revenue
FROM seller_revenue_view;

-- Business Insight:
-- Provides benchmark statistics that can be used to evaluate
-- individual seller performance against the marketplace.



/*=============================================================================
Question 8
Business Question:
List all product categories generating above-average revenue.
=============================================================================*/

CREATE OR REPLACE VIEW category_revenue_view AS
SELECT
    p.product_category_name AS category,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY category;

SELECT *
FROM category_revenue_view
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM category_revenue_view
);

-- Business Insight:
-- Identifies the product categories driving the largest share
-- of marketplace revenue.

/*=============================================================================
Question 9
Business Question:
Determine how many product categories generate above-average revenue.
=============================================================================*/

CREATE OR REPLACE VIEW category_revenue_view AS
SELECT
    p.product_category_name AS category,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY category;

SELECT
    COUNT(*) AS categories_above_average
FROM category_revenue_view
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM category_revenue_view
);

-- Business Insight:
-- Measures the number of product categories outperforming the
-- marketplace average, indicating how concentrated revenue is
-- across different product categories.



/*=============================================================================
Question 10
Business Question:
Calculate the percentage of product categories whose revenue is
above the marketplace average.
=============================================================================*/

CREATE OR REPLACE VIEW category_revenue_view AS
SELECT
    p.product_category_name AS category,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY category;

SELECT
    COUNT(*) AS categories_above_average,
    (
        SELECT COUNT(category)
        FROM category_revenue_view
    ) AS total_categories,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(category)
            FROM category_revenue_view
        ),
        2
    ) AS percentage_above_average
FROM category_revenue_view
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM category_revenue_view
);

-- Alternative Solution (Using a CTE)

WITH category_segments AS
(
    SELECT
        CASE
            WHEN revenue >
            (
                SELECT AVG(revenue)
                FROM category_revenue_view
            )
            THEN 'Above Average'
            ELSE 'Below Average'
        END AS category_classification,

        COUNT(*) AS no_of_categories,

        ROUND(
            COUNT(*) * 100.0 /
            (
                SELECT COUNT(*)
                FROM category_revenue_view
            ),
            2
        ) AS percentage

    FROM category_revenue_view

    GROUP BY category_classification
)

SELECT *
FROM category_segments;

-- Business Insight:
-- Determines how concentrated category performance is across
-- the marketplace and identifies whether revenue is generated
-- by only a few high-performing categories.



/*=============================================================================
Question 11
Business Question:
Identify every month that generated above-average revenue.
=============================================================================*/

CREATE OR REPLACE VIEW monthly_revenue_view AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS purchase_month,
    SUM(op.payment_value) AS revenue
FROM order_payments op
JOIN orders o
    ON op.order_id = o.order_id
GROUP BY purchase_month;

SELECT *
FROM monthly_revenue_view
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM monthly_revenue_view
);

-- Business Insight:
-- Highlights the strongest-performing sales months,
-- supporting seasonal planning and forecasting.



/*=============================================================================
Question 12
Business Question:
Identify the single highest-performing month by revenue.
=============================================================================*/

CREATE OR REPLACE VIEW monthly_revenue_view AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS purchase_month,
    SUM(op.payment_value) AS revenue
FROM order_payments op
JOIN orders o
    ON op.order_id = o.order_id
GROUP BY purchase_month;

SELECT *
FROM monthly_revenue_view
ORDER BY revenue DESC
LIMIT 1;

-- Business Insight:
-- Identifies the marketplace's strongest month, providing
-- a useful benchmark for future sales targets.



/*=============================================================================
Question 13
Business Question:
Calculate the percentage of months whose revenue exceeds the
overall monthly average.
=============================================================================*/

CREATE OR REPLACE VIEW monthly_revenue_view AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS purchase_month,
    SUM(op.payment_value) AS revenue
FROM order_payments op
JOIN orders o
    ON op.order_id = o.order_id
GROUP BY purchase_month;

WITH monthly_segments AS
(
    SELECT

        CASE
            WHEN revenue >
            (
                SELECT AVG(revenue)
                FROM monthly_revenue_view
            )
            THEN 'Above Average'
            ELSE 'Below Average'
        END AS monthly_classification,

        COUNT(*) AS no_of_months,

        ROUND(
            COUNT(*) * 100.0 /
            (
                SELECT COUNT(*)
                FROM monthly_revenue_view
            ),
            2
        ) AS percentage

    FROM monthly_revenue_view

    GROUP BY monthly_classification
)

SELECT *
FROM monthly_segments;

-- Business Insight:
-- Shows the proportion of months outperforming the average,
-- helping evaluate the consistency of marketplace revenue
-- throughout the observed period.



/*=============================================================================
Question 14
Business Question:
Compare Subqueries, CTEs and Views as analytical SQL tools.
=============================================================================*/

-- Analyst Reflection

/*
Subqueries
----------
• Best suited for one-time calculations.
• Simple and concise for straightforward business questions.
• Can become difficult to read when heavily nested.

Common Table Expressions (CTEs)
-------------------------------
• Ideal for multi-step analytical workflows.
• Improve readability and debugging.
• Allow complex logic to be broken into manageable sections.
• Excellent for temporary transformations within a single query.

Views
-----
• Best suited for reusable business logic.
• Eliminate repetitive SQL code.
• Ensure analysts use consistent business definitions.
• Particularly valuable for dashboards, KPIs and recurring reports.
*/

-- Business Insight:
-- Selecting the appropriate SQL construct improves maintainability,
-- readability and long-term scalability of analytical solutions.



/*=============================================================================
Question 15
Business Question:
Recommend which SQL construct should become the team's standard
for analytical development.
=============================================================================*/

-- Analyst Recommendation

/*
Views should become the standard approach for reusable business KPIs
because they provide a single source of truth, reduce duplicated SQL,
simplify dashboard development and improve collaboration between analysts.

CTEs should remain the preferred choice for complex analytical workflows
that involve multiple transformations within a single query, while
Subqueries should be reserved for simple one-off calculations where
creating additional structures would add unnecessary complexity.
*/

-- Business Recommendation:
-- Standardising reusable KPIs as Views while combining them with CTEs
-- for advanced analysis creates an analytical environment that is
-- scalable, maintainable and easier for future analysts to understand.



/*
===============================================================================
END OF INVESTIGATION 27

Skills Demonstrated

✓ CREATE OR REPLACE VIEW
✓ View Reusability
✓ Common Table Expressions (CTEs)
✓ CASE Expressions
✓ Scalar Subqueries
✓ Aggregate Functions
✓ Business KPI Development
✓ Customer Segmentation
✓ Seller Performance Analysis
✓ Product Category Analysis
✓ Monthly Revenue Analysis
✓ SQL Integration
✓ Professional SQL Documentation

Key Learning Outcome

This investigation demonstrates how Subqueries, CTEs and Views work
together to produce clean, reusable and maintainable business analyses.
Rather than treating them as competing features, they should be viewed
as complementary tools, each suited to different analytical scenarios.

Phase 6 Complete ✓
===============================================================================
*/