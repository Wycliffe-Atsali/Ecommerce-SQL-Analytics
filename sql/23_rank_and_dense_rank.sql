/*
===============================================================================
Investigation 29: Window Functions - RANK() and DENSE_RANK()
===============================================================================

Project:
Retail SQL Business Analysis

Dataset:
Brazilian E-Commerce Public Dataset (Olist)

Database:
PostgreSQL

Phase:
Phase 7 - Window Functions

Investigation:
29

Analyst:
Atsali Akolo

===============================================================================

OVERVIEW

This investigation builds upon the previous introduction to window functions by
introducing two additional ranking functions:

• RANK()
• DENSE_RANK()

Unlike ROW_NUMBER(), these functions assign identical rankings to rows with
equal ordering values.

The investigation demonstrates how ranking functions can be applied to business
problems involving product pricing, customer purchases, seller performance,
payments and geographical sales analysis.

===============================================================================

BUSINESS OBJECTIVES

1. Understand the behaviour of RANK().
2. Understand the behaviour of DENSE_RANK().
3. Compare RANK(), DENSE_RANK() and ROW_NUMBER().
4. Apply ranking functions to realistic business scenarios.
5. Learn when ranking gaps are desirable and when dense rankings are preferred.

===============================================================================
*/


-- ============================================================================
-- Question 1
-- Rank all products by selling price.
--
-- Business Purpose:
-- Produce a ranked list of products based on transaction selling price.
-- Products with identical prices receive the same rank.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        oi.product_id AS product,

        oi.price,

        RANK()
            OVER
            (
                ORDER BY oi.price DESC
            ) AS product_rank

    FROM order_items oi
)

SELECT *

FROM ranked_products;



-- ============================================================================
-- Question 2
-- Rank all products using DENSE_RANK().
--
-- Business Purpose:
-- Produce a dense ranking of product prices without gaps between rankings.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        oi.product_id AS product,

        oi.price,

        DENSE_RANK()
            OVER
            (
                ORDER BY oi.price DESC
            ) AS product_dense_rank

    FROM order_items oi
)

SELECT *

FROM ranked_products;



-- ============================================================================
-- Question 3
-- Rank all payments by payment value.
--
-- Business Purpose:
-- Identify the highest-value payment transactions.
-- ============================================================================

WITH ranked_payments AS
(
    SELECT

        order_id,

        payment_value,

        RANK()
            OVER
            (
                ORDER BY payment_value DESC
            ) AS payment_rank

    FROM order_payments
)

SELECT *

FROM ranked_payments;



-- ============================================================================
-- Question 4
-- Rank all payments using DENSE_RANK().
--
-- Business Purpose:
-- Compare payment values without introducing ranking gaps.
-- ============================================================================

WITH ranked_payments AS
(
    SELECT

        order_id,

        payment_value,

        DENSE_RANK()
            OVER
            (
                ORDER BY payment_value DESC
            ) AS payment_dense_rank

    FROM order_payments
)

SELECT *

FROM ranked_payments;



-- ============================================================================
-- Question 5
-- Rank products by selling price within each product category.
--
-- Business Purpose:
-- Compare products against others within the same category.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        p.product_id,

        p.product_category_name AS category,

        oi.price,

        RANK()
            OVER
            (
                PARTITION BY p.product_category_name
                ORDER BY oi.price DESC
            ) AS category_rank

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id
)

SELECT *

FROM ranked_products;



-- ============================================================================
-- Question 6
-- Rank product sales within each seller.
--
-- Business Purpose:
-- Compare product sales by selling price for every seller.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        seller_id,

        product_id,

        price,

        RANK()
            OVER
            (
                PARTITION BY seller_id
                ORDER BY price DESC
            ) AS seller_rank

    FROM order_items
)

SELECT *

FROM ranked_products;



-- ============================================================================
-- Question 7
-- Rank customer orders by purchase date within each customer's purchasing
-- history.
--
-- Business Purpose:
-- Understand the sequence of purchases for every customer while allowing tied
-- timestamps to share the same rank.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        RANK()
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp ASC
            ) AS customer_order_rank

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT *

FROM ranked_orders;/*
===============================================================================
Investigation 29: Window Functions - RANK() and DENSE_RANK()
===============================================================================

Project:
Retail SQL Business Analysis

Dataset:
Brazilian E-Commerce Public Dataset (Olist)

Database:
PostgreSQL

Phase:
Phase 7 - Window Functions

Investigation:
29

Analyst:
Atsali Akolo

===============================================================================

OVERVIEW

This investigation builds upon the previous introduction to window functions by
introducing two additional ranking functions:

• RANK()
• DENSE_RANK()

Unlike ROW_NUMBER(), these functions assign identical rankings to rows with
equal ordering values.

The investigation demonstrates how ranking functions can be applied to business
problems involving product pricing, customer purchases, seller performance,
payments and geographical sales analysis.

===============================================================================

BUSINESS OBJECTIVES

1. Understand the behaviour of RANK().
2. Understand the behaviour of DENSE_RANK().
3. Compare RANK(), DENSE_RANK() and ROW_NUMBER().
4. Apply ranking functions to realistic business scenarios.
5. Learn when ranking gaps are desirable and when dense rankings are preferred.

===============================================================================
*/


-- ============================================================================
-- Question 1
-- Rank all products by selling price.
--
-- Business Purpose:
-- Produce a ranked list of products based on transaction selling price.
-- Products with identical prices receive the same rank.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        oi.product_id AS product,

        oi.price,

        RANK()
            OVER
            (
                ORDER BY oi.price DESC
            ) AS product_rank

    FROM order_items oi
)

SELECT *

FROM ranked_products;



-- ============================================================================
-- Question 2
-- Rank all products using DENSE_RANK().
--
-- Business Purpose:
-- Produce a dense ranking of product prices without gaps between rankings.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        oi.product_id AS product,

        oi.price,

        DENSE_RANK()
            OVER
            (
                ORDER BY oi.price DESC
            ) AS product_dense_rank

    FROM order_items oi
)

SELECT *

FROM ranked_products;



-- ============================================================================
-- Question 3
-- Rank all payments by payment value.
--
-- Business Purpose:
-- Identify the highest-value payment transactions.
-- ============================================================================

WITH ranked_payments AS
(
    SELECT

        order_id,

        payment_value,

        RANK()
            OVER
            (
                ORDER BY payment_value DESC
            ) AS payment_rank

    FROM order_payments
)

SELECT *

FROM ranked_payments;



-- ============================================================================
-- Question 4
-- Rank all payments using DENSE_RANK().
--
-- Business Purpose:
-- Compare payment values without introducing ranking gaps.
-- ============================================================================

WITH ranked_payments AS
(
    SELECT

        order_id,

        payment_value,

        DENSE_RANK()
            OVER
            (
                ORDER BY payment_value DESC
            ) AS payment_dense_rank

    FROM order_payments
)

SELECT *

FROM ranked_payments;



-- ============================================================================
-- Question 5
-- Rank products by selling price within each product category.
--
-- Business Purpose:
-- Compare products against others within the same category.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        p.product_id,

        p.product_category_name AS category,

        oi.price,

        RANK()
            OVER
            (
                PARTITION BY p.product_category_name
                ORDER BY oi.price DESC
            ) AS category_rank

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id
)

SELECT *

FROM ranked_products;



-- ============================================================================
-- Question 6
-- Rank product sales within each seller.
--
-- Business Purpose:
-- Compare product sales by selling price for every seller.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        seller_id,

        product_id,

        price,

        RANK()
            OVER
            (
                PARTITION BY seller_id
                ORDER BY price DESC
            ) AS seller_rank

    FROM order_items
)

SELECT *

FROM ranked_products;



-- ============================================================================
-- Question 7
-- Rank customer orders by purchase date within each customer's purchasing
-- history.
--
-- Business Purpose:
-- Understand the sequence of purchases for every customer while allowing tied
-- timestamps to share the same rank.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        RANK()
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp ASC
            ) AS customer_order_rank

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT *

FROM ranked_orders;

-- ============================================================================
-- Question 8
-- Rank customer orders by purchase date within each customer's purchasing
-- history using DENSE_RANK().
--
-- Business Purpose:
-- Assign purchase rankings while ensuring consecutive rankings without gaps
-- when multiple orders share the same purchase timestamp.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        DENSE_RANK()
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp ASC
            ) AS customer_order_dense_rank

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT *

FROM ranked_orders;



-- ============================================================================
-- Question 9
-- Compare RANK() and DENSE_RANK() for payments within each payment type.
--
-- Business Purpose:
-- Demonstrate the behavioural difference between the two ranking functions
-- when duplicate payment values exist.
-- ============================================================================

WITH ranked_payments AS
(
    SELECT

        order_id,

        payment_type,

        payment_value,

        RANK()
            OVER
            (
                PARTITION BY payment_type
                ORDER BY payment_value DESC
            ) AS payment_rank,

        DENSE_RANK()
            OVER
            (
                PARTITION BY payment_type
                ORDER BY payment_value DESC
            ) AS payment_dense_rank

    FROM order_payments
)

SELECT *

FROM ranked_payments;



-- ============================================================================
-- Question 10
-- Rank orders within each order status according to purchase timestamp.
--
-- Business Purpose:
-- Analyse the chronological progression of orders for every operational status.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        order_id,

        order_status,

        order_purchase_timestamp,

        RANK()
            OVER
            (
                PARTITION BY order_status
                ORDER BY order_purchase_timestamp ASC
            ) AS status_rank

    FROM orders
)

SELECT *

FROM ranked_orders;



-- ============================================================================
-- Question 11
-- Return the highest-priced product sale(s) for every seller.
--
-- Business Purpose:
-- Identify every highest-value transaction for each seller while preserving
-- ties.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        seller_id,

        product_id,

        price,

        RANK()
            OVER
            (
                PARTITION BY seller_id
                ORDER BY price DESC
            ) AS seller_rank

    FROM order_items
)

SELECT

    seller_id,

    product_id,

    price

FROM ranked_products

WHERE seller_rank = 1;



-- ============================================================================
-- Question 12
-- Return the highest-priced product(s) within every product category.
--
-- Business Purpose:
-- Identify premium-priced products across each product category while allowing
-- ties without ranking gaps.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        p.product_id,

        p.product_category_name AS category,

        oi.price,

        DENSE_RANK()
            OVER
            (
                PARTITION BY p.product_category_name
                ORDER BY oi.price DESC
            ) AS category_dense_rank

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id
)

SELECT

    product_id,

    category,

    price

FROM ranked_products

WHERE category_dense_rank = 1;



-- ============================================================================
-- Question 13
-- Identify the earliest order(s) in each customer state.
--
-- Business Purpose:
-- Determine the first recorded customer purchase within every Brazilian state.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_state,

        o.order_id,

        o.order_purchase_timestamp,

        RANK()
            OVER
            (
                PARTITION BY c.customer_state
                ORDER BY o.order_purchase_timestamp ASC
            ) AS state_rank

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    customer_state,

    order_id,

    order_purchase_timestamp

FROM ranked_orders

WHERE state_rank = 1;



-- ============================================================================
-- Question 14
-- Compare ROW_NUMBER(), RANK() and DENSE_RANK() for customer orders.
--
-- Business Purpose:
-- Demonstrate how each ranking function behaves when duplicate ordering values
-- occur.
-- ============================================================================

WITH ranked_orders AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp,

        ROW_NUMBER()
            OVER
            (
                ORDER BY o.order_purchase_timestamp ASC
            ) AS row_number,

        RANK()
            OVER
            (
                ORDER BY o.order_purchase_timestamp ASC
            ) AS rank_number,

        DENSE_RANK()
            OVER
            (
                ORDER BY o.order_purchase_timestamp ASC
            ) AS dense_rank_number

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT *

FROM ranked_orders;



-- ============================================================================
-- Question 15
-- Produce a seller performance report showing both RANK() and DENSE_RANK().
--
-- Business Purpose:
-- Compare the behaviour of both ranking functions for seller transactions.
-- ============================================================================

WITH ranked_products AS
(
    SELECT

        seller_id,

        product_id,

        price,

        RANK()
            OVER
            (
                PARTITION BY seller_id
                ORDER BY price DESC
            ) AS seller_rank,

        DENSE_RANK()
            OVER
            (
                PARTITION BY seller_id
                ORDER BY price DESC
            ) AS seller_dense_rank

    FROM order_items
)

SELECT *

FROM ranked_products

ORDER BY
    seller_id,
    seller_rank,
    product_id;



/*
===============================================================================
KEY LEARNING OUTCOMES
===============================================================================

This investigation expanded the use of SQL Window Functions by introducing
RANK() and DENSE_RANK().

The following concepts were demonstrated:

✓ RANK()

    Assigns identical rankings to tied values while leaving gaps in subsequent
    rankings.

✓ DENSE_RANK()

    Assigns identical rankings to tied values without leaving gaps.

✓ PARTITION BY

    Creates independent ranking groups for customers, sellers, payment types,
    order statuses and product categories.

✓ Business Ranking

    Demonstrated how different ranking methods support different business
    requirements depending on whether ranking gaps are desirable.

===============================================================================
COMPARISON OF RANKING FUNCTIONS
===============================================================================

ROW_NUMBER()

• Every row receives a unique sequential number.
• Duplicate ordering values receive different numbers.

Example:

Price      Row Number

1000       1
900        2
900        3
700        4


RANK()

• Equal values receive the same rank.
• Ranking gaps appear after ties.

Example:

Price      Rank

1000       1
900        2
900        2
700        4


DENSE_RANK()

• Equal values receive the same rank.
• No ranking gaps occur.

Example:

Price      Dense Rank

1000       1
900        2
900        2
700        3

===============================================================================
ANALYST NOTES
===============================================================================

Choosing the correct ranking function depends on the business objective.

Use ROW_NUMBER() when every row must receive a unique sequence.

Use RANK() when tied values should share the same competitive position and
ranking gaps are acceptable.

Use DENSE_RANK() when tied values should share the same rank while maintaining
continuous rankings.

These functions are widely used in:

• Sales leaderboards
• Product pricing analysis
• Customer segmentation
• Employee performance reporting
• Business dashboards
• Financial reporting
• Operational analytics

Understanding these distinctions is essential for advanced SQL analytics and is
commonly assessed during technical interviews for Data Analyst and Business
Intelligence positions.

===============================================================================
END OF INVESTIGATION 29
===============================================================================