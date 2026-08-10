/*
===============================================================================
INVESTIGATION 41 — FINAL EXECUTIVE BUSINESS REVIEW
Retail SQL Business Analysis — Olist Brazilian E-Commerce Dataset
PostgreSQL

Consolidated Q1–Q25 analytical layer.
Authoritative views are defined once before downstream questions.
===============================================================================
*/

/* ============================================================================
AUTHORITATIVE VIEW 1 — Executive KPI Dashboard
Grain: one row per KPI
============================================================================ */
DROP VIEW IF EXISTS executive_kpi_dashboard;

CREATE VIEW executive_kpi_dashboard AS
WITH delivered_orders AS
(
    SELECT
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date
    FROM orders o
    WHERE o.order_status = 'delivered'
),
order_revenue AS
(
    SELECT
        d.order_id,
        SUM(op.payment_value) AS revenue
    FROM delivered_orders d
    JOIN order_payments op
        ON d.order_id = op.order_id
    GROUP BY d.order_id
),
customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(ore.revenue) AS lifetime_revenue
    FROM delivered_orders d
    JOIN customers c
        ON d.customer_id = c.customer_id
    JOIN order_revenue ore
        ON d.order_id = ore.order_id
    GROUP BY c.customer_unique_id
),
customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(DISTINCT d.order_id) AS delivered_orders
    FROM delivered_orders d
    JOIN customers c
        ON d.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
order_review_scores AS
(
    SELECT
        order_id,
        AVG(review_score) AS order_review_score
    FROM order_reviews
    GROUP BY order_id
),
revenue_kpi AS
(
    SELECT
        SUM(revenue) AS total_revenue,
        AVG(revenue) AS average_order_value
    FROM order_revenue
),
order_kpi AS
(
    SELECT COUNT(*) AS total_delivered_orders
    FROM delivered_orders
),
customer_kpi AS
(
    SELECT
        COUNT(*) AS active_customers,
        AVG(cr.lifetime_revenue) AS average_customer_lifetime_value,
        COUNT(*) FILTER (WHERE co.delivered_orders > 1) * 100.0
            / NULLIF(COUNT(*), 0) AS repeat_purchase_rate
    FROM customer_revenue cr
    JOIN customer_orders co
        ON cr.customer = co.customer
),
delivery_kpi AS
(
    SELECT
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date - order_purchase_timestamp
                )
            ) / 86400.0
        ) AS average_delivery_days
    FROM delivered_orders
    WHERE order_delivered_customer_date IS NOT NULL
),
review_kpi AS
(
    SELECT AVG(ors.order_review_score) AS average_review_score
    FROM delivered_orders d
    JOIN order_review_scores ors
        ON d.order_id = ors.order_id
)
SELECT 'Total Revenue' AS kpi, ROUND(total_revenue::numeric, 2) AS value
FROM revenue_kpi
UNION ALL
SELECT 'Total Delivered Orders', total_delivered_orders::numeric
FROM order_kpi
UNION ALL
SELECT 'Active Customers', active_customers::numeric
FROM customer_kpi
UNION ALL
SELECT 'Average Order Value', ROUND(average_order_value::numeric, 2)
FROM revenue_kpi
UNION ALL
SELECT 'Average Customer Lifetime Value', ROUND(average_customer_lifetime_value::numeric, 2)
FROM customer_kpi
UNION ALL
SELECT 'Repeat Purchase Rate', ROUND(repeat_purchase_rate::numeric, 2)
FROM customer_kpi
UNION ALL
SELECT 'Average Delivery Time', ROUND(average_delivery_days::numeric, 2)
FROM delivery_kpi
UNION ALL
SELECT 'Average Review Score', ROUND(average_review_score::numeric, 2)
FROM review_kpi;

/* ============================================================================
AUTHORITATIVE VIEW 2 — Revenue Opportunity Dashboard
Grain: one row per eligible seller or product category
============================================================================ */
DROP VIEW IF EXISTS revenue_opportunity_dashboard;

CREATE VIEW revenue_opportunity_dashboard AS
WITH seller_base AS
(
    SELECT
        'Seller'::text AS entity_type,
        oi.seller_id::text AS entity_id,
        COUNT(DISTINCT o.order_id) AS activity,
        SUM(oi.price + oi.freight_value) AS sales_value
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),
category_base AS
(
    SELECT
        'Product Category'::text AS entity_type,
        p.product_category_name::text AS entity_id,
        COUNT(DISTINCT o.order_id) AS activity,
        SUM(oi.price + oi.freight_value) AS sales_value
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL
    GROUP BY p.product_category_name
),
base_entities AS
(
    SELECT * FROM seller_base WHERE activity >= 10
    UNION ALL
    SELECT * FROM category_base WHERE activity >= 100
),
order_review_scores AS
(
    SELECT order_id, AVG(review_score) AS order_review_score
    FROM order_reviews
    GROUP BY order_id
),
seller_reviews AS
(
    SELECT
        oi.seller_id::text AS entity_id,
        AVG(ors.order_review_score) AS average_review_score
    FROM (SELECT DISTINCT seller_id, order_id FROM order_items) oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN order_review_scores ors ON o.order_id = ors.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),
category_reviews AS
(
    SELECT
        p.product_category_name::text AS entity_id,
        AVG(ors.order_review_score) AS average_review_score
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN order_review_scores ors ON oi.order_id = ors.order_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL
    GROUP BY p.product_category_name
),
seller_delivery AS
(
    SELECT
        oi.seller_id::text AS entity_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(DISTINCT CASE
            WHEN o.order_delivered_customer_date IS NOT NULL
             AND o.order_estimated_delivery_date IS NOT NULL
             AND o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN o.order_id END) AS on_time_orders
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),
category_delivery AS
(
    SELECT
        p.product_category_name::text AS entity_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(DISTINCT CASE
            WHEN o.order_delivered_customer_date IS NOT NULL
             AND o.order_estimated_delivery_date IS NOT NULL
             AND o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN o.order_id END) AS on_time_orders
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL
    GROUP BY p.product_category_name
),
entity_metrics AS
(
    SELECT
        b.entity_type,
        b.entity_id,
        b.activity,
        b.sales_value,
        COALESCE(
            CASE WHEN b.entity_type = 'Seller'
                 THEN sr.average_review_score
                 ELSE cr.average_review_score END, 0
        ) AS average_review_score,
        COALESCE(
            CASE WHEN b.entity_type = 'Seller'
                 THEN sd.on_time_orders * 100.0 / NULLIF(sd.delivered_orders, 0)
                 ELSE cd.on_time_orders * 100.0 / NULLIF(cd.delivered_orders, 0) END, 0
        ) AS on_time_delivery_rate
    FROM base_entities b
    LEFT JOIN seller_reviews sr
        ON b.entity_type = 'Seller' AND b.entity_id = sr.entity_id
    LEFT JOIN category_reviews cr
        ON b.entity_type = 'Product Category' AND b.entity_id = cr.entity_id
    LEFT JOIN seller_delivery sd
        ON b.entity_type = 'Seller' AND b.entity_id = sd.entity_id
    LEFT JOIN category_delivery cd
        ON b.entity_type = 'Product Category' AND b.entity_id = cd.entity_id
),
standardized_scores AS
(
    SELECT
        *,
        (1 - PERCENT_RANK() OVER (
            PARTITION BY entity_type ORDER BY sales_value
        )) * 100 AS revenue_headroom_score,
        PERCENT_RANK() OVER (
            PARTITION BY entity_type ORDER BY average_review_score
        ) * 100 AS customer_acceptance_score,
        PERCENT_RANK() OVER (
            PARTITION BY entity_type ORDER BY on_time_delivery_rate
        ) * 100 AS operational_readiness_score,
        PERCENT_RANK() OVER (
            PARTITION BY entity_type ORDER BY activity
        ) * 100 AS market_activity_score
    FROM entity_metrics
),
scored_entities AS
(
    SELECT
        *,
        revenue_headroom_score * 0.30
        + customer_acceptance_score * 0.30
        + operational_readiness_score * 0.25
        + market_activity_score * 0.15 AS revenue_opportunity_score
    FROM standardized_scores
)
SELECT
    entity_type,
    entity_id,
    activity,
    ROUND(sales_value::numeric, 2) AS sales_value,
    ROUND(average_review_score::numeric, 2) AS average_review_score,
    ROUND(on_time_delivery_rate::numeric, 2) AS on_time_delivery_rate,
    ROUND(revenue_headroom_score::numeric, 2) AS revenue_headroom_score,
    ROUND(customer_acceptance_score::numeric, 2) AS customer_acceptance_score,
    ROUND(operational_readiness_score::numeric, 2) AS operational_readiness_score,
    ROUND(market_activity_score::numeric, 2) AS market_activity_score,
    ROUND(revenue_opportunity_score::numeric, 2) AS revenue_opportunity_score,
    CASE
        WHEN revenue_opportunity_score >= 80 THEN 'Very High Opportunity'
        WHEN revenue_opportunity_score >= 60 THEN 'High Opportunity'
        WHEN revenue_opportunity_score >= 40 THEN 'Moderate Opportunity'
        WHEN revenue_opportunity_score >= 20 THEN 'Low Opportunity'
        ELSE 'Very Low Opportunity'
    END AS opportunity_tier
FROM scored_entities;


/*
===============================================================================
FINAL ANALYTICAL SQL LAYER
Retail SQL Business Analysis — Olist Brazilian E-Commerce Dataset
PostgreSQL

Purpose
-------
This script contains the consolidated final analytical layer for the executive
business investigation. It is intended to replace development-stage versions
of the individual queries and duplicated view definitions.

Core revenue definitions
------------------------
1. Marketplace revenue:
   order_payments.payment_value

   Used for marketplace-level revenue, AOV, CLV, revenue trends, and executive
   KPIs. Calculated from delivered orders.

2. Seller-attributed sales:
   order_items.price + order_items.freight_value

   Used for seller and product/category analyses. This avoids multiplying
   order-level payment rows when an order contains multiple items/sellers.

3. Product/category sales:
   order_items.price + order_items.freight_value

Important analytical definitions
---------------------------------
- "Active customers" = customers with at least one delivered order.
- "Repeat purchase rate" = percentage of active customers with more than one
  delivered order.
- "Average customer lifetime value" = historical average delivered-order
  lifetime revenue among customers with at least one delivered order. It is
  NOT a predictive CLV model.
- Seller reviews are order-level reviews attributed to each seller appearing
  in the reviewed order. The dataset does not attach a review directly to a
  seller.
- Opportunity scores are relative prioritisation indicators, not forecasts of
  actual incremental revenue.

Scoring methodology
-------------------
PERCENT_RANK() * 100 converts relative position to a 0–100 scale.

Direct normalisation:
    review_score / 5 * 100

Inverse percentile:
    (1 - PERCENT_RANK()) * 100

For opportunity scoring:
    Revenue headroom       30%
    Customer acceptance    30%
    Operational readiness  25%
    Market activity       15%

For seller performance:
    Revenue                35%
    Orders                 25%
    Reviews                20%
    Delivery               20%

NULL metrics are handled explicitly. Missing review or delivery evidence
does not receive an artificially high percentile.
===============================================================================
*/


/* ============================================================================
Q1 — Executive Business Snapshot
=============================================================================== */

SELECT
    kpi,
    value
FROM executive_kpi_dashboard
ORDER BY CASE kpi
    WHEN 'Total Revenue' THEN 1
    WHEN 'Total Delivered Orders' THEN 2
    WHEN 'Active Customers' THEN 3
    WHEN 'Average Order Value' THEN 4
    WHEN 'Average Customer Lifetime Value' THEN 5
    WHEN 'Repeat Purchase Rate' THEN 6
    WHEN 'Average Delivery Time' THEN 7
    WHEN 'Average Review Score' THEN 8
END;


/* ============================================================================
Q2 — Revenue and Customer Scale
=============================================================================== */

WITH delivered_revenue AS
(
    SELECT
        SUM(op.payment_value) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(DISTINCT c.customer_unique_id) AS active_customers
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS lifetime_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)

SELECT
    dr.total_revenue,
    dr.delivered_orders,
    dr.active_customers,
    ROUND(
        dr.total_revenue / NULLIF(dr.delivered_orders, 0),
        2
    ) AS average_order_value,
    ROUND(
        AVG(cr.lifetime_revenue),
        2
    ) AS average_customer_lifetime_value
FROM delivered_revenue dr
CROSS JOIN customer_revenue cr
GROUP BY
    dr.total_revenue,
    dr.delivered_orders,
    dr.active_customers;


/* ============================================================================
Q3 — Revenue Trend
=============================================================================== */

WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp
        ) AS month,
        SUM(op.payment_value) AS revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
),

revenue_trend AS
(
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_revenue
),

growth AS
(
    SELECT
        month,
        revenue,
        previous_month_revenue,
        revenue - previous_month_revenue AS revenue_change,
        (
            revenue - previous_month_revenue
        ) * 100.0
        / NULLIF(previous_month_revenue, 0)
            AS growth_percentage
    FROM revenue_trend
)

SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(revenue_change, 2) AS revenue_change,
    ROUND(growth_percentage, 2) AS revenue_growth_percentage
FROM growth
ORDER BY month;


/* Q3 — Revenue Trend Summary */

WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp
        ) AS month,
        SUM(op.payment_value) AS revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
),

revenue_trend AS
(
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_revenue
    FROM monthly_revenue
),

growth AS
(
    SELECT
        month,
        revenue,
        ROUND(
            (
                revenue - previous_revenue
            ) * 100.0
            / NULLIF(previous_revenue, 0),
            2
        ) AS growth_percentage
    FROM revenue_trend
)

(
    SELECT
        'Strongest Growth Month' AS metric,
        month,
        revenue,
        growth_percentage
    FROM growth
    WHERE growth_percentage IS NOT NULL
    ORDER BY growth_percentage DESC
    LIMIT 1
)

UNION ALL

(
    SELECT
        'Weakest Growth Month',
        month,
        revenue,
        growth_percentage
    FROM growth
    WHERE growth_percentage IS NOT NULL
    ORDER BY growth_percentage
    LIMIT 1
)

UNION ALL

(
    SELECT
        'Highest Revenue Month',
        month,
        revenue,
        growth_percentage
    FROM growth
    ORDER BY revenue DESC
    LIMIT 1
)

UNION ALL

(
    SELECT
        'Lowest Revenue Month',
        month,
        revenue,
        growth_percentage
    FROM growth
    ORDER BY revenue
    LIMIT 1
);


/* ============================================================================
Q4 — Revenue Growth Consistency
=============================================================================== */

WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp
        ) AS month,
        SUM(op.payment_value) AS revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
),

revenue_growth AS
(
    SELECT
        month,
        revenue,
        revenue - LAG(revenue) OVER (
            ORDER BY month
        ) AS revenue_change
    FROM monthly_revenue
),

growth_classification AS
(
    SELECT
        CASE
            WHEN revenue_change > 0 THEN 'Positive Growth'
            WHEN revenue_change < 0 THEN 'Negative Growth'
            ELSE 'No Growth'
        END AS growth_status
    FROM revenue_growth
    WHERE revenue_change IS NOT NULL
)

SELECT
    growth_status,
    COUNT(*) AS months,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_months
FROM growth_classification
GROUP BY growth_status
ORDER BY months DESC;


/* ============================================================================
Q5 — Seller Revenue Concentration
Seller sales = price + freight_value from delivered order items.
Minimum seller volume = 10 delivered orders.
=============================================================================== */

WITH seller_metrics AS
(
    SELECT
        oi.seller_id AS seller,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(
            oi.price + oi.freight_value
        ) AS sales_value
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
    WHERE delivered_orders >= 10
),

ranked_sellers AS
(
    SELECT
        *,
        RANK() OVER (
            ORDER BY sales_value DESC
        ) AS revenue_rank
    FROM eligible_sellers
),

seller_totals AS
(
    SELECT
        SUM(sales_value) AS total_seller_sales
    FROM eligible_sellers
),

concentration AS
(
    SELECT
        st.total_seller_sales,
        SUM(
            CASE
                WHEN rs.revenue_rank <= 10
                    THEN rs.sales_value
                ELSE 0
            END
        ) AS top_10_sales,
        SUM(
            CASE
                WHEN rs.revenue_rank <= 20
                    THEN rs.sales_value
                ELSE 0
            END
        ) AS top_20_sales
    FROM ranked_sellers rs
    CROSS JOIN seller_totals st
    GROUP BY st.total_seller_sales
)

SELECT
    ROUND(total_seller_sales, 2) AS total_seller_sales,
    ROUND(top_10_sales, 2) AS top_10_sales,
    ROUND(top_20_sales, 2) AS top_20_sales,
    ROUND(
        top_10_sales * 100.0
        / NULLIF(total_seller_sales, 0),
        2
    ) AS top_10_percentage,
    ROUND(
        top_20_sales * 100.0
        / NULLIF(total_seller_sales, 0),
        2
    ) AS top_20_percentage
FROM concentration;


/* ============================================================================
Q6 — Customer Retention Health
=============================================================================== */

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(DISTINCT o.order_id) AS delivered_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

customer_classification AS
(
    SELECT
        CASE
            WHEN delivered_orders = 1
                THEN 'One-Time Customer'
            WHEN delivered_orders > 1
                THEN 'Repeat Customer'
        END AS customer_type
    FROM customer_orders
)

SELECT
    customer_type,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_customers
FROM customer_classification
GROUP BY customer_type
ORDER BY customers DESC;


/* ============================================================================
Q7 — Customer Value Concentration
Historical CLV only; not predictive.
=============================================================================== */

WITH customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,
        SUM(op.payment_value) AS lifetime_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

customer_statistics AS
(
    SELECT
        AVG(lifetime_revenue) AS average_clv,
        PERCENTILE_CONT(0.50)
            WITHIN GROUP (
                ORDER BY lifetime_revenue
            )::numeric AS median_clv,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (
                ORDER BY lifetime_revenue
            )::numeric AS third_quartile_clv
    FROM customer_revenue
),

customer_ranked AS
(
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY lifetime_revenue DESC
        ) AS revenue_rank,
        COUNT(*) OVER () AS total_customers
    FROM customer_revenue
),

top_customer_revenue AS
(
    SELECT
        SUM(lifetime_revenue) AS top_10_revenue
    FROM customer_ranked
    WHERE revenue_rank <= CEIL(total_customers * 0.10)
),

total_revenue AS
(
    SELECT
        SUM(lifetime_revenue) AS total_revenue
    FROM customer_revenue
)

SELECT
    ROUND(cs.average_clv, 2) AS average_clv,
    ROUND(cs.median_clv, 2) AS median_clv,
    ROUND(cs.third_quartile_clv, 2) AS third_quartile_clv,
    ROUND(tcr.top_10_revenue, 2) AS top_10_customer_revenue,
    ROUND(
        tcr.top_10_revenue * 100.0
        / NULLIF(tr.total_revenue, 0),
        2
    ) AS top_10_revenue_percentage
FROM customer_statistics cs
CROSS JOIN top_customer_revenue tcr
CROSS JOIN total_revenue tr;


/* ============================================================================
Q8 — Customer Growth vs Customer Retention
=============================================================================== */

WITH monthly_metrics AS
(
    SELECT
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp
        ) AS month,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(
            DISTINCT c.customer_unique_id
        ) AS active_customers,
        SUM(op.payment_value) AS revenue
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
),

monthly_comparison AS
(
    SELECT
        *,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_revenue,
        LAG(active_customers) OVER (
            ORDER BY month
        ) AS previous_customers
    FROM monthly_metrics
)

SELECT
    month,
    revenue,
    active_customers,
    CASE
        WHEN revenue > previous_revenue
         AND active_customers > previous_customers
            THEN 'Revenue Up / Customers Up'
        WHEN revenue > previous_revenue
         AND active_customers < previous_customers
            THEN 'Revenue Up / Customers Down'
        WHEN revenue < previous_revenue
         AND active_customers > previous_customers
            THEN 'Revenue Down / Customers Up'
        WHEN revenue < previous_revenue
         AND active_customers < previous_customers
            THEN 'Revenue Down / Customers Down'
        ELSE 'No Meaningful Change'
    END AS business_pattern
FROM monthly_comparison
WHERE previous_revenue IS NOT NULL
ORDER BY month;


/* ============================================================================
Q9 — Delivery Performance
=============================================================================== */

WITH delivery_metrics AS
(
    SELECT
        o.order_id,
        EXTRACT(
            EPOCH FROM (
                o.order_delivered_customer_date
                - o.order_purchase_timestamp
            )
        ) / 86400 AS delivery_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_purchase_timestamp IS NOT NULL
)

SELECT
    COUNT(DISTINCT order_id) AS delivered_orders,
    ROUND(AVG(delivery_days)::numeric, 2)
        AS average_delivery_days,
    ROUND(
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (
            ORDER BY delivery_days
        )::numeric,
        2
    ) AS median_delivery_days,
    ROUND(
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (
            ORDER BY delivery_days
        )::numeric,
        2
    ) AS third_quartile_delivery_days,
    ROUND(MIN(delivery_days)::numeric, 2)
        AS minimum_delivery_days,
    ROUND(MAX(delivery_days)::numeric, 2)
        AS maximum_delivery_days
FROM delivery_metrics;


/* ============================================================================
Q10 — Delivery Performance by State
=============================================================================== */

SELECT
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    o.order_delivered_customer_date
                    - o.order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS average_delivery_days
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days DESC;


/* ============================================================================
Q11 — Delivery Performance vs Customer Satisfaction

Reviews are order-level. One review summary row is created per order before
joining to delivery bands.
=============================================================================== */

WITH order_delivery AS
(
    SELECT
        o.order_id,
        EXTRACT(
            EPOCH FROM (
                o.order_delivered_customer_date
                - o.order_purchase_timestamp
            )
        ) / 86400 AS delivery_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
),

delivery_bands AS
(
    SELECT
        order_id,
        delivery_days,
        CASE
            WHEN delivery_days < 5
                THEN 'Under 5 Days'
            WHEN delivery_days < 10
                THEN '5-10 Days'
            WHEN delivery_days < 15
                THEN '10-15 Days'
            ELSE '15+ Days'
        END AS delivery_band
    FROM order_delivery
),

review_summary AS
(
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
)

SELECT
    db.delivery_band,
    COUNT(DISTINCT db.order_id) AS orders,
    ROUND(AVG(db.delivery_days), 2)
        AS average_delivery_days,
    ROUND(AVG(rs.review_score), 2)
        AS average_review_score
FROM delivery_bands db
JOIN review_summary rs
    ON db.order_id = rs.order_id
GROUP BY db.delivery_band
ORDER BY MIN(db.delivery_days);


/* ============================================================================
Q12 — Seller Performance Distribution
Seller score:
    Revenue 35%
    Orders 25%
    Reviews 20%
    Delivery 20%

Seller reviews are order-level reviews attributed to sellers appearing in the
reviewed order.
=============================================================================== */

WITH seller_sales AS
(
    SELECT
        oi.seller_id AS seller,
        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,
        COUNT(DISTINCT o.order_id) AS orders_fulfilled
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

seller_reviews AS
(
    SELECT
        seller_id AS seller,
        AVG(review_score) AS average_review_score
    FROM
    (
        SELECT DISTINCT
            oi.seller_id,
            oi.order_id
        FROM order_items oi
        JOIN orders o
            ON oi.order_id = o.order_id
        WHERE o.order_status = 'delivered'
    ) seller_orders
    JOIN order_reviews
        ON seller_orders.order_id = order_reviews.order_id
    GROUP BY seller_id
),

seller_delivery AS
(
    SELECT
        oi.seller_id AS seller,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                    THEN o.order_id
            END
        ) AS orders_on_time
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

seller_summary AS
(
    SELECT
        ss.seller,
        ss.sales_value,
        ss.orders_fulfilled,
        sr.average_review_score,
        sd.orders_on_time * 100.0
        / NULLIF(sd.delivered_orders, 0)
            AS on_time_delivery_rate
    FROM seller_sales ss
    JOIN seller_reviews sr
        ON ss.seller = sr.seller
    JOIN seller_delivery sd
        ON ss.seller = sd.seller
),

seller_scores AS
(
    SELECT
        *,
        NTILE(100) OVER (
            ORDER BY sales_value
        ) AS revenue_score,
        NTILE(100) OVER (
            ORDER BY orders_fulfilled
        ) AS orders_score,
        (average_review_score / 5.0) * 100
            AS review_score,
        on_time_delivery_rate AS delivery_score
    FROM seller_summary
),

weighted_scores AS
(
    SELECT
        *,
        (
            revenue_score * 0.35
            + orders_score * 0.25
            + review_score * 0.20
            + delivery_score * 0.20
        ) AS seller_performance_score
    FROM seller_scores
),

seller_classification AS
(
    SELECT
        *,
        CASE
            WHEN seller_performance_score >= 90
                THEN 'Elite Seller'
            WHEN seller_performance_score >= 75
                THEN 'High Performer'
            WHEN seller_performance_score >= 60
                THEN 'Strong Performer'
            WHEN seller_performance_score >= 45
                THEN 'Average Performer'
            ELSE 'Needs Improvement'
        END AS seller_category
    FROM weighted_scores
)

SELECT
    seller_category,
    COUNT(*) AS sellers,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS seller_percentage
FROM seller_classification
GROUP BY seller_category
ORDER BY CASE seller_category
    WHEN 'Elite Seller' THEN 1
    WHEN 'High Performer' THEN 2
    WHEN 'Strong Performer' THEN 3
    WHEN 'Average Performer' THEN 4
    WHEN 'Needs Improvement' THEN 5
END;


/* ============================================================================
Q13 — Seller Performance vs Revenue Contribution

Seller-attributed sales:
    order_items.price + order_items.freight_value

This is deliberately different from marketplace revenue based on
order_payments.payment_value.

Review limitation:
Reviews belong to orders rather than sellers. Where an order contains multiple
sellers, the order-level review is attributed to each seller in that order.
=============================================================================== */

WITH seller_metrics AS
(
    SELECT
        oi.seller_id AS seller,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(
            oi.price + oi.freight_value
        ) AS sales_value
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

seller_reviews AS
(
    SELECT
        seller_id AS seller,
        AVG(review_score) AS average_review_score
    FROM
    (
        SELECT DISTINCT
            oi.seller_id,
            oi.order_id
        FROM order_items oi
        JOIN orders o
            ON oi.order_id = o.order_id
        WHERE o.order_status = 'delivered'
    ) seller_orders
    JOIN order_reviews
        ON seller_orders.order_id = order_reviews.order_id
    GROUP BY seller_id
),

seller_delivery AS
(
    SELECT
        oi.seller_id AS seller,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                    THEN o.order_id
            END
        ) AS on_time_orders
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

seller_summary AS
(
    SELECT
        sm.seller,
        sm.sales_value,
        sm.delivered_orders,
        sr.average_review_score,
        sd.on_time_orders * 100.0
        / NULLIF(sd.delivered_orders, 0)
            AS on_time_delivery_rate
    FROM seller_metrics sm
    LEFT JOIN seller_reviews sr
        ON sm.seller = sr.seller
    LEFT JOIN seller_delivery sd
        ON sm.seller = sd.seller
),

seller_scores AS
(
    SELECT
        *,
        PERCENT_RANK() OVER (
            ORDER BY sales_value
        ) * 100 AS revenue_percentile,
        PERCENT_RANK() OVER (
            ORDER BY delivered_orders
        ) * 100 AS order_percentile,
        CASE
            WHEN average_review_score IS NOT NULL
                THEN (average_review_score / 5.0) * 100
        END AS review_score,
        on_time_delivery_rate AS delivery_score
    FROM seller_summary
),

weighted_scores AS
(
    SELECT
        *,
        (
            revenue_percentile * 0.35
            + order_percentile * 0.25
            + COALESCE(review_score, 0) * 0.20
            + COALESCE(delivery_score, 0) * 0.20
        ) AS seller_performance_score
    FROM seller_scores
)

SELECT
    seller,
    sales_value,
    delivered_orders,
    ROUND(average_review_score, 2)
        AS average_review_score,
    ROUND(on_time_delivery_rate, 2)
        AS on_time_delivery_rate,
    ROUND(seller_performance_score, 2)
        AS seller_performance_score,
    CASE
        WHEN seller_performance_score >= 90
            THEN 'Elite Seller'
        WHEN seller_performance_score >= 75
            THEN 'High Performer'
        WHEN seller_performance_score >= 60
            THEN 'Strong Performer'
        WHEN seller_performance_score >= 45
            THEN 'Average Performer'
        ELSE 'Needs Improvement'
    END AS seller_category
FROM weighted_scores
ORDER BY seller_performance_score DESC;


/* ============================================================================
Q14 — Seller Risk
=============================================================================== */

WITH seller_metrics AS
(
    SELECT
        oi.seller_id AS seller,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(
            oi.price + oi.freight_value
        ) AS sales_value
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

seller_reviews AS
(
    SELECT
        oi.seller_id AS seller,
        AVG(orv.review_score) AS average_review_score
    FROM
    (
        SELECT DISTINCT
            seller_id,
            order_id
        FROM order_items
    ) oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN order_reviews orv
        ON o.order_id = orv.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

seller_delivery AS
(
    SELECT
        oi.seller_id AS seller,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(
            DISTINCT CASE
                WHEN o.order_delivered_customer_date
                     <= o.order_estimated_delivery_date
                    THEN o.order_id
            END
        ) AS on_time_orders
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

seller_summary AS
(
    SELECT
        sm.seller,
        sm.sales_value,
        sm.delivered_orders,
        sr.average_review_score,
        ROUND(
            sd.on_time_orders * 100.0
            / NULLIF(sd.delivered_orders, 0),
            2
        ) AS on_time_delivery_rate
    FROM seller_metrics sm
    JOIN seller_reviews sr
        ON sm.seller = sr.seller
    JOIN seller_delivery sd
        ON sm.seller = sd.seller
),

thresholds AS
(
    SELECT
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (
                ORDER BY sales_value
            ) AS high_revenue_threshold,
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (
                ORDER BY average_review_score
            ) AS poor_review_threshold,
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (
                ORDER BY on_time_delivery_rate
            ) AS poor_delivery_threshold,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (
                ORDER BY delivered_orders
            ) AS high_volume_threshold
    FROM seller_summary
)

SELECT
    ss.*,
    CASE
        WHEN ss.sales_value >= t.high_revenue_threshold
         AND ss.average_review_score <= t.poor_review_threshold
         AND ss.on_time_delivery_rate <= t.poor_delivery_threshold
         AND ss.delivered_orders >= t.high_volume_threshold
            THEN 'High Risk'

        WHEN ss.sales_value >= t.high_revenue_threshold
         AND (
                ss.average_review_score <= t.poor_review_threshold
                OR ss.on_time_delivery_rate <= t.poor_delivery_threshold
             )
            THEN 'Moderate Risk'

        ELSE 'Lower Risk'
    END AS seller_risk_level
FROM seller_summary ss
CROSS JOIN thresholds t
ORDER BY
    CASE
        WHEN ss.sales_value >= t.high_revenue_threshold
         AND ss.average_review_score <= t.poor_review_threshold
         AND ss.on_time_delivery_rate <= t.poor_delivery_threshold
         AND ss.delivered_orders >= t.high_volume_threshold
            THEN 1
        WHEN ss.sales_value >= t.high_revenue_threshold
         AND (
                ss.average_review_score <= t.poor_review_threshold
                OR ss.on_time_delivery_rate <= t.poor_delivery_threshold
             )
            THEN 2
        ELSE 3
    END,
    ss.sales_value DESC;


/* ============================================================================
Q15 — Product Category Performance
=============================================================================== */

WITH category_sales AS
(
    SELECT
        p.product_category_name AS category,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(
            oi.price + oi.freight_value
        ) AS sales_value,
        SUM(oi.freight_value) AS freight_value
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.product_category_name
),

category_reviews AS
(
    SELECT
        p.product_category_name AS category,
        AVG(orv.review_score) AS average_review_score
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN order_reviews orv
        ON oi.order_id = orv.order_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.product_category_name
),

category_summary AS
(
    SELECT
        cs.category,
        cs.delivered_orders,
        cs.sales_value,
        cs.freight_value,
        cr.average_review_score
    FROM category_sales cs
    LEFT JOIN category_reviews cr
        ON cs.category = cr.category
),

category_thresholds AS
(
    SELECT
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (
                ORDER BY sales_value
            ) AS sales_p75,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (
                ORDER BY delivered_orders
            ) AS orders_p75,
        PERCENTILE_CONT(0.50)
            WITHIN GROUP (
                ORDER BY sales_value
            ) AS sales_median,
        PERCENTILE_CONT(0.50)
            WITHIN GROUP (
                ORDER BY delivered_orders
            ) AS orders_median
    FROM category_summary
)

SELECT
    cs.category,
    cs.delivered_orders,
    ROUND(cs.sales_value, 2) AS sales_value,
    ROUND(cs.freight_value, 2) AS freight_value,
    ROUND(
        cs.freight_value * 100.0
        / NULLIF(cs.sales_value, 0),
        2
    ) AS freight_burden_percentage,
    ROUND(cs.average_review_score, 2)
        AS average_review_score,
    CASE
        WHEN cs.sales_value >= ct.sales_p75
         AND cs.delivered_orders >= ct.orders_p75
         AND cs.average_review_score >= 4
            THEN 'Commercially Strong'

        WHEN cs.delivered_orders >= ct.orders_p75
         AND cs.sales_value < ct.sales_median
            THEN 'High Demand / Lower Value'

        WHEN cs.sales_value >= ct.sales_p75
         AND cs.delivered_orders < ct.orders_median
            THEN 'High Value / Lower Demand'

        ELSE 'Other'
    END AS category_classification
FROM category_summary cs
CROSS JOIN category_thresholds ct
ORDER BY cs.sales_value DESC;


/* ============================================================================
Q16 — Regional Revenue Opportunities
=============================================================================== */

WITH state_metrics AS
(
    SELECT
        c.customer_state AS state,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(
            DISTINCT c.customer_unique_id
        ) AS active_customers,
        SUM(op.payment_value) AS revenue,
        SUM(op.payment_value)
        / NULLIF(COUNT(DISTINCT o.order_id), 0)
            AS average_order_value,
        AVG(
            EXTRACT(
                EPOCH FROM (
                    o.order_delivered_customer_date
                    - o.order_purchase_timestamp
                )
            ) / 86400
        ) AS average_delivery_days
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state
),

state_scores AS
(
    SELECT
        *,
        PERCENT_RANK() OVER (
            ORDER BY revenue
        ) * 100 AS revenue_percentile,
        PERCENT_RANK() OVER (
            ORDER BY active_customers
        ) * 100 AS customer_percentile,
        PERCENT_RANK() OVER (
            ORDER BY average_order_value
        ) * 100 AS aov_percentile,
        PERCENT_RANK() OVER (
            ORDER BY average_delivery_days DESC
        ) * 100 AS delivery_risk_percentile
    FROM state_metrics
)

SELECT
    state,
    ROUND(revenue, 2) AS revenue,
    delivered_orders,
    active_customers,
    ROUND(average_order_value, 2)
        AS average_order_value,
    ROUND(average_delivery_days, 2)
        AS average_delivery_days,
    ROUND(
        (
            revenue_percentile
            + customer_percentile
            + aov_percentile
            + delivery_risk_percentile
        ) / 4.0,
        2
    ) AS regional_opportunity_indicator
FROM state_scores
ORDER BY regional_opportunity_indicator DESC;


/* ============================================================================
Q17 — Customer Re-engagement Opportunity
=============================================================================== */

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id AS customer,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(op.payment_value) AS lifetime_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

customer_classification AS
(
    SELECT
        *,
        CASE
            WHEN delivered_orders = 1
                THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM customer_orders
),

summary AS
(
    SELECT
        customer_type,
        COUNT(*) AS customers,
        SUM(lifetime_revenue) AS revenue,
        AVG(lifetime_revenue) AS average_customer_value
    FROM customer_classification
    GROUP BY customer_type
)

SELECT
    customer_type,
    customers,
    ROUND(
        customers * 100.0
        / SUM(customers) OVER (),
        2
    ) AS customer_percentage,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        revenue * 100.0
        / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage,
    ROUND(average_customer_value, 2)
        AS average_customer_value
FROM summary
ORDER BY customers DESC;




/* ============================================================================
Q18 — Seller Expansion Opportunity

Consumes the authoritative revenue opportunity dashboard.
The dashboard already applies seller activity eligibility (>= 10 orders), so
the eligibility condition is not duplicated here.
=============================================================================== */

SELECT
    entity_id AS seller,
    activity,
    sales_value,
    revenue_opportunity_score,
    customer_acceptance_score,
    operational_readiness_score,
    market_activity_score
FROM revenue_opportunity_dashboard
WHERE entity_type = 'Seller'
  AND revenue_opportunity_score >= 60
ORDER BY
    revenue_opportunity_score DESC,
    sales_value ASC;


/* ============================================================================
Q19 — Major Business Risk Indicators
=============================================================================== */

WITH customer_metrics AS
(
    SELECT
        COUNT(*) AS total_customers,
        COUNT(
            CASE
                WHEN delivered_orders = 1
                    THEN 1
            END
        ) AS one_time_customers
    FROM
    (
        SELECT
            c.customer_unique_id,
            COUNT(DISTINCT o.order_id) AS delivered_orders
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_unique_id
    ) x
),

seller_revenue AS
(
    SELECT
        oi.seller_id AS seller,
        SUM(
            oi.price + oi.freight_value
        ) AS sales_value
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

seller_concentration AS
(
    SELECT
        SUM(sales_value) AS total_sales,
        SUM(
            CASE
                WHEN revenue_rank <= 10
                    THEN sales_value
                ELSE 0
            END
        ) AS top_10_sales
    FROM
    (
        SELECT
            *,
            RANK() OVER (
                ORDER BY sales_value DESC
            ) AS revenue_rank
        FROM seller_revenue
    ) x
),

delivery_metrics AS
(
    SELECT
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400
        ) AS average_delivery_days
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
),

satisfaction_metrics AS
(
    SELECT
        AVG(review_score) AS average_review_score
    FROM order_reviews
)

SELECT
    cm.total_customers,
    cm.one_time_customers,
    ROUND(
        cm.one_time_customers * 100.0
        / NULLIF(cm.total_customers, 0),
        2
    ) AS one_time_customer_percentage,
    ROUND(
        sc.top_10_sales * 100.0
        / NULLIF(sc.total_sales, 0),
        2
    ) AS top_10_seller_sales_percentage,
    ROUND(dm.average_delivery_days, 2)
        AS average_delivery_days,
    ROUND(sm.average_review_score, 2)
        AS average_review_score
FROM customer_metrics cm
CROSS JOIN seller_concentration sc
CROSS JOIN delivery_metrics dm
CROSS JOIN satisfaction_metrics sm;


/* ============================================================================
Q20 — Risk Prioritisation
=============================================================================== */

WITH risk_metrics AS
(
    SELECT
        COUNT(*) FILTER (
            WHERE orders = 1
        ) * 100.0
        / NULLIF(COUNT(*), 0)
            AS one_time_rate
    FROM
    (
        SELECT
            c.customer_unique_id,
            COUNT(DISTINCT o.order_id) AS orders
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_unique_id
    ) x
)

SELECT
    'Customer Retention' AS risk,
    ROUND(one_time_rate, 2) AS evidence_value,
    CASE
        WHEN one_time_rate >= 50 THEN 'High'
        WHEN one_time_rate >= 30 THEN 'Medium'
        ELSE 'Low'
    END AS business_impact,
    CASE
        WHEN one_time_rate >= 50 THEN 'High'
        WHEN one_time_rate >= 30 THEN 'Medium'
        ELSE 'Low'
    END AS priority
FROM risk_metrics;


/* ============================================================================
Q21 — Three Strongest Business Findings
Candidate Evidence Dataset

This query intentionally generates candidate evidence. SQL does not
mechanically decide which three findings are "strongest"; that final judgement
is an analytical/management interpretation step.
=============================================================================== */

WITH evidence AS
(
    SELECT
        'Total Revenue' AS finding,
        total_revenue AS evidence_value,
        'Business Scale' AS evidence_type
    FROM
    (
        SELECT SUM(op.payment_value) AS total_revenue
        FROM orders o
        JOIN order_payments op
            ON o.order_id = op.order_id
        WHERE o.order_status = 'delivered'
    ) x

    UNION ALL

    SELECT
        'Average Historical CLV',
        average_clv,
        'Customer Value'
    FROM
    (
        SELECT
            AVG(lifetime_revenue) AS average_clv
        FROM
        (
            SELECT
                c.customer_unique_id,
                SUM(op.payment_value) AS lifetime_revenue
            FROM customers c
            JOIN orders o
                ON c.customer_id = o.customer_id
            JOIN order_payments op
                ON o.order_id = op.order_id
            WHERE o.order_status = 'delivered'
            GROUP BY c.customer_unique_id
        ) x
    ) y

    UNION ALL

    SELECT
        'Average Review Score',
        AVG(review_score),
        'Customer Satisfaction'
    FROM order_reviews

    UNION ALL

    SELECT
        'Very High Opportunity Sellers',
        COUNT(*),
        'Growth Opportunity'
    FROM revenue_opportunity_dashboard
    WHERE entity_type = 'Seller'
      AND revenue_opportunity_score >= 80

    UNION ALL

    SELECT
        'Very High Opportunity Categories',
        COUNT(*),
        'Growth Opportunity'
    FROM revenue_opportunity_dashboard
    WHERE entity_type = 'Product Category'
      AND revenue_opportunity_score >= 80
)

SELECT
    finding,
    ROUND(evidence_value::numeric, 2) AS evidence_value,
    evidence_type
FROM evidence;


/* ============================================================================
Q22 — Weakness Evidence
=============================================================================== */

WITH customer_retention AS
(
    SELECT
        COUNT(*) AS customers,
        COUNT(*) FILTER (WHERE orders = 1) AS one_time_customers
    FROM
    (
        SELECT
            c.customer_unique_id,
            COUNT(DISTINCT o.order_id) AS orders
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_unique_id
    ) x
),
seller_concentration AS
(
    SELECT
        SUM(
            CASE
                WHEN revenue_rank <= 10 THEN sales_value
                ELSE 0
            END
        ) * 100.0
        / NULLIF(SUM(sales_value), 0)
            AS top_10_seller_sales_percentage
    FROM
    (
        SELECT
            oi.seller_id AS seller,
            SUM(oi.price + oi.freight_value) AS sales_value,
            RANK() OVER (
                ORDER BY SUM(oi.price + oi.freight_value) DESC
            ) AS revenue_rank
        FROM order_items oi
        JOIN orders o ON oi.order_id = o.order_id
        WHERE o.order_status = 'delivered'
        GROUP BY oi.seller_id
    ) x
)
SELECT
    'Customer Retention' AS area,
    'One-time customer percentage' AS metric,
    ROUND(
        one_time_customers * 100.0
        / NULLIF(customers, 0),
        2
    ) AS metric_value
FROM customer_retention

UNION ALL

SELECT
    'Seller Concentration',
    'Top 10 seller sales percentage',
    ROUND(top_10_seller_sales_percentage, 2)
FROM seller_concentration;


/* ============================================================================
Q23 — Strongest Growth Opportunities
=============================================================================== */

SELECT
    entity_type,
    entity_id,
    activity,
    sales_value,
    revenue_headroom_score,
    customer_acceptance_score,
    operational_readiness_score,
    market_activity_score,
    revenue_opportunity_score,
    opportunity_tier
FROM revenue_opportunity_dashboard
WHERE revenue_opportunity_score >= 60
ORDER BY
    revenue_opportunity_score DESC,
    sales_value ASC;


/* ============================================================================
Q24 — Management Action Evidence
=============================================================================== */

WITH customer_retention AS
(
    SELECT
        COUNT(*) AS customers,
        COUNT(
            CASE
                WHEN delivered_orders = 1
                    THEN 1
            END
        ) AS one_time_customers
    FROM
    (
        SELECT
            c.customer_unique_id,
            COUNT(DISTINCT o.order_id) AS delivered_orders
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_unique_id
    ) x
),

seller_concentration AS
(
    SELECT
        SUM(
            CASE
                WHEN revenue_rank <= 10
                    THEN sales_value
                ELSE 0
            END
        ) * 100.0
        / NULLIF(SUM(sales_value), 0)
            AS top_10_seller_percentage
    FROM
    (
        SELECT
            oi.seller_id AS seller,
            SUM(
                oi.price + oi.freight_value
            ) AS sales_value,
            RANK() OVER (
                ORDER BY SUM(
                    oi.price + oi.freight_value
                ) DESC
            ) AS revenue_rank
        FROM order_items oi
        JOIN orders o
            ON oi.order_id = o.order_id
        WHERE o.order_status = 'delivered'
        GROUP BY oi.seller_id
    ) x
)

SELECT
    'Customer Retention' AS issue,
    ROUND(
        one_time_customers * 100.0
        / NULLIF(customers, 0),
        2
    ) AS evidence_value
FROM customer_retention

UNION ALL

SELECT
    'Seller Concentration',
    ROUND(top_10_seller_percentage, 2)
FROM seller_concentration;




/* ============================================================================
Q25 — Final Executive Business Review Dataset

Two dimensions:
1. Business health — executive KPI evidence
2. Growth opportunity — opportunity dashboard evidence

The dataset is evidence for executive interpretation. It does not replace the
analyst's judgement.
=============================================================================== */

WITH business_health AS
(
    SELECT
        kpi,
        value
    FROM executive_kpi_dashboard
),

opportunity_summary AS
(
    SELECT
        entity_type,
        COUNT(*) AS entities,
        ROUND(
            AVG(revenue_opportunity_score),
            2
        ) AS average_opportunity_score,
        ROUND(
            MAX(revenue_opportunity_score),
            2
        ) AS highest_opportunity_score
    FROM revenue_opportunity_dashboard
    GROUP BY entity_type
)

SELECT
    'Business Health' AS evidence_group,
    kpi AS metric,
    value AS evidence_value,
    NULL::text AS entity_type,
    NULL::numeric AS entity_count,
    NULL::numeric AS average_opportunity_score,
    NULL::numeric AS highest_opportunity_score
FROM business_health

UNION ALL

SELECT
    'Growth Opportunity',
    CASE WHEN entity_type = 'Seller' THEN 'Eligible sellers' WHEN entity_type = 'Product Category' THEN 'Eligible product categories' ELSE 'Eligible entities' END,
    NULL,
    entity_type,
    entities::numeric,
    average_opportunity_score,
    highest_opportunity_score
FROM opportunity_summary
ORDER BY evidence_group, metric;
