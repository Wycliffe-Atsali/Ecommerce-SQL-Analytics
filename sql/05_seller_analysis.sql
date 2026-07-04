/*======================================================================================================================
INVESTIGATION 11 — SELLER PERFORMANCE

Business Objective
------------------
Analyse the geographical distribution of sellers across Brazil using aggregate SQL
functions and multi-column grouping to identify areas with the highest merchant
concentration.

Skills Practiced
----------------
• COUNT()
• COUNT(DISTINCT)
• GROUP BY
• Multi-column GROUP BY
• HAVING
• ORDER BY
• LIMIT

======================================================================================================================*/

-- -------------------------------------------------------------------------------------------------
-- Q1. Sellers by state
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_state,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_state
ORDER BY seller_count DESC;


-- -------------------------------------------------------------------------------------------------
-- Q2. States with more than 100 sellers
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_state,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_state
HAVING COUNT(*) > 100
ORDER BY seller_count DESC;


-- -------------------------------------------------------------------------------------------------
-- Q3. Top 15 seller cities
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_city,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_city
ORDER BY seller_count DESC
LIMIT 15;


-- -------------------------------------------------------------------------------------------------
-- Q4. Cities with more than 20 sellers
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_city,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_city
HAVING COUNT(*) > 20
ORDER BY seller_count DESC;


-- -------------------------------------------------------------------------------------------------
-- Q5. Sellers by state and city
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_state,
    seller_city,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_state, seller_city
ORDER BY seller_count DESC;


-- -------------------------------------------------------------------------------------------------
-- Q6. State-city combinations with more than 10 sellers
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_state,
    seller_city,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_state, seller_city
HAVING COUNT(*) > 10
ORDER BY seller_count DESC;


-- -------------------------------------------------------------------------------------------------
-- Q7. Unique seller cities by state
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_state,
    COUNT(DISTINCT seller_city) AS unique_cities
FROM sellers
GROUP BY seller_state
ORDER BY unique_cities DESC;


-- -------------------------------------------------------------------------------------------------
-- Q8. State with the greatest geographical seller coverage
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_state,
    COUNT(DISTINCT seller_city) AS unique_cities
FROM sellers
GROUP BY seller_state
ORDER BY unique_cities DESC
LIMIT 1;


-- -------------------------------------------------------------------------------------------------
-- Q9. Seller percentage by state
-- NOTE:
-- Requires subqueries, CTEs, or window functions.
-- Will be revisited in a later phase.
-- -------------------------------------------------------------------------------------------------


-- -------------------------------------------------------------------------------------------------
-- Q10. Seller summary report
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_state,
    COUNT(*) AS seller_count,
    COUNT(DISTINCT seller_city) AS unique_cities
FROM sellers
GROUP BY seller_state
ORDER BY seller_count DESC;


/*======================================================================================================================

KEY FINDINGS
------------------------------------------------------------------------------------------------------------------------
• Sellers are concentrated in a relatively small number of Brazilian states.
• Multi-column grouping provides a detailed view of seller distribution across
  individual cities within each state.
• Geographic coverage varies significantly between states.
• Distinguishing seller counts from the number of unique cities provides additional
  insight into marketplace reach.

------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
------------------------------------------------------------------------------------------------------------------------
This investigation introduced multi-column GROUP BY, allowing data to be summarised
at multiple geographic levels. The analysis reinforced the importance of selecting
the correct level of aggregation for business reporting and highlighted situations
where more advanced SQL techniques will be required for percentage calculations.

======================================================================================================================*/