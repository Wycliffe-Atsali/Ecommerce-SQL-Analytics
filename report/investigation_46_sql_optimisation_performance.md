# Investigation 46 — SQL Optimisation & Performance Analysis

## 1. Investigation Overview

**Investigation:** 46  
**Phase:** Phase 9 — Executive Reporting & Business Recommendations  
**Domain:** PostgreSQL query performance, execution plans, indexing, sorting, temporary I/O, joins, aggregation, window functions, and analytical query architecture.

### Business Objective

Evaluate representative analytical queries developed throughout the Olist SQL Business Analysis project and identify evidence-based opportunities to improve query efficiency.

The investigation focuses on how PostgreSQL executes complex analytical SQL, where execution time is concentrated, how joins and aggregation contribute to cost, whether targeted indexing provides measurable benefits, and which optimisation opportunities warrant further investigation.

The central principle is:

> **SQL optimisation should be evidence-based: inspect the execution plan, form a hypothesis, test one change, benchmark the result, and then accept or reject the optimisation.**

---

## 2. Analytical Context

The Olist PostgreSQL database contains approximately:

- 99,441 orders
- 99,441 customers
- 112,650 order items
- 103,886 payment records
- 99,224 review records
- 32,951 products
- 3,095 sellers
- 1,000,163 geolocation records

The relatively moderate dataset size is important when interpreting execution plans. A sequential scan is not automatically a performance problem: when a query requires a large proportion of a table, PostgreSQL may reasonably determine that reading the table directly is cheaper than using an index.

Performance was therefore evaluated using observed execution evidence rather than assuming that a particular scan or SQL construct was inherently inefficient.

---

## 3. Methodology

The investigation followed:

```text
Inspect
  ↓
Benchmark
  ↓
Diagnose
  ↓
Formulate optimisation hypothesis
  ↓
Test
  ↓
Compare
  ↓
Decide
```

The primary diagnostic command was:

```sql
EXPLAIN (ANALYZE, BUFFERS)
```

Key evidence considered included:

- actual execution time;
- scan type;
- actual rows and loops;
- join strategy;
- sort method;
- temporary reads/writes;
- external disk-based sorting;
- aggregation behaviour;
- repeated processing of large source tables.

Estimated planner cost was treated separately from actual elapsed execution time.

---

# 4. Representative Workloads

| Workload | Analytical purpose | Performance relevance |
|---|---|---|
| Q10 | Delivery performance by customer state | Large order scan, join, aggregation and sorting |
| Q12 | Seller performance classification | Multi-stage aggregation, joins, window functions and scoring |
| Q20 | Executive risk analysis | Multiple analytical branches and transformations |
| Executive benchmark | Additional executive-level workload | Demonstrates cumulative analytical complexity |

These queries were selected because they represent realistic later-stage analytical workloads rather than trivial SQL statements.

---

# 5. Existing Index Context

The database already contains primary/unique indexes generated as part of the relational design.

The targeted optimisation experiment introduced:

```sql
CREATE INDEX idx_orders_delivered_customer
ON orders (customer_id)
WHERE order_status = 'delivered';
```

The hypothesis was that a partial index focused on delivered orders might improve Q10, which filters to delivered orders and joins `orders` to `customers` through `customer_id`.

The index was later verified through `pg_indexes`, confirming that it exists in the database.

---

# 6. Q10 — Delivery Performance by Customer State

## 6.1 Analytical Objective

Q10 calculates delivered-order volume and average delivery time by Brazilian customer state.

**Analytical grain:** one row per customer state.

```sql
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
```

---

# 7. Q10 Baseline → Index Experiment

The chronology of the experiment is important.

## Step 1 — Baseline

Q10 was first executed with:

```sql
EXPLAIN (ANALYZE, BUFFERS)
```

**Baseline execution time:**

> **1,536.845 ms**

This establishes the pre-intervention benchmark.

The baseline plan used a sequential scan of `orders` and a hash join with `customers`. Approximately 96,470 relevant delivered orders were processed.

The plan also showed disk-based sorting:

```text
Sort Method: external merge
Disk: 6240kB
```

with temporary I/O:

```text
temp read=780
temp written=782
```

The external merge sort is therefore a clear performance signal, although the plan alone does not establish that one particular PostgreSQL setting is its sole cause.

## Step 2 — Intervention

The targeted partial index was created:

```sql
CREATE INDEX idx_orders_delivered_customer
ON orders (customer_id)
WHERE order_status = 'delivered';
```

## Step 3 — Post-Index Benchmark

Q10 was executed again using:

```sql
EXPLAIN (ANALYZE, BUFFERS)
```

**Post-index execution time:**

> **1,583.932 ms**

Post-index execution remained a sequential scan of `orders`; PostgreSQL did not choose the new partial index.

---

# 8. Q10 Before vs After

| Metric | Baseline | After index |
|---|---:|---:|
| Execution time | **1,536.845 ms** | **1,583.932 ms** |
| Difference | — | **+47.087 ms** |
| Percentage change | — | **+3.06%** |
| `orders` access | Sequential scan | Sequential scan |
| Index used | No | No |
| Sort | External merge | External merge |
| Temporary I/O | Present | Present |

Calculation:

```text
1,583.932 − 1,536.845 = 47.087 ms

47.087 / 1,536.845 × 100 ≈ 3.06%
```

### Correct interpretation

> **In the tested benchmark, execution time increased by 47.087 ms, or approximately 3.06%, after creation of the targeted partial index.**

This should not be interpreted as a universal claim that the index makes Q10 slower. It describes the observed change in this benchmark under the tested environment.

The experiment therefore produced:

> **No demonstrated optimisation benefit for Q10.**

The appropriate decision is to reject the index as a demonstrated optimisation for this workload, while recognising that different data distributions, table sizes, selectivity, or workloads could produce different results.

---

# 9. Why PostgreSQL Continued to Use a Sequential Scan

Q10 processes approximately 96,470 relevant orders out of approximately 99,441 total orders.

This means that the query requires a very large proportion of the table.

An index can be less attractive when a query needs most rows because PostgreSQL may otherwise have to:

1. traverse the index;
2. locate a large number of table rows;
3. perform additional heap access;
4. continue with the same join, aggregation and sorting work.

The index also does not remove the need to access `customers`, calculate delivery duration, aggregate by state, or perform the required ordering.

Therefore:

> **The planner's continued use of a sequential scan is reasonable for the tested workload and should not be treated as a performance defect by itself.**

---

# 10. Q10 Main Performance Signal — External Sorting

The strongest directly observed Q10 optimisation signal was:

```text
Sort Method: external merge
Disk: 6240kB
```

and:

```text
temp read=780
temp written=782
```

The query processed approximately 96,470 intermediate rows before producing only 27 state-level results.

The execution path can therefore be represented as:

```text
orders
  ↓
Filter delivered orders
  ↓
~96,470 relevant rows
  ↓
Hash Join with customers
  ↓
~96,470 joined rows
  ↓
External merge sort
  ↓
GroupAggregate
  ↓
27 state-level rows
```

This demonstrates that the final result size does not reflect the amount of work required to produce it.

Potential future experiments include reducing intermediate row counts, restructuring aggregation, avoiding unnecessary sorting, and evaluating memory configuration in a controlled session-level benchmark.

These remain hypotheses until tested.

---

# 11. Q12 — Seller Performance Classification

Q12 represents a substantially more complex analytical workload.

It combines:

- delivered-order processing;
- seller-level aggregation;
- revenue;
- fulfilled-order counts;
- review metrics;
- delivery metrics;
- product diversity;
- score standardisation;
- `NTILE(100)` window calculations;
- weighted scoring;
- seller classification.

**Observed execution time: approximately 4,700.677 ms.**

The main performance lesson is not that `NTILE()` itself is inherently slow. Rather, the complete analytical pipeline must construct and aggregate seller-level datasets before the final window and classification stages can execute.

A recurring optimisation opportunity is repeated processing of the same underlying transactional tables across independent analytical branches.

This suggests investigating whether reusable delivered-order/seller analytical bases or more efficient pre-aggregation could reduce repeated joins, scans and aggregation.

Any rewrite should be benchmarked against the original query.

---

# 12. Q20 — Executive Risk Analysis

Q20 represents another high-complexity executive workload.

**Observed execution time: approximately 6,585.437 ms.**

Its greater runtime reflects the number of analytical transformations required across multiple evidence streams.

The investigation identified the same broad performance themes:

- large intermediate datasets;
- repeated joins and aggregation;
- sorting;
- distinct processing;
- and repeated analytical transformations.

The key lesson is:

> **A small executive result can still require substantial database processing.**

---

# 13. Additional Executive Benchmark

An additional executive-level benchmark produced:

> **10,306.650 ms**

This further demonstrates that increasingly sophisticated analytical SQL can become materially more expensive even when the final output is small.

Approximate observed runtimes were therefore:

| Workload | Observed runtime |
|---|---:|
| Q10 baseline | **1,536.845 ms** |
| Q10 after index | **1,583.932 ms** |
| Q12 | **4,700.677 ms** |
| Q20 | **6,585.437 ms** |
| Additional executive benchmark | **10,306.650 ms** |

These are environment-specific observations rather than universal PostgreSQL benchmarks.

---

# 14. Major Performance Patterns

## 14.1 Sequential scans are not automatically a problem

For broad analytical queries over a relatively small dataset, sequential scans can be the appropriate access method.

The Q10 experiment provides direct evidence: PostgreSQL continued using a sequential scan despite the targeted partial index.

## 14.2 External sorting is a recurring optimisation signal

Disk-based sorting and temporary I/O indicate that sorting deserves attention in future optimisation work.

The correct response is not automatically to increase memory. The workload should first be examined to determine whether intermediate row counts or redundant sorting can be reduced.

## 14.3 Complex analytical transformations dominate

The later-stage workloads combine:

```text
JOIN
  ↓
DISTINCT / aggregation
  ↓
SORT
  ↓
WINDOW FUNCTIONS
  ↓
SCORING
  ↓
CLASSIFICATION
```

The cumulative transformation pipeline is more important than any single SQL keyword.

## 14.4 Repeated analytical logic is a potential optimisation opportunity

Independent CTE branches can repeatedly scan, join or aggregate the same transactional sources.

CTEs are not inherently inefficient; the optimisation opportunity is specifically the repeated computation across related branches.

---

# 15. Optimisation Opportunities

### Priority 1 — Reduce repeated computation

Investigate shared delivered-order and seller/order analytical bases where multiple branches independently reconstruct similar relationships.

Potential approaches include:

- consolidating repeated calculations;
- pre-aggregating reusable datasets;
- simplifying analytical branches;
- materialising genuinely reusable intermediate results where justified.

### Priority 2 — Reduce unnecessary sorting

Investigate:

- reducing rows entering sort operations;
- filtering earlier where logically valid;
- eliminating redundant sorting;
- reducing unnecessary duplicate-generating joins;
- reviewing whether aggregation can be restructured.

### Priority 3 — Evaluate memory configuration

The external merge sort suggests that memory configuration may warrant a controlled experiment.

A session-level `work_mem` benchmark could compare execution plans, runtime and temporary I/O.

It should not be increased globally without considering concurrent workloads and available memory.

### Priority 4 — Benchmark targeted indexes

Candidate indexes may be tested individually where execution-plan evidence supports them.

Possible candidates include:

```text
orders(order_status, customer_id)
order_items(order_id, seller_id)
order_reviews(order_id)
```

These are **future test candidates, not validated recommendations**.

---

# 16. Optimisation Decision Framework

Each optimisation should be classified as:

### Retain
Use when a change produces a measurable benefit without introducing disproportionate complexity.

### Investigate Further
Use when execution-plan evidence suggests potential but the benchmark is insufficient.

### Reject
Use when the tested change provides no meaningful benefit, performs worse, or adds unnecessary complexity.

### Q10 index decision

> **Reject as a demonstrated optimisation for this workload.**

The partial index experiment is still valuable because it demonstrates the complete optimisation cycle:

```text
Baseline
  ↓
Hypothesis
  ↓
Intervention
  ↓
Re-benchmark
  ↓
Observed regression / no benefit
  ↓
Reject
```

---

# 17. Key Findings

### Finding 1 — The Q10 index experiment produced no benefit

The baseline was **1,536.845 ms**.

After creation of `idx_orders_delivered_customer`, the observed runtime was **1,583.932 ms**.

The difference was **+47.087 ms**, approximately **+3.06%**.

PostgreSQL continued to use a sequential scan.

### Finding 2 — External sorting is a clear performance signal

Q10 demonstrated an external merge sort with **6,240 kB** of disk usage and temporary reads/writes.

### Finding 3 — Sequential scans can be appropriate

Q10 required approximately 96,470 of approximately 99,441 orders, making a sequential scan a reasonable access strategy.

### Finding 4 — Query complexity increases execution cost

The representative workloads increased from approximately 1.54 seconds to 4.70 seconds, 6.59 seconds and 10.31 seconds as analytical complexity increased.

### Finding 5 — Intermediate processing matters

The number of rows returned at the end of a query can be very small while the database processes tens of thousands of intermediate records.

### Finding 6 — Query architecture is a major optimisation opportunity

Repeated joins, aggregation, sorting and analytical branches should be evaluated as a complete pipeline rather than optimising isolated SQL constructs.

---

# 18. Benchmark Limitations

The results are subject to:

- single-run variability;
- warm/cold cache effects;
- local hardware and PostgreSQL configuration;
- development-scale dataset size;
- absence of production concurrency.

The Q10 before/after difference should therefore be described as an observed benchmark result, not a universal performance guarantee.

The index experiment demonstrates that the tested index did not improve Q10 in the tested environment. It does not prove that the same index could never be useful under different workloads or data distributions.

---

# 19. Recommended Future Optimisation Strategy

Future performance work should follow:

```text
1. Identify a slow workload
          ↓
2. Capture EXPLAIN (ANALYZE, BUFFERS)
          ↓
3. Identify dominant operations
          ↓
4. Formulate one optimisation hypothesis
          ↓
5. Make one controlled change
          ↓
6. Re-run the workload
          ↓
7. Compare runtime and execution plan
          ↓
8. Retain, investigate further, or reject
```

For this project, the priority order should be:

1. reduce repeated computation;
2. reduce unnecessary intermediate rows and sorting;
3. evaluate memory configuration through controlled tests;
4. benchmark additional indexes only where justified.

---

# 20. Business and Portfolio Implications

For the current Olist dataset, the analytical workloads remain practical.

However, the investigation demonstrates why performance becomes increasingly important as analytical systems scale.

If these workloads were moved into a larger production environment, future architecture could consider:

- reusable analytical layers;
- materialised views for frequently refreshed executive metrics;
- pre-aggregated fact tables;
- scheduled refreshes;
- carefully selected indexes;
- session and workload-level performance monitoring.

The current dataset does not justify indiscriminate infrastructure optimisation. The value of the investigation is instead demonstrating a professional, evidence-based optimisation process.

---

# 21. Final Conclusion

Investigation 46 demonstrates that PostgreSQL SQL optimisation should be treated as an empirical analytical process rather than a checklist of rules.

The representative workloads showed that the major costs arise from the work required to transform transactional data into analytical results:

- joins;
- aggregation;
- sorting;
- temporary disk-based processing;
- window calculations;
- repeated analytical transformations.

The Q10 index experiment is particularly important because the proposed optimisation did not improve the workload.

The chronology was:

```text
Q10 baseline
1,536.845 ms
   ↓
Create idx_orders_delivered_customer
   ↓
Q10 post-index
1,583.932 ms
   ↓
+47.087 ms / +3.06%
   ↓
Sequential scan retained
   ↓
No demonstrated benefit
```

The correct professional conclusion is therefore:

> **The targeted partial index did not demonstrate a performance benefit for Q10 under the tested workload. The observed post-index execution was 47.087 ms, or approximately 3.06%, slower than the baseline.**

The broader optimisation conclusion is:

> **For the tested Olist workloads, the strongest optimisation opportunities are indicated by repeated computation, large intermediate datasets, sorting and temporary I/O rather than by the mere presence of sequential scans.**

The investigation establishes a repeatable performance methodology that can be applied to future analytical workloads:

> **Inspect → Benchmark → Diagnose → Hypothesise → Test → Compare → Decide.**
