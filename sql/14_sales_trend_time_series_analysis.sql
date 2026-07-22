/*
===============================================================================
Investigation 20: Sales Trend & Time Series Analysis
File: 14_sales_trend_time_series_analysis.sql
Project: Retail SQL Business Analysis
Database: PostgreSQL
Dataset: Brazilian E-Commerce Public Dataset by Olist
===============================================================================

BUSINESS OBJECTIVE
------------------
Analyze how sales performance changes over time by examining trends in
customer orders and revenue across different time periods.

This investigation focuses on identifying seasonal purchasing patterns,
business growth, peak sales periods, and operational insights that support
forecasting, inventory planning, staffing, and marketing decisions.

===============================================================================

DATABASE THINKING
-----------------

Primary Table
-------------
• orders

Supporting Table
----------------
• order_payments

Relationship Path
-----------------

orders
    │
order_id
    │
order_payments

Analysis Grain
--------------
Different business questions require different analytical grains.

• Order Level
• Monthly Level
• Yearly Level
• Weekday Level

Choosing the correct time grain is essential for producing meaningful
business insights.

===============================================================================

DATA QUALITY NOTES
------------------

• Revenue is calculated using order_payments.payment_value.

• DATE_TRUNC() is used throughout this investigation because it preserves
  complete business periods.

Example

Correct
-------
DATE_TRUNC('month', order_purchase_timestamp)

Incorrect
---------
EXTRACT(MONTH FROM order_purchase_timestamp)

The incorrect approach would combine January 2017 with January 2018,
leading to misleading business conclusions.

===============================================================================
QUESTION 1
Earliest Order Purchase Date
===============================================================================

Business Question
-----------------
When was the earliest purchase made in the dataset?

*/

SELECT

    MIN(order_purchase_timestamp)
        AS earliest_order_purchase_date

FROM orders;



/*
===============================================================================
QUESTION 2
Latest Order Purchase Date
===============================================================================

Business Question
-----------------
When was the most recent purchase made?

*/

SELECT

    MAX(order_purchase_timestamp)
        AS latest_order_purchase_date

FROM orders;



/*
===============================================================================
QUESTION 3
Orders by Year
===============================================================================

Business Question
-----------------
How many orders were placed each year?

*/

SELECT

    DATE_TRUNC('year', order_purchase_timestamp)
        AS purchase_year,

    COUNT(*) AS total_orders

FROM orders

GROUP BY purchase_year

ORDER BY purchase_year;



/*
===============================================================================
QUESTION 4
Orders by Month
===============================================================================

Business Question
-----------------
How many orders were placed each month?

Using DATE_TRUNC() ensures that each month is treated as a unique business
period.

*/

SELECT

    DATE_TRUNC('month', order_purchase_timestamp)
        AS purchase_month,

    COUNT(*) AS total_orders

FROM orders

GROUP BY purchase_month

ORDER BY purchase_month;



/*
===============================================================================
QUESTION 5
Revenue by Year
===============================================================================

Business Question
-----------------
How much revenue was generated during each year?

*/

SELECT

    DATE_TRUNC('year', o.order_purchase_timestamp)
        AS purchase_year,

    ROUND(

        SUM(op.payment_value),

        2

    ) AS total_revenue

FROM orders o

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY purchase_year

ORDER BY purchase_year;



/*
===============================================================================
QUESTION 6
Revenue by Month
===============================================================================

Business Question
-----------------
How much revenue was generated during each month?

*/

SELECT

    DATE_TRUNC('month', o.order_purchase_timestamp)
        AS purchase_month,

    ROUND(

        SUM(op.payment_value),

        2

    ) AS total_revenue

FROM orders o

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY purchase_month

ORDER BY purchase_month;



/*
===============================================================================
QUESTION 7
Highest Revenue Month
===============================================================================

Business Question
-----------------
Which month generated the highest revenue?

*/

SELECT

    DATE_TRUNC('month', o.order_purchase_timestamp)
        AS purchase_month,

    ROUND(

        SUM(op.payment_value),

        2

    ) AS total_revenue

FROM orders o

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY purchase_month

ORDER BY total_revenue DESC

LIMIT 1;



/*
Expected Result
---------------

Highest Revenue Month

2017-11-01

Revenue

1,194,882.80

This period likely corresponds with major seasonal shopping events such
as Black Friday and the beginning of holiday purchasing.

*/


/*
===============================================================================
QUESTION 8
Average Order Value by Month
===============================================================================

Business Question
-----------------
How does the average order value change throughout the business timeline?

NOTE
----
COUNT(DISTINCT order_id) is used because an order may contain multiple
payment records.

*/

SELECT

    DATE_TRUNC('month', o.order_purchase_timestamp)
        AS purchase_month,

    ROUND(

        SUM(op.payment_value)

        /

        COUNT(DISTINCT o.order_id),

        2

    ) AS average_order_value

FROM orders o

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY purchase_month

ORDER BY purchase_month;

/*
===============================================================================
QUESTION 9
Orders by Day of the Week
===============================================================================

Business Question
-----------------
Which day of the week receives the highest number of customer orders?

NOTE
----
The 'FMDay' format removes trailing spaces that occur when using 'Day'.

*/

SELECT

    TO_CHAR(o.order_purchase_timestamp, 'FMDay')
        AS day_of_week,

    COUNT(*) AS total_orders

FROM orders o

GROUP BY day_of_week

ORDER BY total_orders DESC;



/*
===============================================================================
QUESTION 10
Revenue by Day of the Week
===============================================================================

Business Question
-----------------
Which day of the week generates the highest revenue?

*/

SELECT

    TO_CHAR(o.order_purchase_timestamp, 'FMDay')
        AS day_of_week,

    ROUND(

        SUM(op.payment_value),

        2

    ) AS total_revenue

FROM orders o

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY day_of_week

ORDER BY total_revenue DESC;



/*
===============================================================================
QUESTION 11
Average Order Value by Day of the Week
===============================================================================

Business Question
-----------------
Which weekday has the highest average order value?

NOTE
----
COUNT(DISTINCT order_id) ensures average order value is calculated using
unique orders rather than payment records.

*/

SELECT

    TO_CHAR(o.order_purchase_timestamp, 'FMDay')
        AS day_of_week,

    ROUND(

        SUM(op.payment_value)

        /

        COUNT(DISTINCT o.order_id),

        2

    ) AS average_order_value

FROM orders o

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY day_of_week

ORDER BY average_order_value DESC;



/*
===============================================================================
QUESTION 12
Month with the Highest Order Volume
===============================================================================

Business Question
-----------------
Which month recorded the largest number of customer orders?

*/

SELECT

    DATE_TRUNC('month', o.order_purchase_timestamp)
        AS purchase_month,

    COUNT(*) AS total_orders

FROM orders o

GROUP BY purchase_month

ORDER BY total_orders DESC

LIMIT 1;



/*
===============================================================================
QUESTION 13
Month with the Highest Average Revenue per Order
===============================================================================

Business Question
-----------------
Which month generated the highest average revenue per completed order?

*/

SELECT

    DATE_TRUNC('month', o.order_purchase_timestamp)
        AS purchase_month,

    ROUND(

        SUM(op.payment_value)

        /

        COUNT(DISTINCT o.order_id),

        2

    ) AS average_order_value

FROM orders o

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY purchase_month

ORDER BY average_order_value DESC

LIMIT 1;



/*
===============================================================================
QUESTION 14
Monthly Orders versus Monthly Revenue
===============================================================================

Business Question
-----------------
Do monthly order volume and monthly revenue move together?

Method
------
Compare total monthly orders with total monthly revenue to identify
whether increases in demand generally correspond with increases in revenue.

*/

SELECT

    DATE_TRUNC('month', o.order_purchase_timestamp)
        AS purchase_month,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(

        SUM(op.payment_value),

        2

    ) AS total_revenue

FROM orders o

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY purchase_month

ORDER BY purchase_month;


/*
Business Interpretation
-----------------------

Overall, months with higher order volumes also generate higher revenue.

However, revenue is influenced by two factors:

• Number of orders
• Average order value

Consequently, months with similar order counts may still generate different
levels of revenue if customers spend different amounts per order.

*/


/*
===============================================================================
QUESTION 15
Business Recommendations
===============================================================================

Business Question
-----------------
Based on the observed sales trends, what strategic recommendations can be
made for marketing, inventory management, and operational planning?

Business Recommendations
------------------------

1. Increase inventory before historically high-demand months to reduce the
   risk of stock shortages.

2. Schedule additional warehouse, logistics, and customer support staff
   during peak sales periods.

3. Launch promotional campaigns before historically slower months to
   stimulate demand rather than concentrating promotions only during
   already strong sales periods.

4. Continue investing in end-of-year promotional events, such as Black
   Friday and holiday campaigns, while ensuring operational capacity can
   accommodate increased order volumes.

5. Use historical monthly sales patterns as an input for demand forecasting,
   budgeting, and procurement planning.

*/


/*
===============================================================================
ANALYST OBSERVATIONS
===============================================================================

• Customer purchasing activity follows clear monthly trends.

• Revenue generally increases alongside order volume.

• Peak sales periods likely correspond to seasonal retail events.

• Time-series analysis enables the business to anticipate future demand
  rather than reacting after sales occur.

• Average order value provides additional insight beyond order counts alone,
  helping distinguish between high-volume and high-value sales periods.

===============================================================================
BUSINESS INSIGHTS
===============================================================================

Key Performance Indicators Produced

✓ Orders by Year

✓ Orders by Month

✓ Revenue by Year

✓ Revenue by Month

✓ Highest Revenue Month

✓ Average Order Value by Month

✓ Orders by Weekday

✓ Revenue by Weekday

✓ Average Order Value by Weekday

✓ Peak Sales Month

✓ Monthly Revenue Trend

These KPIs provide management with a historical view of business performance
and form the basis for forecasting future sales.

===============================================================================
TECHNICAL SKILLS DEMONSTRATED
===============================================================================

Throughout this investigation the following PostgreSQL concepts were applied:

• INNER JOIN

• DATE_TRUNC()

• TO_CHAR()

• Aggregate Functions

• SUM()

• COUNT()

• COUNT(DISTINCT)

• MIN()

• MAX()

• ROUND()

• ORDER BY

• LIMIT

• Time-Series Analysis

• Business KPI Development

===============================================================================
END OF INVESTIGATION 20
Sales Trend & Time Series Analysis
===============================================================================