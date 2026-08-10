# Investigation 34: Customer Lifetime Value (CLV) Analysis

## Overview

Investigation 34 develops a historical **Customer Lifetime Value (CLV) framework** for the Olist e-commerce dataset.

The objective is not to predict future customer revenue. Instead, the investigation measures **realised historical customer value** using delivered orders and combines four customer-level metrics:

- Lifetime Revenue
- Purchase Frequency
- Average Order Value (AOV)
- Purchasing Lifespan

These metrics are normalized to a common 0–100 scale using `PERCENT_RANK()` and combined through a weighted Customer Value Score.

The investigation therefore moves beyond isolated customer metrics and demonstrates how SQL can construct a reusable customer-value framework suitable for customer analytics, CRM analysis and dashboard development.

---

# Business Objective

The investigation aims to answer the following business questions:

1. Who belongs to the analytical customer population?
2. How much lifetime revenue has each customer generated?
3. How frequently does each customer purchase?
4. When did each customer's first delivered purchase occur?
5. When did each customer's latest delivered purchase occur?
6. How long has each customer's purchasing relationship lasted?
7. How is lifetime revenue distributed across customers?
8. How are purchase frequency and AOV distributed?
9. How is purchasing lifespan distributed, and how many customers are one-time customers?
10. How can the customer metrics be normalized to a common 0–100 scale?
11. How should the normalized metrics be combined into a weighted Customer Value Score?
12. How sensitive are customer classifications to alternative weighting models?
13. How can customers be classified into actionable value tiers?
14. Do the resulting tiers display meaningful differences in customer behaviour and revenue contribution?
15. How can the complete framework be exposed as a reusable customer-value dashboard?

---

# Analytical Scope and Definitions

## Customer Population

The analytical population consists of customers with **at least one delivered order**.

This ensures that the framework measures customers associated with completed transactions rather than including cancelled, unavailable, created, invoiced or otherwise non-delivered orders.

## Customer Grain

The analytical grain is:

> **One row per `customer_unique_id`**

The `customer_unique_id` is used because the Olist customer table can contain multiple records representing the same underlying customer across orders.

## Revenue Definition

Historical customer revenue is defined as:

```text
Lifetime Revenue = SUM(order_payments.payment_value)
```

Only payments associated with delivered orders are included.

This is a historical realised-value measure rather than a predictive CLV model.

---

# Customer Value Framework

The framework combines four metrics.

| Metric | Definition | Normalization | Weight |
|---|---|---|---:|
| Lifetime Revenue | Total payment value from delivered orders | `PERCENT_RANK() × 100` | **40%** |
| Purchase Frequency | Number of distinct delivered orders | `PERCENT_RANK() × 100` | **25%** |
| AOV | Lifetime revenue ÷ delivered orders | `PERCENT_RANK() × 100` | **20%** |
| Purchasing Lifespan | Latest delivered purchase − first delivered purchase | `PERCENT_RANK() × 100` | **15%** |
| **Total** | | | **100%** |

The base score is:

```text
Customer Value Score =
    Revenue Score × 0.40
  + Frequency Score × 0.25
  + AOV Score × 0.20
  + Lifespan Score × 0.15
```

---

# Why Percentile-Rank Normalization?

The four metrics exist on very different scales.

For example:

- Revenue is measured in currency.
- Frequency is measured in orders.
- AOV is measured in currency per order.
- Lifespan is measured in days.

Directly combining these raw metrics would therefore be inappropriate.

`PERCENT_RANK()` converts each metric into a relative position within the customer population.

The investigation uses:

```sql
PERCENT_RANK() OVER (ORDER BY metric) * 100
```

This produces a score between approximately 0 and 100, where higher values represent stronger relative performance.

### Interpretation

A customer with a revenue score of approximately 90 is positioned near the top of the customer revenue distribution.

This allows otherwise incompatible metrics to contribute to a common weighted score.

---

# Important Interpretation of Ties

`PERCENT_RANK()` preserves tied values.

This is particularly important for:

- Purchase frequency, where many customers may have exactly one order.
- Purchasing lifespan, where many one-time customers have a lifespan of zero days.

The model therefore does not artificially force tied customers into different positions.

This is preferable to arbitrary ranking when the underlying metric values are identical.

---

# Customer Value Tiers

The base Customer Value Score is translated into five business-oriented tiers.

| Score | Tier |
|---:|---|
| **90–100** | VIP |
| **75–89.99** | High Value |
| **60–74.99** | Growth |
| **40–59.99** | Standard |
| **0–39.99** | Low Value |

These thresholds are business classification rules rather than statistical claims.

---

# Investigation Breakdown

## Q1 — Analytical Customer Population

The first query establishes the population used throughout the investigation.

It identifies:

- Number of analytical customers
- Number of delivered orders
- Earliest delivered purchase
- Latest delivered purchase

### Business Value

Establishing the analytical population before calculating KPIs ensures that subsequent calculations use a consistent business definition.

---

## Q2 — Historical Lifetime Revenue

The query calculates total historical payment value generated by each customer through delivered orders.

### KPI

**Lifetime Revenue**

### Business Value

This establishes the primary economic measure of customer value.

---

## Q3 — Purchase Frequency and AOV

The query combines:

- Delivered order frequency
- Lifetime revenue
- Average Order Value

AOV is calculated as:

```text
AOV = Lifetime Revenue / Number of Delivered Orders
```

### Business Value

This distinguishes customers who purchase frequently from customers whose purchases are individually more valuable.

---

## Q4 — First Purchase

The earliest delivered purchase is identified for each customer using `MIN()`.

### KPI

**First Purchase Date**

### Business Value

This establishes the beginning of the customer's observed purchasing relationship.

---

## Q5 — Latest Purchase

The most recent delivered purchase is identified using `MAX()`.

### KPI

**Latest Purchase Date**

### Business Value

This establishes the end of the customer's observed historical purchasing activity.

---

## Q6 — Purchasing Lifespan

Purchasing lifespan is calculated as the difference between the latest and first delivered purchase dates.

### KPI

**Purchasing Lifespan in Days**

### Business Value

This provides a measure of the duration of the customer's observed purchasing relationship.

A customer with only one delivered order has a lifespan of zero days.

---

## Q7 — Lifetime Revenue Distribution

The query examines the distribution of lifetime revenue using:

- Minimum
- Maximum
- Mean
- Q1
- Median
- Q3
- P90
- P95

### Business Value

Revenue distributions help reveal concentration and skewness before customer scores are constructed.

This is particularly important for e-commerce data because customer spending can be highly uneven.

---

## Q8 — Frequency and AOV Distributions

The query profiles:

- Minimum frequency
- Maximum frequency
- Average frequency
- Median frequency
- Q3 frequency
- Minimum AOV
- Maximum AOV
- Average AOV
- Median AOV
- Q3 AOV

### Business Value

These statistics establish the underlying behaviour of the customer population before normalization and weighting are applied.

---

## Q9 — Lifespan Distribution and One-Time Customers

The query measures:

- Number of customers
- One-time customers
- One-time customer percentage
- Minimum lifespan
- Maximum lifespan
- Average lifespan
- Median lifespan
- Q3 lifespan
- P90 lifespan

### Business Value

The one-time customer rate is particularly important because it highlights the difference between acquiring customers and retaining them.

---

# Q10 — Metric Normalization

The four customer metrics are transformed into 0–100 percentile scores:

- Revenue Score
- Frequency Score
- AOV Score
- Lifespan Score

### Business Value

Normalization creates a common scale that allows heterogeneous customer metrics to be combined.

---

# Q11 — Base Customer Value Score

The normalized metrics are combined using the base weighting model:

| Metric | Weight |
|---|---:|
| Revenue | **40%** |
| Frequency | **25%** |
| AOV | **20%** |
| Lifespan | **15%** |

Revenue receives the highest weight because the model is primarily intended to identify customers who have generated substantial historical economic value.

Frequency receives the second-highest weight because repeat purchasing represents an important behavioural indicator.

AOV captures transaction quality, while lifespan provides a secondary relationship-duration signal.

---

# Q12 — Weighting Sensitivity Analysis

Three weighting models are compared.

## Economic Model

| Metric | Weight |
|---|---:|
| Revenue | 50% |
| Frequency | 20% |
| AOV | 20% |
| Lifespan | 10% |

This model prioritizes historical monetary contribution.

## Relationship Model

| Metric | Weight |
|---|---:|
| Revenue | 30% |
| Frequency | 30% |
| AOV | 15% |
| Lifespan | 25% |

This model gives greater emphasis to repeated purchasing and relationship duration.

## Balanced Model

| Metric | Weight |
|---|---:|
| Revenue | 40% |
| Frequency | 25% |
| AOV | 20% |
| Lifespan | 15% |

This is the base model selected for the investigation.

### Business Value

Sensitivity analysis demonstrates that customer classification depends partly on the business objective.

A customer can appear more attractive under an economic model than under a relationship-oriented model, depending on the relative importance assigned to revenue, frequency and lifespan.

---

# Q13 — Customer Value Classification

Customers are assigned to five value tiers:

- VIP
- High Value
- Growth
- Standard
- Low Value

### Business Value

The classification converts a continuous numerical score into actionable business groups.

Possible applications include:

- VIP relationship management
- Loyalty programmes
- Targeted promotions
- Retention campaigns
- Customer prioritisation

---

# Q14 — Tier Validation

The query validates whether the tiers exhibit meaningful differences in:

- Customer count
- Customer percentage
- Total revenue
- Revenue percentage
- Average revenue
- Average frequency
- Average AOV
- Average lifespan
- Average Customer Value Score

### Business Value

A segmentation model should not simply produce labels.

The resulting groups should also demonstrate interpretable differences in the underlying customer metrics.

This validation step therefore acts as a basic model-diagnostic layer.

---

# Q15 — Reusable Customer Value Dashboard

The final query creates:

```text
customer_value_dashboard
```

The view combines the major customer-value attributes into a reusable analytical dataset.

The dashboard contains:

- Customer identifier
- Lifetime revenue
- Order frequency
- Average Order Value
- First purchase date
- Latest purchase date
- Purchasing lifespan
- Revenue score
- Frequency score
- AOV score
- Lifespan score
- Customer Value Score
- Customer Value Tier
- Revenue rank
- Customer Value rank
- Economic Contribution Score
- Relationship-Oriented Score

### Business Value

The view provides a reusable analytical layer that can be queried directly by downstream dashboards or reporting workflows.

---

# Alternative Scoring Models

The final dashboard retains two additional scores:

### Economic Contribution Score

```text
Revenue       50%
Frequency     20%
AOV           20%
Lifespan      10%
```

This score emphasizes historical economic contribution.

### Relationship-Oriented Score

```text
Revenue       30%
Frequency     30%
AOV           15%
Lifespan      25%
```

This score emphasizes behavioural engagement and relationship duration.

The base Customer Value Score remains the primary classification score.

---

# SQL Techniques Demonstrated

This investigation demonstrates:

- `INNER JOIN`
- `SUM()`
- `COUNT(DISTINCT)`
- `MIN()`
- `MAX()`
- `AVG()`
- `ROUND()`
- `NULLIF()`
- `EXTRACT(EPOCH FROM ...)`
- `FILTER`
- `PERCENTILE_CONT()`
- `PERCENT_RANK()`
- Window functions
- Multiple CTEs
- `CASE`
- Weighted KPI construction
- Analytical views
- Ranking
- Distribution analysis
- Model sensitivity analysis
- Customer segmentation

---

# Data Modelling Considerations

## Customer Grain

The final analytical model operates at:

```text
customer_unique_id
```

This prevents the analysis from treating multiple Olist customer records associated with the same underlying customer as separate customers.

## Order Grain

Order frequency is calculated using:

```sql
COUNT(DISTINCT o.order_id)
```

This prevents duplicate order rows from inflating the frequency metric.

## Payment Grain

Revenue is sourced from:

```text
order_payments.payment_value
```

The payment table is joined through `order_id`.

Because the payment data can contain multiple payment records for an order, the revenue calculation aggregates all payment values associated with each delivered order.

---

# Model Limitations

The framework should be interpreted within its analytical scope.

## Historical Rather Than Predictive

This is a realised historical customer-value framework.

It does not predict:

- Future customer spending
- Future purchases
- Churn probability
- Expected remaining customer lifetime
- Discounted future cash flow

Therefore, it should not be described as a predictive CLV model.

## Lifespan Is Observed Purchasing Duration

Purchasing lifespan is:

```text
Latest observed delivered purchase
-
First observed delivered purchase
```

It is not the customer's true lifetime with the company.

A customer with one order has a lifespan of zero days, even though the customer may have been acquired and lost over a longer unobserved period.

## Recency Is Not a Base Score

The model does not explicitly include recency as one of its four weighted metrics.

This is deliberate.

The framework focuses on historical customer value through:

- Revenue
- Frequency
- AOV
- Lifespan

Recency becomes more important in subsequent customer segmentation analysis.

---

# Normalization and Weighting Summary

The complete scoring pipeline is:

```text
Raw Customer Metrics
        ↓
Revenue
Frequency
AOV
Lifespan
        ↓
PERCENT_RANK()
        ↓
0–100 Normalized Scores
        ↓
Weighted Combination
        ↓
Customer Value Score
        ↓
Customer Value Tier
        ↓
Dashboard / Analytical View
```

This architecture demonstrates an important business analytics principle:

> Metrics should be made comparable before being combined into a composite KPI.

---

# Business Applications

The resulting customer-value framework can support:

### Customer Relationship Management

Identify customers who deserve differentiated relationship treatment.

### Loyalty Programmes

Prioritize high-value customers for loyalty initiatives.

### Marketing

Allocate promotional resources according to customer value.

### Retention

Identify valuable customers whose behavioural profile warrants further investigation.

### Executive Reporting

Provide a concise customer-value KPI framework for management dashboards.

### Customer Analytics

Create a reusable customer-level analytical dataset for downstream segmentation and modelling.

---

# Conclusion

Investigation 34 represents a transition from individual customer metrics toward **composite business KPI development**.

The analysis begins by establishing a consistent delivered-customer population and then constructs four core measures of historical customer value:

- Lifetime Revenue
- Purchase Frequency
- Average Order Value
- Purchasing Lifespan

Because these metrics operate on different scales, `PERCENT_RANK()` is used to normalize them to a common 0–100 scale. The normalized metrics are then combined using a transparent weighting model to produce a Customer Value Score.

The investigation also introduces weighting sensitivity analysis, allowing economic and relationship-oriented perspectives to be compared with the balanced base model.

Finally, the model is converted into the reusable `customer_value_dashboard` view, creating an analytical layer suitable for downstream reporting and business intelligence.

The resulting framework demonstrates how PostgreSQL can be used not merely to retrieve data, but to construct transparent, interpretable and reusable business scoring systems from transactional data.
