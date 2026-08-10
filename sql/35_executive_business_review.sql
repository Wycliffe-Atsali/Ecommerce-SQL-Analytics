/* ============================================================
   Investigation 41 — Executive Business Review
   SQL Analysis

   Purpose:
   Translate executive KPI analysis into a reusable dataset that
   can support senior-management business review.

   Core principles:
   - Revenue uses order_payments.payment_value.
   - Delivered orders are the primary transaction population.
   - customer_unique_id represents the actual customer.
   - Order-level revenue is calculated before customer-level metrics.
   - CTEs are used for analytical transformations.
   - The final executive KPI dataset is exposed through a VIEW.
   ============================================================ */


/* ============================================================
   Q1 — Total Revenue
   ============================================================ */

SELECT
    ROUND(SUM(op.payment_value)::numeric, 2) AS total_revenue
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
WHERE o.order_status = 'delivered';


/* ============================================================
   Q2 — Total Delivered Orders
   ============================================================ */

SELECT
    COUNT(
        DISTINCT CASE
            WHEN order_status = 'delivered'
            THEN order_id
        END
    ) AS delivered_orders,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        COUNT(
            DISTINCT CASE
                WHEN order_status = 'delivered'
                THEN order_id
            END
        ) * 100.0 / COUNT(DISTINCT order_id),
        2
    ) AS delivered_order_percentage
FROM orders;


/* ============================================================
   Q3 — Active Customers
   ============================================================ */

SELECT
    COUNT(DISTINCT c.customer_unique_id) AS active_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered';


/* ============================================================
   Q4 — Average Order Value
   ============================================================ */

WITH order_revenue AS
(
    SELECT
        o.order_id,
        SUM(op.payment_value) AS order_revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id
)
SELECT
    ROUND(AVG(order_revenue)::numeric, 2) AS average_order_value
FROM order_revenue;


/* ============================================================
   Q5 — Customer Lifetime Value
   ============================================================ */

WITH customer_lifetime_value AS
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
    COUNT(*) AS customers,
    ROUND(AVG(lifetime_revenue)::numeric, 2) AS average_clv,
    ROUND(
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY lifetime_revenue)::numeric,
        2
    ) AS median_clv,
    ROUND(MIN(lifetime_revenue)::numeric, 2) AS minimum_clv,
    ROUND(MAX(lifetime_revenue)::numeric, 2) AS maximum_clv
FROM customer_lifetime_value;


/* ============================================================
   Q5B — CLV Distribution
   ============================================================ */

WITH customer_lifetime_value AS
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
    PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY lifetime_revenue) AS clv_25th_percentile,
    PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY lifetime_revenue) AS clv_median,
    PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY lifetime_revenue) AS clv_75th_percentile
FROM customer_lifetime_value;


/* ============================================================
   Q6 — Repeat Purchase Rate
   ============================================================ */

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
)
SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE delivered_orders = 1
    ) AS one_time_customers,

    COUNT(*) FILTER (
        WHERE delivered_orders > 1
    ) AS repeat_customers,

    ROUND(
        COUNT(*) FILTER (
            WHERE delivered_orders > 1
        ) * 100.0 / COUNT(*),
        2
    ) AS repeat_purchase_rate
FROM customer_orders;


/* ============================================================
   Q7 — Average Delivery Time
   ============================================================ */

WITH delivery_times AS
(
    SELECT
        o.order_id,

        EXTRACT(
            EPOCH FROM (
                o.order_delivered_customer_date
                - o.order_purchase_timestamp
            )
        ) / 86400.0 AS delivery_days

    FROM orders o

    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_purchase_timestamp IS NOT NULL
)
SELECT
    COUNT(*) AS delivered_orders,

    ROUND(AVG(delivery_days)::numeric, 2)
        AS average_delivery_days,

    ROUND(
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY delivery_days)::numeric,
        2
    ) AS median_delivery_days,

    ROUND(
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY delivery_days)::numeric,
        2
    ) AS delivery_days_75th_percentile,

    ROUND(MIN(delivery_days)::numeric, 2)
        AS minimum_delivery_days,

    ROUND(MAX(delivery_days)::numeric, 2)
        AS maximum_delivery_days
FROM delivery_times;


/* ============================================================
   Q8 — Customer Satisfaction
   ============================================================ */

WITH delivered_reviews AS
(
    SELECT
        o.order_id,
        orv.review_score
    FROM orders o
    JOIN order_reviews orv
        ON o.order_id = orv.order_id
    WHERE o.order_status = 'delivered'
)
SELECT
    COUNT(DISTINCT order_id) AS reviewed_delivered_orders,

    ROUND(AVG(review_score)::numeric, 2)
        AS average_review_score,

    ROUND(
        PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY review_score)::numeric,
        2
    ) AS median_review_score
FROM delivered_reviews;


/* ============================================================
   Q8B — Review Score Distribution
   ============================================================ */

WITH delivered_reviews AS
(
    SELECT
        o.order_id,
        orv.review_score
    FROM orders o
    JOIN order_reviews orv
        ON o.order_id = orv.order_id
    WHERE o.order_status = 'delivered'
)
SELECT
    review_score,
    COUNT(*) AS review_count,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS review_percentage
FROM delivered_reviews
GROUP BY review_score
ORDER BY review_score DESC;


/* ============================================================
   Q9 — Monthly Revenue Growth
   ============================================================ */

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        o.order_purchase_timestamp
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

monthly_revenue AS
(
    SELECT
        DATE_TRUNC(
            'month',
            d.order_purchase_timestamp
        ) AS month,
        SUM(ore.revenue) AS revenue
    FROM delivered_orders d
    JOIN order_revenue ore
        ON d.order_id = ore.order_id
    GROUP BY DATE_TRUNC(
        'month',
        d.order_purchase_timestamp
    )
),

revenue_growth AS
(
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(previous_month_revenue::numeric, 2)
        AS previous_month_revenue,

    ROUND(
        (revenue - previous_month_revenue)::numeric,
        2
    ) AS revenue_change,

    ROUND(
        (
            (revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
            * 100
        )::numeric,
        2
    ) AS revenue_growth_percentage
FROM revenue_growth
ORDER BY month;


/* ============================================================
   Q10 — Top Sellers
   ============================================================ */

WITH seller_performance AS
(
    SELECT
        oi.seller_id AS seller,

        SUM(oi.price + oi.freight_value)
            AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

ranked_sellers AS
(
    SELECT
        seller,
        ROUND(sales_value::numeric, 2) AS sales_value,
        delivered_orders,

        RANK() OVER (
            ORDER BY sales_value DESC
        ) AS seller_rank

    FROM seller_performance
)
SELECT *
FROM ranked_sellers
ORDER BY seller_rank;


/* ============================================================
   Q10B — Top Sellers With Activity Threshold
   ============================================================ */

WITH seller_performance AS
(
    SELECT
        oi.seller_id AS seller,

        SUM(oi.price + oi.freight_value)
            AS sales_value,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders

    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

ranked_sellers AS
(
    SELECT
        seller,
        ROUND(sales_value::numeric, 2) AS sales_value,
        delivered_orders,

        RANK() OVER (
            ORDER BY sales_value DESC
        ) AS seller_rank

    FROM seller_performance
    WHERE delivered_orders >= 10
)
SELECT *
FROM ranked_sellers
ORDER BY seller_rank;


/* ============================================================
   Q11 — KPI Consistency Check
   ============================================================ */

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

revenue AS
(
    SELECT
        SUM(op.payment_value) AS total_revenue
    FROM delivered_orders d
    JOIN order_payments op
        ON d.order_id = op.order_id
),

order_metrics AS
(
    SELECT
        COUNT(DISTINCT order_id) AS delivered_orders,
        COUNT(DISTINCT customer_id) AS customer_ids
    FROM delivered_orders
),

customer_metrics AS
(
    SELECT
        COUNT(DISTINCT c.customer_unique_id)
            AS unique_customers
    FROM delivered_orders d
    JOIN customers c
        ON d.customer_id = c.customer_id
),

aov AS
(
    SELECT
        AVG(order_revenue) AS average_order_value
    FROM
    (
        SELECT
            d.order_id,
            SUM(op.payment_value) AS order_revenue
        FROM delivered_orders d
        JOIN order_payments op
            ON d.order_id = op.order_id
        GROUP BY d.order_id
    ) order_values
)
SELECT
    ROUND(r.total_revenue::numeric, 2) AS total_revenue,
    om.delivered_orders,
    cm.unique_customers,
    ROUND(a.average_order_value::numeric, 2)
        AS average_order_value
FROM revenue r
CROSS JOIN order_metrics om
CROSS JOIN customer_metrics cm
CROSS JOIN aov a;


/* ============================================================
   Q12 — Executive KPI Dataset
   Grain: one row per KPI
   ============================================================ */

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

revenue_kpi AS
(
    SELECT
        SUM(revenue) AS total_revenue,
        AVG(revenue) AS average_order_value
    FROM order_revenue
),

order_kpi AS
(
    SELECT
        COUNT(*) AS total_delivered_orders
    FROM delivered_orders
),

customer_kpi AS
(
    SELECT
        COUNT(*) AS active_customers,

        AVG(cr.lifetime_revenue)
            AS average_customer_lifetime_value,

        COUNT(*) FILTER (
            WHERE co.delivered_orders > 1
        ) * 100.0 / COUNT(*)
            AS repeat_purchase_rate

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
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400.0
        ) AS average_delivery_days
    FROM delivered_orders
    WHERE order_delivered_customer_date IS NOT NULL
),

review_kpi AS
(
    SELECT
        AVG(orv.review_score)
            AS average_review_score
    FROM delivered_orders d
    JOIN order_reviews orv
        ON d.order_id = orv.order_id
)
SELECT
    'Total Revenue' AS kpi,
    ROUND(total_revenue::numeric, 2) AS value
FROM revenue_kpi

UNION ALL
SELECT
    'Total Delivered Orders',
    total_delivered_orders::numeric
FROM order_kpi

UNION ALL
SELECT
    'Active Customers',
    active_customers::numeric
FROM customer_kpi

UNION ALL
SELECT
    'Average Order Value',
    ROUND(average_order_value::numeric, 2)
FROM revenue_kpi

UNION ALL
SELECT
    'Average Customer Lifetime Value',
    ROUND(average_customer_lifetime_value::numeric, 2)
FROM customer_kpi

UNION ALL
SELECT
    'Repeat Purchase Rate',
    ROUND(repeat_purchase_rate::numeric, 2)
FROM customer_kpi

UNION ALL
SELECT
    'Average Delivery Time',
    ROUND(average_delivery_days::numeric, 2)
FROM delivery_kpi

UNION ALL
SELECT
    'Average Review Score',
    ROUND(average_review_score::numeric, 2)
FROM review_kpi;


/* ============================================================
   Q13 — Monthly KPI Dataset
   Grain: one row per month

   Missing delivery dates affect only the delivery KPI.
   Revenue, orders, customers, and AOV remain based on the
   complete delivered-order population.
   ============================================================ */

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

monthly_orders AS
(
    SELECT
        DATE_TRUNC(
            'month',
            d.order_purchase_timestamp
        ) AS month,

        d.order_id,
        d.customer_id,
        d.order_purchase_timestamp,
        d.order_delivered_customer_date,

        COALESCE(ore.revenue, 0)
            AS revenue

    FROM delivered_orders d

    LEFT JOIN order_revenue ore
        ON d.order_id = ore.order_id
),

monthly_kpis AS
(
    SELECT
        mo.month,

        SUM(mo.revenue)
            AS monthly_revenue,

        COUNT(DISTINCT mo.order_id)
            AS delivered_orders,

        COUNT(DISTINCT c.customer_unique_id)
            AS active_customers,

        ROUND(
            (
                SUM(mo.revenue)
                /
                NULLIF(
                    COUNT(DISTINCT mo.order_id),
                    0
                )
            )::numeric,
            2
        ) AS average_order_value,

        ROUND(
            AVG(
                CASE
                    WHEN mo.order_delivered_customer_date
                         IS NOT NULL
                    THEN EXTRACT(
                        EPOCH FROM (
                            mo.order_delivered_customer_date
                            - mo.order_purchase_timestamp
                        )
                    ) / 86400.0
                END
            )::numeric,
            2
        ) AS average_delivery_days

    FROM monthly_orders mo

    JOIN customers c
        ON mo.customer_id = c.customer_id

    GROUP BY mo.month
)
SELECT
    month,
    ROUND(monthly_revenue::numeric, 2) AS revenue,
    delivered_orders,
    active_customers,
    average_order_value,
    average_delivery_days
FROM monthly_kpis
ORDER BY month;


/* ============================================================
   Q13B — Monthly Revenue Growth
   ============================================================ */

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        o.order_purchase_timestamp
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

monthly_revenue AS
(
    SELECT
        DATE_TRUNC(
            'month',
            d.order_purchase_timestamp
        ) AS month,

        SUM(ore.revenue) AS revenue

    FROM delivered_orders d

    JOIN order_revenue ore
        ON d.order_id = ore.order_id

    GROUP BY DATE_TRUNC(
        'month',
        d.order_purchase_timestamp
    )
),

revenue_growth AS
(
    SELECT
        month,
        revenue,

        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue

    FROM monthly_revenue
)
SELECT
    month,

    ROUND(revenue::numeric, 2) AS revenue,

    ROUND(
        previous_month_revenue::numeric,
        2
    ) AS previous_month_revenue,

    ROUND(
        (revenue - previous_month_revenue)::numeric,
        2
    ) AS revenue_change,

    ROUND(
        (
            (revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
            * 100
        )::numeric,
        2
    ) AS revenue_growth_percentage

FROM revenue_growth
ORDER BY month;


/* ============================================================
   Q14A — Validate Executive KPI Dataset Grain
   Expected grain: one row per KPI
   ============================================================ */

WITH executive_kpis AS
(
    SELECT 'Total Revenue' AS kpi
    UNION ALL
    SELECT 'Total Delivered Orders'
    UNION ALL
    SELECT 'Active Customers'
    UNION ALL
    SELECT 'Average Order Value'
    UNION ALL
    SELECT 'Average Customer Lifetime Value'
    UNION ALL
    SELECT 'Repeat Purchase Rate'
    UNION ALL
    SELECT 'Average Delivery Time'
    UNION ALL
    SELECT 'Average Review Score'
)
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT kpi) AS distinct_kpis,

    CASE
        WHEN COUNT(*) = COUNT(DISTINCT kpi)
        THEN 'Valid — One Row Per KPI'
        ELSE 'Invalid — Duplicate KPI Rows'
    END AS grain_validation
FROM executive_kpis;


/* ============================================================
   Q14B — Validate Monthly KPI Dataset Grain
   Expected grain: one row per month
   ============================================================ */

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        o.order_purchase_timestamp
    FROM orders o
    WHERE o.order_status = 'delivered'
),

monthly_kpis AS
(
    SELECT
        DATE_TRUNC(
            'month',
            order_purchase_timestamp
        ) AS month
    FROM delivered_orders
    GROUP BY DATE_TRUNC(
        'month',
        order_purchase_timestamp
    )
)
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT month) AS distinct_months,

    CASE
        WHEN COUNT(*) = COUNT(DISTINCT month)
        THEN 'Valid — One Row Per Month'
        ELSE 'Invalid — Duplicate Month Rows'
    END AS grain_validation
FROM monthly_kpis;


/* ============================================================
   Q15 — Final Executive KPI Dashboard View
   Grain: one row per KPI

   The exploratory analyses remain CTE-based. This VIEW provides
   a stable BI-facing dataset for executive reporting.
   ============================================================ */

/* ============================================================
Executive KPI Dashboard
============================================================ */

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

        SUM(op.payment_value)
            AS revenue

    FROM delivered_orders d

    JOIN order_payments op
        ON d.order_id = op.order_id

    GROUP BY d.order_id
),

customer_revenue AS
(
    SELECT
        c.customer_unique_id AS customer,

        SUM(ore.revenue)
            AS lifetime_revenue

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

        COUNT(DISTINCT d.order_id)
            AS delivered_orders

    FROM delivered_orders d

    JOIN customers c
        ON d.customer_id = c.customer_id

    GROUP BY c.customer_unique_id
),

revenue_kpi AS
(
    SELECT
        SUM(revenue)
            AS total_revenue,

        AVG(revenue)
            AS average_order_value

    FROM order_revenue
),

order_kpi AS
(
    SELECT
        COUNT(*)
            AS total_delivered_orders

    FROM delivered_orders
),

customer_kpi AS
(
    SELECT
        COUNT(*)
            AS active_customers,

        AVG(cr.lifetime_revenue)
            AS average_customer_lifetime_value,

        COUNT(*) FILTER (
            WHERE co.delivered_orders > 1
        ) * 100.0 / COUNT(*)
            AS repeat_purchase_rate

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
                    order_delivered_customer_date
                    -
                    order_purchase_timestamp
                )
            ) / 86400.0
        ) AS average_delivery_days

    FROM delivered_orders

    WHERE order_delivered_customer_date IS NOT NULL
),

review_kpi AS
(
    SELECT
        AVG(orv.review_score)
            AS average_review_score

    FROM delivered_orders d

    JOIN order_reviews orv
        ON d.order_id = orv.order_id
)

SELECT
    'Total Revenue' AS kpi,
    ROUND(total_revenue::numeric, 2) AS value

FROM revenue_kpi

UNION ALL

SELECT
    'Total Delivered Orders',
    total_delivered_orders::numeric

FROM order_kpi

UNION ALL

SELECT
    'Active Customers',
    active_customers::numeric

FROM customer_kpi

UNION ALL

SELECT
    'Average Order Value',
    ROUND(average_order_value::numeric, 2)

FROM revenue_kpi

UNION ALL

SELECT
    'Average Customer Lifetime Value',
    ROUND(average_customer_lifetime_value::numeric, 2)

FROM customer_kpi

UNION ALL

SELECT
    'Repeat Purchase Rate',
    ROUND(repeat_purchase_rate::numeric, 2)

FROM customer_kpi

UNION ALL

SELECT
    'Average Delivery Time',
    ROUND(average_delivery_days::numeric, 2)

FROM delivery_kpi

UNION ALL

SELECT
    'Average Review Score',
    ROUND(average_review_score::numeric, 2)

FROM review_kpi;


/* ============================================================
   END OF INVESTIGATION 41
   ============================================================ */
