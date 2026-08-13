# Investigation 47 — Technical Interview Preparation

## Investigation Overview

**Phase:** Technical Interview Preparation  
**Investigation:** 47  
**Purpose:** Prepare for technical, analytical and behavioural interview questions based on the SQL and Business Analytics project.

### Objective

This investigation consolidates 200 interview questions covering SQL fundamentals, PostgreSQL, aggregation, joins, CTEs, views, window functions, date/time analysis, database design, data quality, analytical grain, customer analytics, seller scorecards, revenue opportunity analysis, executive KPIs, SQL performance, debugging, business interpretation, project defence, technical communication and portfolio-level questions.

The answers have been reviewed for technical accuracy, PostgreSQL precision and consistency with the methodology used throughout the Olist project. Where an original answer was already sound, its substance has been retained. Where greater precision was necessary, the answer has been refined.

---

# A. SQL Fundamentals

## 1. Explain the logical order in which SQL processes a query.

The logical processing order is generally:

`FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT`

This differs from the written order of a SQL query. Understanding the logical order explains why, for example, a `WHERE` clause normally cannot reference an aggregate calculated later in the query.

## 2. What is the difference between WHERE and HAVING?

`WHERE` filters individual rows before grouping and aggregation.

`HAVING` filters groups after aggregation.

For example, `WHERE order_status = 'delivered'` establishes the row population before aggregation, while `HAVING COUNT(*) > 5` filters groups after they have been formed.

## 3. What is the difference between DISTINCT and GROUP BY?

`DISTINCT` removes duplicate combinations from the selected result.

`GROUP BY` creates groups so that aggregate calculations such as `SUM()`, `COUNT()` and `AVG()` can be performed per group.

## 4. When would you use ORDER BY with multiple columns?

When I need a deterministic hierarchy for sorting. For example, `ORDER BY revenue DESC, review_score DESC` primarily sorts by revenue and then uses review score to break ties.

## 5. What is the difference between COUNT(*), COUNT(column) and COUNT(DISTINCT column)?

- `COUNT(*)` counts rows.
- `COUNT(column)` counts non-null values.
- `COUNT(DISTINCT column)` counts unique non-null values.

This distinction was important in the Olist project because orders, customer records and unique customers represent different analytical populations.

## 6. What happens when you use aggregate functions without a GROUP BY?

The filtered result is treated as one group. For example, `SELECT SUM(payment_value) FROM order_payments;` returns one aggregate value.

---

# B. Aggregation

## 7. Explain how GROUP BY works.

`GROUP BY` divides rows into groups based on one or more expressions. Aggregate functions then calculate results independently for each group.

## 8. Why can't you normally reference an aggregate result in WHERE?

Because `WHERE` is logically evaluated before aggregation. An aggregate condition normally belongs in `HAVING`.

## 9. How would you calculate total revenue, average order value, number of customers and repeat-purchase rate?

The exact calculation depends on the analytical population and grain.

- Total revenue: `SUM(payment_value)`
- Average order value: `SUM(order_revenue) / COUNT(DISTINCT order_id)`
- Customers: `COUNT(DISTINCT customer_unique_id)`
- Repeat-purchase rate: first aggregate to one row per customer, then `COUNT(*) FILTER (WHERE order_count > 1)::numeric / COUNT(*)`

The key principle is to establish the correct grain before calculating the metric.

## 10. What is conditional aggregation and where did you use it?

Conditional aggregation calculates an aggregate over rows satisfying a condition, for example:

```sql
COUNT(*) FILTER (WHERE review_score >= 4)
```

or:

```sql
SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END)
```

It was used throughout the project for delivery performance, customer behaviour, reviews and executive KPI analysis.

---

# C. Joins & Relational SQL

## 11. Explain INNER, LEFT, RIGHT, FULL OUTER and CROSS JOIN.

- **INNER JOIN:** matching rows from both tables.
- **LEFT JOIN:** every left row plus matching right rows.
- **RIGHT JOIN:** every right row plus matching left rows.
- **FULL OUTER JOIN:** matched and unmatched rows from both sides.
- **CROSS JOIN:** Cartesian product of the two inputs.

`INNER JOIN` and `LEFT JOIN` were the most common in the project.

## 12. Why did your Olist analysis require multiple joins?

The Olist dataset is normalized across separate business entities such as customers, orders, items, payments, sellers and reviews. Business questions therefore often require several joins.

## 13. What happens when you join a one-to-many table to another one-to-many table?

The join can multiply rows. If an order has three item rows and two payment rows, directly joining both through `order_id` can produce six rows.

## 14. What is join multiplication, and how can it produce incorrect revenue?

Join multiplication occurs when multiple records on both sides represent the same logical entity. Summing payment values after such a join can count payments multiple times and overstate revenue.

## 15. How would you prevent double-counting when joining orders, order_items and order_payments?

First establish the intended analytical grain. Aggregate payments and item-level measures independently to a common grain, such as one row per order, before joining them.

The key principle is **control the grain before joining**.

## 16. Why was customer_unique_id important when analysing customers?

`customer_unique_id` identifies the underlying customer across the dataset and was therefore appropriate for customer lifetime, RFM and repeat-purchase analysis.

## 17. What is the difference between customer_id and customer_unique_id?

`customer_id` identifies the customer record associated with an order. `customer_unique_id` is the more stable identifier used to identify the same underlying customer across multiple orders.

## 18. Give an example where choosing the wrong join could produce misleading results.

Joining `order_payments` directly to `order_items` without appropriate pre-aggregation could multiply payment rows, inflating revenue and potentially making categories, sellers or products appear more valuable.

---

# D. Subqueries, CTEs & Views

## 19. What is a subquery?

A subquery is a query nested inside another SQL statement. It can calculate an intermediate result, filter against another result, or provide a derived table.

## 20. Difference between scalar and multi-row subquery?

A scalar subquery returns a single value. A multi-row subquery returns multiple rows and can be used with operators such as `IN`, `ANY`, `ALL` or `EXISTS`.

## 21. What is a correlated subquery?

A correlated subquery references a value from the outer query, so its result depends on the current outer row.

## 22. Why use a CTE instead of one very large query?

CTEs divide complex logic into logical stages, improving readability, debugging and analytical reasoning.

Typical structure:

```text
delivered orders
       ↓
order revenue
       ↓
customer metrics
       ↓
customer classification
```

## 23. Can one CTE reference another CTE?

Yes. A later CTE can reference an earlier CTE in the same `WITH` clause.

## 24. Advantages and disadvantages of CTEs?

**Advantages:** readability, modularity, easier debugging and clear intermediate stages.

**Potential disadvantages:** long CTE chains can become difficult to maintain; repeated or unnecessarily complex branches can increase work; planner/materialization behaviour depends on PostgreSQL version and query structure.

A CTE is not automatically a performance problem.

## 25. What is a SQL View?

A view is a named database object defined by a SQL query. It can be queried like a table while its underlying query remains stored as the view definition.

## 26. Why did you create reusable analytical views?

Views centralized commonly used analytical logic and allowed later investigations to reuse established transformations.

## 27. Difference between View and CTE?

A CTE exists for one SQL statement. A view is stored in the database and can be queried repeatedly.

## 28. When would you avoid creating a View?

When the logic is highly specific to one analysis or when another abstraction would unnecessarily complicate the analytical architecture.

## 29. Explain how modular SQL improved Phase 6.

Phase 6 introduced CTEs and reusable views, allowing complex transformations to be separated into logical stages and reused more easily.

---

# E. Window Functions

## 30. What is a window function?

A window function calculates across related rows while retaining the individual rows.

## 31. How is a window function different from GROUP BY?

`GROUP BY` collapses rows into groups. Window functions preserve the rows while adding calculations based on related rows.

## 32. Explain OVER() and PARTITION BY.

`OVER()` defines the window. `PARTITION BY` divides it into independent groups.

Example:

```sql
ROW_NUMBER() OVER (
    PARTITION BY customer_unique_id
    ORDER BY order_purchase_timestamp DESC
)
```

## 33. Difference between ROW_NUMBER(), RANK() and DENSE_RANK()?

For `100, 90, 90, 80`:

- `ROW_NUMBER()` → `1, 2, 3, 4`
- `RANK()` → `1, 2, 2, 4`
- `DENSE_RANK()` → `1, 2, 2, 3`

## 34. Business example where ROW_NUMBER is preferable to RANK?

Finding one most recent purchase per customer. For deterministic selection when timestamps tie, add a secondary ordering column such as `order_id`.

## 35. Explain NTILE().

`NTILE(n)` divides ordered rows into approximately equal-sized buckets. `NTILE(100)` provides a percentile-style relative segmentation, not an exact mathematical percentile.

## 36. Why use percentile/quantile-style segmentation?

Raw metrics have different units and distributions. Relative scoring makes them more comparable for composite analysis.

## 37. Difference between NTILE(100) and PERCENT_RANK()?

`NTILE(100)` assigns rows to discrete buckets. `PERCENT_RANK()` calculates relative rank on a 0–1 scale:

`(rank - 1) / (rows - 1)`.

They are related but not interchangeable.

## 38. Explain LAG().

`LAG()` accesses a preceding row within an ordered window.

## 39. Explain LEAD().

`LEAD()` accesses a subsequent row within an ordered window.

## 40. What happens when LAG/LEAD has no previous/next row?

It returns `NULL` by default unless a default value is supplied.

## 41. What are window frames?

A window frame defines the subset of rows considered relative to the current row for frame-sensitive calculations.

## 42. Explain a running total.

A running total continuously accumulates values over an ordered sequence, commonly using:

```sql
SUM(revenue) OVER (
    ORDER BY month
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

## 43. Explain a moving average.

A moving average calculates the average over a rolling number of observations, such as the current month plus the previous two months.

## 44. What are FIRST_VALUE() and LAST_VALUE() used for?

They return first or last values within a defined window/frame, useful for lifecycle and sequence analysis.

## 45. Common mistake with LAST_VALUE()?

The default ordered frame can end at the current row, causing `LAST_VALUE()` to return the current row's value instead of the partition's final value. An explicit frame such as `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` can be used when required.

---

# F. Dates & Time-Series Analysis

## 46. What does DATE_TRUNC() do?

It truncates a timestamp to a specified period, such as month:

```sql
DATE_TRUNC('month', order_purchase_timestamp)
```

## 47. Why use DATE_TRUNC instead of manually extracting year/month?

It provides a proper period value and simplifies chronological grouping.

## 48. Difference between date and timestamp?

A `date` represents a calendar date. A `timestamp` represents a date and time of day.

## 49. How did you analyse sales trends over time?

I grouped transactions into periods such as months using `DATE_TRUNC()`, calculated metrics such as order count and revenue, and examined their progression over time.

## 50. How would you calculate delivery duration?

Subtract the delivery timestamp from the purchase timestamp. PostgreSQL returns an interval; for numeric days, convert the interval using epoch seconds divided by `86400`.

## 51. How would you calculate the number of days between two timestamps?

```sql
EXTRACT(EPOCH FROM (end_timestamp - start_timestamp)) / 86400
```

## 52. How would you identify a customer's most recent purchase?

Use `ROW_NUMBER()` partitioned by `customer_unique_id` and ordered by purchase timestamp descending. Add a tie-breaker such as `order_id` when deterministic selection is required.

## 53. How would you calculate customer recency?

Choose a defined reference date and subtract the customer's most recent qualifying purchase date. A smaller value indicates more recent activity.

## 54. What problems can arise with time zones?

Inconsistent time zones can produce incorrect event ordering and duration calculations. Production systems should establish and consistently apply a timezone convention.

---

# G. Data Quality & Database Design

## 55. Why did you use PostgreSQL?

PostgreSQL provided relational integrity, window functions, CTEs, analytical functions and execution-plan tools suitable for the project.

## 56. Purpose of a primary key?

It uniquely identifies a row and prevents duplicate key values. It also provides a reliable target for foreign-key relationships.

## 57. Purpose of a foreign key?

It establishes and can enforce a relationship between tables, helping maintain referential integrity.

## 58. What is normalization?

Normalization organizes data into related tables to reduce unnecessary redundancy and improve data integrity.

## 59. Why was normalization appropriate for Olist?

Olist naturally contains separate entities such as customers, orders, products, sellers, payments and reviews. Separating those entities reflects their relationships and avoids unnecessary duplication.

## 60. What data-quality issues did you discover?

The project encountered duplicate review identifiers requiring schema handling, missing product category information and special payment-method values such as `NOT DEFINED`. Row-count and structural validation were also performed after import.

## 61. Why did order_reviews require schema modification?

The source contained duplicate `review_id` values, so `review_id` alone could not safely serve as the primary key. A unique `review_key` was introduced.

## 62. Difference between natural/business key and surrogate key?

A natural key has business meaning. A surrogate key is an artificial identifier created for database identification.

## 63. Why introduce review_key?

It provided a reliable unique identifier for review records when the source `review_id` was not sufficiently unique.

## 64. How did you validate imported data?

I checked row counts, primary-key uniqueness, null values, distinct values, foreign-key relationships, expected categories/states and suspicious or duplicate records.

## 65. Why is row-count validation important?

A successful import message does not guarantee that every source record loaded correctly. Comparing expected and actual row counts can reveal incomplete or rejected data.

## 66. What would you check if a CSV import produced fewer rows?

Delimiter, quoting, encoding, header handling, malformed rows, null representation, import errors and rejected/duplicate records.

## 67. What is referential integrity?

It means relationships between related tables remain valid; for example, an order's `customer_id` should correspond to a valid customer record.

## 68. How would duplicate records affect analysis?

They can inflate counts, revenue, averages and rates. Uniqueness and grain validation should therefore precede business analysis.

---

# H. Analytical Grain & Metric Definitions

## 69. What does analytical grain mean?

Grain describes what one row represents in an analytical dataset, such as one row per `customer_unique_id`.

## 70. Why define grain before SQL?

Because joins, aggregations and metrics depend on what one row represents. Without explicit grain, duplication and incorrect calculations become much more likely.

## 71. What was the grain of customer-level analyses?

Generally one row per `customer_unique_id`.

## 72. What was the grain of seller analyses?

Generally one row per seller, with seller-level metrics aggregated before scoring and classification.

## 73. What was the RFM grain?

One row per `customer_unique_id` with at least one delivered order.

## 74. What was your definition of revenue?

For marketplace-level analysis, the project's primary revenue definition was:

```sql
SUM(order_payments.payment_value)
```

within the relevant analytical population, particularly delivered orders for historical customer and business-performance analysis.

## 75. Why use order_payments.payment_value?

It represents the payment value recorded in the marketplace transaction data and was adopted as the project's primary marketplace revenue measure for relevant analyses.

## 76. When would order_items.price + freight_value be more appropriate?

When the question specifically concerns item-level sales value, product economics, seller merchandise value or freight contribution.

## 77. Why restrict historical analysis to delivered orders?

Delivered orders represent completed fulfilment and provide a consistent population for historical customer and business-performance analysis.

## 78. Problems if cancelled/unavailable orders are included?

They can distort revenue, delivery performance and behavioural metrics because they do not represent completed fulfilment. The appropriate population still depends on the business question.

## 79. Why is metric definition often more important than SQL syntax?

A technically correct query can still answer the wrong business question if the metric is incorrectly defined.

---

# I. Customer Analytics

## 80. Explain CLV.

Customer Lifetime Value estimates the economic value associated with a customer's relationship with a business. In this project, CLV was a historical observed-value framework rather than a predictive future-value model.

## 81. How did you define CLV?

I used historical customer purchasing behaviour, primarily based on delivered orders and payment value, to estimate observed customer economic contribution. It was not a predictive future CLV model.

## 82. What assumptions does historical CLV make?

It assumes historical purchasing behaviour is useful for evaluating observed customer value. It does not predict future purchases, retention or future profitability.

## 83. What is RFM?

RFM stands for Recency, Frequency and Monetary value. It segments customers by how recently, how often and how much they purchased.

## 84. Explain Recency, Frequency and Monetary.

- **Recency:** time since the customer's most recent qualifying purchase.
- **Frequency:** number of qualifying purchases/orders.
- **Monetary:** qualifying amount spent.

## 85. Why is recency treated differently?

Lower recency is better because fewer elapsed days indicate a more recent purchase. Frequency and monetary value generally increase with customer value.

## 86. What was the RFM reference date?

The reference date was based on the latest relevant purchase date in the historical delivered-order dataset so recency was measured consistently relative to the end of the observed period.

## 87. Why is customer_unique_id appropriate for RFM?

RFM measures behaviour across a customer's relationship rather than treating individual customer/order records as separate customers.

## 88. How did you convert RFM metrics into scores?

I used percentile-style segmentation to create comparable scores, reversing the direction for recency because lower recency indicates more recent activity.

## 89. How did you classify customers?

I combined RFM dimensions into behavioural segments so customers could be interpreted according to engagement and value rather than one metric alone.

## 90. Business actions for RFM segments?

Examples:

- high-value recent customers → retain;
- high-value inactive customers → re-engage;
- recent low-frequency customers → nurture;
- low-value inactive customers → lower-cost engagement.

## 91. Limitations of RFM?

RFM does not directly capture profitability, acquisition cost, product preferences, customer satisfaction, reasons for churn or future behaviour. It is a behavioural segmentation framework rather than a complete customer-value model.

---

# J. Seller Performance & Scorecards

## 92. What metrics evaluated sellers?

Revenue, orders fulfilled, review score, on-time delivery and product diversity.

## 93. Why not evaluate sellers using revenue alone?

A seller can generate high revenue while performing poorly in reviews or delivery. A balanced scorecard captures commercial contribution alongside operational and customer-experience dimensions.

## 94. Explain your weighted seller scorecard.

Each seller metric was converted to a comparable scale and combined using predetermined weights to create a composite performance score and seller tiers.

## 95. What were the weights?

- Revenue — **35%**
- Orders fulfilled — **25%**
- Review score — **20%**
- On-time delivery — **15%**
- Product diversity — **5%**

## 96. Why did revenue receive the largest weight?

Revenue represents direct commercial contribution, so it received the largest weight while still being balanced by fulfilment, customer experience and operations.

## 97. Why did product diversity receive a smaller weight?

It is useful contextual information but is less directly connected to current commercial and customer-service performance than revenue, fulfilment and reviews.

## 98. How did you standardise metrics onto 1–100?

I used percentile-style scoring such as `NTILE(100)` where relative performance was appropriate. Review score was normalized from its 1–5 scale and on-time delivery was already a percentage.

## 99. Why can't raw metrics simply be added?

They have different units and scales. Adding revenue, a 1–5 review score and a percentage would allow large-scale variables to dominate.

## 100. Explain NTILE(100) for seller metrics.

`NTILE(100)` divides sellers into approximately 100 ordered buckets, providing a percentile-style relative score rather than an absolute quality measure.

## 101. Why standardise review score differently?

Because review scores have a bounded 1–5 scale:

```text
(review_score / 5) × 100
```

provides a direct normalized score.

## 102. How did you classify sellers?

- **Elite Seller:** ≥90
- **High Performer:** ≥75
- **Strong Performer:** ≥60
- **Average Performer:** ≥45
- **Needs Improvement:** <45

## 103. Limitations of weighted scorecards?

Weights and thresholds involve judgement. Composite scores can also hide weaknesses because strong performance in one dimension can offset poor performance elsewhere.

## 104. How would you validate the weights?

Perform sensitivity analysis using alternative weighting schemes and assess whether classifications materially change. Where possible, compare scores with future outcomes such as retention, complaints or revenue growth.

---

# K. Product & Revenue Opportunity Analysis

## 105. Objective of product portfolio analysis?

To understand which product categories contribute strongly to revenue and customer demand and which appear weaker or strategically different.

## 106. How did you distinguish stronger and weaker categories?

I compared multiple signals such as revenue, order activity, customer demand and relative performance rather than relying on one metric.

## 107. What does revenue opportunity mean?

It identifies areas where current performance and other business signals suggest potential for improvement or expansion. It is an analytical prioritisation concept, not a guaranteed future outcome.

## 108. Why isn't opportunity score a revenue forecast?

A score ranks or prioritizes opportunities. A forecast estimates future numerical outcomes using a forecasting or predictive model. The project's opportunity score did not claim to predict future revenue.

## 109. What factors contributed to opportunity scoring?

The model combined standardized business-performance indicators relevant to the specific opportunity analysis. The purpose was to combine several signals into a structured prioritisation framework.

## 110. Why standardise underlying metrics?

Because metrics measured on different scales cannot be meaningfully combined without normalization or another transformation.

## 111. Why use a composite score?

It provides one interpretable prioritisation measure while retaining multiple dimensions of performance.

## 112. Risks of composite scoring?

It can hide individual weaknesses, depend on subjective weights and thresholds, and create an appearance of precision beyond what the underlying assumptions justify.

## 113. How validate a high-opportunity seller/category?

Inspect underlying metrics, compare with historical performance, assess operational feasibility and test the recommendation through an appropriately designed pilot or controlled intervention where feasible.

## 114. What additional data would improve the model?

Potentially margins, inventory, marketing spend, customer acquisition cost, repeat-purchase behaviour, stock availability, competitor pricing and customer demographics.

---

# L. Executive KPI & Business Analytics

## 115. What KPIs did you include?

Revenue, delivered orders, customers, average order value, customer value, seller performance, delivery performance, customer experience and revenue opportunities.

## 116. Why were those KPIs selected?

They represent major dimensions of marketplace health:

> financial performance → customer behaviour → operational execution → seller ecosystem → opportunity.

## 117. Difference between KPI and ordinary metric?

A metric is any measurable value. A KPI is a strategically important metric tied to a business objective, target or decision. Not every metric is a KPI.

## 118. How ensured consistent KPI definitions?

I explicitly defined population, analytical grain, revenue definition, order-status treatment and calculation method, then reused those definitions across investigations.

## 119. Why is consistency important?

If two dashboards calculate "revenue" differently, management can receive apparently conflicting results. Metric governance therefore matters as much as SQL correctness.

## 120. How explain an executive KPI to a non-technical manager?

Explain what it measures, why it matters, how it is calculated at a high level, what the result means and what decision it supports.

---

# M. SQL Performance & Optimisation

## 121. What does EXPLAIN do?

`EXPLAIN` shows PostgreSQL's planned execution strategy, including scans, joins, sorts and estimated costs.

## 122. What does EXPLAIN ANALYZE do?

`EXPLAIN ANALYZE` executes the query and reports actual execution statistics alongside planned estimates.

## 123. Estimated vs actual execution plan?

Estimated plans describe what PostgreSQL expects. `EXPLAIN ANALYZE` provides actual execution statistics from running the query.

## 124. What is a sequential scan?

PostgreSQL reads table pages sequentially rather than locating rows through an index. It is not automatically inefficient and can be cheapest when a large portion of the table is required.

## 125. What is an index scan?

PostgreSQL uses an index to identify relevant rows and then retrieves the corresponding table data.

## 126. What is a bitmap index scan?

A bitmap scan uses an index to identify matching row locations, builds a bitmap of relevant pages/tuples and retrieves table pages efficiently. It can be useful when many rows match.

## 127. Why doesn't PostgreSQL always use an available index?

The planner chooses the lowest estimated-cost strategy. If many rows match, a sequential scan may be cheaper than index lookups.

## 128. What is a partial index?

A partial index indexes only rows satisfying a condition, for example:

```sql
CREATE INDEX ...
ON orders(customer_id)
WHERE order_status = 'delivered';
```

## 129. Why did you create idx_orders_delivered_customer?

The hypothesis was that a partial index on `orders(customer_id) WHERE order_status = 'delivered'` could benefit workloads repeatedly filtering delivered orders and joining through `customer_id`. The experiment tested that hypothesis rather than assuming an improvement.

## 130. What condition did it target?

`order_status = 'delivered'`.

## 131. What was your Q10 baseline execution time?

**1,536.845 ms**

## 132. What happened after creating the index?

The measured post-index execution took **1,583.932 ms**, and PostgreSQL continued using a sequential scan on `orders`.

## 133. Calculate and explain the observed performance change.

Difference:

`1,583.932 − 1,536.845 = 47.087 ms`

Percentage change:

`47.087 / 1,536.845 × 100 ≈ 3.1%`

Therefore, the measured execution was approximately **3.1% slower** after the index.

## 134. Why can't you conclude the index is universally harmful?

This was one workload under one database state, data distribution and execution environment. A different query or workload could benefit. The experiment only shows that it did not improve the tested workload under the measured conditions.

## 135. Why might PostgreSQL continue using a sequential scan?

The query processed a very large proportion of delivered orders—approximately 96,470 rows—so a sequential scan could have been estimated as cheaper than using the index.

## 136. Factors before adding an index?

Query patterns, selectivity, table size, column cardinality, write frequency, storage cost, existing indexes and actual execution plans.

## 137. Costs of indexes?

Indexes consume storage and add maintenance overhead to `INSERT`, `UPDATE` and `DELETE` operations.

## 138. How conduct a more rigorous benchmark?

Establish a true no-index baseline, run multiple repetitions, control for cache/environmental effects, compare execution-time distributions, inspect `BUFFERS`, compare plans, test representative workloads and consider write/storage costs.

---

# N. SQL Debugging & Problem Solving

## 139. Revenue suddenly doubles. How investigate?

First suspect join multiplication. Inspect row counts before/after joins, cardinalities, duplicate keys, one-to-many relationships and order-level revenue before and after each join. Reconcile against a known baseline.

## 140. Query returns fewer customers after adding a join.

Check whether an `INNER JOIN` unintentionally changed the population. If customers without matching records should remain, consider a `LEFT JOIN`. Also check whether later filters on the right table effectively remove unmatched rows.

## 141. Query extremely slow. What investigate first?

Use:

```sql
EXPLAIN (ANALYZE, BUFFERS)
```

Then inspect sequential scans, joins, sorts, row-estimate errors, actual rows, temporary I/O, repeated transformations and the operations consuming the most time.

## 142. LEFT JOIN unexpectedly behaves like INNER JOIN.

A common cause is putting a right-table condition in `WHERE`:

```sql
LEFT JOIN orders o ...
WHERE o.order_status = 'delivered'
```

Unmatched rows become `NULL` and are removed. Depending on the intended logic, move the condition into the `ON` clause.

## 143. Window-function result looks wrong.

Check `PARTITION BY`, `ORDER BY`, duplicate rows, window frame, intended grain, null handling and whether an earlier join multiplied rows.

## 144. Customer appears multiple times unexpectedly.

Possible causes include wrong grain, multiple orders/items/payments/reviews, missing aggregation or an incorrect join condition. Trace row counts and grain through each stage.

## 145. How verify KPI before management presentation?

Validate population, grain, metric definition, joins, null handling, duplicates, edge cases, reconciliation against known totals and result reasonableness.

---

# O. Business Interpretation

## 146. Difference between finding and insight?

A finding describes what the data shows. An insight explains why the finding matters for the business and what decision or question it may support.

## 147. Correlation vs causation?

Correlation means variables are associated. Causation means a change in one factor contributes directly to a change in another. Observational SQL analysis generally establishes association rather than causation.

## 148. Why avoid causal claims?

Historical observational data can contain confounding variables, selection effects and other biases. Without experimental or stronger causal methodology, causal claims should be avoided.

## 149. Example recommendation that should be tested?

If high-performing categories appear to have expansion potential, I would not immediately increase investment. I would test the recommendation through a controlled pilot where feasible and measure incremental revenue, margin and customer response.

## 150. How translate SQL into recommendations?

The workflow was:

> **Business Objective → Metric Definition → Analytical Dataset → Standardisation → Scoring/Classification → Interpretation → Recommendation**

SQL generates evidence; interpretation converts evidence into potential action.

## 151. Explain RETAIN → IMPROVE → EXPAND.

**RETAIN:** protect strong existing performance.  
**IMPROVE:** address measurable weaknesses.  
**EXPAND:** invest further where evidence indicates attractive opportunity.

## 152. Why different implementation horizons?

Recommendations differ in complexity, cost and risk. Some can be implemented immediately, while others require operational changes, additional data or controlled testing.

## 153. How measure whether a recommendation worked?

Define a baseline KPI, implement the intervention, establish a measurement period and compare post-intervention performance with the baseline or, where feasible, a control group. The goal is to assess incremental impact.

## 154. Why are baselines important?

A baseline establishes the starting point against which subsequent performance can be evaluated.

## 155. When is an A/B test or controlled pilot appropriate?

When an intervention can be isolated and there are sufficient observations to compare treatment and control meaningfully. A controlled pilot may be more practical when a full A/B test is not feasible.

---

# P. Project-Specific Defence

## 156. Why choose Olist?

It is a realistic relational e-commerce dataset containing customers, orders, products, sellers, payments, reviews and delivery information, making it suitable for both SQL and business analytics.

## 157. Original business problem?

The project evolved into understanding marketplace performance across customers, sellers, products, revenue, delivery and customer experience and translating those findings into business recommendations.

## 158. How did the project evolve?

It progressed from:

> database design → SQL fundamentals → aggregation → relational analysis → CTEs/views → window functions → strategic analytics → executive reporting → performance optimisation → interview preparation.

The progression was from learning SQL techniques toward applying them to increasingly complex business questions.

## 159. Investigation best demonstrating SQL skills?

The window-function investigations and later strategic analyses demonstrate the broadest SQL capability because they combine joins, CTEs, aggregation, windows, ranking and classification.

## 160. Best demonstrating analytical thinking?

The RFM and scorecard investigations are strong examples because they required defining populations, grains, metrics, standardisation and classification rather than simply retrieving data.

## 161. Best demonstrating business thinking?

The executive KPI, revenue opportunity and final executive review investigations are strong examples because they translate technical analysis into prioritized business actions.

## 162. Most technically difficult?

The later multi-stage strategic analyses and the SQL performance investigation were among the most difficult because they required combining complex SQL with analytical reasoning and performance evaluation.

## 163. Biggest mistake?

A major lesson was that technically valid SQL can still produce incorrect business results when joins unexpectedly change analytical grain or duplicate records. This led me to place greater emphasis on grain and validation.

## 164. What did debugging teach you?

Break complex queries into intermediate datasets and validate each stage rather than diagnosing the entire query at once.

## 165. What analytical decision would you change?

I would define analytical grain, metric definitions and validation requirements earlier, before constructing complex joins.

## 166. Biggest project limitation?

The dataset is historical and observational. It therefore supports descriptive and diagnostic analysis well but has limitations for causal inference and predictive decision-making.

## 167. Additional Olist data wanted?

Product margins, marketing expenditure, inventory, customer acquisition data, seller costs, promotional data and more complete repeat-purchase history beyond the available observation period.

## 168. If given another month?

I would extend the project toward predictive analytics, experimentation and more rigorous validation of opportunity and customer-segmentation frameworks.

## 169. What would you do differently starting today?

Establish the analytical dictionary, grain definitions, validation framework and reusable metric layer earlier to reduce later rework and improve consistency.

---

# Q. Explain This Query

## 170. Walk me through this query.

Explain from the business objective down:

> "The purpose of this query is X. The first CTE establishes Y at this grain. The next CTE aggregates Z. I then join these datasets because... Finally, the window or classification step produces the business output."

Focus on **why**, not merely reading the SQL line by line.

## 171. Why start with this CTE?

Because it establishes the foundational population or grain required by subsequent calculations.

## 172. What is the grain of this CTE?

Explicitly state what one row represents, such as one delivered order or one customer.

## 173. Why use this join?

Explain the business relationship and why the join preserves the intended analytical grain.

## 174. Why is this filter here rather than later?

If it defines the analytical population, applying it at the appropriate stage ensures subsequent calculations use a consistent population and can reduce irrelevant processing.

## 175. Why LEFT JOIN rather than INNER JOIN?

Because the complete left-table population should be retained even when matching records do not exist.

## 176. Why aggregate at this stage?

Aggregation establishes the required analytical grain before later joins or calculations and can prevent row multiplication.

## 177. What happens if GROUP BY is removed?

If aggregate functions remain with non-aggregated selected columns, PostgreSQL will generally reject the query because those columns are neither grouped nor aggregated. If only aggregate expressions remain, removing `GROUP BY` produces one aggregate result over the filtered input.

## 178. Why use this window function?

Explain the business purpose—for example ranking sellers, finding a customer's latest order, calculating change over time or segmenting performance.

## 179. What happens if ties occur?

- `RANK()` gives tied rows the same rank and leaves gaps.
- `DENSE_RANK()` gives tied rows the same rank without gaps.
- `ROW_NUMBER()` assigns unique sequential numbers.

## 180. How would you optimise this query?

Start with:

```sql
EXPLAIN (ANALYZE, BUFFERS)
```

Identify dominant operations rather than automatically adding indexes. Investigate repeated scans, joins, sorts, aggregation, temporary I/O and row-estimation problems.

## 181. How validate query correctness?

Validate row counts, analytical grain, duplicates, totals, sample records, joins, edge cases and reconciliation against known values.

---

# R. Behavioural / Technical Communication

## 182. Tell me about this project.

> "I built a PostgreSQL-based SQL analytics portfolio using the Olist Brazilian e-commerce dataset. I started by designing and validating the relational database, then progressed through aggregation, relational analysis, CTEs, views and window functions. I eventually used those skills to analyse customers, sellers, products, delivery, revenue and executive KPIs, and translated the findings into business recommendations. I also investigated SQL performance using execution plans."

## 183. What was your role?

I was responsible for database implementation, SQL analysis, metric definitions, analytical reasoning, validation, documentation and Git-based project management.

## 184. Most interesting business insight?

Strong commercial performance does not necessarily mean strong overall performance. Seller evaluation becomes more meaningful when revenue is considered alongside fulfilment, customer reviews, delivery and product diversity.

## 185. Tell me about an initially wrong SQL approach.

A recurring lesson was that joining multiple one-to-many tables directly can change analytical grain and duplicate measures. I learned to aggregate at the appropriate grain before joining.

## 186. Difficult debugging problem?

Complex multi-CTE queries were challenging because an error could originate earlier than where the incorrect final result appeared. Breaking the query into intermediate CTEs and validating each stage made debugging more systematic.

## 187. How validate analytical results?

Combine SQL validation with business sanity checks: row counts, uniqueness, reconciliations, expected ranges, sample records and alternative calculations.

## 188. How communicate technical findings to non-technical stakeholders?

Focus on:

> **What happened → why it matters → what should we consider doing → how would we measure it?**

Avoid overwhelming stakeholders with SQL details unless they are relevant.

## 189. How decide which findings are worth presenting?

Prioritize findings that are materially important, supported by reliable data, actionable, connected to business objectives and understandable to the intended audience.

## 190. How handle uncertainty?

Explicitly distinguish what the data demonstrates from what is a hypothesis. Use wording such as "the analysis suggests" rather than "the analysis proves" when causal evidence is unavailable.

## 191. What if a stakeholder challenges your numbers?

Return to the metric definition, population, grain and SQL logic, reproduce the calculation and determine whether the disagreement comes from data, assumptions or interpretation.

---

# S. Portfolio-Level Questions

## 192. Why structure the project into phases?

The phases represent increasing analytical maturity and allowed a systematic progression from database and SQL fundamentals toward advanced analytics, strategic analysis, executive reporting and performance optimisation.

## 193. Why aren't SQL files necessarily one-to-one with investigations?

Investigations are documentation units representing analytical questions, while SQL files represent executable analytical workflows. One SQL file can therefore support multiple closely related investigations.

## 194. Why document investigations separately from SQL scripts?

SQL explains **how** the analysis was performed. Markdown explains the business objective, methodology, assumptions, findings, interpretation, limitations and recommendations.

## 195. Why PostgreSQL rather than another database?

PostgreSQL provided the relational integrity, analytical SQL features, window functions, CTEs and execution-plan tooling required by the project.

## 196. How is the project reproducible?

The repository contains database/schema setup, SQL analysis scripts, documentation and version history. A new user can follow the documented workflow to recreate the environment, subject to having the source dataset and PostgreSQL environment.

## 197. How did Git contribute?

Git provided version control, allowing analytical changes and project milestones to be tracked and the repository history maintained professionally.

## 198. What would improve the repository?

Potential improvements include stronger automated data-quality checks, automated benchmark reporting, a formal data dictionary, more automated SQL testing and eventual dashboard integration.

## 199. How turn it into a production analytics workflow?

A production-oriented workflow could be:

```text
source data
   ↓
ETL/ELT pipeline
   ↓
validated warehouse
   ↓
semantic/metric layer
   ↓
automated SQL tests
   ↓
BI dashboards
   ↓
monitoring
```

It would also include scheduled refreshes, data-quality monitoring, lineage and performance monitoring.

## 200. Give me a five-minute walkthrough of the entire project.

> **"This project is a PostgreSQL-based analysis of the Olist Brazilian e-commerce dataset. I began by importing and validating the nine relational tables and establishing appropriate keys and relationships.**
>
> **I then progressed through SQL fundamentals, aggregation and relational analysis before moving into CTEs, reusable views and window functions. This established the technical foundation for the later business analysis.**
>
> **In the strategic phase, I analysed customer lifetime value, RFM segmentation, seller performance, product portfolios, delivery and customer experience, and revenue opportunities. A major focus was making the analytical grain and metric definitions explicit so that the results remained reliable across different investigations.**
>
> **I then developed executive KPI and business-review analyses, translating the SQL findings into recommendations using a RETAIN, IMPROVE and EXPAND framework.**
>
> **I also investigated SQL performance using EXPLAIN ANALYZE and BUFFERS. One experiment tested a partial index on delivered orders. The baseline Q10 execution was 1,536.845 milliseconds, while the indexed execution was 1,583.932 milliseconds—approximately 3.1% slower in that measured run. PostgreSQL continued using a sequential scan, demonstrating that indexes should be validated empirically rather than assumed to improve performance.**
>
> **Overall, the project demonstrates not just SQL syntax, but the full analytical workflow: understanding the business problem, defining the metric and grain, building reliable SQL, validating the results, interpreting them, communicating recommendations and evaluating the performance of the analytical workload."**

---

# Review Summary

## Overall Assessment

The 200-question preparation set demonstrates strong understanding of the project's progression from SQL fundamentals to business-oriented analytics.

The strongest aspect is that the answers generally connect SQL decisions to:

> **Business Objective → Analytical Grain → Population → Metric Definition → SQL Construction → Validation → Finding → Interpretation → Recommendation**

That is the core reasoning to demonstrate in a Business/Data Analyst interview.

## Strongest Areas

### Analytical Grain

The answers repeatedly recognize that metric meaning depends on what one row represents. This is especially strong in discussions of join multiplication, customer analysis, RFM, seller scorecards, pre-aggregation and KPI validation.

### Metric Definition

The distinction between marketplace payment value, item-level revenue, delivered-order populations, customer-level metrics, historical CLV and opportunity scores is well developed.

### Window Functions

The answers demonstrate practical understanding of `ROW_NUMBER()`, ranking functions, `NTILE()`, `LAG()`, `LEAD()`, running totals, moving averages and window frames.

### Business Interpretation

The distinction between findings and insights, and the deliberate avoidance of unsupported causal claims, are strong.

### SQL Performance

The performance answers correctly avoid assuming that an index must improve performance. The Q10 experiment is useful evidence because PostgreSQL continued using a sequential scan and the measured execution became approximately 3.1% slower.

### Debugging

The answers demonstrate a systematic approach: break complex queries into stages, validate grain, inspect joins and reconcile results.

---

# Important Refinements Made During Review

The original answers were generally strong, but several were tightened for interview-level precision:

- `ROW_NUMBER()` now includes the importance of a deterministic tie-breaker.
- `NTILE(100)` is explicitly described as discrete buckets rather than exact percentiles.
- `LAST_VALUE()` now emphasizes window-frame behaviour.
- `COUNT(DISTINCT column)` is explicitly identified as counting unique non-null values.
- `GROUP BY` removal is distinguished between invalid non-aggregated selections and a valid single aggregate.
- `LEFT JOIN` filtering is explained in terms of the `ON` versus `WHERE` clause.
- The index experiment is explicitly limited to the tested workload rather than generalized.
- Project reproducibility is qualified by the need for the source dataset and PostgreSQL environment.
- KPI and metric definitions are consistently tied to analytical population and grain.

---

# Areas to Continue Practising

## 1. Defend every metric

Be prepared for:

> "Why did you define revenue this way?"

and:

> "Why did you restrict the population to delivered orders?"

Return to:

**business objective → population → grain → metric definition.**

## 2. Explain grain during query walkthroughs

For complex SQL, explain what one row represents at every major stage:

> "At this point there is one row per order."

Then:

> "This aggregation changes the grain to one row per customer."

Then:

> "This join preserves the customer-level grain."

## 3. Practise writing SQL from memory

Be comfortable producing:

- latest order per customer;
- top seller per category;
- customers with multiple orders;
- monthly revenue;
- running totals;
- month-over-month changes;
- duplicate detection;
- conditional aggregation;
- pre-aggregated joins.

## 4. Defend scorecard assumptions

If asked why particular weights or thresholds were chosen, do not claim they are objectively correct.

A stronger answer is:

> "They were analytical assumptions designed to create a prioritisation framework. I would validate their robustness through sensitivity analysis and, ideally, against future business outcomes."

## 5. Explain limitations confidently

The project is strongest when limitations are acknowledged:

- historical CLV is not predictive CLV;
- RFM does not establish causation;
- opportunity scores are not revenue forecasts;
- observational relationships are not causal;
- a single benchmark does not establish universal index performance.

---

# Interview Answer Framework

For difficult project-specific questions:

### 1. Answer directly

Do not begin with unnecessary background.

### 2. Explain the reasoning

Why was the decision made?

### 3. Give the project example

Connect the concept to an actual investigation.

### 4. State the limitation where relevant

This demonstrates analytical maturity.

### 5. Explain what you would do next

Especially for modelling, scoring and performance questions.

A strong response might be:

> **"I used `NTILE(100)` because I wanted a relative performance score that put sellers on a comparable 1–100 scale. However, it is a ranking-based measure rather than an absolute quality score. I would therefore validate the weighting and thresholds through sensitivity analysis and compare the resulting tiers against future outcomes."**

---

# Final Interview Preparation Assessment

The goal of Investigation 47 is not to memorize 200 answers word-for-word.

The objective is to explain the underlying reasoning naturally.

The strongest recurring themes are:

> **Grain**

> **Metric Definition**

> **Population Definition**

> **Join Control**

> **Validation**

> **Standardisation**

> **Business Interpretation**

> **Analytical Limitations**

> **Evidence-Based Recommendations**

If these concepts can be explained consistently, they provide a strong foundation for handling interview questions that are not explicitly contained in this 200-question set.

The project demonstrates a progression from:

> **SQL Syntax**

to:

> **SQL Problem Solving**

to:

> **Analytical Reasoning**

to:

> **Business Decision Support**

---

# Conclusion

Investigation 47 consolidates the technical and analytical knowledge developed throughout the project into an interview-preparation framework.

The preparation covers both **technical SQL competence** and the ability to defend analytical decisions.

The project should not be presented as a collection of SQL queries. It should be presented as an analytical workflow:

> **Business Problem → Business Objective → Analytical Grain → Population → Metric Definition → SQL → Validation → Findings → Insights → Recommendations**

This is the strongest narrative connecting the technical work with the business-analysis skills demonstrated throughout the project.

---

**Investigation Status:** Completed  
**Questions Reviewed:** 200  
**Primary Focus:** Technical SQL, PostgreSQL, analytical reasoning, business interpretation and project defence  
**Overall Project Status:** Investigation 47 completed; the overall portfolio project remains in progress.
