/*
===============================================================================
Investigation 18: Delivery Performance Analysis
File: 12_delivery_performance_analysis.sql
Project: Retail SQL Business Analysis
Database: PostgreSQL
Dataset: Brazilian E-Commerce Public Dataset by Olist
===============================================================================

BUSINESS OBJECTIVE
------------------
Evaluate the efficiency and reliability of the company's delivery operations by
analyzing delivery timelines, shipping delays, and on-time delivery performance.

This investigation measures key operational KPIs related to logistics,
identifies potential delivery bottlenecks, and provides insights that can help
improve customer satisfaction and operational efficiency.

===============================================================================

DATABASE THINKING
-----------------

Primary Table
-------------
orders

Supporting Table
----------------
customers

Relationship Path
-----------------

customers
    │
customer_id
    │
orders

Analysis Grain
--------------
One row represents one order.

This investigation is performed at the order level because delivery events
(purchase, approval, shipping, delivery, and estimated delivery) are recorded
once per order.

===============================================================================

DATA QUALITY NOTES
------------------

• Delivery duration calculations require valid purchase and customer delivery
  timestamps.

• On-time delivery calculations require both actual and estimated delivery
  dates.

• Cancelled, unavailable, and processing orders are excluded from delivery
  performance metrics where appropriate.

• Delivery durations are calculated using:

      EXTRACT(EPOCH FROM (timestamp_difference))/86400

  instead of EXTRACT(DAY)

  This preserves fractional days and provides more accurate averages.

===============================================================================
QUESTION 1
Total Number of Orders
===============================================================================

Business Question
-----------------
How many total orders exist in the database?

*/

SELECT
    COUNT(*) AS total_orders
FROM orders;



/*
===============================================================================
QUESTION 2
Orders Successfully Delivered
===============================================================================

Business Question
-----------------
How many orders have a recorded customer delivery date?

*/

SELECT
    COUNT(*) AS orders_with_customer_delivery_date
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;



/*
===============================================================================
QUESTION 3
Orders Without Customer Delivery Date
===============================================================================

Business Question
-----------------
How many orders are missing a customer delivery date?

*/

SELECT
    COUNT(*) AS orders_without_customer_delivery_date
FROM orders
WHERE order_delivered_customer_date IS NULL;



/*
===============================================================================
QUESTION 4
Distribution of Order Statuses
===============================================================================

Business Question
-----------------
How are orders distributed across different order statuses?

*/

SELECT
    order_status,
    COUNT(*) AS number_of_orders
FROM orders
GROUP BY order_status
ORDER BY number_of_orders DESC;



/*
===============================================================================
QUESTION 5
Orders with Complete Delivery Information
===============================================================================

Business Question
-----------------
How many delivered orders contain all timestamps required for delivery analysis?

*/

SELECT
    COUNT(*) AS complete_delivery_records
FROM orders
WHERE
    order_purchase_timestamp IS NOT NULL
    AND order_approved_at IS NOT NULL
    AND order_delivered_carrier_date IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL;



/*
===============================================================================
QUESTION 6
Average Delivery Duration
===============================================================================

Business Question
-----------------
How many days does it take, on average, for an order to reach the customer?

*/

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date -
                    order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE
    order_status = 'delivered'
    AND order_purchase_timestamp IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL;



/*
===============================================================================
QUESTION 7
Minimum, Maximum and Median Delivery Duration
===============================================================================

Business Question
-----------------
What are the minimum, maximum, and median delivery times?

*/

SELECT
    ROUND(
        MIN(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date -
                    order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS minimum_delivery_days,

    ROUND(
        MAX(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date -
                    order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS maximum_delivery_days,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY
                EXTRACT(
                    EPOCH FROM (
                        order_delivered_customer_date -
                        order_purchase_timestamp
                    )
                ) / 86400
        ),
        2
    ) AS median_delivery_days

FROM orders
WHERE
    order_status = 'delivered'
    AND order_purchase_timestamp IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL;



/*
===============================================================================
QUESTION 8
Longest Delivery Times
===============================================================================

Business Question
-----------------
Which orders experienced the longest delivery durations?

*/

SELECT
    order_id,

    ROUND(
        EXTRACT(
            EPOCH FROM (
                order_delivered_customer_date -
                order_purchase_timestamp
            )
        ) / 86400,
        2
    ) AS delivery_days

FROM orders

WHERE
    order_status = 'delivered'
    AND order_purchase_timestamp IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL

ORDER BY delivery_days DESC

LIMIT 10;



/*
===============================================================================
QUESTION 9
Orders Delivered On or Before Estimated Date
===============================================================================

Business Question
-----------------
How many delivered orders arrived on or before the promised delivery date?

*/

SELECT
    COUNT(*) AS on_time_orders
FROM orders
WHERE
    order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date <= order_estimated_delivery_date;



/*
===============================================================================
QUESTION 10
Late Deliveries
===============================================================================

Business Question
-----------------
How many delivered orders arrived after the estimated delivery date?

*/

SELECT
    COUNT(*) AS late_orders
FROM orders
WHERE
    order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date > order_estimated_delivery_date;



/*
===============================================================================
QUESTION 11
Percentage of On-Time Deliveries
===============================================================================

Business Question
-----------------
What percentage of delivered orders arrived on or before the estimated
delivery date?

*/

SELECT
    ROUND(

        COUNT(*) FILTER (
            WHERE
                order_status = 'delivered'
                AND order_delivered_customer_date IS NOT NULL
                AND order_estimated_delivery_date IS NOT NULL
                AND order_delivered_customer_date <= order_estimated_delivery_date
        ) * 100.0

        /

        COUNT(*) FILTER (
            WHERE order_status = 'delivered'
        ),

        2

    ) AS percentage_on_time_deliveries

FROM orders;



/*
===============================================================================
QUESTION 12
Average Delivery Time by Customer State
===============================================================================

Business Question
-----------------
Which customer states experience the longest average delivery times?

*/

SELECT

    c.customer_state,

    ROUND(

        AVG(

            EXTRACT(
                EPOCH FROM (
                    o.order_delivered_customer_date -
                    o.order_purchase_timestamp
                )
            ) / 86400

        ),

        2

    ) AS average_delivery_days

FROM orders o

INNER JOIN customers c
ON o.customer_id = c.customer_id

WHERE
    o.order_status = 'delivered'
    AND o.order_purchase_timestamp IS NOT NULL
    AND o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY average_delivery_days DESC;



/*
===============================================================================
QUESTION 13
Late Delivery Percentage by Customer State
===============================================================================

Business Question
-----------------
Which customer states have the highest percentage of late deliveries?

*/

SELECT

    c.customer_state,

    ROUND(

        COUNT(*) FILTER (

            WHERE
                o.order_status = 'delivered'
                AND o.order_delivered_customer_date IS NOT NULL
                AND o.order_estimated_delivery_date IS NOT NULL
                AND o.order_delivered_customer_date >
                    o.order_estimated_delivery_date

        ) * 100.0

        /

        COUNT(*) FILTER (

            WHERE
                o.order_status = 'delivered'

        ),

        2

    ) AS late_delivery_percentage

FROM orders o

INNER JOIN customers c
ON o.customer_id = c.customer_id

GROUP BY c.customer_state

ORDER BY late_delivery_percentage DESC;



/*
===============================================================================
QUESTION 14
Average Time from Approval to Carrier Pickup
===============================================================================

Business Question
-----------------
How long does it take, on average, for approved orders to be handed over to
the shipping carrier?

*/

SELECT

    ROUND(

        AVG(

            EXTRACT(
                EPOCH FROM (
                    order_delivered_carrier_date -
                    order_approved_at
                )
            ) / 86400

        ),

        2

    ) AS average_carrier_pickup_days

FROM orders

WHERE
    order_approved_at IS NOT NULL
    AND order_delivered_carrier_date IS NOT NULL;



/*
===============================================================================
QUESTION 15
Average Difference Between Estimated and Actual Delivery
===============================================================================

Business Question
-----------------
On average, how many days earlier or later than the estimated delivery date
are orders delivered?

Interpretation
--------------
Positive Value  = Delivered Earlier Than Estimated

Negative Value  = Delivered Later Than Estimated

*/

SELECT

    ROUND(

        AVG(

            EXTRACT(
                EPOCH FROM (
                    order_estimated_delivery_date -
                    order_delivered_customer_date
                )
            ) / 86400

        ),

        2

    ) AS average_days_before_estimated_delivery

FROM orders

WHERE
    order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL;



/*
===============================================================================
ANALYST OBSERVATIONS
===============================================================================

• The majority of orders were successfully delivered.

• Most deliveries arrived on or before the promised delivery date,
  demonstrating strong logistics performance.

• Average delivery duration was approximately twelve days.

• Some customer states experienced noticeably longer delivery times,
  indicating regional logistical challenges.

• Delivery performance varied across regions, suggesting opportunities
  for targeted logistics improvements.

• Orders were delivered, on average, several days before their estimated
  delivery date, indicating conservative delivery estimates.

===============================================================================
BUSINESS RECOMMENDATIONS
===============================================================================

1. Investigate regions with consistently long delivery times.

2. Review logistics partnerships in states with high late-delivery rates.

3. Continue monitoring on-time delivery as a key operational KPI.

4. Use historical delivery performance to improve estimated delivery dates.

5. Build delivery performance dashboards segmented by customer state to
   support ongoing operational decision-making.

===============================================================================
END OF INVESTIGATION 18
===============================================================================