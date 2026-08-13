-- =============================================================================
-- Investigation 46 — SQL Optimisation & Performance Analysis
-- Project: Olist SQL Business Analysis
-- Phase: Phase 9 — Executive Reporting & Business Recommendations
--
-- Purpose:
--   Evaluate representative analytical workloads using PostgreSQL execution
--   plans and benchmark a targeted partial index.
--
-- IMPORTANT Q10 chronology:
--   1. Baseline Q10 benchmark: 1,536.845 ms
--   2. Create targeted partial index
--   3. Post-index Q10 benchmark: 1,583.932 ms
--   4. Observed change: +47.087 ms / approximately +3.06%
--
-- The recorded runtimes are environment-specific observations.
-- =============================================================================


-- =============================================================================
-- 1. EXISTING INDEX INVENTORY
-- =============================================================================

SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;


-- =============================================================================
-- 2. Q10 — BASELINE BENCHMARK
-- =============================================================================
--
-- IMPORTANT:
-- Run this query BEFORE creating idx_orders_delivered_customer when
-- reproducing the original baseline experiment.
--
-- Recorded baseline:
--   Execution Time: 1,536.845 ms
-- =============================================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(
        (
            AVG(
                EXTRACT(
                    EPOCH FROM (
                        o.order_delivered_customer_date
                        - o.order_purchase_timestamp
                    )
                ) / 86400
            )
        )::numeric,
        2
    ) AS average_delivery_days
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days DESC;


-- =============================================================================
-- 3. Q10 — TARGETED PARTIAL INDEX EXPERIMENT
-- =============================================================================
--
-- Hypothesis:
--   A partial index on delivered orders keyed by customer_id may improve
--   Q10's delivered-order/customer join.
-- =============================================================================

CREATE INDEX idx_orders_delivered_customer
ON orders (customer_id)
WHERE order_status = 'delivered';


-- =============================================================================
-- 4. VERIFY THE EXPERIMENTAL INDEX
-- =============================================================================

SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname = 'idx_orders_delivered_customer';


-- =============================================================================
-- 5. Q10 — POST-INDEX BENCHMARK
-- =============================================================================
--
-- Recorded post-index result:
--   Execution Time: 1,583.932 ms
--
-- PostgreSQL continued to use a sequential scan on orders.
-- =============================================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(
        (
            AVG(
                EXTRACT(
                    EPOCH FROM (
                        o.order_delivered_customer_date
                        - o.order_purchase_timestamp
                    )
                ) / 86400
            )
        )::numeric,
        2
    ) AS average_delivery_days
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days DESC;


-- =============================================================================
-- 6. Q10 — RECORDED BENCHMARK COMPARISON
-- =============================================================================
--
-- Baseline:
--   1,536.845 ms
--
-- Post-index:
--   1,583.932 ms
--
-- Absolute change:
--   +47.087 ms
--
-- Percentage change:
--   +3.06% approximately
--
-- Interpretation:
--   The post-index execution was approximately 3.06% slower in the observed
--   run. This is not a universal claim about the index.
-- =============================================================================


-- =============================================================================
-- 7. Q12 — SELLER PERFORMANCE CLASSIFICATION
-- =============================================================================
--
-- Run the FINAL Q12 query from the project under EXPLAIN (ANALYZE, BUFFERS).
--
-- Recorded Investigation 46 benchmark:
--   Approximately 4,700.677 ms
--
-- Example:
--
-- EXPLAIN (ANALYZE, BUFFERS)
-- <FINAL Q12 QUERY>;
--
-- Areas to inspect:
--   * repeated scans and joins
--   * aggregation
--   * COUNT(DISTINCT ...)
--   * sorting
--   * NTILE/window processing
--   * temporary I/O
-- =============================================================================


-- =============================================================================
-- 8. Q20 — EXECUTIVE RISK ANALYSIS
-- =============================================================================
--
-- Run the FINAL Q20 query from the project under EXPLAIN (ANALYZE, BUFFERS).
--
-- Recorded Investigation 46 benchmark:
--   Approximately 6,585.437 ms
--
-- Example:
--
-- EXPLAIN (ANALYZE, BUFFERS)
-- <FINAL Q20 QUERY>;
--
-- Areas to inspect:
--   * repeated analytical branches
--   * large intermediate datasets
--   * aggregation
--   * sorting
--   * temporary I/O
--   * repeated analytical-base construction
-- =============================================================================


-- =============================================================================
-- 9. ADDITIONAL EXECUTIVE BENCHMARK
-- =============================================================================
--
-- Run the selected final executive-level analytical query under:
--
-- EXPLAIN (ANALYZE, BUFFERS)
-- <FINAL EXECUTIVE QUERY>;
--
-- Recorded benchmark:
--   Approximately 10,306.650 ms
-- =============================================================================


-- =============================================================================
-- 10. FUTURE INDEX CANDIDATES — NOT EXECUTED
-- =============================================================================
--
-- These are candidates for future controlled benchmarking only.
-- They are NOT validated optimisations from Investigation 46.
--
-- Possible candidates:
--
-- CREATE INDEX ...
-- ON orders (order_status, customer_id);
--
-- CREATE INDEX ...
-- ON order_items (order_id, seller_id);
--
-- CREATE INDEX ...
-- ON order_reviews (order_id);
--
-- Test each independently with EXPLAIN (ANALYZE, BUFFERS) before and after.
-- =============================================================================


-- =============================================================================
-- 11. FUTURE MEMORY EXPERIMENT — NOT EXECUTED
-- =============================================================================
--
-- Q10 showed:
--   Sort Method: external merge
--   Disk: 6240kB
--
-- A controlled session-level work_mem test may be appropriate.
--
-- Example:
--
-- SET LOCAL work_mem = '32MB';
--
-- EXPLAIN (ANALYZE, BUFFERS)
-- <Q10 QUERY>;
--
-- Compare execution time, sort method and temporary I/O.
--
-- Do not apply a global work_mem change solely from this investigation.
-- =============================================================================


-- =============================================================================
-- 12. OPTIONAL CLEAN-UP
-- =============================================================================
--
-- If the experimental index should be removed after documenting the test:
--
-- DROP INDEX IF EXISTS idx_orders_delivered_customer;
--
-- Only execute this if the index is not required by another workload.
-- =============================================================================
