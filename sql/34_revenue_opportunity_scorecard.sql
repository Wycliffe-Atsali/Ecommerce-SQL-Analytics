# Investigation 40 — Revenue Opportunity Scorecard

## SQL File: `34_revenue_opportunity_scorecard.sql`

```sql
/*
======================================================================
Investigation 40 — Revenue Opportunity Scorecard

SQL Script: 34_revenue_opportunity_scorecard.sql

Purpose:
Identify sellers and product categories with attractive potential
for additional revenue growth.

Investigation 39 established the analytical population:

    Sellers:
        >= 10 delivered orders

    Product Categories:
        >= 100 delivered orders

This investigation builds on those thresholds and evaluates:

    1. Seller eligibility
    2. Product-category eligibility
    3. Eligibility coverage
    4. Seller opportunity metrics
    5. Product-category opportunity metrics
    6. Promising low-scale entities
    7. Seller opportunity standardization
    8. Seller revenue headroom
    9. Product-category opportunity standardization
   10. Seller revenue opportunity score
   11. Product-category revenue opportunity score
   12. Opportunity classification
   13. Highest-opportunity sellers
   14. Highest-opportunity product categories
   15. Final reusable dashboard

Revenue attribution:
    order_items.price + order_items.freight_value

Only delivered orders are included.

Scoring weights:

    Revenue Headroom          30%
    Customer Acceptance       30%
    Operational Readiness     25%
    Market Activity           15%

IMPORTANT:
Seller and product-category populations are standardized separately.
======================================================================
*/


/*======================================================================
  QUESTION 1
  Seller Eligibility

  Minimum threshold established in Investigation 39:
      >= 10 delivered orders
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
  QUESTION 2
  Product Category Eligibility

  Minimum threshold established in Investigation 39:
      >= 100 delivered orders
======================================================================*/

WITH category_activity AS
(
    SELECT
        p.product_category_name AS category,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

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
  QUESTION 3
  Eligibility Coverage

  Measure the impact of the thresholds established in Investigation 39.
======================================================================*/

WITH seller_activity AS
(
    SELECT
        oi.seller_id AS entity,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

seller_coverage AS
(
    SELECT
        'Seller' AS entity_type,

        COUNT(*) AS total_entities,

        COUNT(*) FILTER (
            WHERE delivered_orders >= 10
        ) AS eligible_entities,

        COUNT(*) FILTER (
            WHERE delivered_orders < 10
        ) AS excluded_entities,

        SUM(delivered_orders) FILTER (
            WHERE delivered_orders >= 10
        ) AS eligible_activity,

        SUM(delivered_orders)
            AS total_activity

    FROM seller_activity
),

category_activity AS
(
    SELECT
        p.product_category_name AS entity,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
),

category_coverage AS
(
    SELECT
        'Product Category' AS entity_type,

        COUNT(*) AS total_entities,

        COUNT(*) FILTER (
            WHERE delivered_orders >= 100
        ) AS eligible_entities,

        COUNT(*) FILTER (
            WHERE delivered_orders < 100
        ) AS excluded_entities,

        SUM(delivered_orders) FILTER (
            WHERE delivered_orders >= 100
        ) AS eligible_activity,

        SUM(delivered_orders)
            AS total_activity

    FROM category_activity
)

SELECT
    entity_type,
    total_entities,
    eligible_entities,
    excluded_entities,
    eligible_activity,
    total_activity,

    ROUND(
        eligible_entities * 100.0
        / total_entities,
        2
    ) AS percentage_entities_retained,

    ROUND(
        eligible_activity * 100.0
        / total_activity,
        2
    ) AS percentage_activity_covered

FROM seller_coverage

UNION ALL

SELECT
    entity_type,
    total_entities,
    eligible_entities,
    excluded_entities,
    eligible_activity,
    total_activity,

    ROUND(
        eligible_entities * 100.0
        / total_entities,
        2
    ),

    ROUND(
        eligible_activity * 100.0
        / total_activity,
        2
    )

FROM category_coverage;


/*======================================================================
  QUESTION 4
  Seller Opportunity Metrics

  Build the raw seller metric layer.
======================================================================*/

WITH seller_metrics AS
(
    SELECT
        oi.seller_id AS seller,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
)

SELECT
    seller,

    ROUND(sales_value, 2)
        AS sales_value,

    delivered_orders,

    ROUND(average_review_score, 2)
        AS average_review_score,

    ROUND(on_time_delivery_rate, 2)
        AS on_time_delivery_rate

FROM seller_metrics

WHERE delivered_orders >= 10

ORDER BY sales_value DESC;


/*======================================================================
  QUESTION 5
  Product Category Opportunity Metrics

  Build the raw product-category metric layer.
======================================================================*/

WITH category_metrics AS
(
    SELECT
        p.product_category_name AS category,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
)

SELECT
    category,

    ROUND(sales_value, 2)
        AS sales_value,

    delivered_orders,

    ROUND(average_review_score, 2)
        AS average_review_score,

    ROUND(on_time_delivery_rate, 2)
        AS on_time_delivery_rate

FROM category_metrics

WHERE delivered_orders >= 100

ORDER BY sales_value DESC;


/*======================================================================
  QUESTION 6
  Promising Low-Scale Entities

  Identify eligible sellers and categories that combine:
      - relatively low sales;
      - sufficient activity;
      - review score >= 4.0;
      - on-time delivery >= 80%.

  Sellers use the bottom 25% of eligible seller sales.
  Categories use below-average eligible-category sales.
======================================================================*/

WITH seller_metrics AS
(
    SELECT
        oi.seller_id::text AS entity,

        'Seller' AS entity_type,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

eligible_sellers AS
(
    SELECT *
    FROM seller_metrics
    WHERE activity >= 10
),

seller_sales_threshold AS
(
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (
                ORDER BY sales_value
            ) AS p25_sales

    FROM eligible_sellers
),

category_metrics AS
(
    SELECT
        p.product_category_name AS entity,

        'Product Category' AS entity_type,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
),

eligible_categories AS
(
    SELECT *
    FROM category_metrics
    WHERE activity >= 100
),

category_sales_threshold AS
(
    SELECT
        AVG(sales_value) AS average_sales

    FROM eligible_categories
)

SELECT
    entity_type,
    entity,
    ROUND(sales_value, 2) AS sales_value,
    activity,
    ROUND(average_review_score, 2)
        AS average_review_score,
    ROUND(on_time_delivery_rate, 2)
        AS on_time_delivery_rate

FROM eligible_sellers es

CROSS JOIN seller_sales_threshold st

WHERE es.sales_value <= st.p25_sales
  AND es.average_review_score >= 4.0
  AND es.on_time_delivery_rate >= 80

UNION ALL

SELECT
    entity_type,
    entity,
    ROUND(sales_value, 2),
    activity,
    ROUND(average_review_score, 2),
    ROUND(on_time_delivery_rate, 2)

FROM eligible_categories ec

CROSS JOIN category_sales_threshold ct

WHERE ec.sales_value < ct.average_sales
  AND ec.average_review_score >= 4.0
  AND ec.on_time_delivery_rate >= 80

ORDER BY sales_value ASC;


/*======================================================================
  QUESTION 7
  Seller Opportunity Standardization

  Convert seller metrics to relative 0–100 scores.
======================================================================*/

WITH seller_metrics AS
(
    SELECT
        oi.seller_id AS seller,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

eligible_sellers AS
(
    SELECT *
    FROM seller_metrics
    WHERE activity >= 10
)

SELECT
    seller,

    ROUND(sales_value, 2)
        AS sales_value,

    activity,

    ROUND(average_review_score, 2)
        AS average_review_score,

    ROUND(on_time_delivery_rate, 2)
        AS on_time_delivery_rate,

    ROUND(
        (
            1 -
            PERCENT_RANK() OVER (
                ORDER BY sales_value
            )
        ) * 100,
        2
    ) AS revenue_headroom_score,

    ROUND(
        PERCENT_RANK() OVER (
            ORDER BY average_review_score
        ) * 100,
        2
    ) AS customer_acceptance_score,

    ROUND(
        PERCENT_RANK() OVER (
            ORDER BY on_time_delivery_rate
        ) * 100,
        2
    ) AS operational_readiness_score,

    ROUND(
        PERCENT_RANK() OVER (
            ORDER BY activity
        ) * 100,
        2
    ) AS market_activity_score

FROM eligible_sellers

ORDER BY revenue_headroom_score DESC;


/*======================================================================
  QUESTION 8
  Seller Revenue Headroom

  Show seller revenue percentile and its inverse headroom score.
======================================================================*/

WITH seller_metrics AS
(
    SELECT
        oi.seller_id AS seller,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

eligible_sellers AS
(
    SELECT *
    FROM seller_metrics
    WHERE activity >= 10
),

seller_percentiles AS
(
    SELECT
        seller,
        sales_value,
        activity,

        PERCENT_RANK() OVER (
            ORDER BY sales_value
        ) AS revenue_percentile

    FROM eligible_sellers
)

SELECT
    seller,

    ROUND(sales_value, 2)
        AS sales_value,

    activity,

    ROUND(
        revenue_percentile * 100,
        2
    ) AS revenue_percentile,

    ROUND(
        (1 - revenue_percentile) * 100,
        2
    ) AS revenue_headroom_score

FROM seller_percentiles

ORDER BY revenue_headroom_score DESC;


/*======================================================================
  QUESTION 9
  Product Category Opportunity Standardization

  Convert category metrics to relative 0–100 scores.
======================================================================*/

WITH category_metrics AS
(
    SELECT
        p.product_category_name AS category,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
),

eligible_categories AS
(
    SELECT *
    FROM category_metrics
    WHERE activity >= 100
)

SELECT
    category,

    ROUND(sales_value, 2)
        AS sales_value,

    activity,

    ROUND(average_review_score, 2)
        AS average_review_score,

    ROUND(on_time_delivery_rate, 2)
        AS on_time_delivery_rate,

    ROUND(
        (
            1 -
            PERCENT_RANK() OVER (
                ORDER BY sales_value
            )
        ) * 100,
        2
    ) AS revenue_headroom_score,

    ROUND(
        PERCENT_RANK() OVER (
            ORDER BY average_review_score
        ) * 100,
        2
    ) AS customer_acceptance_score,

    ROUND(
        PERCENT_RANK() OVER (
            ORDER BY on_time_delivery_rate
        ) * 100,
        2
    ) AS operational_readiness_score,

    ROUND(
        PERCENT_RANK() OVER (
            ORDER BY activity
        ) * 100,
        2
    ) AS market_activity_score

FROM eligible_categories

ORDER BY revenue_headroom_score DESC;


/*======================================================================
  QUESTION 10
  Seller Revenue Opportunity Score

  Weighting:

      Revenue Headroom          30%
      Customer Acceptance       30%
      Operational Readiness     25%
      Market Activity           15%
======================================================================*/

WITH seller_metrics AS
(
    SELECT
        oi.seller_id::text AS entity,

        'Seller' AS entity_type,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

eligible_sellers AS
(
    SELECT *
    FROM seller_metrics
    WHERE activity >= 10
),

standardized_scores AS
(
    SELECT
        *,

        (
            1 -
            PERCENT_RANK() OVER (
                ORDER BY sales_value
            )
        ) * 100
            AS revenue_headroom_score,

        PERCENT_RANK() OVER (
            ORDER BY average_review_score
        ) * 100
            AS customer_acceptance_score,

        PERCENT_RANK() OVER (
            ORDER BY on_time_delivery_rate
        ) * 100
            AS operational_readiness_score,

        PERCENT_RANK() OVER (
            ORDER BY activity
        ) * 100
            AS market_activity_score

    FROM eligible_sellers
)

SELECT
    entity_type,
    entity,

    ROUND(sales_value, 2)
        AS sales_value,

    activity,

    ROUND(average_review_score, 2)
        AS average_review_score,

    ROUND(on_time_delivery_rate, 2)
        AS on_time_delivery_rate,

    ROUND(revenue_headroom_score, 2)
        AS revenue_headroom_score,

    ROUND(customer_acceptance_score, 2)
        AS customer_acceptance_score,

    ROUND(operational_readiness_score, 2)
        AS operational_readiness_score,

    ROUND(market_activity_score, 2)
        AS market_activity_score,

    ROUND(
        revenue_headroom_score * 0.30
        +
        customer_acceptance_score * 0.30
        +
        operational_readiness_score * 0.25
        +
        market_activity_score * 0.15,
        2
    ) AS revenue_opportunity_score

FROM standardized_scores

ORDER BY revenue_opportunity_score DESC;


/*======================================================================
  QUESTION 11
  Product Category Revenue Opportunity Score
======================================================================*/

WITH category_metrics AS
(
    SELECT
        p.product_category_name::text AS entity,

        'Product Category' AS entity_type,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
),

eligible_categories AS
(
    SELECT *
    FROM category_metrics
    WHERE activity >= 100
),

standardized_scores AS
(
    SELECT
        *,

        (
            1 -
            PERCENT_RANK() OVER (
                ORDER BY sales_value
            )
        ) * 100
            AS revenue_headroom_score,

        PERCENT_RANK() OVER (
            ORDER BY average_review_score
        ) * 100
            AS customer_acceptance_score,

        PERCENT_RANK() OVER (
            ORDER BY on_time_delivery_rate
        ) * 100
            AS operational_readiness_score,

        PERCENT_RANK() OVER (
            ORDER BY activity
        ) * 100
            AS market_activity_score

    FROM eligible_categories
)

SELECT
    entity_type,
    entity,

    ROUND(sales_value, 2)
        AS sales_value,

    activity,

    ROUND(average_review_score, 2)
        AS average_review_score,

    ROUND(on_time_delivery_rate, 2)
        AS on_time_delivery_rate,

    ROUND(revenue_headroom_score, 2)
        AS revenue_headroom_score,

    ROUND(customer_acceptance_score, 2)
        AS customer_acceptance_score,

    ROUND(operational_readiness_score, 2)
        AS operational_readiness_score,

    ROUND(market_activity_score, 2)
        AS market_activity_score,

    ROUND(
        revenue_headroom_score * 0.30
        +
        customer_acceptance_score * 0.30
        +
        operational_readiness_score * 0.25
        +
        market_activity_score * 0.15,
        2
    ) AS revenue_opportunity_score

FROM standardized_scores

ORDER BY revenue_opportunity_score DESC;


/*======================================================================
  QUESTION 12
  Opportunity Classification

  Classify the complete eligible population into five business-facing
  opportunity tiers.
======================================================================*/

WITH seller_metrics AS
(
    SELECT
        oi.seller_id::text AS entity,
        'Seller' AS entity_type,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

category_metrics AS
(
    SELECT
        p.product_category_name::text AS entity,
        'Product Category' AS entity_type,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
),

eligible_entities AS
(
    SELECT *
    FROM seller_metrics
    WHERE activity >= 10

    UNION ALL

    SELECT *
    FROM category_metrics
    WHERE activity >= 100
),

standardized_scores AS
(
    SELECT
        *,

        (
            1 -
            PERCENT_RANK() OVER (
                PARTITION BY entity_type
                ORDER BY sales_value
            )
        ) * 100
            AS revenue_headroom_score,

        PERCENT_RANK() OVER (
            PARTITION BY entity_type
            ORDER BY average_review_score
        ) * 100
            AS customer_acceptance_score,

        PERCENT_RANK() OVER (
            PARTITION BY entity_type
            ORDER BY on_time_delivery_rate
        ) * 100
            AS operational_readiness_score,

        PERCENT_RANK() OVER (
            PARTITION BY entity_type
            ORDER BY activity
        ) * 100
            AS market_activity_score

    FROM eligible_entities
),

final_scores AS
(
    SELECT
        *,

        revenue_headroom_score * 0.30
        +
        customer_acceptance_score * 0.30
        +
        operational_readiness_score * 0.25
        +
        market_activity_score * 0.15
            AS revenue_opportunity_score

    FROM standardized_scores
)

SELECT
    entity_type,

    COUNT(*) AS entities,

    COUNT(*) FILTER (
        WHERE revenue_opportunity_score >= 80
    ) AS very_high_opportunity,

    COUNT(*) FILTER (
        WHERE revenue_opportunity_score >= 60
          AND revenue_opportunity_score < 80
    ) AS high_opportunity,

    COUNT(*) FILTER (
        WHERE revenue_opportunity_score >= 40
          AND revenue_opportunity_score < 60
    ) AS moderate_opportunity,

    COUNT(*) FILTER (
        WHERE revenue_opportunity_score >= 20
          AND revenue_opportunity_score < 40
    ) AS low_opportunity,

    COUNT(*) FILTER (
        WHERE revenue_opportunity_score < 20
    ) AS very_low_opportunity

FROM final_scores

GROUP BY entity_type

ORDER BY entity_type;


/*======================================================================
  QUESTION 13
  Highest-Opportunity Sellers

  Return the top 20 sellers.
======================================================================*/

SELECT *
FROM revenue_opportunity_dashboard

WHERE entity_type = 'Seller'

ORDER BY revenue_opportunity_score DESC

LIMIT 20;


/*======================================================================
  QUESTION 14
  Highest-Opportunity Product Categories

  Return the top 20 product categories.
======================================================================*/

SELECT *
FROM revenue_opportunity_dashboard

WHERE entity_type = 'Product Category'

ORDER BY revenue_opportunity_score DESC

LIMIT 20;


/*======================================================================
  QUESTION 15
  Final Revenue Opportunity Dashboard

  Create the reusable analytical view.

  IMPORTANT:
  The view must be created BEFORE executing Q13 and Q14.
======================================================================*/

/* ============================================================
Revenue Opportunity Dashboard
============================================================ */

CREATE OR REPLACE VIEW revenue_opportunity_dashboard AS

WITH seller_metrics AS
(
    SELECT
        oi.seller_id::text AS entity,

        'Seller' AS entity_type,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

category_metrics AS
(
    SELECT
        p.product_category_name::text AS entity,

        'Product Category' AS entity_type,

        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS activity,

        AVG(orv.review_score)
            AS average_review_score,

        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                THEN o.order_id
            END
        ) * 100.0
        /
        NULLIF(
            COUNT(DISTINCT o.order_id),
            0
        ) AS on_time_delivery_rate

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN order_reviews orv
        ON o.order_id = orv.order_id

    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL

    GROUP BY p.product_category_name
),

eligible_entities AS
(
    SELECT *
    FROM seller_metrics

    WHERE activity >= 10

    UNION ALL

    SELECT *
    FROM category_metrics

    WHERE activity >= 100
),

standardized_scores AS
(
    SELECT
        entity_type,
        entity,
        sales_value,
        activity,
        average_review_score,
        on_time_delivery_rate,

        (
            1 -
            PERCENT_RANK() OVER (
                PARTITION BY entity_type
                ORDER BY sales_value
            )
        ) * 100
            AS revenue_headroom_score,

        PERCENT_RANK() OVER (
            PARTITION BY entity_type
            ORDER BY average_review_score
        ) * 100
            AS customer_acceptance_score,

        PERCENT_RANK() OVER (
            PARTITION BY entity_type
            ORDER BY on_time_delivery_rate
        ) * 100
            AS operational_readiness_score,

        PERCENT_RANK() OVER (
            PARTITION BY entity_type
            ORDER BY activity
        ) * 100
            AS market_activity_score

    FROM eligible_entities
),

final_scorecard AS
(
    SELECT
        entity_type,
        entity,
        sales_value,
        activity,
        average_review_score,
        on_time_delivery_rate,

        revenue_headroom_score,
        customer_acceptance_score,
        operational_readiness_score,
        market_activity_score,

        revenue_headroom_score * 0.30
        +
        customer_acceptance_score * 0.30
        +
        operational_readiness_score * 0.25
        +
        market_activity_score * 0.15
            AS revenue_opportunity_score

    FROM standardized_scores
)

SELECT
    entity_type,
    entity,

    ROUND(
        sales_value::numeric,
        2
    ) AS sales_value,

    activity,

    ROUND(
        average_review_score::numeric,
        2
    ) AS average_review_score,

    ROUND(
        on_time_delivery_rate::numeric,
        2
    ) AS on_time_delivery_rate,

    ROUND(
        revenue_headroom_score::numeric,
        2
    ) AS revenue_headroom_score,

    ROUND(
        customer_acceptance_score::numeric,
        2
    ) AS customer_acceptance_score,

    ROUND(
        operational_readiness_score::numeric,
        2
    ) AS operational_readiness_score,

    ROUND(
        market_activity_score::numeric,
        2
    ) AS market_activity_score,

    ROUND(
        revenue_opportunity_score::numeric,
        2
    ) AS revenue_opportunity_score,

    CASE
        WHEN revenue_opportunity_score >= 80
            THEN 'Very High Opportunity'

        WHEN revenue_opportunity_score >= 60
            THEN 'High Opportunity'

        WHEN revenue_opportunity_score >= 40
            THEN 'Moderate Opportunity'

        WHEN revenue_opportunity_score >= 20
            THEN 'Low Opportunity'

        ELSE 'Very Low Opportunity'

    END AS opportunity_tier

FROM final_scorecard;
```

## SQL Execution Order

Because Q13 and Q14 query the reusable view created by Q15, the practical execution sequence is:

```text
Q1
 ↓
Q2
 ↓
Q3
 ↓
Q4
 ↓
Q5
 ↓
Q6
 ↓
Q7
 ↓
Q8
 ↓
Q9
 ↓
Q10
 ↓
Q11
 ↓
Q12
 ↓
Q15 — CREATE VIEW
 ↓
Q13 — Top Sellers
 ↓
Q14 — Top Categories
```

This preserves the investigation-question numbering while ensuring the reusable dashboard exists before it is queried.
