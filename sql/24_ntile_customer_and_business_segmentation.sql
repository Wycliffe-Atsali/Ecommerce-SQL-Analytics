/*
===============================================================================
SQL Script: 24_ntile_customer_and_business_segmentation.sql
===============================================================================

Project         : Retail SQL Business Analysis
Dataset         : Brazilian E-Commerce Public Dataset (Olist)
Database        : PostgreSQL
Phase           : Phase 7 - Window Functions
Investigation   : 30
SQL Script      : 24

Title:
NTILE() - Customer and Business Segmentation

Description:
This investigation introduces the NTILE() window function and demonstrates
how data can be divided into approximately equal-sized groups.

Unlike ranking functions such as ROW_NUMBER(), RANK() and DENSE_RANK(),
NTILE() focuses on segmentation rather than ranking.

Business applications include:

• Customer Segmentation
• Product Pricing Tiers
• Seller Performance Bands
• Payment Analysis
• Customer Revenue Classification
• Business Intelligence Reporting

SQL Techniques Used

• NTILE()
• OVER()
• PARTITION BY
• ORDER BY
• GROUP BY
• CASE
• Common Table Expressions (CTEs)
• INNER JOIN

===============================================================================
*/


/******************************************************************************
Question 1
Divide all products into four price quartiles.

Business Objective
Segment products into four equally sized pricing groups to identify premium,
mid-range and lower-priced products.
******************************************************************************/

WITH product_segmentation AS
(
    SELECT
        product_id,
        price,

        NTILE(4)
            OVER
            (
                ORDER BY price DESC
            ) AS product_quartile_rank

    FROM order_items
)

SELECT *

FROM product_segmentation;



/******************************************************************************
Question 2
Divide all payments into five payment-value groups.

Business Objective
Group payment transactions into quintiles according to payment value.
******************************************************************************/

WITH payment_segmentation AS
(
    SELECT

        order_id,

        payment_value,

        NTILE(5)
            OVER
            (
                ORDER BY payment_value DESC
            ) AS payment_quintile_rank

    FROM order_payments
)

SELECT *

FROM payment_segmentation;



/******************************************************************************
Question 3
Divide all orders into ten chronological buckets.

Business Objective
Segment orders into purchase-date deciles to analyse order distribution
through time.
******************************************************************************/

WITH order_segmentation AS
(
    SELECT

        order_id,

        order_purchase_timestamp,

        NTILE(10)
            OVER
            (
                ORDER BY order_purchase_timestamp ASC
            ) AS order_decile_rank

    FROM orders
)

SELECT *

FROM order_segmentation;



/******************************************************************************
Question 4
Divide customers into four alphabetical groups.

Business Objective
Create equally sized customer groups based on customer identifiers.
******************************************************************************/

WITH customer_segmentation AS
(
    SELECT

        customer_unique_id,

        NTILE(4)
            OVER
            (
                ORDER BY customer_unique_id
            ) AS customer_quartile_rank

    FROM customers
)

SELECT *

FROM customer_segmentation;



/******************************************************************************
Question 5
Divide products into quartiles within each product category.

Business Objective
Compare products fairly within their own categories instead of across the
entire catalogue.
******************************************************************************/

WITH product_segmentation AS
(
    SELECT

        p.product_id,

        p.product_category_name AS category,

        oi.price,

        NTILE(4)
            OVER
            (
                PARTITION BY p.product_category_name
                ORDER BY oi.price DESC
            ) AS product_category_quartile_rank

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id
)

SELECT *

FROM product_segmentation;



/******************************************************************************
Question 6
Divide seller transactions into four price quartiles.

Business Objective
Segment every seller's transactions into pricing quartiles.
******************************************************************************/

WITH seller_transaction_segmentation AS
(
    SELECT

        seller_id,

        product_id,

        price,

        NTILE(4)
            OVER
            (
                PARTITION BY seller_id
                ORDER BY price DESC
            ) AS seller_transaction_quartile_rank

    FROM order_items
)

SELECT *

FROM seller_transaction_segmentation;



/******************************************************************************
Question 7
Divide each customer's purchase history into three chronological groups.

Business Objective
Analyse customer purchasing timelines by grouping orders into chronological
thirds.
******************************************************************************/

WITH order_segmentation AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        NTILE(3)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS customer_order_group

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT *

FROM order_segmentation;

/******************************************************************************
Question 8
Divide payments into four groups within each payment type.

Business Objective
Segment payment transactions into quartiles for every payment method to compare
high-value and low-value transactions within each payment category.
******************************************************************************/

WITH payment_segmentation AS
(
    SELECT

        order_id,

        payment_type,

        payment_value,

        NTILE(4)
            OVER
            (
                PARTITION BY payment_type
                ORDER BY payment_value DESC
            ) AS payment_quartile_rank

    FROM order_payments
)

SELECT *

FROM payment_segmentation;



/******************************************************************************
Question 9
Divide orders into four chronological groups within each order status.

Business Objective
Analyse the distribution of orders over time for every operational status.
******************************************************************************/

WITH order_segmentation AS
(
    SELECT

        order_id,

        order_status,

        order_purchase_timestamp,

        NTILE(4)
            OVER
            (
                PARTITION BY order_status
                ORDER BY order_purchase_timestamp ASC
            ) AS order_status_quartile_rank

    FROM orders
)

SELECT *

FROM order_segmentation;



/******************************************************************************
Question 10
Divide products into five pricing groups within each seller.

Business Objective
Segment every seller's product portfolio into pricing quintiles.
******************************************************************************/

WITH product_segmentation AS
(
    SELECT

        seller_id,

        product_id,

        price,

        NTILE(5)
            OVER
            (
                PARTITION BY seller_id
                ORDER BY price DESC
            ) AS product_quintile_rank

    FROM order_items
)

SELECT *

FROM product_segmentation;



/******************************************************************************
Question 11
Identify customers in the highest spending quartile.

Business Objective
Determine the highest-value customers based on total revenue generated.
******************************************************************************/

WITH customer_segmentation AS
(
    SELECT

        c.customer_unique_id AS customer,

        SUM(op.payment_value) AS total_revenue,

        NTILE(4)
            OVER
            (
                ORDER BY SUM(op.payment_value) DESC
            ) AS customer_quartile_rank

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id

    JOIN customers c
        ON o.customer_id = c.customer_id

    GROUP BY c.customer_unique_id
)

SELECT *

FROM customer_segmentation

WHERE customer_quartile_rank = 1;



/******************************************************************************
Question 12
Identify products belonging to the highest pricing quartile.

Business Objective
Identify premium-priced products across all recorded transactions.
******************************************************************************/

WITH product_segmentation AS
(
    SELECT

        product_id,

        price,

        NTILE(4)
            OVER
            (
                ORDER BY price DESC
            ) AS product_quartile_rank

    FROM order_items
)

SELECT *

FROM product_segmentation

WHERE product_quartile_rank = 1;



/******************************************************************************
Question 13
Produce a seller report showing seller, product, price and pricing quartile.

Business Objective
Compare products within each seller's catalogue by assigning pricing quartiles.
******************************************************************************/

WITH seller_report AS
(
    SELECT

        seller_id AS seller,

        product_id,

        price,

        NTILE(4)
            OVER
            (
                PARTITION BY seller_id
                ORDER BY price DESC
            ) AS seller_quartile_rank

    FROM order_items
)

SELECT *

FROM seller_report

ORDER BY
    seller,
    seller_quartile_rank,
    price DESC;



/******************************************************************************
Question 14
Produce a customer purchase report showing chronological purchase buckets.

Business Objective
Segment customer purchases into chronological quartiles across the complete
order history.
******************************************************************************/

WITH customer_purchase_report AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        NTILE(4)
            OVER
            (
                ORDER BY o.order_purchase_timestamp ASC
            ) AS purchase_quartile_rank

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT *

FROM customer_purchase_report;



/******************************************************************************
Question 15
Build a customer segmentation report based on lifetime revenue.

Business Objective
Classify customers into revenue-based spending quartiles suitable for customer
analytics, loyalty programmes and marketing campaigns.
******************************************************************************/

WITH customer_purchase AS
(
    SELECT

        c.customer_unique_id AS customer,

        SUM(op.payment_value) AS total_revenue,

        NTILE(4)
            OVER
            (
                ORDER BY SUM(op.payment_value) DESC
            ) AS customer_quartile_rank

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id

    JOIN customers c
        ON o.customer_id = c.customer_id

    GROUP BY c.customer_unique_id
),

customer_segmentation AS
(
    SELECT
        *,

        CASE

            WHEN customer_quartile_rank = 1
                THEN 'Top 25%'

            WHEN customer_quartile_rank = 2
                THEN 'Upper Middle 25%'

            WHEN customer_quartile_rank = 3
                THEN 'Lower Middle 25%'

            ELSE 'Bottom 25%'

        END AS customer_classification

    FROM customer_purchase
)

SELECT *

FROM customer_segmentation;



/*
===============================================================================
KEY LEARNING OUTCOMES
===============================================================================

This investigation introduced NTILE(), a window function designed for data
segmentation rather than ranking.

Unlike ROW_NUMBER(), RANK() and DENSE_RANK(), NTILE() divides rows into
approximately equal-sized groups called buckets.

The following concepts were demonstrated:

✓ Creating quartiles, quintiles and deciles.

✓ Segmenting customers according to lifetime revenue.

✓ Building product pricing tiers.

✓ Segmenting seller transactions independently using PARTITION BY.

✓ Creating chronological purchase groups.

✓ Combining NTILE() with aggregate functions.

✓ Using CASE expressions to transform numeric buckets into meaningful business
  classifications.

===============================================================================
ANALYST NOTES
===============================================================================

NTILE() is one of the most practical analytical window functions because it
supports customer segmentation, pricing analysis, performance reporting and
executive dashboards.

Typical business applications include:

• Customer Lifetime Value segmentation

• Loyalty programme design

• Sales performance evaluation

• Product pricing analysis

• Revenue distribution studies

• Marketing campaign targeting

• Executive KPI dashboards

When combined with GROUP BY, CASE expressions and Common Table Expressions,
NTILE() becomes a powerful tool for transforming transactional data into
actionable business insights.

This investigation establishes the analytical foundation required for the
upcoming topics on LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE(), running totals
and moving averages.

===============================================================================
END OF SQL SCRIPT
===============================================================================