# Investigation 35 — RFM Customer Segmentation

## 1. Investigation Overview

### Business Objective

Build a **Recency, Frequency and Monetary (RFM) customer segmentation framework** using historical delivered-order behaviour.

The investigation moves beyond simply measuring customer revenue. It evaluates customers according to three complementary dimensions:

- **Recency** — how recently the customer purchased.
- **Frequency** — how often the customer purchased.
- **Monetary** — how much delivered-order revenue the customer generated.

The resulting framework produces both:

1. A continuous **RFM score from 0–100**, and
2. A behavioural **customer segment**.

The analysis is designed as a reusable customer-level analytical layer that can support subsequent customer strategy and dashboard analysis.

---

## 2. Analytical Design

| Component | Definition |
|---|---|
| Analytical grain | One row per `customer_unique_id` |
| Population | Customers with at least one delivered order |
| Order status | `delivered` |
| Revenue | `order_payments.payment_value` |
| Recency reference date | Latest delivered purchase date in the analytical population |
| Recency direction | Lower `recency_days` = better |
| Frequency direction | Higher frequency = better |
| Monetary direction | Higher revenue = better |
| Normalisation | `PERCENT_RANK() × 100` |
| Recency normalisation | `(1 - PERCENT_RANK()) × 100` |
| RFM weights | Recency 30%, Frequency 30%, Monetary 40% |
| Quartile method | `NTILE(4)` |
| Final score | Weighted 0–100 RFM score |

---

# 3. Revenue Definition and Join Strategy

Revenue is defined consistently as:

```text
order_payments.payment_value
```

The investigation deliberately aggregates payment records to the **order level first**:

```sql
SELECT
    order_id,
    SUM(payment_value) AS order_revenue
FROM order_payments
GROUP BY order_id
```

This prevents payment values from being multiplied if the analysis is later joined to tables containing multiple rows per order, such as `order_items`.

This is particularly important in the Olist dataset because the analytical grain changes between:

- customer
- order
- order item
- payment

The investigation therefore establishes the customer-level RFM dataset only after order-level revenue has been safely calculated.

---

# 4. Investigation Questions

The investigation contains 15 business questions.

| Q | Business Question | Analytical Purpose |
|---|---|---|
| Q1 | Which customers are eligible for RFM analysis? | Establish analytical population |
| Q2 | How many days have passed since each customer's latest delivered purchase? | Build Recency |
| Q3 | How many delivered orders has each customer placed? | Build Frequency |
| Q4 | How much delivered-order revenue has each customer generated? | Build Monetary |
| Q5 | Can RFM metrics be combined into one customer-level dataset? | Establish RFM base |
| Q6 | What does the customer recency distribution look like? | Understand recency behaviour |
| Q7 | What do Frequency and Monetary distributions look like? | Understand F/M behaviour |
| Q8 | Which customers have the strongest recent purchasing activity? | Rank Recency |
| Q9 | How do customers rank independently on Frequency and Monetary value? | Compare F/M dimensions |
| Q10 | How can RFM metrics be normalised to 0–100? | Create comparable scores |
| Q11 | How should the normalised RFM metrics be weighted? | Build composite score |
| Q12 | How should customers be divided into RFM quartiles? | Establish behavioural bands |
| Q13 | How should customers be assigned to behavioural segments? | Create actionable segments |
| Q14 | Do the resulting RFM segments actually behave differently? | Validate segmentation |
| Q15 | Can the complete RFM framework be exposed through a reusable view? | Create final analytical layer |

---

# 5. Q1 — Analytical Customer Population

The first investigation establishes the eligible population.

Only customers associated with at least one:

```text
order_status = 'delivered'
```

order are included.

The customer identifier is:

```text
customers.customer_unique_id
```

rather than `orders.customer_id`.

This distinction is important because `customer_id` identifies the individual order-level customer record, while `customer_unique_id` represents the customer identity used for longitudinal customer analysis.

### Output

One row per customer containing:

- customer identifier
- delivered order count
- first delivered purchase date
- latest delivered purchase date

---

# 6. Q2 — Recency

## Definition

Recency measures the number of days between:

```text
RFM reference date
-
customer's latest delivered purchase date
```

The reference date is:

```text
MAX(latest_purchase_date)
```

across the analytical population.

This means the analysis uses a **dataset-relative historical reference date**, rather than the current calendar date.

### Why this matters

Using the latest delivered purchase in the population provides a consistent historical snapshot.

A customer with:

```text
recency_days = 10
```

is more recently active than one with:

```text
recency_days = 300
```

Therefore:

> Lower recency is better.

---

# 7. Q3 — Frequency

Frequency is defined as:

```text
COUNT(DISTINCT delivered order_id)
```

for each `customer_unique_id`.

Only delivered orders are included.

This measures actual completed purchasing behaviour rather than orders that were cancelled, unavailable, or otherwise failed to reach delivered status.

---

# 8. Q4 — Monetary Value

Monetary value is defined as the customer's historical delivered-order revenue:

```text
SUM(order_payments.payment_value)
```

The analysis first aggregates payments to the order level and then aggregates those order revenues to the customer.

This gives:

```text
customer lifetime delivered-order revenue
```

within the historical Olist dataset.

---

# 9. Q5 — RFM Base Dataset

The three metrics are combined into a customer-level dataset:

| Customer | Recency | Frequency | Monetary |
|---|---:|---:|---:|
| Customer A | 10 | 5 | 900 |
| Customer B | 120 | 2 | 250 |
| Customer C | 30 | 8 | 1,500 |

The analytical grain remains:

> **One row per `customer_unique_id`.**

This dataset becomes the foundation for scoring and segmentation.

---

# 10. Q6 — Recency Distribution

The investigation examines:

- minimum
- maximum
- average
- Q1
- median
- Q3
- P90

The distribution analysis is important because RFM scoring can behave differently when a metric is highly concentrated.

For example, if most customers have very recent purchases while a smaller group is extremely inactive, the distribution will be highly skewed.

That distribution informs the interpretation of the resulting RFM scores.

---

# 11. Q7 — Frequency and Monetary Distributions

Frequency and Monetary are also examined using:

- minimum
- maximum
- average
- Q1
- median
- Q3
- P90

This provides context before normalisation.

Frequency in particular is expected to be highly concentrated around one-time customers in many transactional datasets.

Monetary value may also be skewed because a relatively small number of customers can generate disproportionately high revenue.

These characteristics make percentile-based normalisation useful for the framework.

---

# 12. Q8 — Recency Ranking

Customers are ranked by:

```sql
RANK() OVER (
    ORDER BY recency_days ASC
)
```

Because lower recency is better:

```text
Rank 1 = strongest recent activity
```

Ties receive the same rank.

This ranking is primarily exploratory. The final RFM framework uses percentile-based scoring rather than the raw rank.

---

# 13. Q9 — Independent Frequency and Monetary Rankings

Frequency and Monetary are ranked independently.

### Frequency

```text
Higher frequency = better rank
```

### Monetary

```text
Higher revenue = better rank
```

This makes it possible to identify different customer profiles.

For example:

| Behaviour | Frequency | Monetary |
|---|---:|---:|
| Frequent low spenders | High | Low |
| Infrequent high spenders | Low | High |
| Core valuable customers | High | High |
| Weak customers | Low | Low |

This demonstrates why RFM requires multiple dimensions rather than relying on revenue alone.

---

# 14. Q10 — RFM Normalisation

The investigation converts all three metrics to a common **0–100 scale**.

The selected method is:

```text
PERCENT_RANK() × 100
```

### Frequency

```sql
PERCENT_RANK() OVER (
    ORDER BY order_frequency ASC
) * 100
```

Higher frequency receives a higher score.

### Monetary

```sql
PERCENT_RANK() OVER (
    ORDER BY lifetime_revenue ASC
) * 100
```

Higher revenue receives a higher score.

### Recency

Recency has the opposite direction.

Lower days are better, so the percentile rank is inverted:

```sql
(
    1 -
    PERCENT_RANK() OVER (
        ORDER BY recency_days ASC
    )
) * 100
```

Therefore:

```text
Most recent customer → high recency score
Least recent customer → low recency score
```

---

# 15. Why PERCENT_RANK Was Selected

Percentile ranking is appropriate because the RFM metrics do not need to be interpreted in their original units when constructing the composite score.

A revenue value of:

```text
R$100
```

and:

```text
R$10,000
```

cannot be directly combined with:

```text
10 days
```

of recency and:

```text
5 orders
```

Percentile scoring puts all three metrics on the same relative scale:

```text
0–100
```

This makes weighted combination possible.

### Important characteristic

`PERCENT_RANK()` preserves relative ordering and gives identical values the same percentile position.

This is especially useful for highly repeated values such as:

- frequency = 1
- recency = 0
- other repeated transactional values.

---

# 16. Q11 — Weighted RFM Score

The final RFM score uses:

| Metric | Weight |
|---|---:|
| Recency | 30% |
| Frequency | 30% |
| Monetary | 40% |
| **Total** | **100%** |

The formula is:

```text
RFM Score =
    Recency Score × 0.30
  + Frequency Score × 0.30
  + Monetary Score × 0.40
```

The model deliberately gives Monetary the highest weight because the investigation is intended to identify customers with the greatest combination of current engagement and economic value.

The resulting score remains on a:

```text
0–100
```

scale.

---

# 17. Q12 — RFM Quartiles

`NTILE(4)` is used to divide customers into four relative groups for each RFM dimension.

### Recency

```text
Quartile 1 = most recent
Quartile 4 = least recent
```

### Frequency

```text
Quartile 1 = lowest frequency
Quartile 4 = highest frequency
```

### Monetary

```text
Quartile 1 = lowest monetary value
Quartile 4 = highest monetary value
```

These quartiles are not the same thing as the weighted RFM score.

The score measures:

> **Overall relative RFM strength.**

The quartiles describe:

> **Behavioural position on each individual dimension.**

---

# 18. Q13 — Customer Segmentation

The investigation converts the three quartile positions into behavioural customer segments.

## 1. Champions

```text
Recency = 1
Frequency = 4
Monetary = 4
```

These customers combine the strongest recent activity with high purchasing frequency and high monetary value.

## 2. Loyal Customers

Customers with:

- relatively strong frequency
- relatively strong monetary value
- strong recency

but not necessarily the exact Champion combination.

## 3. Recent Customers

Customers who are:

- very recent
- but not yet highly established in Frequency or Monetary.

These customers may represent promising acquisition-to-retention opportunities.

## 4. Potential Loyalists

Customers showing relatively strong recency combined with moderate-to-strong Frequency and Monetary characteristics.

## 5. At Risk

Customers with weaker recency but evidence of meaningful historical engagement through Frequency or Monetary value.

These customers can represent important retention opportunities.

## 6. Lost Customers

Customers with:

- worst recency quartile
- low frequency
- low monetary value.

## 7. Standard

Customers who do not satisfy the more specific behavioural rules.

---

# 19. Why a Hierarchical CASE Expression Is Used

The segmentation rules can overlap.

For example, a Champion could also satisfy a broader Loyal Customer condition.

The ordered `CASE` expression resolves this by evaluating the most specific/high-value condition first.

The hierarchy is:

```text
Champions
    ↓
Loyal Customers
    ↓
Recent Customers
    ↓
Potential Loyalists
    ↓
At Risk
    ↓
Lost Customers
    ↓
Standard
```

This ensures:

> Every customer receives exactly one segment.

---

# 20. Q14 — Segment Validation

The segmentation is not considered successful merely because every customer receives a label.

The segments must demonstrate meaningful behavioural differences.

The validation compares:

- customer count
- customer percentage
- total lifetime revenue
- revenue percentage
- average recency
- average frequency
- average monetary value
- average RFM score

### Expected directional behaviour

A strong segmentation should generally show:

**Champions**

```text
Lower recency
Higher frequency
Higher monetary value
Higher RFM score
```

**Lost Customers**

```text
Higher recency
Lower frequency
Lower monetary value
Lower RFM score
```

The validation output therefore tests whether the business labels correspond to actual behavioural differences.

---

# 21. Q15 — Reusable RFM Customer Dashboard

The investigation creates:

```text
rfm_customer_dashboard
```

This is the authoritative reusable analytical view.

### Grain

```text
One row per customer_unique_id
```

### Core behavioural metrics

- `first_purchase_date`
- `latest_purchase_date`
- `rfm_reference_date`
- `recency_days`
- `frequency`
- `lifetime_revenue`

### Relative rankings

- `recency_rank`
- `frequency_rank`
- `monetary_rank`

### Normalised scores

- `recency_score`
- `frequency_score`
- `monetary_score`

### Quartiles

- `recency_quartile`
- `frequency_quartile`
- `monetary_quartile`

### Final outputs

- `rfm_score`
- `rfm_rank`
- `customer_segment`

---

# 22. Why the RFM Reference Date Is Retained

The final dashboard explicitly stores:

```text
latest_purchase_date
rfm_reference_date
recency_days
```

This makes the recency calculation auditable.

For example, instead of seeing only:

```text
recency_days = 250
```

the dashboard shows the underlying dates used to derive the value.

This is important for portfolio-quality analytical models because a metric should be explainable and reproducible.

---

# 23. RFM Score vs RFM Segment

An important methodological distinction is maintained.

### RFM Score

The continuous score is calculated from:

```text
30% Recency
30% Frequency
40% Monetary
```

It measures:

> **Overall relative RFM strength.**

### RFM Segment

The segment is calculated from the three independent quartile positions.

It measures:

> **Behavioural customer type.**

Therefore, the segment is **not simply a bucket of the RFM score**.

Two customers can have similar RFM scores but different behavioural profiles.

This is intentional.

---

# 24. Final Validation Checks

The SQL script includes validation for:

### Score ranges

The component scores should remain between:

```text
0 and 100
```

The composite RFM score should also remain between:

```text
0 and 100
```

### Weight validation

```text
0.30 + 0.30 + 0.40 = 1.00
```

### Segment coverage

The dashboard should assign every analytical customer to exactly one segment.

### Reference-date consistency

All customers should use the same RFM reference date.

### Grain validation

The number of dashboard rows should equal the number of distinct customers.

---

# 25. Analytical Interpretation Framework

Once the SQL is executed, the investigation should be interpreted in the following order:

### Step 1 — Understand the population

How many customers qualify for RFM analysis?

### Step 2 — Understand the distributions

Are Recency, Frequency and Monetary highly skewed?

### Step 3 — Examine the normalised scores

Do the percentile scores behave as expected?

### Step 4 — Examine the RFM score

Which customers have the highest overall RFM strength?

### Step 5 — Examine segment composition

How large is each customer segment?

### Step 6 — Examine revenue concentration

Which segments contribute the greatest proportion of revenue?

### Step 7 — Validate behavioural separation

Do the segments actually exhibit different:

- recency
- frequency
- monetary value
- RFM score

patterns?

---

# 26. Business Questions Enabled by the Framework

The completed RFM layer supports questions such as:

- Who are the most valuable currently active customers?
- How concentrated is revenue among Champions and Loyal Customers?
- How many customers are potentially at risk?
- Which customers have high historical value but poor recent engagement?
- Which recently acquired customers show potential to become loyal?
- How much revenue is associated with At Risk customers?
- Which segments should receive retention-oriented strategies?
- Which segments represent opportunities for customer development?

---

# 27. Limitations

The RFM model is a **historical behavioural segmentation**, not a predictive customer lifetime value model.

It does not directly estimate:

- future revenue
- churn probability
- future purchase date
- customer acquisition cost
- profit margin
- expected lifetime value

It should therefore be interpreted as a descriptive and strategic segmentation framework.

### Historical reference date

The RFM reference date is the latest delivered purchase in the dataset rather than the current date.

This is appropriate for a historical dataset, but means the model represents the customer's position relative to the dataset's historical endpoint.

### Percentile-based scores

Percentile scores measure relative position within the analytical population.

A score of 90 means the customer ranks very highly relative to other customers in this population; it does not mean the customer has achieved 90% of some absolute business target.

### Quartile boundaries

`NTILE(4)` creates four approximately equal-sized groups, but repeated metric values can mean that the groups do not correspond exactly to statistical percentile cut-points.

This is acceptable because the quartiles are being used as behavioural segmentation bands.

---

# 28. Portfolio / Interview Value

This investigation demonstrates several important analytical skills:

### SQL

- multi-table joins
- CTEs
- aggregation
- `COUNT(DISTINCT)`
- `PERCENT_RANK()`
- `RANK()`
- `NTILE()`
- conditional segmentation
- window functions
- reusable SQL views

### Data modelling

The investigation explicitly manages:

```text
customer grain
→ order grain
→ payment grain
→ customer analytical grain
```

### Analytical reasoning

The project demonstrates that:

> A metric cannot be combined into a weighted model until the metrics are made comparable.

That leads to:

```text
Raw metrics
      ↓
Distribution analysis
      ↓
Percentile normalisation
      ↓
Weighted RFM score
      ↓
Behavioural quartiles
      ↓
Customer segments
      ↓
Validation
      ↓
Reusable dashboard
```

### Business thinking

The analysis translates transactional data into actionable customer groups rather than stopping at descriptive SQL outputs.

---

# 29. Final Investigation Deliverables

The investigation produces two primary artefacts:

### SQL

`35_rfm_customer_segmentation.sql`

Contains:

- Q1–Q15
- RFM normalisation
- weighting model
- quartile framework
- segmentation logic
- validation queries
- reusable `rfm_customer_dashboard` view

### Markdown

`35_rfm_customer_segmentation.md`

Documents:

- business objective
- analytical definitions
- methodology
- all 15 questions
- scoring framework
- weighting rationale
- segmentation logic
- validation approach
- limitations
- business interpretation
- portfolio value

---

# 30. Final Methodology Summary

The completed Investigation 35 follows this analytical pipeline:

```text
Delivered Orders
      ↓
Eligible Customers
      ↓
Customer-Level RFM Base
      ↓
┌────────────┬────────────┬────────────┐
│  Recency   │ Frequency  │ Monetary   │
└────────────┴────────────┴────────────┘
      ↓
PERCENT_RANK Normalisation
      ↓
0–100 Component Scores
      ↓
30% R + 30% F + 40% M
      ↓
Composite RFM Score
      ↓
NTILE(4) Behavioural Quartiles
      ↓
Hierarchical Customer Segmentation
      ↓
Segment Validation
      ↓
rfm_customer_dashboard
```

## Conclusion

Investigation 35 establishes a complete, reusable **RFM customer segmentation framework** for the Olist dataset.

The investigation progresses from raw delivered-order behaviour to customer-level metrics, normalised scores, weighted RFM scoring, behavioural segmentation, validation, and finally a reusable analytical view.

This creates the customer-level foundation required for the next strategic customer analyses in the project.
