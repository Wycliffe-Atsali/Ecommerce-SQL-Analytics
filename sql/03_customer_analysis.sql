/*======================================================================================================================
INVESTIGATION 09 — CUSTOMER INSIGHTS

Business Objective
------------------
Analyse customer distribution across Brazilian states and cities using aggregate SQL functions.
The objective is to identify major customer markets, understand regional concentration,
and demonstrate how GROUP BY and HAVING can be used for business reporting.

Skills Practiced
----------------
• COUNT()
• COUNT(DISTINCT)
• GROUP BY
• HAVING
• ORDER BY
• LIMIT

======================================================================================================================*/

-- -------------------------------------------------------------------------------------------------
-- Q1. Customer records by state
-- -------------------------------------------------------------------------------------------------

SELECT
    customer_state,
    COUNT(*) AS customer_records
FROM customers
GROUP BY customer_state
ORDER BY customer_records DESC;


-- -------------------------------------------------------------------------------------------------
-- Q2. States with more than 1,000 customer records
-- -------------------------------------------------------------------------------------------------

SELECT
    customer_state,
    COUNT(*) AS customer_records
FROM customers
GROUP BY customer_state
HAVING COUNT(*) > 1000
ORDER BY customer_records DESC;


-- -------------------------------------------------------------------------------------------------
-- Q3. States with fewer than 500 customer records
-- -------------------------------------------------------------------------------------------------

SELECT
    customer_state,
    COUNT(*) AS customer_records
FROM customers
GROUP BY customer_state
HAVING COUNT(*) < 500
ORDER BY customer_records DESC;


-- -------------------------------------------------------------------------------------------------
-- Q4. Average customer records per state
-- NOTE:
-- This analysis requires nested aggregation (subqueries/CTEs),
-- which will be introduced later in the project.
-- -------------------------------------------------------------------------------------------------


-- -------------------------------------------------------------------------------------------------
-- Q5. Top 10 customer cities by customer records
-- -------------------------------------------------------------------------------------------------

SELECT
    customer_city,
    COUNT(*) AS customer_records
FROM customers
GROUP BY customer_city
ORDER BY customer_records DESC
LIMIT 10;


-- -------------------------------------------------------------------------------------------------
-- Q6. Cities with more than 500 customer records
-- -------------------------------------------------------------------------------------------------

SELECT
    customer_city,
    COUNT(*) AS customer_records
FROM customers
GROUP BY customer_city
HAVING COUNT(*) > 500
ORDER BY customer_records DESC;


-- -------------------------------------------------------------------------------------------------
-- Q7. Unique customers by state
-- -------------------------------------------------------------------------------------------------

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers
GROUP BY customer_state
ORDER BY unique_customers DESC;


-- -------------------------------------------------------------------------------------------------
-- Q8. States ranked by unique customers
-- (Same analysis as Question 7 with emphasis on ranking.)
-- -------------------------------------------------------------------------------------------------

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers
GROUP BY customer_state
ORDER BY unique_customers DESC;


-- -------------------------------------------------------------------------------------------------
-- Q9. Top 10 ZIP code prefixes by customer records
-- -------------------------------------------------------------------------------------------------

SELECT
    customer_zip_code_prefix,
    COUNT(*) AS customer_records
FROM customers
GROUP BY customer_zip_code_prefix
ORDER BY customer_records DESC
LIMIT 10;


-- -------------------------------------------------------------------------------------------------
-- Q10. Customer records vs unique customers by state
-- -------------------------------------------------------------------------------------------------

SELECT
    customer_state,
    COUNT(*) AS customer_records,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers
GROUP BY customer_state
ORDER BY customer_records DESC;


/*======================================================================================================================

KEY FINDINGS
------------------------------------------------------------------------------------------------------------------------
• Customer records are highly concentrated in a small number of Brazilian states.
• São Paulo (SP) remains the largest customer market.
• Large metropolitan areas account for the highest customer concentrations.
• Customer records and unique customers differ because repeat purchases generate
  multiple customer records for the same individual.
• HAVING allows aggregate results to be filtered after grouping, making it ideal
  for identifying high- and low-performing regions.

------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
------------------------------------------------------------------------------------------------------------------------
This investigation introduced HAVING, allowing aggregate results to be filtered after
GROUP BY. The analysis demonstrated how customer information can be summarized at
different geographical levels while reinforcing the distinction between customer
records and unique customers.

One analytical question—calculating the average number of customer records per state—
highlighted the need for nested aggregation, providing a natural transition into
subqueries and Common Table Expressions (CTEs), which will be covered later in
the project.

======================================================================================================================*/