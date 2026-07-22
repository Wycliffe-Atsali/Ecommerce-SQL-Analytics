/*
===============================================================================
Investigation 19: Customer Geographic Analysis
File: 13_customer_geographic_analysis.sql
Project: Retail SQL Business Analysis
Database: PostgreSQL
Dataset: Brazilian E-Commerce Public Dataset by Olist
===============================================================================

BUSINESS OBJECTIVE
------------------
Analyze the geographical distribution of customers and purchasing activity
across Brazil to identify high-value regions, customer concentration,
purchasing behaviour, and opportunities for business growth.

This investigation focuses on understanding where customers are located,
which regions generate the highest revenue, and how customer spending varies
across different states.

===============================================================================

DATABASE THINKING
-----------------

Primary Tables
--------------
• customers
• orders

Supporting Table
----------------
• order_payments

Relationship Path
-----------------

customers
      │
customer_id
      │
orders
      │
order_id
      │
order_payments

Analysis Grain
--------------
Depending on the business question, the analysis is performed at one of four
levels:

• Customer Level
• Order Level
• State Level
• Revenue by State

Choosing the correct analytical grain ensures that customer counts, order
counts, and revenue calculations accurately represent business performance.

===============================================================================

DATA QUALITY NOTES
------------------

• The Olist dataset assigns a new customer_id for every purchase.

• customer_unique_id represents the actual customer across multiple orders.

• customer_unique_id must therefore be used whenever analysing customer
  behaviour, repeat purchases, or customer lifetime value.

• Revenue in this investigation is calculated using
  order_payments.payment_value because we are analysing customer spending
  rather than product sales.

===============================================================================
QUESTION 1
Number of Customer States
===============================================================================

Business Question
-----------------
How many unique customer states are represented in the dataset?

*/

SELECT
    COUNT(DISTINCT customer_state) AS customer_states
FROM customers;



/*
===============================================================================
QUESTION 2
Customer Distribution by State
===============================================================================

Business Question
-----------------
How many customers are located in each state?

*/

SELECT
    customer_state,
    COUNT(*) AS number_of_customers
FROM customers
GROUP BY customer_state
ORDER BY number_of_customers DESC;



/*
===============================================================================
QUESTION 3
Top 10 States by Customer Count
===============================================================================

Business Question
-----------------
Which ten states contain the largest customer populations?

*/

SELECT
    customer_state,
    COUNT(*) AS number_of_customers
FROM customers
GROUP BY customer_state
ORDER BY number_of_customers DESC
LIMIT 10;



/*
===============================================================================
QUESTION 4
Top 10 Customer Cities
===============================================================================

Business Question
-----------------
Which cities contain the largest customer populations?

*/

SELECT
    customer_city,
    COUNT(*) AS number_of_customers
FROM customers
GROUP BY customer_city
ORDER BY number_of_customers DESC
LIMIT 10;



/*
===============================================================================
QUESTION 5
Orders by Customer State
===============================================================================

Business Question
-----------------
How many orders were placed by customers from each state?

*/

SELECT

    c.customer_state,

    COUNT(*) AS total_orders

FROM orders o

INNER JOIN customers c
ON o.customer_id = c.customer_id

GROUP BY c.customer_state

ORDER BY total_orders DESC;



/*
===============================================================================
QUESTION 6
Top Five States by Order Volume
===============================================================================

Business Question
-----------------
Which five customer states generated the highest number of orders?

*/

SELECT

    c.customer_state,

    COUNT(*) AS total_orders

FROM orders o

INNER JOIN customers c
ON o.customer_id = c.customer_id

GROUP BY c.customer_state

ORDER BY total_orders DESC

LIMIT 5;



/*
===============================================================================
QUESTION 7
Average Orders per Unique Customer
===============================================================================

Business Question
-----------------
How many orders does the average customer place within each state?

NOTE
----
customer_unique_id is used instead of customer_id because a single customer
may place multiple orders using different customer_id values.

*/

SELECT

    c.customer_state,

    ROUND(

        COUNT(DISTINCT o.order_id)::NUMERIC

        /

        COUNT(DISTINCT c.customer_unique_id),

        2

    ) AS average_orders_per_customer

FROM customers c

INNER JOIN orders o
ON c.customer_id = o.customer_id

GROUP BY c.customer_state

ORDER BY average_orders_per_customer DESC;



/*
===============================================================================
QUESTION 8
Revenue by Customer State
===============================================================================

Business Question
-----------------
How much revenue has each customer state generated?

*/

SELECT

    c.customer_state,

    ROUND(

        SUM(op.payment_value),

        2

    ) AS total_revenue

FROM customers c

INNER JOIN orders o
ON c.customer_id = o.customer_id

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY c.customer_state

ORDER BY total_revenue DESC;



/*
===============================================================================
QUESTION 9
Top Five Revenue Generating States
===============================================================================

Business Question
-----------------
Which five customer states generated the highest revenue?

*/

SELECT

    c.customer_state,

    ROUND(

        SUM(op.payment_value),

        2

    ) AS total_revenue

FROM customers c

INNER JOIN orders o
ON c.customer_id = o.customer_id

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY c.customer_state

ORDER BY total_revenue DESC

LIMIT 5;



/*
===============================================================================
QUESTION 10
Average Order Value by State
===============================================================================

Business Question
-----------------
What is the average order value for each customer state?

*/

SELECT

    c.customer_state,

    ROUND(

        SUM(op.payment_value)

        /

        COUNT(DISTINCT o.order_id),

        2

    ) AS average_order_value

FROM customers c

INNER JOIN orders o
ON c.customer_id = o.customer_id

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY c.customer_state

ORDER BY average_order_value DESC;



/*
===============================================================================
QUESTION 11
Top Spending Customers
===============================================================================

Business Question
-----------------
Which ten customers have spent the most money?

*/

SELECT

    c.customer_unique_id,

    ROUND(

        SUM(op.payment_value),

        2

    ) AS total_amount_spent

FROM customers c

INNER JOIN orders o
ON c.customer_id = o.customer_id

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY c.customer_unique_id

ORDER BY total_amount_spent DESC

LIMIT 10;



/*
===============================================================================
QUESTION 12
Average Customer Lifetime Value by State
===============================================================================

Business Question
-----------------
Which customer states have the highest average customer lifetime value?

Definition
----------
Customer Lifetime Value (CLV) is approximated as the total amount spent by a
unique customer across all recorded orders.

*/

WITH customer_lifetime_value AS
(

SELECT

    c.customer_unique_id,

    c.customer_state,

    SUM(op.payment_value) AS customer_lifetime_value

FROM customers c

INNER JOIN orders o
ON c.customer_id = o.customer_id

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY

    c.customer_unique_id,

    c.customer_state

)

SELECT

    customer_state,

    ROUND(

        AVG(customer_lifetime_value),

        2

    ) AS average_customer_lifetime_value

FROM customer_lifetime_value

GROUP BY customer_state

ORDER BY average_customer_lifetime_value DESC;



/*
===============================================================================
QUESTION 13
High Customer Population with Low Average Order Value
===============================================================================

Business Question
-----------------
Which states have many customers but relatively low average order values?

*/

SELECT

    c.customer_state,

    COUNT(DISTINCT c.customer_unique_id) AS number_of_customers,

    ROUND(

        SUM(op.payment_value)

        /

        COUNT(DISTINCT o.order_id),

        2

    ) AS average_order_value

FROM customers c

INNER JOIN orders o
ON c.customer_id = o.customer_id

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY c.customer_state

ORDER BY

    number_of_customers DESC,

    average_order_value ASC;



/*
===============================================================================
QUESTION 14
Low Customer Population with High Average Order Value
===============================================================================

Business Question
-----------------
Which states have relatively few customers but high average order values?

*/

SELECT

    c.customer_state,

    COUNT(DISTINCT c.customer_unique_id) AS number_of_customers,

    ROUND(

        SUM(op.payment_value)

        /

        COUNT(DISTINCT o.order_id),

        2

    ) AS average_order_value

FROM customers c

INNER JOIN orders o
ON c.customer_id = o.customer_id

INNER JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY c.customer_state

ORDER BY

    number_of_customers ASC,

    average_order_value DESC;



/*
===============================================================================
QUESTION 15
Strongest Customer Markets
===============================================================================

Business Question
-----------------
Based on customer population, order volume, and total revenue, which states
represent the company's strongest markets?

Business Conclusion
-------------------

Based on the combined findings from this investigation:

• São Paulo (SP)
• Rio de Janeiro (RJ)
• Minas Gerais (MG)

appear to be the strongest customer markets.

These states consistently rank highly in:

• Customer population
• Order volume
• Revenue generation

making them strategically important markets for future business investment.

===============================================================================
ANALYST OBSERVATIONS
===============================================================================

• Customer distribution is highly concentrated within a few states.

• São Paulo represents the company's largest customer market.

• Revenue closely follows customer concentration, although average spending
  varies across regions.

• High customer populations do not always correspond to high average order
  values.

• Customer lifetime value differs between states, indicating varying purchasing
  behaviour across regional markets.

===============================================================================
BUSINESS RECOMMENDATIONS
===============================================================================

1. Prioritize customer retention strategies in SP, RJ, and MG.

2. Expand marketing efforts in states with growing customer populations but
   lower average order values.

3. Investigate regions with high average order values but relatively few
   customers, as they may represent premium market opportunities.

4. Continue monitoring customer lifetime value by region to improve marketing
   budget allocation.

5. Develop regional executive dashboards tracking customer growth, order
   volume, revenue, and lifetime value.

===============================================================================
END OF INVESTIGATION 19
===============================================================================