/*======================================================================================================================
INVESTIGATION 10 — PRODUCT PERFORMANCE

Business Objective
------------------
Summarise the product catalogue to understand category distribution, product
characteristics, and data quality using aggregate SQL functions.

Skills Practiced
----------------
• COUNT()
• AVG()
• MIN()
• MAX()
• ROUND()
• GROUP BY
• HAVING

======================================================================================================================*/

-- Q1. Products by category

SELECT
    product_category_name AS category,
    COUNT(*) AS product_count
FROM products
GROUP BY product_category_name
ORDER BY product_count DESC;


-- Q2. Categories with more than 500 products

SELECT
    product_category_name AS category,
    COUNT(*) AS product_count
FROM products
GROUP BY product_category_name
HAVING COUNT(*) > 500
ORDER BY product_count DESC;


-- Q3. Average product weight by category

SELECT
    product_category_name AS category,
    ROUND(AVG(product_weight_g),2) AS average_weight_g
FROM products
GROUP BY product_category_name
ORDER BY average_weight_g DESC;


-- Q4. Categories with average weight above 1000g

SELECT
    product_category_name AS category,
    ROUND(AVG(product_weight_g),2) AS average_weight_g
FROM products
GROUP BY product_category_name
HAVING AVG(product_weight_g) > 1000
ORDER BY average_weight_g DESC;


-- Q5. Product name length statistics

SELECT
    product_category_name AS category,
    MIN(product_name_lenght) AS minimum_name_length,
    MAX(product_name_lenght) AS maximum_name_length,
    ROUND(AVG(product_name_lenght),2) AS average_name_length
FROM products
GROUP BY product_category_name
ORDER BY average_name_length DESC;


-- Q6. Products with missing category names

SELECT
    COUNT(*) AS missing_category_names
FROM products
WHERE product_category_name IS NULL;


-- Q7. Average description length by category

SELECT
    product_category_name AS category,
    ROUND(AVG(product_description_lenght),2) AS average_description_length
FROM products
GROUP BY product_category_name
ORDER BY average_description_length DESC;


-- Q8. Five categories with longest average descriptions

SELECT
    product_category_name AS category,
    ROUND(AVG(product_description_lenght),2) AS average_description_length
FROM products
GROUP BY product_category_name
ORDER BY average_description_length DESC
LIMIT 5;


-- Q9. Products with zero recorded weight

SELECT
    COUNT(*) AS products_with_zero_weight
FROM products
WHERE product_weight_g = 0;


-- Q10. Product summary report

SELECT
    product_category_name AS category,
    COUNT(*) AS product_count,
    ROUND(AVG(product_weight_g),2) AS average_weight_g,
    ROUND(AVG(product_name_lenght),2) AS average_name_length
FROM products
GROUP BY product_category_name
ORDER BY product_count DESC;


/*======================================================================================================================

KEY FINDINGS
------------------------------------------------------------------------------------------------------------------------
• Product distribution is highly concentrated in a relatively small number of categories.
• Several categories contain more than 500 products.
• Average product weights vary considerably between categories.
• A small number of products have missing category information.
• Four products have an implausible recorded weight of zero grams, indicating potential
  data quality issues.
• Combining multiple aggregate functions provides a concise business summary suitable
  for dashboard reporting.

------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
------------------------------------------------------------------------------------------------------------------------
This investigation expanded aggregate analysis by introducing ROUND() for presentation
purposes while reinforcing the importance of selecting appropriate measures for
business reporting. It also highlighted that the simplest SQL solution is often the
most effective when answering straightforward business questions.

======================================================================================================================*/