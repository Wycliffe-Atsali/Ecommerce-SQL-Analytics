/*
===============================================================================
Investigation 28: Window Functions - Introduction to ROW_NUMBER()
===============================================================================

Project:
Retail SQL Business Analysis
Brazilian E-Commerce Public Dataset (Olist)

Database:
PostgreSQL

Phase:
Phase 7 - Window Functions

Investigation:
28

Analyst:
Atsali Akolo

===============================================================================

OVERVIEW

This investigation introduces SQL Window Functions using the ROW_NUMBER()
function.

Unlike aggregate functions that collapse multiple rows into summary results,
window functions perform calculations across related rows while preserving every
individual row in the result set.

This investigation focuses on:

• OVER()
• PARTITION BY
• ORDER BY within a window
• ROW_NUMBER()

Business scenarios include:

• Sequencing customer purchases
• Identifying first purchases
• Identifying latest purchases
• Ranking sales within sellers
• Ranking payments within payment methods
• Chronological order analysis

===============================================================================

BUSINESS OBJECTIVES

1. Learn the fundamentals of SQL Window Functions.
2. Understand the OVER() clause.
3. Apply PARTITION BY to restart calculations within logical groups.
4. Generate sequential row numbers using ROW_NUMBER().
5. Solve practical business ranking problems without collapsing rows.
6. Prepare for advanced ranking functions such as RANK() and DENSE_RANK().

===============================================================================
*/

-- ============================================================================
-- Question 1
-- Display every order together with a row number based on purchase date
-- (oldest order first).
-- ============================================================================

SELECT
    order_id,
    order_purchase_timestamp AS time_ordered,
    ROW_NUMBER()
        OVER (
            ORDER BY
                order_purchase_timestamp ASC
        ) AS order_sequence
FROM orders;


-- ============================================================================
-- Question 2
-- Display every order together with a row number based on purchase date
-- (newest order first).
-- ============================================================================

SELECT
    order_id,
    order_purchase_timestamp AS time_ordered,
    ROW_NUMBER()
        OVER (
            ORDER BY
                order_purchase_timestamp DESC
        ) AS order_sequence
FROM orders;


-- ============================================================================
-- Question 3
-- Assign a sequential number to every customer ordered alphabetically.
-- ============================================================================

SELECT
    customer_unique_id AS customer,
    ROW_NUMBER()
        OVER (
            ORDER BY
                customer_unique_id ASC
        ) AS customer_number
FROM customers;


-- ============================================================================
-- Question 4
-- Assign a sequential number to every seller ordered alphabetically.
-- ============================================================================

SELECT
    seller_id AS seller,
    ROW_NUMBER()
        OVER (
            ORDER BY
                seller_id ASC
        ) AS seller_number
FROM sellers;


-- ============================================================================
-- Question 5
-- For each customer, number their orders chronologically.
--
-- Business Purpose:
-- Understand each customer's purchasing journey by assigning an order sequence
-- beginning with their first purchase.
-- ============================================================================

SELECT
    c.customer_unique_id AS customer,
    o.order_id,
    o.order_purchase_timestamp AS time_ordered,

    ROW_NUMBER()
        OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY
                o.order_purchase_timestamp,
                o.order_id
        ) AS customer_order_sequence

FROM orders o

JOIN customers c
    ON o.customer_id = c.customer_id;


-- ============================================================================
-- Question 6
-- Identify the first purchase made by every customer.
--
-- Business Purpose:
-- Useful for customer acquisition analysis, onboarding studies and retention
-- reporting.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS time_ordered,

        ROW_NUMBER()
            OVER (
                PARTITION BY c.customer_unique_id
                ORDER BY
                    o.order_purchase_timestamp,
                    o.order_id
            ) AS purchase_number

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT
    customer,
    order_id,
    time_ordered
FROM ranked_orders
WHERE purchase_number = 1;


-- ============================================================================
-- Question 7
-- Identify the most recent purchase made by every customer.
--
-- Business Purpose:
-- Frequently used in customer retention analysis and CRM reporting.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS time_ordered,

        ROW_NUMBER()
            OVER (
                PARTITION BY c.customer_unique_id
                ORDER BY
                    o.order_purchase_timestamp DESC,
                    o.order_id DESC
            ) AS purchase_number

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT
    customer,
    order_id,
    time_ordered
FROM ranked_orders
WHERE purchase_number = 1;


-- ============================================================================
-- Question 8
-- Number every order within each order status.
--
-- Business Purpose:
-- Analyse the chronological progression of orders within each operational
-- status (delivered, shipped, cancelled, etc.).
-- ============================================================================

SELECT

    order_id,

    order_status,

    order_purchase_timestamp AS time_ordered,

    ROW_NUMBER()
        OVER (
            PARTITION BY order_status
            ORDER BY
                order_purchase_timestamp,
                order_id
        ) AS status_order_sequence

FROM orders;

-- ============================================================================
-- Question 9
-- For each seller, number product sales based on selling price (highest first).
--
-- Business Purpose:
-- Identify a seller's highest-value product sales and establish a ranked list
-- of transactions based on selling price.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        s.seller_id AS seller,

        p.product_id AS product,

        oi.price,

        ROW_NUMBER()
            OVER (
                PARTITION BY s.seller_id
                ORDER BY
                    oi.price DESC,
                    oi.product_id
            ) AS seller_sale_rank

    FROM sellers s

    JOIN order_items oi
        ON s.seller_id = oi.seller_id

    JOIN products p
        ON oi.product_id = p.product_id
)

SELECT
    seller,
    product,
    price,
    seller_sale_rank
FROM ranked_products;


-- ============================================================================
-- Question 10
-- Rank payments within each payment type according to payment value.
--
-- Business Purpose:
-- Compare payment values within each payment method to identify the highest
-- value transactions.
-- ============================================================================

WITH ranked_payments AS
(
    SELECT

        order_id,

        payment_type,

        payment_value,

        ROW_NUMBER()
            OVER (
                PARTITION BY payment_type
                ORDER BY
                    payment_value DESC,
                    order_id
            ) AS payment_rank

    FROM order_payments
)

SELECT
    order_id,
    payment_type,
    payment_value,
    payment_rank
FROM ranked_payments;


-- ============================================================================
-- Question 11
-- Retrieve only the first order for every customer.
--
-- Business Purpose:
-- Identify customer acquisition orders for onboarding and first-purchase
-- analysis.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        ROW_NUMBER()
            OVER (
                PARTITION BY c.customer_unique_id
                ORDER BY
                    o.order_purchase_timestamp,
                    o.order_id
            ) AS purchase_number

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    customer,

    order_id,

    order_purchase_timestamp

FROM ranked_orders

WHERE purchase_number = 1;


-- ============================================================================
-- Question 12
-- Retrieve only the most recent order for every customer.
--
-- Business Purpose:
-- Useful for customer activity monitoring and retention reporting.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        ROW_NUMBER()
            OVER (
                PARTITION BY c.customer_unique_id
                ORDER BY
                    o.order_purchase_timestamp DESC,
                    o.order_id DESC
            ) AS purchase_number

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    customer,

    order_id,

    order_purchase_timestamp

FROM ranked_orders

WHERE purchase_number = 1;


-- ============================================================================
-- Question 13
-- Return the highest-priced product sale for every seller.
--
-- Business Purpose:
-- Identify each seller's highest-value sale.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        s.seller_id AS seller,

        p.product_id AS product,

        oi.price,

        ROW_NUMBER()
            OVER (
                PARTITION BY s.seller_id
                ORDER BY
                    oi.price DESC,
                    oi.product_id
            ) AS seller_sale_rank

    FROM sellers s

    JOIN order_items oi
        ON s.seller_id = oi.seller_id

    JOIN products p
        ON oi.product_id = p.product_id
)

SELECT

    seller,

    product,

    price

FROM ranked_products

WHERE seller_sale_rank = 1;


-- ============================================================================
-- Question 14
-- Find the first order placed within each customer state.
--
-- Business Purpose:
-- Analyse the earliest recorded customer purchase in every Brazilian state.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_state,

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        ROW_NUMBER()
            OVER (
                PARTITION BY c.customer_state
                ORDER BY
                    o.order_purchase_timestamp,
                    o.order_id
            ) AS state_order_rank

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id
)

SELECT

    customer_state,

    customer,

    order_id,

    order_purchase_timestamp

FROM ranked_orders

WHERE state_order_rank = 1;


-- ============================================================================
-- Question 15
-- Produce a report showing every order together with its sequence number within
-- each customer's purchasing history.
--
-- Business Purpose:
-- Construct a chronological customer purchasing timeline that preserves every
-- order while indicating its position in the customer's journey.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        ROW_NUMBER()
            OVER (
                PARTITION BY c.customer_unique_id
                ORDER BY
                    o.order_purchase_timestamp,
                    o.order_id
            ) AS customer_order_sequence

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    customer,

    order_id,

    order_purchase_timestamp,

    customer_order_sequence

FROM ranked_orders

ORDER BY
    customer,
    customer_order_sequence;



/*
===============================================================================
KEY LEARNING OUTCOMES
===============================================================================

This investigation introduced SQL Window Functions through ROW_NUMBER().

The following concepts were demonstrated:

✓ OVER()

    Defines the window over which calculations are performed.

✓ PARTITION BY

    Divides the dataset into logical groups while preserving individual rows.

✓ ORDER BY within OVER()

    Determines the order in which rows are evaluated inside each partition.

✓ ROW_NUMBER()

    Assigns a unique sequential number to every row within a partition.

Unlike GROUP BY, window functions do not collapse data into summary rows.
Instead, they enrich each row with analytical information while maintaining the
original level of detail.

===============================================================================
ANALYST NOTES
===============================================================================

Business analysts frequently use ROW_NUMBER() to:

• Identify first customer purchases.
• Retrieve the latest customer activity.
• Build customer purchasing timelines.
• Rank transactions within categories.
• Remove duplicate records by retaining the first or latest occurrence.
• Support customer lifecycle and retention analysis.
• Prepare datasets for advanced reporting and dashboard development.

ROW_NUMBER() forms the foundation for more advanced window functions such as:

• RANK()
• DENSE_RANK()
• NTILE()
• LAG()
• LEAD()
• FIRST_VALUE()
• LAST_VALUE()

Mastering ROW_NUMBER() is an essential step toward advanced SQL analytics and
is a highly valued skill in professional data analyst and business intelligence
roles.

===============================================================================
END OF INVESTIGATION 28
===============================================================================