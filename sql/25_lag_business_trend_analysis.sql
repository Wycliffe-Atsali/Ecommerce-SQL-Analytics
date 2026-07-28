/*
===============================================================================
SQL Script: 25_lag_business_trend_analysis.sql
===============================================================================

Project         : Retail SQL Business Analysis
Dataset         : Brazilian E-Commerce Public Dataset (Olist)
Database        : PostgreSQL
Phase           : Phase 7 - Window Functions
Investigation   : 31
SQL Script      : 25

Title:
LAG() - Business Trend Analysis

Description:
This investigation introduces the LAG() window function, which retrieves values
from previous rows within a logical ordering. LAG() is widely used for trend
analysis, time-series reporting and period-over-period comparisons.

Business Applications

• Customer purchase history
• Payment trend analysis
• Seller pricing history
• Revenue trend reporting
• Operational reporting
• Time interval analysis

SQL Techniques Used

• LAG()
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
Display every order together with the previous order purchase timestamp.

Business Objective
Retrieve the purchase timestamp of the previous order to analyse the overall
chronological flow of customer purchases.
******************************************************************************/

WITH order_history AS
(
    SELECT

        order_id,

        order_purchase_timestamp AS current_order_timestamp,

        LAG(order_purchase_timestamp)
            OVER
            (
                ORDER BY order_purchase_timestamp
            ) AS previous_order_timestamp

    FROM orders
)

SELECT *

FROM order_history;



/******************************************************************************
Question 2
Display every payment together with the previous payment value.

Business Objective
Compare each payment with the payment recorded immediately before it.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LAG(op.payment_value, 1, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS previous_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
)

SELECT *

FROM payment_history;



/******************************************************************************
Question 3
Display every customer's orders together with the previous purchase date.

Business Objective
Track purchasing behaviour for each customer individually by comparing every
purchase with the customer's previous purchase.
******************************************************************************/

WITH customer_order_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LAG(o.order_purchase_timestamp)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS previous_purchase_timestamp

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT *

FROM customer_order_history;



/******************************************************************************
Question 4
Display every seller transaction together with the previous product price sold.

Business Objective
Compare each seller's current transaction price with the previous transaction
recorded by the same seller.
******************************************************************************/

WITH seller_transaction_history AS
(
    SELECT

        oi.seller_id,

        oi.product_id,

        oi.price AS current_product_price,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LAG(oi.price)
            OVER
            (
                PARTITION BY oi.seller_id
                ORDER BY o.order_purchase_timestamp
            ) AS previous_product_price

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id
)

SELECT *

FROM seller_transaction_history;



/******************************************************************************
Question 5
Calculate the difference between each payment and the previous payment.

Business Objective
Measure increases and decreases in payment values over time.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LAG(op.payment_value, 1, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS previous_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
)

SELECT

    *,

    current_order_payment -
    previous_order_payment AS payment_difference

FROM payment_history;



/******************************************************************************
Question 6
Calculate the time difference between consecutive customer purchases.

Business Objective
Determine the elapsed time between purchases made by the same customer.
******************************************************************************/

WITH customer_purchase_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LAG(o.order_purchase_timestamp)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS previous_purchase_timestamp

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    *,

    current_purchase_timestamp -
    previous_purchase_timestamp AS purchase_interval

FROM customer_purchase_history;



/******************************************************************************
Question 7
Compare each seller's current product price with the previous product price.

Business Objective
Measure pricing changes across consecutive seller transactions.
******************************************************************************/

WITH seller_transaction_history AS
(
    SELECT

        oi.seller_id,

        oi.product_id,

        oi.price AS current_product_price,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LAG(oi.price)
            OVER
            (
                PARTITION BY oi.seller_id
                ORDER BY o.order_purchase_timestamp
            ) AS previous_product_price

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id
)

SELECT

    *,

    current_product_price -
    previous_product_price AS price_difference

FROM seller_transaction_history;


/******************************************************************************
Question 8
Display the previous order within each order status.

Business Objective
Compare each order with the previous order recorded within the same operational
status.
******************************************************************************/

WITH order_history AS
(
    SELECT

        order_id,

        order_status,

        order_purchase_timestamp AS current_order_timestamp,

        LAG(order_purchase_timestamp)
            OVER
            (
                PARTITION BY order_status
                ORDER BY order_purchase_timestamp
            ) AS previous_order_timestamp

    FROM orders
)

SELECT *

FROM order_history;



/******************************************************************************
Question 9
Display the previous payment within each payment type.

Business Objective
Compare payment transactions against the previous transaction of the same
payment method.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        op.payment_type,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LAG(op.payment_value, 1, 0)
            OVER
            (
                PARTITION BY op.payment_type
                ORDER BY o.order_purchase_timestamp
            ) AS previous_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
)

SELECT *

FROM payment_history;



/******************************************************************************
Question 10
Retrieve the payment made two transactions earlier.

Business Objective
Compare each payment with both the immediately previous payment and the payment
made two transactions earlier.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LAG(op.payment_value, 1, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS previous_order_payment,

        LAG(op.payment_value, 2, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS second_previous_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
)

SELECT *

FROM payment_history;



/******************************************************************************
Question 11
Create a customer purchase trend report showing the current purchase date,
previous purchase date and the elapsed time between purchases.

Business Objective
Analyse purchasing frequency for each customer by measuring the interval
between consecutive purchases.
******************************************************************************/

WITH customer_purchase_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LAG(o.order_purchase_timestamp)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS previous_purchase_timestamp

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    *,

    current_purchase_timestamp -
    previous_purchase_timestamp AS purchase_interval

FROM customer_purchase_history

ORDER BY
    customer,
    current_purchase_timestamp;



/******************************************************************************
Question 12
Create a seller pricing trend report showing the current price, previous price
and price difference.

Business Objective
Monitor pricing changes across consecutive seller transactions.
******************************************************************************/

WITH seller_transaction_history AS
(
    SELECT

        oi.seller_id,

        oi.product_id,

        oi.price AS current_product_price,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LAG(oi.price)
            OVER
            (
                PARTITION BY oi.seller_id
                ORDER BY o.order_purchase_timestamp
            ) AS previous_product_price

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id
)

SELECT

    *,

    current_product_price -
    previous_product_price AS price_difference

FROM seller_transaction_history

ORDER BY
    seller_id,
    current_purchase_timestamp;



/******************************************************************************
Question 13
Identify payment transactions that are greater than the immediately previous
payment.

Business Objective
Highlight payment transactions that increased compared to the previous
transaction.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        o.order_id,

        o.order_purchase_timestamp,

        op.payment_value AS current_order_payment,

        LAG(op.payment_value, 1, 0)
            OVER
            (
                ORDER BY o.order_purchase_timestamp
            ) AS previous_order_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id
),

payment_difference AS
(
    SELECT

        *,

        current_order_payment -
        previous_order_payment AS payment_difference

    FROM payment_history
)

SELECT *

FROM payment_difference

WHERE payment_difference > 0;



/******************************************************************************
Question 14
Identify customer purchases that occurred after unusually long gaps.

Business Objective
Identify customers whose purchases were separated by more than 30 days,
highlighting potential inactivity or re-engagement.
******************************************************************************/

WITH customer_purchase_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS current_purchase_timestamp,

        LAG(o.order_purchase_timestamp)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS previous_purchase_timestamp

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id
),

purchase_intervals AS
(
    SELECT

        *,

        current_purchase_timestamp -
        previous_purchase_timestamp AS purchase_interval

    FROM customer_purchase_history
)

SELECT *

FROM purchase_intervals

WHERE purchase_interval > INTERVAL '30 days'

ORDER BY
    purchase_interval DESC;



/******************************************************************************
Question 15
Build a customer payment trend report combining current payments, previous
payments and payment changes.

Business Objective
Produce a business-ready trend report suitable for customer behaviour analysis
and dashboard reporting.
******************************************************************************/

WITH payment_history AS
(
    SELECT

        c.customer_unique_id AS customer,

        o.order_id,

        o.order_purchase_timestamp AS purchase_timestamp,

        op.payment_value AS current_payment,

        LAG(op.payment_value, 1, 0)
            OVER
            (
                PARTITION BY c.customer_unique_id
                ORDER BY o.order_purchase_timestamp
            ) AS previous_payment

    FROM order_payments op

    JOIN orders o
        ON op.order_id = o.order_id

    JOIN customers c
        ON o.customer_id = c.customer_id
)

SELECT

    *,

    current_payment -
    previous_payment AS payment_change

FROM payment_history

ORDER BY
    customer,
    purchase_timestamp;



/*
===============================================================================
KEY LEARNING OUTCOMES
===============================================================================

This investigation introduced the LAG() window function and demonstrated how
it can be used to retrieve values from previous rows for analytical
comparisons.

Concepts demonstrated include:

✓ Retrieving previous values using LAG()

✓ Comparing current and previous records

✓ Measuring payment and pricing changes

✓ Calculating time intervals between customer purchases

✓ Using PARTITION BY to restart comparisons within customers, sellers,
  payment types and order statuses

✓ Using LAG() with different offsets

✓ Building trend analysis reports using CTEs

===============================================================================
ANALYST NOTES
===============================================================================

LAG() is one of the most frequently used window functions in business
intelligence because it enables period-over-period comparisons.

Typical business applications include:

• Customer purchase behaviour

• Revenue trend analysis

• Seller pricing trends

• Operational monitoring

• Financial reporting

• Customer retention analysis

Combined with arithmetic operations, aggregate functions and CTEs, LAG()
provides a robust foundation for trend reporting and time-series analysis.

The concepts introduced in this investigation prepare the way for LEAD(),
FIRST_VALUE(), LAST_VALUE(), running totals and moving average calculations.

===============================================================================
END OF SQL SCRIPT
===============================================================================
