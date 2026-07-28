/*
===============================================================================
SQL Script: 26_lead_business_forecasting_analysis.sql
===============================================================================

Project         : Retail SQL Business Analysis
Dataset         : Brazilian E-Commerce Public Dataset (Olist)
Database        : PostgreSQL
Phase           : Phase 7 - Window Functions
Investigation   : 32
SQL Script      : 26

Title:
LEAD() - Business Forecasting and Forward Trend Analysis

Description:
This investigation introduces the LEAD() window function, which retrieves
values from subsequent rows within an ordered window. LEAD() enables analysts
to compare current business events with future events, making it invaluable
for forecasting, customer lifecycle analysis and operational planning.

Business Applications

• Customer purchase forecasting
• Revenue forecasting
• Seller pricing trends
• Customer lifecycle analysis
• Operational planning
• Payment forecasting
• Future event analysis

SQL Techniques Used

• LEAD()
• OVER()
• PARTITION BY
• ORDER BY
• Common Table Expressions (CTEs)
• INNER JOIN
• Date/Time Arithmetic

===============================================================================
*/


/******************************************************************************
Question 1
Display every order together with the next order purchase timestamp.

Business Objective
Retrieve the purchase timestamp of the next order in chronological sequence.
******************************************************************************/

WITH order_history AS
(
    SELECT

        order_id,

        order_purchase_timestamp AS current_order_timestamp,

        LEAD(order_purchase_timestamp)
            OVER
            (
                ORDER BY order_purchase_timestamp
            ) AS next_order_timestamp

    FROM orders
)

SELECT *

FROM order_history;



/******************************************************************************
Question 2
Display every payment together with the next payment value.

Business Objective
Compare each payment with the payment that immediately follows it.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LEAD(op.payment_value, 1, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS next_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
)

SELECT *

FROM payment_history;



/******************************************************************************
Question 3
Display every customer's purchases together with their next purchase date.

Business Objective
Track customer purchasing behaviour by identifying each customer's next
purchase.
******************************************************************************/

WITH customer_order_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LEAD(o.order_purchase_timestamp)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS next_purchase_timestamp

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT *

FROM customer_order_history;



/******************************************************************************
Question 4
Display every seller transaction together with the next product price sold.

Business Objective
Compare each seller's current product price with the next recorded selling
price.
******************************************************************************/

WITH seller_transaction_history AS
(
    SELECT

        oi.seller_id,

        oi.product_id,

        oi.price AS current_product_price,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LEAD(oi.price)
            OVER
            (
                PARTITION BY oi.seller_id
                ORDER BY o.order_purchase_timestamp
            ) AS next_product_price

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id
)

SELECT *

FROM seller_transaction_history;



/******************************************************************************
Question 5
Calculate the payment difference between the current payment and the next
payment.

Business Objective
Measure projected increases or decreases between consecutive payments.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LEAD(op.payment_value, 1, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS next_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
)

SELECT

    *,

    next_order_payment -
    current_order_payment AS payment_difference

FROM payment_history;



/******************************************************************************
Question 6
Calculate the time remaining until each customer's next purchase.

Business Objective
Measure the time interval between a customer's current purchase and their next
purchase.
******************************************************************************/

WITH customer_purchase_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LEAD(o.order_purchase_timestamp)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS next_purchase_timestamp

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    *,

    next_purchase_timestamp -
    current_purchase_timestamp AS purchase_interval

FROM customer_purchase_history;



/******************************************************************************
Question 7
Compare each seller's current product price with the next product price and
calculate the price difference.

Business Objective
Track projected pricing changes across seller transactions.
******************************************************************************/

WITH seller_transaction_history AS
(
    SELECT

        oi.seller_id,

        oi.product_id,

        oi.price AS current_product_price,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LEAD(oi.price)
            OVER
            (
                PARTITION BY oi.seller_id
                ORDER BY o.order_purchase_timestamp
            ) AS next_product_price

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id
)

SELECT

    *,

    next_product_price -
    current_product_price AS price_difference

FROM seller_transaction_history;


/******************************************************************************
Question 8
Display the next order within each order status.

Business Objective
Compare each order with the next order recorded within the same operational
status.
******************************************************************************/

WITH order_history AS
(
    SELECT

        order_id,

        order_status,

        order_purchase_timestamp AS current_order_timestamp,

        LEAD(order_purchase_timestamp)
            OVER
            (
                PARTITION BY order_status
                ORDER BY order_purchase_timestamp
            ) AS next_order_timestamp

    FROM orders
)

SELECT *

FROM order_history;



/******************************************************************************
Question 9
Display the next payment within each payment type.

Business Objective
Compare payment transactions with the next transaction of the same payment
method.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        op.payment_type,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LEAD(op.payment_value, 1, 0)
            OVER
            (
                PARTITION BY op.payment_type
                ORDER BY o.order_purchase_timestamp
            ) AS next_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
)

SELECT *

FROM payment_history;



/******************************************************************************
Question 10
Retrieve the payment occurring two transactions later.

Business Objective
Compare each payment with both the next payment and the payment occurring two
transactions later.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LEAD(op.payment_value, 1, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS next_order_payment,

        LEAD(op.payment_value, 2, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS second_next_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
)

SELECT *

FROM payment_history;



/******************************************************************************
Question 11
Create a customer purchase forecast report showing the current purchase date,
next purchase date and the time until the next purchase.

Business Objective
Forecast customer purchasing behaviour by measuring the interval until the next
purchase.
******************************************************************************/

WITH customer_purchase_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LEAD(o.order_purchase_timestamp)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS next_purchase_timestamp

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    *,

    next_purchase_timestamp -
    current_purchase_timestamp AS purchase_interval

FROM customer_purchase_history

ORDER BY
    customer,
    current_purchase_timestamp;



/******************************************************************************
Question 12
Create a seller pricing forecast report showing the current product price,
next product price and projected price difference.

Business Objective
Forecast pricing changes by comparing each seller's current transaction with
their following transaction.
******************************************************************************/

WITH seller_transaction_history AS
(
    SELECT

        oi.seller_id,

        oi.product_id,

        oi.price AS current_product_price,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LEAD(oi.price)
            OVER
            (
                PARTITION BY oi.seller_id
                ORDER BY o.order_purchase_timestamp
            ) AS next_product_price

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id
)

SELECT

    *,

    next_product_price -
    current_product_price AS price_difference

FROM seller_transaction_history

ORDER BY
    seller_id,
    current_purchase_timestamp;



/******************************************************************************
Question 13
Identify payment transactions that are smaller than the following payment.

Business Objective
Identify payment records where the next payment exceeds the current payment.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LEAD(op.payment_value, 1, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS next_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
),

payment_difference AS
(
    SELECT

        *,

        next_order_payment -
        current_order_payment AS payment_difference

    FROM payment_history
)

SELECT *

FROM payment_difference

WHERE payment_difference > 0;



/******************************************************************************
Question 14
Identify customers whose next purchase occurred within 30 days.

Business Objective
Highlight highly engaged customers who returned within a short period after
their previous purchase.
******************************************************************************/

WITH customer_purchase_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LEAD(o.order_purchase_timestamp)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS next_purchase_timestamp

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
),

purchase_intervals AS
(
    SELECT

        *,

        next_purchase_timestamp -
        current_purchase_timestamp AS purchase_interval

    FROM customer_purchase_history
)

SELECT *

FROM purchase_intervals

WHERE purchase_interval < INTERVAL '30 days'

ORDER BY
    purchase_interval DESC;



/******************************************************************************
Question 15
Build a customer payment forecast report containing the current payment, next
payment and projected payment difference.

Business Objective
Produce a business-ready forecasting dataset suitable for customer payment
trend analysis and dashboard reporting.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS purchase_timestamp,

        op.payment_value AS current_payment,

        LEAD(op.payment_value, 1, 0)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS next_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    *,

    next_payment -
    current_payment AS payment_change

FROM payment_history

ORDER BY
    customer,
    purchase_timestamp;



/*
===============================================================================
KEY LEARNING OUTCOMES
===============================================================================

This investigation introduced the LEAD() window function and demonstrated how
future values can be retrieved and compared within ordered datasets.

Concepts demonstrated include:

✓ Retrieving future values using LEAD()

✓ Comparing current and future business events

✓ Measuring projected payment and pricing changes

✓ Calculating time until the next customer purchase

✓ Using PARTITION BY to restart forward-looking analysis within customers,
  sellers, payment types and order statuses

✓ Using LEAD() with different offsets

✓ Building forecasting reports using Common Table Expressions (CTEs)

===============================================================================
ANALYST NOTES
===============================================================================

LEAD() complements LAG() by enabling forward-looking analysis.

Typical business applications include:

• Customer purchase forecasting

• Revenue forecasting

• Seller pricing strategy

• Customer lifecycle analysis

• Operational planning

• Business performance forecasting

Combined with arithmetic operations, CTEs and other window functions, LEAD()
provides a powerful framework for developing predictive and trend-based
business reports.

The concepts introduced in this investigation naturally lead into more
advanced analytical techniques, including FIRST_VALUE(), LAST_VALUE(),
running totals and moving averages.

===============================================================================
END OF SQL SCRIPT
===============================================================================
```