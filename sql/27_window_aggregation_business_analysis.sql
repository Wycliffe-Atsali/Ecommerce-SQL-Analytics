/*
===============================================================================
SQL Script: 27_window_aggregation_business_analysis.sql
===============================================================================

Project         : Retail SQL Business Analysis
Dataset         : Brazilian E-Commerce Public Dataset (Olist)
Database        : PostgreSQL
Phase           : Phase 7 - Window Functions
Investigation   : 33
SQL Script      : 27

Title:
Window Aggregation Functions - FIRST_VALUE(), LAST_VALUE(),
Running Totals and Moving Averages

Description:
This investigation introduces analytical window aggregation functions used
for executive reporting and business intelligence dashboards. Unlike ranking
functions, these calculations preserve every row while computing cumulative
and rolling metrics.

Business Applications

• First customer purchase identification
• Latest customer purchase identification
• Running revenue analysis
• Customer lifetime spending progression
• Seller cumulative sales analysis
• Moving average trend analysis
• Executive KPI reporting

SQL Techniques Used

• FIRST_VALUE()
• LAST_VALUE()
• SUM() OVER()
• AVG() OVER()
• PARTITION BY
• ORDER BY
• Window Frames
• INNER JOIN

===============================================================================
*/


/******************************************************************************
Question 1
Display every order together with the first order purchase timestamp.

Business Objective
Identify the earliest recorded order while preserving every order record.
******************************************************************************/

SELECT

    order_id,

    order_purchase_timestamp AS current_order_timestamp,

    FIRST_VALUE(order_purchase_timestamp)
        OVER
        (
            ORDER BY order_purchase_timestamp ASC
        ) AS first_order_purchase_timestamp

FROM orders;



/******************************************************************************
Question 2
Display every order together with the last order purchase timestamp.

Business Objective
Display the final recorded purchase timestamp for every order in the dataset.
******************************************************************************/

SELECT

    order_id,

    order_purchase_timestamp AS current_order_timestamp,

    LAST_VALUE(order_purchase_timestamp)
        OVER
        (
            ORDER BY order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND UNBOUNDED FOLLOWING
        ) AS last_order_purchase_timestamp

FROM orders;



/******************************************************************************
Question 3
Display each customer's first purchase date.

Business Objective
Determine when each customer made their first purchase.
******************************************************************************/

SELECT

    c.customer_unique_id AS customer,

    o.order_id,

    o.order_purchase_timestamp AS current_order_timestamp,

    FIRST_VALUE(o.order_purchase_timestamp)
        OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC
        ) AS first_order_purchase_timestamp

FROM orders o

JOIN customers c
    ON o.customer_id = c.customer_id

ORDER BY
    o.order_purchase_timestamp ASC;



/******************************************************************************
Question 4
Display each seller together with their first recorded sale.

Business Objective
Identify each seller's earliest recorded sales transaction.
******************************************************************************/

SELECT

    o.order_id,

    oi.seller_id AS seller,

    oi.product_id,

    oi.price,

    FIRST_VALUE(oi.price)
        OVER
        (
            PARTITION BY oi.seller_id
            ORDER BY o.order_purchase_timestamp ASC
        ) AS first_recorded_sale

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

ORDER BY
    o.order_purchase_timestamp ASC;



/******************************************************************************
Question 5
Calculate a running total of payment revenue over time.

Business Objective
Measure cumulative revenue growth across all transactions.
******************************************************************************/

SELECT

    c.customer_unique_id AS customer,

    o.order_id,

    o.order_purchase_timestamp AS current_order_timestamp,

    op.payment_value,

    SUM(op.payment_value)
        OVER
        (
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS running_total

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id;



/******************************************************************************
Question 6
Calculate a running total of sales for each seller.

Business Objective
Measure cumulative seller revenue over time.
******************************************************************************/

SELECT

    oi.seller_id AS seller,

    o.order_id,

    oi.price,

    SUM(oi.price)
        OVER
        (
            PARTITION BY oi.seller_id
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS running_sales_total

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id;



/******************************************************************************
Question 7
Calculate a running total of customer spending.

Business Objective
Measure cumulative spending for every customer across their purchasing history.
******************************************************************************/

SELECT

    c.customer_unique_id AS customer,

    o.order_id,

    o.order_purchase_timestamp AS current_order_timestamp,

    op.payment_value,

    SUM(op.payment_value)
        OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS running_total

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

ORDER BY
    o.order_purchase_timestamp ASC;



/******************************************************************************
Question 8
Calculate a three-transaction moving average of payment values.

Business Objective
Smooth short-term payment fluctuations using a rolling average.
******************************************************************************/

SELECT

    o.order_id,

    o.order_purchase_timestamp AS current_order_timestamp,

    op.payment_value,

    ROUND
    (
        AVG(op.payment_value)
            OVER
            (
                ORDER BY o.order_purchase_timestamp ASC
                ROWS BETWEEN 2 PRECEDING
                         AND CURRENT ROW
            ),
        2
    ) AS moving_average_payment

FROM orders o

JOIN order_payments op
    ON o.order_id = op.order_id;


/******************************************************************************
Question 9
Calculate a three-transaction moving average of seller product prices.

Business Objective
Smooth seller pricing trends by calculating a rolling average over the current
and two previous transactions.
******************************************************************************/

SELECT

    oi.seller_id,

    oi.product_id,

    oi.price,

    ROUND
    (
        AVG(oi.price)
            OVER
            (
                PARTITION BY oi.seller_id
                ORDER BY o.order_purchase_timestamp ASC
                ROWS BETWEEN 2 PRECEDING
                         AND CURRENT ROW
            ),
        2
    ) AS moving_average_price

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id;



/******************************************************************************
Question 10
Display every order together with both the first and last purchase timestamps.

Business Objective
Compare each order against the earliest and latest purchases recorded in the
dataset.
******************************************************************************/

SELECT

    order_id,

    order_purchase_timestamp AS current_order_timestamp,

    FIRST_VALUE(order_purchase_timestamp)
        OVER
        (
            ORDER BY order_purchase_timestamp ASC
        ) AS first_order_purchase_timestamp,

    LAST_VALUE(order_purchase_timestamp)
        OVER
        (
            ORDER BY order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND UNBOUNDED FOLLOWING
        ) AS last_order_purchase_timestamp

FROM orders;



/******************************************************************************
Question 11
Display each customer's latest purchase.

Business Objective
Identify the most recent purchase recorded for every customer.
******************************************************************************/

SELECT

    c.customer_unique_id AS customer,

    o.order_id,

    o.order_purchase_timestamp AS current_order_timestamp,

    op.payment_value,

    LAST_VALUE(op.payment_value)
        OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND UNBOUNDED FOLLOWING
        ) AS latest_purchase_value

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id;



/******************************************************************************
Question 12
Create a running revenue report grouped by payment type.

Business Objective
Track cumulative revenue independently for each payment method.
******************************************************************************/

SELECT

    c.customer_unique_id AS customer,

    o.order_id,

    op.payment_type,

    o.order_purchase_timestamp AS current_order_timestamp,

    op.payment_value,

    SUM(op.payment_value)
        OVER
        (
            PARTITION BY op.payment_type
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS running_total

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id;



/******************************************************************************
Question 13
Build a seller revenue trend report using cumulative sales.

Business Objective
Measure cumulative revenue growth for every seller over time.
******************************************************************************/

SELECT

    oi.seller_id AS seller,

    o.order_id,

    oi.price,

    SUM(oi.price)
        OVER
        (
            PARTITION BY oi.seller_id
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS running_sales_total

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id;



/******************************************************************************
Question 14
Create a customer purchase timeline showing the first purchase, latest
purchase and cumulative spending.

Business Objective
Produce a comprehensive customer lifecycle report for analytical and executive
reporting purposes.
******************************************************************************/

SELECT

    c.customer_unique_id AS customer,

    o.order_id,

    o.order_purchase_timestamp AS current_order_timestamp,

    op.payment_value,

    FIRST_VALUE(op.payment_value)
        OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC
        ) AS first_purchase_value,

    LAST_VALUE(op.payment_value)
        OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND UNBOUNDED FOLLOWING
        ) AS latest_purchase_value,

    SUM(op.payment_value)
        OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS cumulative_customer_spending

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id;



/******************************************************************************
Question 15
Build an executive sales dashboard dataset.

Business Objective
Produce a business-ready dataset containing first payment, latest payment,
running revenue and moving average metrics suitable for dashboard reporting.
******************************************************************************/

SELECT

    o.order_id,

    o.order_purchase_timestamp AS current_order_timestamp,

    op.payment_value,

    FIRST_VALUE(op.payment_value)
        OVER
        (
            ORDER BY o.order_purchase_timestamp ASC
        ) AS first_payment,

    LAST_VALUE(op.payment_value)
        OVER
        (
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND UNBOUNDED FOLLOWING
        ) AS latest_payment,

    SUM(op.payment_value)
        OVER
        (
            ORDER BY o.order_purchase_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS running_revenue,

    ROUND
    (
        AVG(op.payment_value)
            OVER
            (
                ORDER BY o.order_purchase_timestamp ASC
                ROWS BETWEEN 2 PRECEDING
                         AND CURRENT ROW
            ),
        2
    ) AS moving_average_payment

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id;



/*
===============================================================================
KEY LEARNING OUTCOMES
===============================================================================

This investigation introduced analytical window aggregation functions used in
professional business intelligence reporting and dashboard development.

Concepts demonstrated include:

✓ FIRST_VALUE()

✓ LAST_VALUE()

✓ Running totals using SUM() OVER()

✓ Moving averages using AVG() OVER()

✓ Window frame specification

✓ ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

✓ ROWS BETWEEN 2 PRECEDING AND CURRENT ROW

✓ ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

✓ Customer lifecycle analysis

✓ Revenue trend reporting

✓ Seller performance monitoring

✓ Executive KPI dataset creation

===============================================================================
ANALYST NOTES
===============================================================================

Window aggregation functions enable analysts to calculate cumulative and
rolling metrics while preserving the original level of detail in the dataset.

Unlike GROUP BY, window aggregates do not collapse rows, making them ideal for
business dashboards, time-series reporting and customer journey analysis.

Special attention should be given to LAST_VALUE(), as its behaviour depends on
the defined window frame. Explicitly specifying the frame avoids unexpected
results and ensures accurate analytical reporting.

These techniques represent a core competency for modern SQL analysts and are
widely used in production reporting systems, financial dashboards and business
intelligence platforms.

===============================================================================
END OF SQL SCRIPT
===============================================================================