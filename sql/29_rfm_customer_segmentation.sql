/*
================================================================
INVESTIGATION 35 — RFM CUSTOMER SEGMENTATION
================================================================

Business Objective:
Build a Recency, Frequency and Monetary (RFM) customer
segmentation framework using historical delivered-order behaviour.

Analytical Grain:
One row per customer_unique_id

Population:
Customers with at least one delivered order

Revenue Definition:
order_payments.payment_value

RFM Reference Date:
Latest delivered purchase date in the analytical population

Normalisation:
PERCENT_RANK() converted to a 0–100 scale

RFM Weights:
Recency   = 30%
Frequency = 30%
Monetary  = 40%

Quartile Direction:
Recency   -> 1 = best / most recent, 4 = worst / least recent
Frequency -> 1 = lowest, 4 = highest
Monetary  -> 1 = lowest, 4 = highest

Segments:
1. Champions
2. Loyal Customers
3. Recent Customers
4. Potential Loyalists
5. At Risk
6. Lost Customers
7. Standard

================================================================
*/


/*
================================================================
Q1 — ANALYTICAL CUSTOMER POPULATION
================================================================

Business Question:
Which customers are eligible for RFM analysis based on
delivered orders?

Grain:
One row per customer_unique_id
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
)

SELECT
    customer,
    COUNT(DISTINCT order_id) AS delivered_orders,
    MIN(order_purchase_timestamp) AS first_purchase_date,
    MAX(order_purchase_timestamp) AS latest_purchase_date
FROM delivered_orders
GROUP BY customer
ORDER BY delivered_orders DESC;


/*
================================================================
Q2 — CUSTOMER RECENCY BASE
================================================================

Business Question:
How many days have passed since each customer's most recent
delivered purchase?

Reference Date:
Maximum delivered purchase date in the RFM population.

Lower recency_days = more recent activity = higher value.
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_history AS
(
    SELECT
        customer,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_history
)

SELECT
    ch.customer,
    ch.latest_purchase_date,
    rd.rfm_reference_date,
    (
        rd.rfm_reference_date::date
        - ch.latest_purchase_date::date
    ) AS recency_days
FROM customer_history ch
CROSS JOIN reference_date rd
ORDER BY recency_days ASC;


/*
================================================================
Q3 — CUSTOMER FREQUENCY
================================================================

Business Question:
How many delivered orders has each customer placed?
*/

SELECT
    c.customer_unique_id AS customer,
    COUNT(DISTINCT o.order_id) AS order_frequency
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY order_frequency DESC;


/*
================================================================
Q4 — CUSTOMER MONETARY VALUE
================================================================

Business Question:
How much lifetime delivered-order revenue has each customer
generated?

Revenue:
order_payments.payment_value

Important:
Payments are aggregated to order level first so that payment
values cannot be accidentally multiplied by later joins.
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
)

SELECT
    d.customer,
    SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
FROM delivered_orders d
LEFT JOIN order_revenue orv
    ON d.order_id = orv.order_id
GROUP BY d.customer
ORDER BY lifetime_revenue DESC;


/*
================================================================
Q5 — COMBINED RFM ANALYTICAL DATASET
================================================================

Business Question:
Can Recency, Frequency and Monetary metrics be combined into
one customer-level analytical dataset?

Output Grain:
One row per customer_unique_id
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_history AS
(
    SELECT
        customer,
        COUNT(DISTINCT order_id) AS order_frequency,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
),

customer_revenue AS
(
    SELECT
        d.customer,
        SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
    FROM delivered_orders d
    LEFT JOIN order_revenue orv
        ON d.order_id = orv.order_id
    GROUP BY d.customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_history
)

SELECT
    ch.customer,
    (
        rd.rfm_reference_date::date
        - ch.latest_purchase_date::date
    ) AS recency_days,
    ch.order_frequency,
    cr.lifetime_revenue
FROM customer_history ch
INNER JOIN customer_revenue cr
    ON ch.customer = cr.customer
CROSS JOIN reference_date rd
ORDER BY recency_days ASC;


/*
================================================================
Q6 — RECENCY DISTRIBUTION
================================================================

Business Question:
What does the customer recency distribution look like?
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_history AS
(
    SELECT
        customer,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_history
),

rfm_base AS
(
    SELECT
        ch.customer,
        (
            rd.rfm_reference_date::date
            - ch.latest_purchase_date::date
        ) AS recency_days
    FROM customer_history ch
    CROSS JOIN reference_date rd
)

SELECT
    COUNT(*) AS customers,
    MIN(recency_days) AS minimum_recency_days,
    MAX(recency_days) AS maximum_recency_days,
    ROUND(AVG(recency_days)::numeric, 2) AS average_recency_days,
    PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY recency_days) AS q1_recency_days,
    PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY recency_days) AS median_recency_days,
    PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY recency_days) AS q3_recency_days,
    PERCENTILE_CONT(0.90)
        WITHIN GROUP (ORDER BY recency_days) AS p90_recency_days
FROM rfm_base;


/*
================================================================
Q7 — FREQUENCY AND MONETARY DISTRIBUTIONS
================================================================

Business Question:
What do the Frequency and Monetary distributions look like?
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_frequency AS
(
    SELECT
        customer,
        COUNT(DISTINCT order_id) AS order_frequency
    FROM delivered_orders
    GROUP BY customer
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
),

customer_monetary AS
(
    SELECT
        d.customer,
        SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
    FROM delivered_orders d
    LEFT JOIN order_revenue orv
        ON d.order_id = orv.order_id
    GROUP BY d.customer
),

rfm_base AS
(
    SELECT
        f.customer,
        f.order_frequency,
        m.lifetime_revenue
    FROM customer_frequency f
    INNER JOIN customer_monetary m
        ON f.customer = m.customer
)

SELECT
    'Frequency' AS metric,
    MIN(order_frequency)::numeric AS minimum_value,
    MAX(order_frequency)::numeric AS maximum_value,
    ROUND(AVG(order_frequency)::numeric, 2) AS average_value,
    PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY order_frequency) AS q1_value,
    PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY order_frequency) AS median_value,
    PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY order_frequency) AS q3_value,
    PERCENTILE_CONT(0.90)
        WITHIN GROUP (ORDER BY order_frequency) AS p90_value
FROM rfm_base

UNION ALL

SELECT
    'Monetary' AS metric,
    MIN(lifetime_revenue),
    MAX(lifetime_revenue),
    ROUND(AVG(lifetime_revenue)::numeric, 2),
    PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY lifetime_revenue),
    PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY lifetime_revenue),
    PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY lifetime_revenue),
    PERCENTILE_CONT(0.90)
        WITHIN GROUP (ORDER BY lifetime_revenue)
FROM rfm_base;


/*
================================================================
Q8 — RECENCY RANKING
================================================================

Business Question:
Which customers have the strongest recent purchasing activity?

Lower recency_days = better rank.

Note:
customer_unique_id is obtained through the customers table.
The orders table contains customer_id, not customer_unique_id.
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_history AS
(
    SELECT
        customer,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_history
),

rfm_base AS
(
    SELECT
        ch.customer,
        (
            rd.rfm_reference_date::date
            - ch.latest_purchase_date::date
        ) AS recency_days
    FROM customer_history ch
    CROSS JOIN reference_date rd
)

SELECT
    customer,
    recency_days,
    RANK() OVER (
        ORDER BY recency_days ASC
    ) AS recency_rank
FROM rfm_base
ORDER BY recency_rank, customer;


/*
================================================================
Q9 — INDEPENDENT FREQUENCY AND MONETARY RANKINGS
================================================================

Business Question:
How do customers rank independently on Frequency and Monetary
value?
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

frequency AS
(
    SELECT
        customer,
        COUNT(DISTINCT order_id) AS frequency
    FROM delivered_orders
    GROUP BY customer
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
),

monetary AS
(
    SELECT
        d.customer,
        SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
    FROM delivered_orders d
    LEFT JOIN order_revenue orv
        ON d.order_id = orv.order_id
    GROUP BY d.customer
)

SELECT
    f.customer,
    f.frequency,
    RANK() OVER (
        ORDER BY f.frequency DESC
    ) AS frequency_rank,
    m.lifetime_revenue,
    RANK() OVER (
        ORDER BY m.lifetime_revenue DESC
    ) AS monetary_rank
FROM frequency f
INNER JOIN monetary m
    ON f.customer = m.customer
ORDER BY frequency_rank, monetary_rank, f.customer;


/*
================================================================
Q10 — NORMALISE RFM METRICS TO 0–100
================================================================

Method:
PERCENT_RANK() * 100

Direction:
Recency   -> lower days = higher score
Frequency -> higher frequency = higher score
Monetary  -> higher revenue = higher score

Recency:
(1 - PERCENT_RANK()) * 100
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_metrics AS
(
    SELECT
        customer,
        COUNT(DISTINCT order_id) AS order_frequency,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
),

customer_revenue AS
(
    SELECT
        d.customer,
        SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
    FROM delivered_orders d
    LEFT JOIN order_revenue orv
        ON d.order_id = orv.order_id
    GROUP BY d.customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_metrics
),

rfm_base AS
(
    SELECT
        cm.customer,
        (
            rd.rfm_reference_date::date
            - cm.latest_purchase_date::date
        ) AS recency_days,
        cm.order_frequency,
        cr.lifetime_revenue
    FROM customer_metrics cm
    INNER JOIN customer_revenue cr
        ON cm.customer = cr.customer
    CROSS JOIN reference_date rd
),

scored AS
(
    SELECT
        customer,

        (
            1 -
            PERCENT_RANK() OVER (
                ORDER BY recency_days ASC
            )
        ) * 100 AS recency_score,

        PERCENT_RANK() OVER (
            ORDER BY order_frequency ASC
        ) * 100 AS frequency_score,

        PERCENT_RANK() OVER (
            ORDER BY lifetime_revenue ASC
        ) * 100 AS monetary_score

    FROM rfm_base
)

SELECT
    customer,
    ROUND(recency_score::numeric, 2) AS recency_score,
    ROUND(frequency_score::numeric, 2) AS frequency_score,
    ROUND(monetary_score::numeric, 2) AS monetary_score
FROM scored
ORDER BY recency_score DESC, frequency_score DESC, monetary_score DESC;


/*
================================================================
Q11 — WEIGHTED RFM SCORE
================================================================

Weights:
Recency   = 30%
Frequency = 30%
Monetary  = 40%

Total weight = 100%
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_metrics AS
(
    SELECT
        customer,
        COUNT(DISTINCT order_id) AS order_frequency,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
),

customer_revenue AS
(
    SELECT
        d.customer,
        SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
    FROM delivered_orders d
    LEFT JOIN order_revenue orv
        ON d.order_id = orv.order_id
    GROUP BY d.customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_metrics
),

rfm_base AS
(
    SELECT
        cm.customer,
        (
            rd.rfm_reference_date::date
            - cm.latest_purchase_date::date
        ) AS recency_days,
        cm.order_frequency,
        cr.lifetime_revenue
    FROM customer_metrics cm
    INNER JOIN customer_revenue cr
        ON cm.customer = cr.customer
    CROSS JOIN reference_date rd
),

rfm_scores AS
(
    SELECT
        customer,

        (
            1 -
            PERCENT_RANK() OVER (
                ORDER BY recency_days ASC
            )
        ) * 100 AS recency_score,

        PERCENT_RANK() OVER (
            ORDER BY order_frequency ASC
        ) * 100 AS frequency_score,

        PERCENT_RANK() OVER (
            ORDER BY lifetime_revenue ASC
        ) * 100 AS monetary_score

    FROM rfm_base
)

SELECT
    customer,
    ROUND(recency_score::numeric, 2) AS recency_score,
    ROUND(frequency_score::numeric, 2) AS frequency_score,
    ROUND(monetary_score::numeric, 2) AS monetary_score,
    ROUND(
          recency_score * 0.30
        + frequency_score * 0.30
        + monetary_score * 0.40
    , 2) AS rfm_score
FROM rfm_scores
ORDER BY rfm_score DESC;


/*
================================================================
Q12 — RFM QUARTILES
================================================================

Recency:
Quartile 1 = most recent customers
Quartile 4 = least recent customers

Frequency:
Quartile 1 = lowest
Quartile 4 = highest

Monetary:
Quartile 1 = lowest
Quartile 4 = highest
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_metrics AS
(
    SELECT
        customer,
        COUNT(DISTINCT order_id) AS order_frequency,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
),

customer_revenue AS
(
    SELECT
        d.customer,
        SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
    FROM delivered_orders d
    LEFT JOIN order_revenue orv
        ON d.order_id = orv.order_id
    GROUP BY d.customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_metrics
),

rfm_base AS
(
    SELECT
        cm.customer,
        (
            rd.rfm_reference_date::date
            - cm.latest_purchase_date::date
        ) AS recency_days,
        cm.order_frequency,
        cr.lifetime_revenue
    FROM customer_metrics cm
    INNER JOIN customer_revenue cr
        ON cm.customer = cr.customer
    CROSS JOIN reference_date rd
)

SELECT
    customer,
    recency_days,
    order_frequency,
    lifetime_revenue,

    NTILE(4) OVER (
        ORDER BY recency_days ASC
    ) AS recency_quartile,

    NTILE(4) OVER (
        ORDER BY order_frequency ASC
    ) AS frequency_quartile,

    NTILE(4) OVER (
        ORDER BY lifetime_revenue ASC
    ) AS monetary_quartile

FROM rfm_base
ORDER BY customer;


/*
================================================================
Q13 — CUSTOMER RFM SEGMENTATION
================================================================

Segment hierarchy:

1. Champions
2. Loyal Customers
3. Recent Customers
4. Potential Loyalists
5. At Risk
6. Lost Customers
7. Standard

The ordered CASE expression ensures each customer receives
exactly one segment.
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_metrics AS
(
    SELECT
        customer,
        COUNT(DISTINCT order_id) AS order_frequency,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
),

customer_revenue AS
(
    SELECT
        d.customer,
        SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
    FROM delivered_orders d
    LEFT JOIN order_revenue orv
        ON d.order_id = orv.order_id
    GROUP BY d.customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_metrics
),

rfm_base AS
(
    SELECT
        cm.customer,
        (
            rd.rfm_reference_date::date
            - cm.latest_purchase_date::date
        ) AS recency_days,
        cm.order_frequency,
        cr.lifetime_revenue
    FROM customer_metrics cm
    INNER JOIN customer_revenue cr
        ON cm.customer = cr.customer
    CROSS JOIN reference_date rd
),

rfm_scored AS
(
    SELECT
        *,
        (
            1 -
            PERCENT_RANK() OVER (
                ORDER BY recency_days ASC
            )
        ) * 100 AS recency_score,

        PERCENT_RANK() OVER (
            ORDER BY order_frequency ASC
        ) * 100 AS frequency_score,

        PERCENT_RANK() OVER (
            ORDER BY lifetime_revenue ASC
        ) * 100 AS monetary_score,

        NTILE(4) OVER (
            ORDER BY recency_days ASC
        ) AS recency_quartile,

        NTILE(4) OVER (
            ORDER BY order_frequency ASC
        ) AS frequency_quartile,

        NTILE(4) OVER (
            ORDER BY lifetime_revenue ASC
        ) AS monetary_quartile

    FROM rfm_base
),

rfm_final AS
(
    SELECT
        *,
        (
              recency_score * 0.30
            + frequency_score * 0.30
            + monetary_score * 0.40
        ) AS rfm_score
    FROM rfm_scored
)

SELECT
    customer,
    recency_days,
    order_frequency,
    lifetime_revenue,
    ROUND(recency_score::numeric, 2) AS recency_score,
    ROUND(frequency_score::numeric, 2) AS frequency_score,
    ROUND(monetary_score::numeric, 2) AS monetary_score,
    recency_quartile,
    frequency_quartile,
    monetary_quartile,
    ROUND(rfm_score::numeric, 2) AS rfm_score,

    CASE
        WHEN recency_quartile = 1
             AND frequency_quartile = 4
             AND monetary_quartile = 4
        THEN 'Champions'

        WHEN frequency_quartile >= 3
             AND monetary_quartile >= 3
             AND recency_quartile <= 2
        THEN 'Loyal Customers'

        WHEN recency_quartile = 1
             AND frequency_quartile <= 2
             AND monetary_quartile <= 2
        THEN 'Recent Customers'

        WHEN recency_quartile <= 2
             AND frequency_quartile >= 2
             AND monetary_quartile >= 2
        THEN 'Potential Loyalists'

        WHEN recency_quartile >= 3
             AND (
                    frequency_quartile >= 3
                    OR monetary_quartile >= 3
                 )
        THEN 'At Risk'

        WHEN recency_quartile = 4
             AND frequency_quartile <= 2
             AND monetary_quartile <= 2
        THEN 'Lost Customers'

        ELSE 'Standard'
    END AS customer_segment

FROM rfm_final
ORDER BY rfm_score DESC, customer;


/*
================================================================
Q14 — SEGMENT VALIDATION
================================================================

Business Question:
Do the resulting RFM segments actually behave differently?

Validation metrics:
- customer distribution
- revenue concentration
- average recency
- average frequency
- average monetary value
- average RFM score
*/

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_metrics AS
(
    SELECT
        customer,
        COUNT(DISTINCT order_id) AS order_frequency,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
),

customer_revenue AS
(
    SELECT
        d.customer,
        SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
    FROM delivered_orders d
    LEFT JOIN order_revenue orv
        ON d.order_id = orv.order_id
    GROUP BY d.customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_metrics
),

rfm_base AS
(
    SELECT
        cm.customer,
        (
            rd.rfm_reference_date::date
            - cm.latest_purchase_date::date
        ) AS recency_days,
        cm.order_frequency,
        cr.lifetime_revenue
    FROM customer_metrics cm
    INNER JOIN customer_revenue cr
        ON cm.customer = cr.customer
    CROSS JOIN reference_date rd
),

rfm_scored AS
(
    SELECT
        *,
        (
            1 -
            PERCENT_RANK() OVER (
                ORDER BY recency_days ASC
            )
        ) * 100 AS recency_score,

        PERCENT_RANK() OVER (
            ORDER BY order_frequency ASC
        ) * 100 AS frequency_score,

        PERCENT_RANK() OVER (
            ORDER BY lifetime_revenue ASC
        ) * 100 AS monetary_score,

        NTILE(4) OVER (
            ORDER BY recency_days ASC
        ) AS recency_quartile,

        NTILE(4) OVER (
            ORDER BY order_frequency ASC
        ) AS frequency_quartile,

        NTILE(4) OVER (
            ORDER BY lifetime_revenue ASC
        ) AS monetary_quartile

    FROM rfm_base
),

rfm_final AS
(
    SELECT
        *,
        (
              recency_score * 0.30
            + frequency_score * 0.30
            + monetary_score * 0.40
        ) AS rfm_score
    FROM rfm_scored
),

segmented AS
(
    SELECT
        *,
        CASE
            WHEN recency_quartile = 1
                 AND frequency_quartile = 4
                 AND monetary_quartile = 4
            THEN 'Champions'

            WHEN frequency_quartile >= 3
                 AND monetary_quartile >= 3
                 AND recency_quartile <= 2
            THEN 'Loyal Customers'

            WHEN recency_quartile = 1
                 AND frequency_quartile <= 2
                 AND monetary_quartile <= 2
            THEN 'Recent Customers'

            WHEN recency_quartile <= 2
                 AND frequency_quartile >= 2
                 AND monetary_quartile >= 2
            THEN 'Potential Loyalists'

            WHEN recency_quartile >= 3
                 AND (
                        frequency_quartile >= 3
                        OR monetary_quartile >= 3
                     )
            THEN 'At Risk'

            WHEN recency_quartile = 4
                 AND frequency_quartile <= 2
                 AND monetary_quartile <= 2
            THEN 'Lost Customers'

            ELSE 'Standard'
        END AS customer_segment
    FROM rfm_final
),

segment_summary AS
(
    SELECT
        customer_segment,
        COUNT(*) AS customer_count,
        SUM(lifetime_revenue) AS total_lifetime_revenue,
        AVG(recency_days) AS average_recency,
        AVG(order_frequency) AS average_frequency,
        AVG(lifetime_revenue) AS average_monetary_value,
        AVG(rfm_score) AS average_rfm_score
    FROM segmented
    GROUP BY customer_segment
),

total_population AS
(
    SELECT
        SUM(customer_count) AS total_customers,
        SUM(total_lifetime_revenue) AS total_revenue
    FROM segment_summary
)

SELECT
    ss.customer_segment,
    ss.customer_count,
    ROUND(
        ss.customer_count * 100.0 / NULLIF(tp.total_customers, 0),
        2
    ) AS customer_percentage,

    ROUND(ss.total_lifetime_revenue::numeric, 2)
        AS total_lifetime_revenue,

    ROUND(
        ss.total_lifetime_revenue * 100.0
        / NULLIF(tp.total_revenue, 0),
        2
    ) AS revenue_percentage,

    ROUND(ss.average_recency::numeric, 2)
        AS average_recency,

    ROUND(ss.average_frequency::numeric, 2)
        AS average_frequency,

    ROUND(ss.average_monetary_value::numeric, 2)
        AS average_monetary_value,

    ROUND(ss.average_rfm_score::numeric, 2)
        AS average_rfm_score

FROM segment_summary ss
CROSS JOIN total_population tp

ORDER BY
    CASE ss.customer_segment
        WHEN 'Champions' THEN 1
        WHEN 'Loyal Customers' THEN 2
        WHEN 'Potential Loyalists' THEN 3
        WHEN 'Recent Customers' THEN 4
        WHEN 'At Risk' THEN 5
        WHEN 'Lost Customers' THEN 6
        ELSE 7
    END;


/*
================================================================
Q15 — AUTHORITATIVE REUSABLE RFM CUSTOMER DASHBOARD
================================================================

Grain:
One row per customer_unique_id

Purpose:
This view is the authoritative reusable analytical layer for
Investigation 35. Subsequent analysis can consume the view
without recreating the RFM calculations.

Important:
latest_purchase_date and rfm_reference_date are retained so
recency_days remains auditable and interpretable.
*/

DROP VIEW IF EXISTS rfm_customer_dashboard;

CREATE VIEW rfm_customer_dashboard AS

WITH delivered_orders AS
(
    SELECT
        o.order_id,
        c.customer_unique_id AS customer,
        o.order_purchase_timestamp
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_metrics AS
(
    SELECT
        customer,
        COUNT(DISTINCT order_id) AS frequency,
        MIN(order_purchase_timestamp) AS first_purchase_date,
        MAX(order_purchase_timestamp) AS latest_purchase_date
    FROM delivered_orders
    GROUP BY customer
),

order_revenue AS
(
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM order_payments
    GROUP BY order_id
),

customer_revenue AS
(
    SELECT
        d.customer,
        SUM(COALESCE(orv.order_revenue, 0)) AS lifetime_revenue
    FROM delivered_orders d
    LEFT JOIN order_revenue orv
        ON d.order_id = orv.order_id
    GROUP BY d.customer
),

reference_date AS
(
    SELECT
        MAX(latest_purchase_date) AS rfm_reference_date
    FROM customer_metrics
),

rfm_base AS
(
    SELECT
        cm.customer,
        cm.first_purchase_date,
        cm.latest_purchase_date,
        rd.rfm_reference_date,

        (
            rd.rfm_reference_date::date
            - cm.latest_purchase_date::date
        ) AS recency_days,

        cm.frequency,
        cr.lifetime_revenue

    FROM customer_metrics cm
    INNER JOIN customer_revenue cr
        ON cm.customer = cr.customer
    CROSS JOIN reference_date rd
),

rfm_scored AS
(
    SELECT
        *,

        RANK() OVER (
            ORDER BY recency_days ASC
        ) AS recency_rank,

        RANK() OVER (
            ORDER BY frequency DESC
        ) AS frequency_rank,

        RANK() OVER (
            ORDER BY lifetime_revenue DESC
        ) AS monetary_rank,

        (
            1 -
            PERCENT_RANK() OVER (
                ORDER BY recency_days ASC
            )
        ) * 100 AS recency_score,

        PERCENT_RANK() OVER (
            ORDER BY frequency ASC
        ) * 100 AS frequency_score,

        PERCENT_RANK() OVER (
            ORDER BY lifetime_revenue ASC
        ) * 100 AS monetary_score,

        NTILE(4) OVER (
            ORDER BY recency_days ASC
        ) AS recency_quartile,

        NTILE(4) OVER (
            ORDER BY frequency ASC
        ) AS frequency_quartile,

        NTILE(4) OVER (
            ORDER BY lifetime_revenue ASC
        ) AS monetary_quartile

    FROM rfm_base
),

rfm_model AS
(
    SELECT
        *,
        (
              recency_score * 0.30
            + frequency_score * 0.30
            + monetary_score * 0.40
        ) AS rfm_score
    FROM rfm_scored
),

classified AS
(
    SELECT
        *,

        RANK() OVER (
            ORDER BY rfm_score DESC
        ) AS rfm_rank,

        CASE
            WHEN recency_quartile = 1
                 AND frequency_quartile = 4
                 AND monetary_quartile = 4
            THEN 'Champions'

            WHEN frequency_quartile >= 3
                 AND monetary_quartile >= 3
                 AND recency_quartile <= 2
            THEN 'Loyal Customers'

            WHEN recency_quartile = 1
                 AND frequency_quartile <= 2
                 AND monetary_quartile <= 2
            THEN 'Recent Customers'

            WHEN recency_quartile <= 2
                 AND frequency_quartile >= 2
                 AND monetary_quartile >= 2
            THEN 'Potential Loyalists'

            WHEN recency_quartile >= 3
                 AND (
                        frequency_quartile >= 3
                        OR monetary_quartile >= 3
                     )
            THEN 'At Risk'

            WHEN recency_quartile = 4
                 AND frequency_quartile <= 2
                 AND monetary_quartile <= 2
            THEN 'Lost Customers'

            ELSE 'Standard'
        END AS customer_segment

    FROM rfm_model
)

SELECT
    customer,

    first_purchase_date,
    latest_purchase_date,
    rfm_reference_date,

    recency_days,
    frequency,
    lifetime_revenue,

    recency_rank,
    frequency_rank,
    monetary_rank,

    ROUND(recency_score::numeric, 2) AS recency_score,
    ROUND(frequency_score::numeric, 2) AS frequency_score,
    ROUND(monetary_score::numeric, 2) AS monetary_score,

    recency_quartile,
    frequency_quartile,
    monetary_quartile,

    ROUND(rfm_score::numeric, 2) AS rfm_score,

    rfm_rank,

    customer_segment

FROM classified;


/*
================================================================
FINAL VALIDATION
================================================================

These checks confirm:

1. RFM component scores remain within 0–100.
2. Composite RFM score remains within 0–100.
3. The weighting model totals 100%.
4. Every customer receives exactly one segment.
5. The reference date is consistent across the dashboard.
================================================================
*/


/* Score and weighting validation */

SELECT
    MIN(rfm_score) AS minimum_rfm_score,
    MAX(rfm_score) AS maximum_rfm_score,

    MIN(recency_score) AS minimum_recency_score,
    MAX(recency_score) AS maximum_recency_score,

    MIN(frequency_score) AS minimum_frequency_score,
    MAX(frequency_score) AS maximum_frequency_score,

    MIN(monetary_score) AS minimum_monetary_score,
    MAX(monetary_score) AS maximum_monetary_score,

    0.30 + 0.30 + 0.40 AS total_weight

FROM rfm_customer_dashboard;


/* Segment distribution validation */

SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM rfm_customer_dashboard
GROUP BY customer_segment
ORDER BY
    CASE customer_segment
        WHEN 'Champions' THEN 1
        WHEN 'Loyal Customers' THEN 2
        WHEN 'Potential Loyalists' THEN 3
        WHEN 'Recent Customers' THEN 4
        WHEN 'At Risk' THEN 5
        WHEN 'Lost Customers' THEN 6
        ELSE 7
    END;


/* Reference-date consistency */

SELECT
    COUNT(DISTINCT rfm_reference_date) AS reference_date_count,
    MIN(rfm_reference_date) AS rfm_reference_date
FROM rfm_customer_dashboard;


/* Grain validation */

SELECT
    COUNT(*) AS dashboard_rows,
    COUNT(DISTINCT customer) AS distinct_customers
FROM rfm_customer_dashboard;


/*
================================================================
END OF INVESTIGATION 35
================================================================
*/
