/*
============================================================
Script Name: 01_data_exploration.sql

Purpose:
Explore the Olist e-commerce dataset to understand the
structure, contents, and quality of the imported data
before performing business analysis.

Author: Atsali Akolo

Database: PostgreSQL

Project:
Retail SQL Business Analysis

============================================================
*/

------------------------------------------------------------
-- Investigation 1: Orders Table
------------------------------------------------------------

-- Query 1: View a sample of the orders table

SELECT *
FROM orders
LIMIT 10;

------------------------------------------------------------

-- Query 2: Count the total number of orders

SELECT COUNT(*) AS total_orders
FROM orders;

------------------------------------------------------------

-- Query 3: View all unique order statuses

SELECT DISTINCT order_status
FROM orders
ORDER BY order_status;

------------------------------------------------------------

-- Query 4: Count the number of unique order statuses

SELECT COUNT(DISTINCT order_status) AS total_order_statuses
FROM orders;

------------------------------------------------------------

-- Query 5: Determine the time period covered by the dataset

SELECT
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date
FROM orders;

------------------------------------------------------------

-- Query 6: Count orders without a recorded customer delivery date

SELECT COUNT(*) AS orders_without_delivery_date
FROM orders
WHERE order_delivered_customer_date IS NULL;

------------------------------------------------------------

-- Query 7: Identify order statuses associated with missing
-- customer delivery dates

SELECT DISTINCT order_status
FROM orders
WHERE order_delivered_customer_date IS NULL;

------------------------------------------------------------
Investigation Summary

Key Findings

• Total Orders:
  99,441

• Dataset Coverage:
  2016-09-04 21:15:19
  to
  2018-10-17 17:30:18

• Unique Order Statuses:
  8

• Orders Without Customer Delivery Date:
  2,965

Business Relevance

The orders table is the central transaction table of the
database and forms the foundation for almost every business
analysis. The dataset spans just over two years of business
activity and contains eight distinct order statuses.

Although most orders progress through the expected lifecycle,
the presence of orders marked as 'delivered' without a
recorded customer delivery date highlights the importance of
validating data quality before conducting delivery
performance analyses.

Analyst Reflection

This investigation reinforced the importance of validating
business assumptions using SQL. Initially, it was expected
that delivered orders would always contain a customer
delivery timestamp. Exploratory analysis revealed that this
assumption does not always hold, demonstrating that
real-world datasets often contain inconsistencies that must
be investigated before drawing conclusions.

============================================================
*/

------------------------------------------------------------
-- Investigation 2: Customers Table
------------------------------------------------------------

-- Query 1: View a sample of the customers table

SELECT *
FROM customers
LIMIT 5;

------------------------------------------------------------

-- Query 2: Count the total number of customer records

SELECT COUNT(*) AS total_customers
FROM customers;

------------------------------------------------------------

-- Query 3: Count the number of unique customers

SELECT COUNT(DISTINCT customer_unique_id) AS total_unique_customers
FROM customers;

------------------------------------------------------------

-- Query 4: View all customer states

SELECT DISTINCT customer_state
FROM customers
ORDER BY customer_state;

------------------------------------------------------------

-- Query 5: Count the number of unique customer states

SELECT COUNT(DISTINCT customer_state) AS total_states
FROM customers;

------------------------------------------------------------

-- Query 6: View all customer cities

SELECT DISTINCT customer_city
FROM customers
ORDER BY customer_city;

------------------------------------------------------------

-- Query 7: Count customers with missing ZIP code prefixes

SELECT COUNT(*) AS missing_zip_code_prefix
FROM customers
WHERE customer_zip_code_prefix IS NULL;

------------------------------------------------------------

-- Query 8: Count customers with missing cities

SELECT COUNT(*) AS missing_city
FROM customers
WHERE customer_city IS NULL;

------------------------------------------------------------

-- Query 9: Count customers with missing states

SELECT COUNT(*) AS missing_state
FROM customers
WHERE customer_state IS NULL;

------------------------------------------------------------

-- Query 10: Identify the state with the most customer records

SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 1;

------------------------------------------------------------
Investigation Summary

Key Findings

• Total Customer Records:
  99,441

• Unique Customers:
  96,096

• Customer Records Representing Repeat Customers:
  3,345 additional customer records beyond the
  unique customer count.

• States Represented:
  27

• State with the Highest Number of Customers:
  SP (41,746)

Business Relevance

The customers table provides the demographic foundation
for customer-focused analyses. The presence of more
customer records than unique customers indicates repeat
purchasing behaviour within the dataset, enabling future
analyses such as customer retention and lifetime value.

The dataset also includes customers from all 27 Brazilian
federal units, making it suitable for nationwide regional
analysis.

Analyst Reflection

This investigation demonstrated the importance of
understanding the difference between business entities and
database records. While customer_id uniquely identifies a
customer record, customer_unique_id represents the same
customer across multiple purchases. This distinction is
essential when measuring customer behaviour and avoiding
double-counting in business analyses.

------------------------------------------------------------

/*======================================================================================================================
INVESTIGATION 3 — PRODUCTS

Business Objective
------------------
Explore the structure, completeness, and quality of the product catalog before performing
product performance, inventory, or sales analyses.

======================================================================================================================*/


-- -------------------------------------------------------------------------------------------------
-- Q1. How many products are in the catalog?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS total_products
FROM products;

-- Result: 32,951


-- -------------------------------------------------------------------------------------------------
-- Q2. How many unique product categories exist?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT product_category_name) AS unique_product_categories
FROM products;

-- Result: 73


-- -------------------------------------------------------------------------------------------------
-- Q3. Which product categories are represented?
-- -------------------------------------------------------------------------------------------------

SELECT DISTINCT product_category_name
FROM products
ORDER BY product_category_name;

-- Observation:
-- One NULL category appears, indicating that some products have no assigned category.


-- -------------------------------------------------------------------------------------------------
-- Q4. How many products do not have a category assigned?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS products_without_category
FROM products
WHERE product_category_name IS NULL;

-- Result: 610


-- -------------------------------------------------------------------------------------------------
-- Q5. What is the shortest recorded product name length?
-- -------------------------------------------------------------------------------------------------

SELECT MIN(product_name_lenght) AS shortest_product_name_length
FROM products;

-- Result: 5 characters

-- Analyst Note:
-- A later inspection found that two products share this minimum value.
-- Once subqueries are introduced, we will retrieve both records dynamically.


-- -------------------------------------------------------------------------------------------------
-- Q6. What is the longest recorded product name length?
-- -------------------------------------------------------------------------------------------------

SELECT MAX(product_name_lenght) AS longest_product_name_length
FROM products;

-- Result: 76 characters


-- -------------------------------------------------------------------------------------------------
-- Q7. What is the smallest recorded product weight?
-- -------------------------------------------------------------------------------------------------

SELECT MIN(product_weight_g) AS minimum_product_weight_g
FROM products;

-- Result: 0 g

-- Data Quality Observation:
-- Four products have a recorded weight of 0 g.
-- Since the dataset represents physical products, these values are likely data-entry
-- errors or placeholder values rather than valid measurements.


-- -------------------------------------------------------------------------------------------------
-- Q8. What is the largest recorded product weight?
-- -------------------------------------------------------------------------------------------------

SELECT MAX(product_weight_g) AS maximum_product_weight_g
FROM products;

-- Result: 40,425 g (approximately 40.4 kg)


-- -------------------------------------------------------------------------------------------------
-- Q9. How many products have missing weight information?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS products_missing_weight
FROM products
WHERE product_weight_g IS NULL;

-- Result: 2


-- -------------------------------------------------------------------------------------------------
-- Q10. How many products have incomplete dimension information?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS products_with_missing_dimensions
FROM products
WHERE product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;

-- Result: 2


/========================================================================================================================
KEY FINDINGS
-------------------------------------------------------------------------------------------------------------------------

• The catalog contains 32,951 products.
• Products are distributed across 73 unique categories.
• 610 products do not have an assigned category.
• Product names range from 5 to 76 characters.
• Four products have an implausible recorded weight of 0 g.
• Only two products have missing weight information.
• Only two products have incomplete dimension data.

-------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
-------------------------------------------------------------------------------------------------------------------------

This investigation focused on understanding the completeness and quality of the product catalog before
performing business analyses.

Several data quality issues were identified, including missing category assignments and implausible
zero-weight products. These findings reinforce an important analytical principle:

Never assume operational data is perfectly clean.

Validating datasets before conducting deeper analysis helps prevent misleading conclusions and
improves confidence in future reporting.

======================================================================================================================*/

/*======================================================================================================================
INVESTIGATION 4 — SELLERS

Business Objective
------------------
Explore the seller network to understand its size, geographic distribution,
and the completeness of seller location information.

======================================================================================================================*/


-- -------------------------------------------------------------------------------------------------
-- Q1. How many sellers are registered on the marketplace?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS total_sellers
FROM sellers;


-- -------------------------------------------------------------------------------------------------
-- Q2. How many unique seller cities are represented?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT seller_city) AS unique_seller_cities
FROM sellers;


-- -------------------------------------------------------------------------------------------------
-- Q3. How many seller states are represented?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT seller_state) AS unique_seller_states
FROM sellers;


-- -------------------------------------------------------------------------------------------------
-- Q4. Which seller states are represented?
-- -------------------------------------------------------------------------------------------------

SELECT DISTINCT seller_state
FROM sellers
ORDER BY seller_state;


-- -------------------------------------------------------------------------------------------------
-- Q5. How many sellers are located in each state?
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_state,
    COUNT(*) AS sellers_per_state
FROM sellers
GROUP BY seller_state
ORDER BY seller_state;


-- -------------------------------------------------------------------------------------------------
-- Q6. How many sellers have missing city information?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS sellers_missing_city
FROM sellers
WHERE seller_city IS NULL;


-- -------------------------------------------------------------------------------------------------
-- Q7. How many sellers have missing state information?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS sellers_missing_state
FROM sellers
WHERE seller_state IS NULL;


-- -------------------------------------------------------------------------------------------------
-- Q8. What is the alphabetically first recorded seller city?
-- -------------------------------------------------------------------------------------------------

SELECT DISTINCT seller_city
FROM sellers
ORDER BY seller_city
LIMIT 1;

-- Analyst Note:
-- The first returned value is "04482255", which appears to be a postal code
-- rather than a valid city name, suggesting a possible data-entry or import issue.


-- -------------------------------------------------------------------------------------------------
-- Q9. What is the alphabetically last recorded seller city?
-- -------------------------------------------------------------------------------------------------

SELECT DISTINCT seller_city
FROM sellers
ORDER BY seller_city DESC
LIMIT 1;


-- -------------------------------------------------------------------------------------------------
-- Q10. Verify that seller_id values are unique.
-- -------------------------------------------------------------------------------------------------

SELECT
    seller_id,
    COUNT(*) AS occurrences
FROM sellers
GROUP BY seller_id
ORDER BY occurrences DESC;

-- Analyst Note:
-- Every seller_id appears exactly once, confirming that the primary key
-- uniquely identifies each seller.


/========================================================================================================================
KEY FINDINGS
-------------------------------------------------------------------------------------------------------------------------

• The marketplace contains 3,095 registered sellers.
• Sellers operate across 611 unique cities.
• Sellers are present in 23 Brazilian states.
• No seller records are missing city information.
• No seller records are missing state information.
• One record contains "04482255" in the seller_city field, indicating a possible
  data quality issue.
• seller_id successfully functions as a unique identifier.

-------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
-------------------------------------------------------------------------------------------------------------------------

This investigation focused on understanding the seller network before analyzing
sales performance.

The seller dataset is highly complete, with no missing city or state values.
However, exploratory analysis identified one apparent data quality issue where
a numeric value appears in the seller_city column.

The investigation also introduced GROUP BY as a natural extension of aggregate
analysis, allowing business questions involving grouped summaries to be answered
efficiently.

======================================================================================================================*/

/*======================================================================================================================
INVESTIGATION 5 — PAYMENTS

Business Objective
------------------
Explore the payment dataset to understand payment methods, installment usage,
transaction completeness, and potential data quality issues before performing
financial analysis.

======================================================================================================================*/


-- -------------------------------------------------------------------------------------------------
-- Q1. How many payment records exist?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS total_payment_records
FROM order_payments;


-- -------------------------------------------------------------------------------------------------
-- Q2. How many payment methods are available?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT payment_type) AS unique_payment_methods
FROM order_payments;


-- -------------------------------------------------------------------------------------------------
-- Q3. Which payment methods are represented?
-- -------------------------------------------------------------------------------------------------

SELECT DISTINCT payment_type
FROM order_payments
ORDER BY payment_type;


-- -------------------------------------------------------------------------------------------------
-- Q4. How many payments were made using each payment method?
-- -------------------------------------------------------------------------------------------------

SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;


-- -------------------------------------------------------------------------------------------------
-- Q5. What is the minimum number of payment installments?
-- -------------------------------------------------------------------------------------------------

SELECT MIN(payment_installments) AS minimum_installments
FROM order_payments;


-- -------------------------------------------------------------------------------------------------
-- Q6. What is the maximum number of payment installments?
-- -------------------------------------------------------------------------------------------------

SELECT MAX(payment_installments) AS maximum_installments
FROM order_payments;


-- -------------------------------------------------------------------------------------------------
-- Q7. How many payment records have missing payment types?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS missing_payment_types
FROM order_payments
WHERE payment_type IS NULL;


-- -------------------------------------------------------------------------------------------------
-- Q8. How many payment records have missing payment values?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS missing_payment_values
FROM order_payments
WHERE payment_value IS NULL;


-- -------------------------------------------------------------------------------------------------
-- Q9. What is the smallest recorded payment value?
-- -------------------------------------------------------------------------------------------------

SELECT MIN(payment_value) AS minimum_payment_value
FROM order_payments;


-- -------------------------------------------------------------------------------------------------
-- Q10. What is the largest recorded payment value?
-- -------------------------------------------------------------------------------------------------

SELECT MAX(payment_value) AS maximum_payment_value
FROM order_payments;


/========================================================================================================================
KEY FINDINGS
-------------------------------------------------------------------------------------------------------------------------

• The dataset contains 103,886 payment records.
• Five payment methods are represented.
• Credit card is the dominant payment method.
• Three records contain the explicit payment type 'not_defined'.
• Payment installments range from 0 to 24.
• No payment records have NULL payment types.
• No payment values are missing.
• Payment values range from 0.00 to 13,664.08.

-------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
-------------------------------------------------------------------------------------------------------------------------

This investigation explored the structure and completeness of payment data before
conducting financial analyses.

Several findings warrant future investigation, including payment records with zero
installments, zero payment values, and the explicit 'not_defined' payment type.
These observations demonstrate that exploratory analysis should focus not only on
summarizing data but also on identifying records that may influence future business
reporting.

======================================================================================================================*/

/*======================================================================================================================
INVESTIGATION 6 — REVIEWS

Business Objective
------------------
Explore customer review data to understand review coverage, score distribution,
timestamps, and completeness before performing customer satisfaction analysis.

======================================================================================================================*/


-- -------------------------------------------------------------------------------------------------
-- Q1. How many review records exist?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS total_reviews
FROM order_reviews;


-- -------------------------------------------------------------------------------------------------
-- Q2. How many unique review IDs exist?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT review_id) AS unique_review_ids
FROM order_reviews;


-- -------------------------------------------------------------------------------------------------
-- Q3. Which review scores are represented?
-- -------------------------------------------------------------------------------------------------

SELECT DISTINCT review_score
FROM order_reviews
ORDER BY review_score;


-- -------------------------------------------------------------------------------------------------
-- Q4. How many reviews were given for each review score?
-- -------------------------------------------------------------------------------------------------

SELECT
    review_score,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_score
ORDER BY review_count DESC;


-- -------------------------------------------------------------------------------------------------
-- Q5. What is the earliest review creation date?
-- -------------------------------------------------------------------------------------------------

SELECT MIN(review_creation_date) AS earliest_review_creation
FROM order_reviews;


-- -------------------------------------------------------------------------------------------------
-- Q6. What is the latest review creation date?
-- -------------------------------------------------------------------------------------------------

SELECT MAX(review_creation_date) AS latest_review_creation
FROM order_reviews;


-- -------------------------------------------------------------------------------------------------
-- Q7. How many reviews are missing a title?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS reviews_missing_title
FROM order_reviews
WHERE review_comment_title IS NULL;


-- -------------------------------------------------------------------------------------------------
-- Q8. How many reviews are missing a written message?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS reviews_missing_message
FROM order_reviews
WHERE review_comment_message IS NULL;


-- -------------------------------------------------------------------------------------------------
-- Q9. How many reviews contain only a numerical rating?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS reviews_missing_title_and_message
FROM order_reviews
WHERE review_comment_title IS NULL
  AND review_comment_message IS NULL;


-- -------------------------------------------------------------------------------------------------
-- Q10. Verify duplicate review IDs.
-- -------------------------------------------------------------------------------------------------

SELECT
    review_id,
    COUNT(*) AS occurrences
FROM order_reviews
GROUP BY review_id
ORDER BY occurrences DESC;

--To count the number of duplicate review_id values, we can use the following query:
SELECT COUNT(*) AS duplicated_review_ids
FROM (
    SELECT review_id
    FROM order_reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) AS duplicates;

-- Analyst Note:
-- Duplicate review_id values confirm that review_id is not a suitable
-- primary key. This validates the earlier decision to introduce the
-- surrogate key review_key during database design.


/========================================================================================================================
KEY FINDINGS
-------------------------------------------------------------------------------------------------------------------------

• The dataset contains 99,224 review records.
• Only 98,410 review IDs are unique.
• Review scores range from 1 to 5.
• Five-star reviews dominate the dataset.
• Review coverage is exceptionally high relative to total orders.
• Most reviews do not contain titles.
• More than half of all reviews contain only a numerical rating.
• Duplicate review IDs validate the schema redesign implemented during Phase 1.

-------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
-------------------------------------------------------------------------------------------------------------------------

This investigation reinforced the importance of validating business identifiers
before relying on them for database design.

Although review scores suggest a generally positive customer experience,
analysts should avoid assuming they perfectly represent overall customer
satisfaction because review participation may be subject to response bias.

The investigation also highlighted that missing textual comments are common in
customer review systems and do not necessarily indicate poor data quality.

======================================================================================================================*/

/*======================================================================================================================
INVESTIGATION 7 — GEOLOCATION

Business Objective
------------------
Explore the geolocation reference dataset to understand its size, geographic
coverage, uniqueness, and completeness before supporting customer, seller,
and delivery analyses.

======================================================================================================================*/


-- -------------------------------------------------------------------------------------------------
-- Q1. How many geolocation records exist?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS total_geolocation_records
FROM geolocation;


-- -------------------------------------------------------------------------------------------------
-- Q2. How many unique ZIP code prefixes are represented?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_code_prefixes
FROM geolocation;


-- -------------------------------------------------------------------------------------------------
-- Q3. How many unique cities are represented?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT geolocation_city) AS unique_cities
FROM geolocation;


-- -------------------------------------------------------------------------------------------------
-- Q4. How many states are represented?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT geolocation_state) AS unique_states
FROM geolocation;


-- -------------------------------------------------------------------------------------------------
-- Q5. Which states are represented?
-- -------------------------------------------------------------------------------------------------

SELECT DISTINCT geolocation_state
FROM geolocation
ORDER BY geolocation_state;


-- -------------------------------------------------------------------------------------------------
-- Q6. How many geolocation records belong to each state?
-- -------------------------------------------------------------------------------------------------

SELECT
    geolocation_state,
    COUNT(*) AS state_records
FROM geolocation
GROUP BY geolocation_state
ORDER BY state_records DESC;


-- -------------------------------------------------------------------------------------------------
-- Q7. How many records have missing latitude values?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS missing_latitude
FROM geolocation
WHERE geolocation_lat IS NULL;


-- -------------------------------------------------------------------------------------------------
-- Q8. How many records have missing longitude values?
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS missing_longitude
FROM geolocation
WHERE geolocation_lng IS NULL;


-- -------------------------------------------------------------------------------------------------
-- Q9. Verify duplicate ZIP code prefixes.
-- -------------------------------------------------------------------------------------------------

SELECT
    geolocation_zip_code_prefix,
    COUNT(*) AS occurrences
FROM geolocation
GROUP BY geolocation_zip_code_prefix
ORDER BY occurrences DESC;

-- Analyst Note:
-- Multiple records share the same ZIP code prefix, confirming that
-- geolocation_zip_code_prefix cannot serve as a primary key.


-- -------------------------------------------------------------------------------------------------
-- Q10. Verify surrogate key range.
-- -------------------------------------------------------------------------------------------------

SELECT MIN(geolocation_id) AS first_geolocation_id,
       MAX(geolocation_id) AS last_geolocation_id
FROM geolocation;


/========================================================================================================================
KEY FINDINGS
-------------------------------------------------------------------------------------------------------------------------

• The table contains 1,000,163 geographic records.
• There are 19,015 unique ZIP code prefixes.
• Geographic coverage spans 8,011 cities and all 27 Brazilian federal units.
• Duplicate ZIP code prefixes validate the use of a surrogate primary key.
• Latitude and longitude values should be complete before mapping analyses.
• The surrogate key spans the full dataset from 1 to 1,000,163.

-------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
-------------------------------------------------------------------------------------------------------------------------

This investigation confirmed that the geolocation dataset provides broad geographic
coverage suitable for future regional analyses.

It also reinforced an important database design principle: business identifiers
are not always unique enough to function as primary keys. The surrogate key
introduced during database implementation ensures that each geographic record can
be uniquely identified while preserving the original ZIP code prefix for analysis.

======================================================================================================================*/