# Investigation 39 — Activity Threshold Analysis

## 1. Investigation Overview

### Business Area

Strategic Business Analytics — Analytical Population Design

### Investigation Objective

The objective of Investigation 39 is to determine appropriate minimum delivered-order activity thresholds for sellers and product categories before constructing the Revenue Opportunity Scorecard in Investigation 40.

The investigation addresses an important analytical problem:

> **How much observed activity is enough for an entity to participate in a comparative opportunity analysis?**

Very small sellers or product categories may have unstable averages, rankings, and percentile scores. At the same time, an excessively high threshold may remove too much of the marketplace from the analysis.

Therefore, the investigation evaluates the trade-off between:

* population coverage;
* activity coverage;
* sample stability;
* comparative reliability; and
* analytical usefulness.

The investigation ultimately establishes the activity thresholds carried into Investigation 40.

---

# 2. Business Problem

Investigation 40 will compare sellers and product categories using:

* revenue headroom;
* customer acceptance;
* operational readiness; and
* market activity.

However, these metrics are only meaningful if the entities being compared have sufficient observed activity.

For example, a seller with only a handful of delivered orders may have a very high average review score or perfect delivery rate simply because the underlying sample is very small.

Similarly, a product category with very few delivered orders may appear unusually strong or weak because of limited observations.

The threshold analysis therefore precedes the scorecard.

The sequence is:

```text
Activity Distribution
        ↓
Threshold Candidates
        ↓
Coverage Analysis
        ↓
Sensitivity Analysis
        ↓
Threshold Decision
        ↓
Investigation 40
```

---

# 3. Analytical Questions

The investigation contains 15 analytical questions.

## Seller Activity

### Q1 — Seller Activity Distribution

How is delivered-order activity distributed across sellers?

The analysis examines:

* minimum activity;
* 25th percentile;
* median;
* 75th percentile;
* 90th percentile; and
* maximum activity.

### Q2 — Seller Activity Bands

How many sellers fall into different delivered-order activity bands?

The bands provide an easier business interpretation of the seller activity distribution.

### Q3 — Seller Threshold Coverage

What percentage of sellers would remain in the analysis under alternative thresholds?

Candidate thresholds include:

* 5 orders;
* 10 orders;
* 20 orders; and
* 50 orders.

### Q4 — Seller Threshold Candidates

Which sellers meet the proposed minimum threshold of 10 delivered orders?

This establishes the seller population that can proceed into Investigation 40.

---

## Product Category Activity

### Q5 — Product Category Activity Distribution

How is delivered-order activity distributed across product categories?

The analysis uses the same distributional approach applied to sellers.

### Q6 — Product Category Activity Bands

How many categories fall into different delivered-order activity bands?

This provides a business-readable view of category scale.

### Q7 — Product Category Threshold Coverage

What percentage of product categories would remain under alternative thresholds?

Candidate thresholds include:

* 25 orders;
* 50 orders;
* 100 orders; and
* 250 orders.

### Q8 — Product Category Threshold Candidates

Which product categories meet the proposed minimum threshold of 100 delivered orders?

---

## Threshold Comparison

### Q9 — Threshold Comparison

How much of each entity population would remain after applying the proposed thresholds?

The analysis compares:

* total entities;
* eligible entities;
* excluded entities; and
* percentage retained.

### Q10 — Activity Coverage at Proposed Thresholds

How much delivered-order activity remains represented after applying the thresholds?

This is important because entity retention alone does not tell the complete story.

A threshold may remove many entities while still retaining most marketplace activity.

### Q11 — Seller Threshold Sensitivity

How does seller population and activity coverage change as the minimum threshold increases?

### Q12 — Product Category Threshold Sensitivity

How does category population and activity coverage change as the minimum threshold increases?

---

## Final Threshold Decisions

### Q13 — Proposed Seller Threshold Summary

What seller population will be carried into Investigation 40?

### Q14 — Proposed Product Category Threshold Summary

What category population will be carried into Investigation 40?

### Q15 — Final Threshold Decision

What thresholds will be used by Investigation 40?

The selected thresholds are:

| Entity Type      | Minimum Delivered Orders |
| ---------------- | -----------------------: |
| Seller           |                   **10** |
| Product Category |                  **100** |

---

# 4. Analytical Population

The investigation is based on delivered orders.

```sql
WHERE order_status = 'delivered'
```

This is intentional.

Cancelled, unavailable, and other incomplete orders should not contribute to the activity threshold used to evaluate entities participating in the revenue opportunity analysis.

Activity is measured as:

```sql
COUNT(DISTINCT o.order_id)
```

This prevents an order containing multiple items from being counted multiple times.

---

# 5. Seller Activity Methodology

Seller activity is calculated by joining:

```text
order_items
      ↓
orders
```

The seller is identified through:

```text
order_items.seller_id
```

Activity is:

```text
Distinct delivered orders
```

This provides a consistent measure of observed seller activity.

The analysis then examines the full seller distribution before applying any threshold.

---

# 6. Product Category Activity Methodology

Product category activity is calculated through:

```text
products
      ↓
order_items
      ↓
orders
```

The category is identified through:

```text
products.product_category_name
```

Only categories with a known category name are included.

Activity is again measured using:

```sql
COUNT(DISTINCT o.order_id)
```

This keeps the activity definition consistent between sellers and categories.

---

# 7. Threshold Selection Framework

The threshold decision is not based on a single statistic.

Instead, the investigation considers three dimensions.

### 7.1 Entity Retention

How many entities remain after the threshold?

A threshold that removes almost the entire population would be difficult to justify.

### 7.2 Activity Coverage

How much delivered-order activity remains represented?

This is important because a threshold can remove many low-activity entities while retaining the majority of observed activity.

### 7.3 Analytical Stability

Higher activity generally provides a stronger basis for comparing:

* average reviews;
* delivery rates;
* revenue;
* activity percentiles; and
* opportunity scores.

The threshold therefore represents a balance rather than a claim that exactly 10 or 100 observations is universally statistically sufficient.

---

# 8. Selected Thresholds

Investigation 39 establishes the following thresholds for Investigation 40:

| Entity             |                Threshold |
| ------------------ | -----------------------: |
| Sellers            |  **10 delivered orders** |
| Product Categories | **100 delivered orders** |

These thresholds are applied before percentile standardization in Investigation 40.

This is important because the scorecard should compare entities within a deliberately defined analytical population.

---

# 9. Why Sellers and Categories Use Different Thresholds

Sellers and product categories operate at different scales.

A seller represents an individual marketplace participant.

A product category aggregates many products and sellers.

Therefore, using the same numerical threshold for both populations would not necessarily produce comparable analytical reliability.

For example:

```text
Seller:
10 delivered orders
```

may already represent meaningful seller-level activity.

At the category level:

```text
10 delivered orders
```

could represent an extremely small fraction of category demand.

The thresholds are therefore entity-specific.

---

# 10. Key Analytical Design Decision

The most important output of Investigation 39 is not a ranking.

It is the establishment of the analytical population for Investigation 40.

The relationship is:

```text
Investigation 39
Activity Threshold Analysis
        ↓
Seller threshold = 10
Category threshold = 100
        ↓
Investigation 40
Revenue Opportunity Scorecard
```

This prevents Investigation 40 from applying arbitrary eligibility filters without analytical justification.

---

# 11. Relationship to Investigation 40

Investigation 40 should **not independently redefine the thresholds**.

Instead, it should use:

```text
Seller activity >= 10
```

and:

```text
Category activity >= 100
```

as the established analytical population.

The scorecard can then focus on:

```text
Revenue Headroom
        +
Customer Acceptance
        +
Operational Readiness
        +
Market Activity
```

---

# 12. Interpretation

A threshold does not mean that entities below the threshold are poor performers.

An excluded seller may still be:

* profitable;
* highly rated;
* operationally reliable; or
* commercially promising.

The threshold simply means that the entity does not have enough observed delivered-order activity to participate in this particular comparative opportunity framework.

Therefore:

> **Eligibility is an analytical requirement, not a performance judgment.**

---

# 13. Limitations

### 13.1 Thresholds Are Analytical Decisions

The selected thresholds are designed for this investigation and dataset.

They should not automatically be treated as universal business standards.

### 13.2 Activity Does Not Guarantee Statistical Stability

Ten delivered orders provide more information than one or two orders, but the resulting averages can still be sensitive to individual observations.

### 13.3 Historical Dataset

The Olist dataset represents a historical marketplace period.

Threshold decisions may need to be revisited when applied to a newer operational environment.

### 13.4 Entity Retention vs Activity Coverage

A threshold can exclude a large number of entities while retaining most activity.

Both measures therefore need to be considered.

---

# 14. Validation Checklist

Before using the thresholds in Investigation 40:

* [ ] Only delivered orders are included.
* [ ] Seller activity uses `COUNT(DISTINCT order_id)`.
* [ ] Category activity uses `COUNT(DISTINCT order_id)`.
* [ ] Product categories with NULL category names are excluded.
* [ ] Seller activity distribution has been examined.
* [ ] Category activity distribution has been examined.
* [ ] Alternative thresholds have been compared.
* [ ] Entity retention has been evaluated.
* [ ] Activity coverage has been evaluated.
* [ ] Seller threshold is documented as 10.
* [ ] Category threshold is documented as 100.
* [ ] Investigation 40 uses the same thresholds.

---

# 15. Expected Deliverable

### SQL Deliverable

```text
33_activity_threshold_analysis.sql
```

The SQL script contains all 15 analytical questions covering:

```text
Activity Distribution
        ↓
Activity Bands
        ↓
Threshold Coverage
        ↓
Threshold Candidates
        ↓
Sensitivity Analysis
        ↓
Final Threshold Decision
```

### Investigation Report

```text
39_activity_threshold_analysis.md
```

The report documents:

* the business problem;
* analytical questions;
* methodology;
* threshold logic;
* selected thresholds;
* limitations; and
* relationship to Investigation 40.

---

# 16. Final Analytical Takeaway

Investigation 39 establishes that a revenue opportunity scorecard should not begin with scoring.

It should begin with defining a sufficiently active analytical population.

The final framework is:

```text
Observed Activity
       ↓
Activity Distribution
       ↓
Threshold Sensitivity
       ↓
Entity Retention
       ↓
Activity Coverage
       ↓
Threshold Decision
       ↓
Reliable Opportunity Population
```

The selected thresholds carried into Investigation 40 are:

> **Sellers: at least 10 delivered orders**

> **Product Categories: at least 100 delivered orders**

Investigation 39 therefore serves as the methodological foundation for the Revenue Opportunity Scorecard developed in Investigation 40.
