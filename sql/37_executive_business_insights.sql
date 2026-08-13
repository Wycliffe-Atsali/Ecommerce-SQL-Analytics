/*
===============================================================================
Investigation 43 — Executive Business Insights & Strategic Priorities
Final Evidence SQL
===============================================================================

Purpose
-------
Final retained SQL supporting the executive insights for Investigation 43.

Definitions
-----------
- Delivered orders only unless otherwise stated.
- Customer grain: customer_unique_id.
- Revenue: order_payments.payment_value.
- Seller revenue: payment_value associated with seller order_items.
- Delivery time: delivered_customer_date - order_purchase_timestamp.

Interpretation notes
--------------------
- Historical customer revenue is realised revenue, not predictive CLV.
- Delivery/review results show association, not causation.
- Seller concentration is descriptive and requires a benchmark before being
  labelled a risk.
- Opportunity scores are relative prioritisation indicators, not forecasts.
===============================================================================
*/

/* Q01 — Executive business snapshot */
WITH delivered_orders AS (
    SELECT order_id, customer_id, order_purchase_timestamp,
           order_delivered_customer_date
    FROM orders
    WHERE order_status = 'delivered'
),
customer_revenue AS (
    SELECT c.customer_unique_id, SUM(op.payment_value) AS customer_revenue
    FROM delivered_orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_payments op ON op.order_id = o.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    COUNT(DISTINCT c.customer_unique_id) AS active_customers,
    ROUND(SUM(op.payment_value), 2) AS total_revenue,
    ROUND(SUM(op.payment_value) /
          NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS average_order_value,
    ROUND(AVG(cr.customer_revenue), 2) AS avg_historical_customer_revenue,
    ROUND(AVG(ore.review_score), 2) AS avg_review_score,
    ROUND(AVG(EXTRACT(EPOCH FROM
        (o.order_delivered_customer_date - o.order_purchase_timestamp))
        / 86400)::numeric, 2) AS avg_delivery_days
FROM delivered_orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_payments op ON op.order_id = o.order_id
JOIN customer_revenue cr ON cr.customer_unique_id = c.customer_unique_id
LEFT JOIN order_reviews ore ON ore.order_id = o.order_id;


/* Q02 — One-time versus repeat customers */
WITH customer_orders AS (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE WHEN order_count = 1 THEN 'One-time customer'
         ELSE 'Repeat customer' END AS customer_type,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS customer_share_pct
FROM customer_orders
GROUP BY 1
ORDER BY customers DESC;


/* Q03 — Revenue contribution by customer type */
WITH customer_summary AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(op.payment_value) AS customer_revenue
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_payments op ON op.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE WHEN order_count = 1 THEN 'One-time customer'
         ELSE 'Repeat customer' END AS customer_type,
    COUNT(*) AS customers,
    ROUND(SUM(customer_revenue), 2) AS historical_revenue,
    ROUND(100.0 * SUM(customer_revenue) /
          SUM(SUM(customer_revenue)) OVER (), 2) AS revenue_share_pct,
    ROUND(AVG(customer_revenue), 2) AS avg_revenue_per_customer
FROM customer_summary
GROUP BY 1
ORDER BY historical_revenue DESC;


/* Q04 — Customer-value distribution and top-10% concentration */
WITH customer_revenue AS (
    SELECT c.customer_unique_id, SUM(op.payment_value) AS customer_revenue
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_payments op ON op.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
ranked AS (
    SELECT *,
           NTILE(10) OVER (ORDER BY customer_revenue DESC) AS decile
    FROM customer_revenue
)
SELECT
    ROUND(PERCENTILE_CONT(0.50)
          WITHIN GROUP (ORDER BY customer_revenue)::numeric, 2) AS median_revenue,
    ROUND(AVG(customer_revenue)::numeric, 2) AS average_revenue,
    ROUND(PERCENTILE_CONT(0.75)
          WITHIN GROUP (ORDER BY customer_revenue)::numeric, 2) AS q3_revenue,
    ROUND(100.0 * SUM(CASE WHEN decile = 1 THEN customer_revenue ELSE 0 END)
          / SUM(customer_revenue), 2) AS top_10_revenue_share_pct
FROM ranked;


/* Q05 — Monthly revenue/customer growth and business pattern */
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month,
        SUM(op.payment_value) AS revenue,
        COUNT(DISTINCT c.customer_unique_id) AS active_customers
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_payments op ON op.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
growth AS (
    SELECT *,
        LAG(revenue) OVER (ORDER BY month) AS previous_revenue,
        LAG(active_customers) OVER (ORDER BY month) AS previous_customers
    FROM monthly
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    active_customers,
    ROUND(100.0 * (revenue - previous_revenue) /
          NULLIF(previous_revenue, 0), 2) AS revenue_growth_pct,
    ROUND(100.0 * (active_customers - previous_customers) /
          NULLIF(previous_customers, 0), 2) AS customer_growth_pct,
    CASE
        WHEN revenue > previous_revenue AND active_customers > previous_customers
            THEN 'Revenue Up / Customers Up'
        WHEN revenue < previous_revenue AND active_customers < previous_customers
            THEN 'Revenue Down / Customers Down'
        WHEN revenue > previous_revenue AND active_customers < previous_customers
            THEN 'Revenue Up / Customers Down'
        WHEN revenue < previous_revenue AND active_customers > previous_customers
            THEN 'Revenue Down / Customers Up'
    END AS business_pattern
FROM growth
WHERE previous_revenue IS NOT NULL
ORDER BY month;


/* Q06 — Growth consistency summary */
WITH monthly AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month,
           SUM(op.payment_value) AS revenue
    FROM orders o
    JOIN order_payments op ON op.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
growth AS (
    SELECT month, revenue,
           LAG(revenue) OVER (ORDER BY month) AS previous_revenue
    FROM monthly
)
SELECT
    COUNT(*) AS month_over_month_periods,
    COUNT(*) FILTER (WHERE revenue > previous_revenue) AS positive_periods,
    COUNT(*) FILTER (WHERE revenue < previous_revenue) AS negative_periods,
    ROUND(100.0 * COUNT(*) FILTER (WHERE revenue > previous_revenue) /
          NULLIF(COUNT(*), 0), 1) AS positive_growth_share_pct
FROM growth
WHERE previous_revenue IS NOT NULL;


/* Q07 — Revenue/customer movement pattern counts */
WITH monthly AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month,
           SUM(op.payment_value) AS revenue,
           COUNT(DISTINCT c.customer_unique_id) AS customers
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_payments op ON op.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
x AS (
    SELECT *,
           LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
           LAG(customers) OVER (ORDER BY month) AS prev_customers
    FROM monthly
)
SELECT
    CASE
        WHEN revenue > prev_revenue AND customers > prev_customers
            THEN 'Revenue Up / Customers Up'
        WHEN revenue < prev_revenue AND customers < prev_customers
            THEN 'Revenue Down / Customers Down'
        WHEN revenue > prev_revenue AND customers < prev_customers
            THEN 'Revenue Up / Customers Down'
        WHEN revenue < prev_revenue AND customers > prev_customers
            THEN 'Revenue Down / Customers Up'
    END AS business_pattern,
    COUNT(*) AS periods
FROM x
WHERE prev_revenue IS NOT NULL AND prev_customers IS NOT NULL
GROUP BY 1
ORDER BY periods DESC;


/* Q08 — Delivery-time distribution */
WITH d AS (
    SELECT EXTRACT(EPOCH FROM
        (order_delivered_customer_date - order_purchase_timestamp))
        / 86400.0 AS delivery_days
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
)
SELECT
    COUNT(*) AS delivered_orders,
    ROUND(MIN(delivery_days)::numeric, 2) AS min_days,
    ROUND(AVG(delivery_days)::numeric, 2) AS avg_days,
    ROUND(PERCENTILE_CONT(0.50)
          WITHIN GROUP (ORDER BY delivery_days)::numeric, 2) AS median_days,
    ROUND(PERCENTILE_CONT(0.75)
          WITHIN GROUP (ORDER BY delivery_days)::numeric, 2) AS q3_days,
    ROUND(MAX(delivery_days)::numeric, 2) AS max_days
FROM d;


/* Q09 — Slowest states by delivery time */
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(AVG(EXTRACT(EPOCH FROM
        (o.order_delivered_customer_date - o.order_purchase_timestamp))
        / 864)::numeric, 2) AS avg_delivery_days
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 100
ORDER BY avg_delivery_days DESC;


/* Q10 — Delivery band versus review score */
WITH bands AS (
    SELECT
        o.order_id,
        CASE
            WHEN EXTRACT(EPOCH FROM
                (o.order_delivered_customer_date - o.order_purchase_timestamp))
                / 864 < 5 THEN 'Under 5 days'
            WHEN EXTRACT(EPOCH FROM
                (o.order_delivered_customer_date - o.order_purchase_timestamp))
                / 864 < 10 THEN '5–10 days'
            WHEN EXTRACT(EPOCH FROM
                (o.order_delivered_customer_date - o.order_purchase_timestamp))
                / 864 < 15 THEN '10–15 days'
            ELSE '15+ days'
        END AS delivery_band
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    b.delivery_band,
    COUNT(DISTINCT b.order_id) AS orders,
    ROUND(AVG(EXTRACT(EPOCH FROM
        (o.order_delivered_customer_date - o.order_purchase_timestamp))
        / 864)::numeric, 2) AS avg_delivery_days,
    ROUND(AVG(r.review_score)::numeric, 2) AS avg_review_score
FROM bands b
JOIN orders o ON o.order_id = b.order_id
JOIN order_reviews r ON r.order_id = b.order_id
GROUP BY b.delivery_band
ORDER BY CASE b.delivery_band
    WHEN 'Under 5 days' THEN 1
    WHEN '5–10 days' THEN 2
    WHEN '10–15 days' THEN 3
    WHEN '15+ days' THEN 4
END;


/* Q11 — Seller concentration */
WITH seller_sales AS (
    SELECT oi.seller_id, SUM(op.payment_value) AS seller_sales
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    JOIN order_payments op ON op.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),
ranked AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY seller_sales DESC) AS seller_rank
    FROM seller_sales
)
SELECT
    ROUND(100.0 * SUM(CASE WHEN seller_rank <= 10 THEN seller_sales ELSE 0 END)
          / SUM(seller_sales), 2) AS top_10_sales_share_pct,
    ROUND(100.0 * SUM(CASE WHEN seller_rank <= 20 THEN seller_sales ELSE 0 END)
          / SUM(seller_sales), 2) AS top_20_sales_share_pct
FROM ranked;


/* Q12 — Seller performance distribution
   Note: Uses the Investigation 36 scorecard methodology. */
WITH seller_metrics AS (
    SELECT
        oi.seller_id,
        COUNT(DISTINCT oi.order_id) AS orders_fulfilled,
        SUM(op.payment_value) AS revenue,
        AVG(r.review_score) AS avg_review,
        AVG(EXTRACT(EPOCH FROM
            (o.order_delivered_customer_date - o.order_purchase_timestamp))
            / 864) AS avg_delivery_days,
        COUNT(DISTINCT oi.product_id) AS products
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    JOIN order_payments op ON op.order_id = oi.order_id
    LEFT JOIN order_reviews r ON r.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
    HAVING COUNT(DISTINCT oi.order_id) >= 10
),
scores AS (
    SELECT *,
        NTILE(100) OVER (ORDER BY revenue) AS revenue_score,
        NTILE(100) OVER (ORDER BY orders_fulfilled) AS order_score,
        NTILE(100) OVER (ORDER BY products) AS product_score,
        (avg_review / 5.0) * 100 AS review_score,
        NULL::numeric AS delivery_score
    FROM seller_metrics
),
final_scores AS (
    SELECT *,
        0.35 * revenue_score
        + 0.25 * order_score
        + 0.20 * review_score
        + 0.05 * product_score AS weighted_score
    FROM scores
)
SELECT
    CASE
        WHEN weighted_score >= 90 THEN 'Elite Seller'
        WHEN weighted_score >= 75 THEN 'High Performer'
        WHEN weighted_score >= 60 THEN 'Strong Performer'
        WHEN weighted_score >= 45 THEN 'Average Performer'
        ELSE 'Needs Improvement'
    END AS seller_classification,
    COUNT(*) AS sellers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM final_scores
GROUP BY 1
ORDER BY sellers DESC;


/* Q13 — Seller risk distribution
   Thresholds reflect the Investigation 43 risk framework. */
WITH seller_metrics AS (
    SELECT
        oi.seller_id,
        COUNT(DISTINCT oi.order_id) AS delivered_orders,
        SUM(op.payment_value) AS revenue,
        AVG(r.review_score) AS avg_review_score,
        AVG(EXTRACT(EPOCH FROM
            (o.order_delivered_customer_date - o.order_purchase_timestamp))
            / 864) AS avg_delivery_days
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    JOIN order_payments op ON op.order_id = oi.order_id
    LEFT JOIN order_reviews r ON r.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
    HAVING COUNT(DISTINCT oi.order_id) >= 10
),
risk AS (
    SELECT *,
        CASE
            WHEN avg_review_score < 3.5 AND avg_delivery_days > 20
                THEN 'High Risk'
            WHEN avg_review_score < 4.0 OR avg_delivery_days > 15
                THEN 'Moderate Risk'
            ELSE 'Lower Risk'
        END AS risk_classification
    FROM seller_metrics
)
SELECT
    risk_classification,
    COUNT(*) AS sellers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM risk
GROUP BY 1
ORDER BY CASE risk_classification
    WHEN 'High Risk' THEN 1
    WHEN 'Moderate Risk' THEN 2
    ELSE 3
END;


/* Q14 — Product-category commercial evidence */
WITH category_metrics AS (
    SELECT
        COALESCE(t.product_category_name_english,
                 p.product_category_name) AS category,
        COUNT(DISTINCT o.order_id) AS orders,
        SUM(op.payment_value) AS sales,
        COUNT(DISTINCT c.customer_unique_id) AS customers,
        SUM(op.payment_value) /
            NULLIF(COUNT(DISTINCT o.order_id), 0) AS aov
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    LEFT JOIN product_category_name_translation t
        ON t.product_category_name = p.product_category_name
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_payments op ON op.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    category,
    orders,
    customers,
    ROUND(sales, 2) AS sales,
    ROUND(aov, 2) AS aov,
    NTILE(4) OVER (ORDER BY sales) AS sales_quartile,
    NTILE(4) OVER (ORDER BY orders) AS order_quartile,
    NTILE(4) OVER (ORDER BY customers) AS customer_quartile
FROM category_metrics
ORDER BY sales DESC;


/* Q15 — Regional opportunity evidence */
WITH regional AS (
    SELECT
        c.customer_state,
        COUNT(DISTINCT o.order_id) AS orders,
        COUNT(DISTINCT c.customer_unique_id) AS customers,
        SUM(op.payment_value) AS revenue,
        SUM(op.payment_value) /
            NULLIF(COUNT(DISTINCT o.order_id), 0) AS aov,
        AVG(EXTRACT(EPOCH FROM
            (o.order_delivered_customer_date - o.order_purchase_timestamp))
            / 864) AS avg_delivery_days
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_payments op ON op.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state
)
SELECT
    customer_state,
    orders,
    customers,
    ROUND(revenue, 2) AS revenue,
    ROUND(aov, 2) AS aov,
    ROUND(avg_delivery_days, 2) AS avg_delivery_days,
    NTILE(4) OVER (ORDER BY revenue) AS revenue_quartile,
    NTILE(4) OVER (ORDER BY customers) AS customer_quartile,
    NTILE(4) OVER (ORDER BY aov) AS aov_quartile
FROM regional
ORDER BY revenue DESC;


/* Q16 — High-value / lower-demand categories */
WITH category_metrics AS (
    SELECT
        COALESCE(t.product_category_name_english,
                 p.product_category_name) AS category,
        COUNT(DISTINCT o.order_id) AS orders,
        SUM(op.payment_value) AS sales,
        SUM(op.payment_value) /
            NULLIF(COUNT(DISTINCT o.order_id), 0) AS aov
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    LEFT JOIN product_category_name_translation t
        ON t.product_category_name = p.product_category_name
    JOIN order_payments op ON op.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
benchmarks AS (
    SELECT
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY aov) AS q3_aov,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY orders) AS q1_orders
    FROM category_metrics
)
SELECT
    c.category,
    c.orders,
    ROUND(c.sales, 2) AS sales,
    ROUND(c.aov, 2) AS aov,
    'High Value / Lower Demand' AS classification
FROM category_metrics c
CROSS JOIN benchmarks b
WHERE c.aov >= b.q3_aov
  AND c.orders <= b.q1_orders
ORDER BY c.aov DESC;


/* Q17 — High-value sellers requiring targeted attention */
WITH seller_metrics AS (
    SELECT
        oi.seller_id,
        COUNT(DISTINCT oi.order_id) AS orders,
        SUM(op.payment_value) AS revenue,
        AVG(r.review_score) AS avg_review,
        AVG(EXTRACT(EPOCH FROM
            (o.order_delivered_customer_date - o.order_purchase_timestamp))
            / 864) AS avg_delivery_days
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    JOIN order_payments op ON op.order_id = oi.order_id
    LEFT JOIN order_reviews r ON r.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
    HAVING COUNT(DISTINCT oi.order_id) >= 10
),
threshold AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue) AS q3_revenue
    FROM seller_metrics
)
SELECT
    s.seller_id,
    s.orders,
    ROUND(s.revenue, 2) AS revenue,
    ROUND(s.avg_review, 2) AS avg_review,
    ROUND(s.avg_delivery_days, 2) AS avg_delivery_days
FROM seller_metrics s
CROSS JOIN threshold t
WHERE s.revenue >= t.q3_revenue
  AND (s.avg_review < 4.0 OR s.avg_delivery_days > 15)
ORDER BY s.revenue DESC;
