/*
======================================================================
Investigation 39 — Activity Threshold Analysis

SQL Script: 33_activity_threshold_analysis.sql

Purpose:
Determine and validate minimum delivered-order activity thresholds
for sellers and product categories before applying the Revenue
Opportunity Scorecard in Investigation 40.

The investigation evaluates:

    1. Seller activity distribution
    2. Seller activity bands
    3. Seller threshold coverage
    4. Seller threshold candidates
    5. Product-category activity distribution
    6. Product-category activity bands
    7. Product-category threshold coverage
    8. Product-category threshold candidates
    9. Threshold comparison
   10. Eligible population summary

Activity is measured using DISTINCT delivered order IDs.

Proposed thresholds carried into Investigation 40:

    Sellers:
        >= 10 delivered orders

    Product Categories:
        >= 100 delivered orders

Important:
The purpose of this investigation is not to identify revenue
opportunities directly.

It establishes whether the minimum activity thresholds used by
Investigation 40 are analytically defensible.
======================================================================
*/


/*======================================================================
  QUESTION 1
  Seller Activity Distribution

  How is delivered-order activity distributed across sellers?
======================================================================*/

WITH seller_activity AS
(
    SELECT
        oi.seller_id AS seller,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
)

SELECT
    COUNT(*) AS total_sellers,

    MIN(delivered_orders)
        AS minimum_orders,

    PERCENTILE_CONT(0.25)
        WITHIN GROUP (
            ORDER BY delivered_orders
        ) AS p25_orders,

    PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY delivered_orders
        ) AS median_orders,

    PERCENTILE_CONT(0.75)
        WITHIN GROUP (
            ORDER BY delivered_orders
        ) AS p75_orders,

    PERCENTILE_CONT(0.90)
        WITHIN GROUP (
            ORDER BY delivered_orders
        ) AS p90_orders,

    MAX(delivered_orders)
        AS maximum_orders

FROM seller_activity;


/*======================================================================
  QUESTION 2
  Seller Activity Bands

  How many sellers fall into different delivered-order activity bands?
======================================================================*/

WITH seller_activity AS
(
    SELECT
        oi.seller_id AS seller,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

seller_activity_bands AS
(
    SELECT

        CASE
            WHEN delivered_orders < 5
                THEN '1-4 orders'

            WHEN delivered_orders BETWEEN 5 AND 9
                THEN '5-9 orders'

            WHEN delivered_orders BETWEEN 10 AND 19
                THEN '10-19 orders'

            WHEN delivered_orders BETWEEN 20 AND 49
                THEN '20-49 orders'

            WHEN delivered_orders BETWEEN 50 AND 99
                THEN '50-99 orders'

            ELSE '100+ orders'

        END AS activity_band,

        MIN(delivered_orders)
            AS minimum_orders,

        COUNT(*) AS sellers

    FROM seller_activity

    GROUP BY activity_band
)

SELECT
    activity_band,

    sellers

FROM seller_activity_bands

ORDER BY minimum_orders;


/*======================================================================
  QUESTION 3
  Seller Threshold Coverage

  What proportion of sellers and delivered-order activity would be
  retained at different possible thresholds?
======================================================================*/

WITH seller_activity AS
(
    SELECT
        oi.seller_id AS seller,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
)

SELECT

    COUNT(*) AS total_sellers,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 5
    ) AS sellers_5_plus,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 10
    ) AS sellers_10_plus,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 20
    ) AS sellers_20_plus,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 50
    ) AS sellers_50_plus,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 5
        ) * 100.0
        / COUNT(*),
        2
    ) AS pct_sellers_5_plus,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 10
        ) * 100.0
        / COUNT(*),
        2
    ) AS pct_sellers_10_plus,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 20
        ) * 100.0
        / COUNT(*),
        2
    ) AS pct_sellers_20_plus,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 50
        ) * 100.0
        / COUNT(*),
        2
    ) AS pct_sellers_50_plus

FROM seller_activity;


/*======================================================================
  QUESTION 4
  Seller Threshold Candidates

  Which sellers satisfy the proposed minimum threshold of 10 delivered
  orders?
======================================================================*/

WITH seller_activity AS
(
    SELECT
        oi.seller_id AS seller,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
)

SELECT
    seller,

    delivered_orders

FROM seller_activity

WHERE delivered_orders >= 10

ORDER BY delivered_orders DESC;


/*======================================================================
  QUESTION 5
  Product Category Activity Distribution

  How is delivered-order activity distributed across product
  categories?
======================================================================*/

WITH category_activity AS
(
    SELECT
        p.product_category_name AS category,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
)

SELECT

    COUNT(*) AS total_categories,

    MIN(delivered_orders)
        AS minimum_orders,

    PERCENTILE_CONT(0.25)
        WITHIN GROUP (
            ORDER BY delivered_orders
        ) AS p25_orders,

    PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY delivered_orders
        ) AS median_orders,

    PERCENTILE_CONT(0.75)
        WITHIN GROUP (
            ORDER BY delivered_orders
        ) AS p75_orders,

    PERCENTILE_CONT(0.90)
        WITHIN GROUP (
            ORDER BY delivered_orders
        ) AS p90_orders,

    MAX(delivered_orders)
        AS maximum_orders

FROM category_activity;


/*======================================================================
  QUESTION 6
  Product Category Activity Bands

  How many product categories fall into different delivered-order
  activity bands?
======================================================================*/

WITH category_activity AS
(
    SELECT
        p.product_category_name AS category,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
),

category_activity_bands AS
(
    SELECT

        CASE
            WHEN delivered_orders < 50
                THEN '1-49 orders'

            WHEN delivered_orders BETWEEN 50 AND 99
                THEN '50-99 orders'

            WHEN delivered_orders BETWEEN 100 AND 499
                THEN '100-499 orders'

            WHEN delivered_orders BETWEEN 500 AND 999
                THEN '500-999 orders'

            ELSE '1000+ orders'

        END AS activity_band,

        MIN(delivered_orders)
            AS minimum_orders,

        COUNT(*) AS categories

    FROM category_activity

    GROUP BY activity_band
)

SELECT
    activity_band,

    categories

FROM category_activity_bands

ORDER BY minimum_orders;


/*======================================================================
  QUESTION 7
  Product Category Threshold Coverage

  What proportion of categories and delivered-order activity would be
  retained at different possible thresholds?
======================================================================*/

WITH category_activity AS
(
    SELECT
        p.product_category_name AS category,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
)

SELECT

    COUNT(*) AS total_categories,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 25
    ) AS categories_25_plus,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 50
    ) AS categories_50_plus,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 100
    ) AS categories_100_plus,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 250
    ) AS categories_250_plus,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 25
        ) * 100.0
        / COUNT(*),
        2
    ) AS pct_categories_25_plus,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 50
        ) * 100.0
        / COUNT(*),
        2
    ) AS pct_categories_50_plus,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 100
        ) * 100.0
        / COUNT(*),
        2
    ) AS pct_categories_100_plus,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 250
        ) * 100.0
        / COUNT(*),
        2
    ) AS pct_categories_250_plus

FROM category_activity;


/*======================================================================
  QUESTION 8
  Product Category Threshold Candidates

  Which categories satisfy the proposed minimum threshold of 100
  delivered orders?
======================================================================*/

WITH category_activity AS
(
    SELECT
        p.product_category_name AS category,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
)

SELECT
    category,

    delivered_orders

FROM category_activity

WHERE delivered_orders >= 100

ORDER BY delivered_orders DESC;


/*======================================================================
  QUESTION 9
  Threshold Comparison

  Compare the proposed seller and category thresholds with their
  respective population distributions.
======================================================================*/

WITH seller_activity AS
(
    SELECT
        oi.seller_id AS entity,

        COUNT(DISTINCT o.order_id)
            AS activity

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

category_activity AS
(
    SELECT
        p.product_category_name AS entity,

        COUNT(DISTINCT o.order_id)
            AS activity

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
)

SELECT
    'Seller' AS entity_type,

    COUNT(*) AS total_entities,

    COUNT(*) FILTER (
        WHERE activity >= 10
    ) AS eligible_entities,

    COUNT(*) FILTER (
        WHERE activity < 10
    ) AS excluded_entities,

    ROUND(
        COUNT(*) FILTER (
            WHERE activity >= 10
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_retained

FROM seller_activity

UNION ALL

SELECT
    'Product Category' AS entity_type,

    COUNT(*) AS total_entities,

    COUNT(*) FILTER (
        WHERE activity >= 100
    ) AS eligible_entities,

    COUNT(*) FILTER (
        WHERE activity < 100
    ) AS excluded_entities,

    ROUND(
        COUNT(*) FILTER (
            WHERE activity >= 100
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_retained

FROM category_activity;


/*======================================================================
  QUESTION 10
  Activity Coverage at the Proposed Thresholds

  How much delivered-order activity remains represented after applying
  the proposed thresholds?
======================================================================*/

WITH seller_activity AS
(
    SELECT
        oi.seller_id AS entity,

        COUNT(DISTINCT o.order_id)
            AS activity

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

category_activity AS
(
    SELECT
        p.product_category_name AS entity,

        COUNT(DISTINCT o.order_id)
            AS activity

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
)

SELECT
    'Seller' AS entity_type,

    SUM(activity) AS total_activity,

    SUM(activity) FILTER (
        WHERE activity >= 10
    ) AS eligible_activity,

    ROUND(
        SUM(activity) FILTER (
            WHERE activity >= 10
        ) * 100.0
        / SUM(activity),
        2
    ) AS percentage_activity_covered

FROM seller_activity

UNION ALL

SELECT
    'Product Category' AS entity_type,

    SUM(activity) AS total_activity,

    SUM(activity) FILTER (
        WHERE activity >= 100
    ) AS eligible_activity,

    ROUND(
        SUM(activity) FILTER (
            WHERE activity >= 100
        ) * 100.0
        / SUM(activity),
        2
    ) AS percentage_activity_covered

FROM category_activity;


/*======================================================================
  QUESTION 11
  Seller Threshold Sensitivity

  Compare the number of sellers retained and activity covered under
  alternative thresholds.
======================================================================*/

WITH seller_activity AS
(
    SELECT
        oi.seller_id AS seller,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
)

SELECT
    threshold,

    COUNT(*) FILTER (
        WHERE delivered_orders >= threshold
    ) AS eligible_sellers,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= threshold
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_sellers_retained,

    SUM(delivered_orders) FILTER (
        WHERE delivered_orders >= threshold
    ) AS eligible_activity,

    ROUND(
        SUM(delivered_orders) FILTER (
            WHERE delivered_orders >= threshold
        ) * 100.0
        / SUM(delivered_orders),
        2
    ) AS percentage_activity_covered

FROM seller_activity

CROSS JOIN
(
    VALUES
        (5),
        (10),
        (20),
        (50)
) AS thresholds(threshold)

GROUP BY threshold

ORDER BY threshold;


/*======================================================================
  QUESTION 12
  Product Category Threshold Sensitivity

  Compare the number of categories retained and activity covered under
  alternative thresholds.
======================================================================*/

WITH category_activity AS
(
    SELECT
        p.product_category_name AS category,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
)

SELECT
    threshold,

    COUNT(*) FILTER (
        WHERE delivered_orders >= threshold
    ) AS eligible_categories,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= threshold
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_categories_retained,

    SUM(delivered_orders) FILTER (
        WHERE delivered_orders >= threshold
    ) AS eligible_activity,

    ROUND(
        SUM(delivered_orders) FILTER (
            WHERE delivered_orders >= threshold
        ) * 100.0
        / SUM(delivered_orders),
        2
    ) AS percentage_activity_covered

FROM category_activity

CROSS JOIN
(
    VALUES
        (25),
        (50),
        (100),
        (250)
) AS thresholds(threshold)

GROUP BY threshold

ORDER BY threshold;


/*======================================================================
  QUESTION 13
  Proposed Seller Threshold Summary

  Produce the final seller population summary that will be carried
  forward into Investigation 40.
======================================================================*/

WITH seller_activity AS
(
    SELECT
        oi.seller_id AS seller,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
)

SELECT
    'Seller' AS entity_type,

    10 AS selected_threshold,

    COUNT(*) AS total_entities,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 10
    ) AS eligible_entities,

    COUNT(*) FILTER (
        WHERE delivered_orders < 10
    ) AS excluded_entities,

    SUM(delivered_orders) AS total_activity,

    SUM(delivered_orders) FILTER (
        WHERE delivered_orders >= 10
    ) AS eligible_activity,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 10
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_entities_retained,

    ROUND(
        SUM(delivered_orders) FILTER (
            WHERE delivered_orders >= 10
        ) * 100.0
        / SUM(delivered_orders),
        2
    ) AS percentage_activity_covered

FROM seller_activity;


/*======================================================================
  QUESTION 14
  Proposed Product Category Threshold Summary

  Produce the final category population summary that will be carried
  forward into Investigation 40.
======================================================================*/

WITH category_activity AS
(
    SELECT
        p.product_category_name AS category,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
)

SELECT
    'Product Category' AS entity_type,

    100 AS selected_threshold,

    COUNT(*) AS total_entities,

    COUNT(*) FILTER (
        WHERE delivered_orders >= 100
    ) AS eligible_entities,

    COUNT(*) FILTER (
        WHERE delivered_orders < 100
    ) AS excluded_entities,

    SUM(delivered_orders) AS total_activity,

    SUM(delivered_orders) FILTER (
        WHERE delivered_orders >= 100
    ) AS eligible_activity,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders >= 100
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_entities_retained,

    ROUND(
        SUM(delivered_orders) FILTER (
            WHERE delivered_orders >= 100
        ) * 100.0
        / SUM(delivered_orders),
        2
    ) AS percentage_activity_covered

FROM category_activity;


/*======================================================================
  QUESTION 15
  Final Threshold Decision

  Present the thresholds that Investigation 40 should use.

  These are analytical decisions, not database constraints.
======================================================================*/

SELECT
    'Seller' AS entity_type,
    10 AS minimum_delivered_orders,
    'Use in Investigation 40 scorecard' AS decision

UNION ALL

SELECT
    'Product Category' AS entity_type,
    100 AS minimum_delivered_orders,
    'Use in Investigation 40 scorecard' AS decision;