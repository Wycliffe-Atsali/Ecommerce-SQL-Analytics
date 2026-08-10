# Investigation 40 — Revenue Opportunity Scorecard

## 1. Investigation Overview

### Business Area

Strategic Business Analytics — Revenue Growth Opportunity

### Objective

Investigation 40 builds a unified Revenue Opportunity Scorecard for sellers and product categories.

The investigation builds directly on Investigation 39, which established the minimum activity thresholds:

| Entity           | Minimum Delivered Orders |
| ---------------- | -----------------------: |
| Seller           |                   **10** |
| Product Category |                  **100** |

The purpose is not to identify the entities generating the most revenue today.

Instead, the investigation asks:

> **Which sellers and product categories demonstrate the strongest combination of revenue headroom, customer acceptance, operational readiness, and market activity?**

This distinction changes the analysis from a conventional performance ranking into a decision-support framework for potential revenue growth.

---

# 2. Relationship to Investigation 39

Investigation 39 answered:

> **Who has sufficient activity to participate in the opportunity analysis?**

Investigation 40 answers:

> **Among those eligible entities, where does the strongest observable opportunity appear?**

The relationship is therefore:

```text
Investigation 39
Activity Threshold Analysis
        ↓
Seller >= 10 orders
Category >= 100 orders
        ↓
Investigation 40
Revenue Opportunity Scorecard
```

The thresholds are not re-derived as part of the scorecard.

They are inherited from the preceding investigation.

---

# 3. Business Problem

A conventional revenue ranking identifies entities that already generate substantial sales.

That is useful for understanding current performance.

However, it does not necessarily identify where additional growth may be possible.

A smaller seller may have:

* strong customer reviews;
* reliable delivery;
* meaningful activity; and
* relatively low current sales.

Such a seller may have greater relative revenue headroom than a seller already operating near the top of the revenue distribution.

The same principle applies to product categories.

Therefore, Investigation 40 evaluates opportunity through four dimensions:

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

# 4. Analytical Questions

The investigation contains 15 questions organized into the project's standard analytical progression.

## Eligibility

### Q1 — Seller Eligibility

Which sellers meet the threshold of at least 10 delivered orders?

### Q2 — Product Category Eligibility

Which product categories meet the threshold of at least 100 delivered orders?

### Q3 — Eligibility Coverage

How many sellers and categories are retained or excluded, and what proportion of delivered-order activity remains covered?

---

## Raw Opportunity Metrics

### Q4 — Seller Opportunity Metrics

What are the current sales, activity, customer acceptance, and delivery metrics for eligible sellers?

### Q5 — Product Category Opportunity Metrics

What are the corresponding metrics for eligible product categories?

### Q6 — Promising Low-Scale Entities

Which eligible sellers and categories combine:

* relatively low current sales;
* sufficient activity;
* average review score of at least 4.0; and
* on-time delivery of at least 80%?

This is an exploratory opportunity screen before standardized scoring.

---

## Standardization

### Q7 — Seller Opportunity Standardization

How do eligible sellers compare across the four opportunity dimensions?

### Q8 — Seller Revenue Headroom

Which sellers have the greatest relative revenue headroom?

### Q9 — Product Category Opportunity Standardization

How do eligible product categories compare across the same opportunity dimensions?

---

## Scorecard

### Q10 — Seller Revenue Opportunity Score

Which eligible sellers receive the highest weighted opportunity scores?

### Q11 — Product Category Revenue Opportunity Score

Which eligible categories receive the highest weighted opportunity scores?

### Q12 — Opportunity Classification

How are sellers and categories distributed across the five opportunity tiers?

---

## Final Outputs

### Q13 — Highest-Opportunity Sellers

Which 20 eligible sellers have the highest Revenue Opportunity Scores?

### Q14 — Highest-Opportunity Product Categories

Which 20 eligible categories have the highest Revenue Opportunity Scores?

### Q15 — Final Revenue Opportunity Dashboard

Can the complete scorecard be exposed through a reusable database view?

---

# 5. Analytical Population

Investigation 40 uses only:

```sql
order_status = 'delivered'
```

This ensures that the scorecard is based on completed marketplace transactions.

The eligibility population is:

```text
Seller:
COUNT(DISTINCT order_id) >= 10

Product Category:
COUNT(DISTINCT order_id) >= 100
```

These thresholds were established in Investigation 39.

---

# 6. Revenue Definition

For seller and category opportunity analysis, revenue is attributed at the item level:

```text
sales_value =
    order_items.price
    +
    order_items.freight_value
```

This is different from marketplace-wide revenue analysis.

The reason is attribution.

`order_items` directly identifies:

```text
Order
  ↓
Product
  ↓
Seller
  ↓
Category
  ↓
Item Value
```

Therefore, item-level sales value can be attributed directly to sellers and categories.

`order_payments.payment_value` represents marketplace-level payment information and does not provide the seller-level attribution required for this scorecard.

---

# 7. Raw Opportunity Metrics

Each eligible entity receives four raw analytical measures.

## 7.1 Sales Value

Current delivered-order sales value.

```text
price + freight_value
```

Lower current sales contribute to greater relative revenue headroom.

---

## 7.2 Market Activity

Measured using:

```sql
COUNT(DISTINCT order_id)
```

Higher activity indicates stronger evidence of observed marketplace demand.

---

## 7.3 Customer Acceptance

Measured using:

```sql
AVG(review_score)
```

Higher review scores indicate stronger observed customer acceptance.

---

## 7.4 Operational Readiness

Measured as the percentage of delivered orders received on or before the estimated delivery date.

```text
on-time delivery rate
```

Higher delivery performance indicates stronger operational readiness.

---

# 8. Promising Low-Scale Entity Analysis

Q6 is deliberately separate from the final score.

It provides a transparent exploratory screen before percentile standardization.

The screen looks for entities with:

```text
Lower current sales
        +
Sufficient activity
        +
Review score >= 4.0
        +
On-time delivery >= 80%
```

For sellers, relatively low scale is defined using the bottom 25% of eligible seller sales.

For product categories, relatively low scale is defined using sales below the average eligible-category sales value.

This creates a business-readable candidate population before the weighted score is introduced.

---

# 9. Relative Standardization

The raw metrics have different units.

For example:

```text
Sales:
Currency

Activity:
Orders

Review:
1–5

Delivery:
Percentage
```

They therefore cannot be combined directly.

The scorecard converts each dimension into a relative 0–100 score using:

```sql
PERCENT_RANK()
```

This preserves each entity's relative position within its peer population.

---

# 10. Separate Peer-Group Standardization

Sellers and product categories are not standardized against each other.

The scorecard uses:

```sql
PARTITION BY entity_type
```

Therefore:

```text
Seller → compared with sellers

Product Category → compared with product categories
```

This is essential because categories operate at a much larger aggregate scale than individual sellers.

The score answers:

> How strong is this seller compared with other eligible sellers?

rather than:

> How strong is this seller compared with a completely different entity type?

---

# 11. Revenue Headroom

Revenue is intentionally scored in the opposite direction from the other dimensions.

For:

* customer acceptance;
* operational readiness; and
* market activity;

higher values represent stronger conditions.

For current revenue:

> Lower current revenue represents greater potential headroom.

Therefore:

```sql
(
    1 -
    PERCENT_RANK() OVER (
        PARTITION BY entity_type
        ORDER BY sales_value
    )
) * 100
```

is used.

The result is the:

```text
Revenue Headroom Score
```

A relatively low-revenue entity therefore receives a higher headroom score.

---

# 12. Opportunity Scorecard

The final score uses four dimensions.

| Opportunity Dimension |   Weight |
| --------------------- | -------: |
| Revenue Headroom      |      30% |
| Customer Acceptance   |      30% |
| Operational Readiness |      25% |
| Market Activity       |      15% |
| **Total**             | **100%** |

The formula is:

```text
Revenue Opportunity Score =
      Revenue Headroom × 0.30
    + Customer Acceptance × 0.30
    + Operational Readiness × 0.25
    + Market Activity × 0.15
```

All four components are standardized to a 0–100 scale before weighting.

---

# 13. Opportunity Classification

The final score is translated into five business-facing tiers.

|    Score | Opportunity Tier      |
| -------: | --------------------- |
|   80–100 | Very High Opportunity |
| 60–79.99 | High Opportunity      |
| 40–59.99 | Moderate Opportunity  |
| 20–39.99 | Low Opportunity       |
|  0–19.99 | Very Low Opportunity  |

The purpose of the tiers is communication and prioritization.

They should not be interpreted as predictions of future revenue.

---

# 14. Q13 — Highest-Opportunity Sellers

The final dashboard is filtered to:

```sql
entity_type = 'Seller'
```

and ordered by:

```sql
revenue_opportunity_score DESC
```

The top 20 sellers are returned.

These sellers represent the highest-scoring candidates within the eligible seller population.

---

# 15. Q14 — Highest-Opportunity Product Categories

The dashboard is filtered to:

```sql
entity_type = 'Product Category'
```

and ordered by:

```sql
revenue_opportunity_score DESC
```

The top 20 categories are returned.

These represent the highest-scoring candidates within the eligible category population.

---

# 16. Q15 — Reusable Dashboard

The final scorecard is exposed through:

```text
revenue_opportunity_dashboard
```

The view contains:

| Column                        | Description                      |
| ----------------------------- | -------------------------------- |
| `entity_type`                 | Seller or Product Category       |
| `entity`                      | Seller ID or category            |
| `sales_value`                 | Delivered item-level sales value |
| `activity`                    | Distinct delivered orders        |
| `average_review_score`        | Average review score             |
| `on_time_delivery_rate`       | Percentage delivered on time     |
| `revenue_headroom_score`      | Relative headroom                |
| `customer_acceptance_score`   | Relative customer acceptance     |
| `operational_readiness_score` | Relative operational readiness   |
| `market_activity_score`       | Relative market activity         |
| `revenue_opportunity_score`   | Weighted opportunity score       |
| `opportunity_tier`            | Business-facing classification   |

The reusable view prevents downstream analysis from rebuilding the entire CTE chain.

---

# 17. Investigation Workflow

Investigation 40 follows the established analytical progression:

```text
Investigation 39
Activity Thresholds
        ↓
Eligibility
        ↓
Raw Opportunity Metrics
        ↓
Low-Scale Opportunity Exploration
        ↓
Relative Standardization
        ↓
Revenue Headroom
        ↓
Weighted Opportunity Score
        ↓
Opportunity Classification
        ↓
Top Sellers / Categories
        ↓
Reusable Dashboard
```

This progression is important because the final score should not appear as an unexplained black-box number.

---

# 18. Interpretation

A high Revenue Opportunity Score means:

> **The entity demonstrates relatively strong observable conditions for potential revenue expansion compared with other eligible entities of the same type.**

It does **not** mean:

* guaranteed future growth;
* guaranteed profitability;
* a forecast of future revenue;
* a causal estimate of promotional impact; or
* proof that additional investment will succeed.

The score is a **prioritization mechanism**.

---

# 19. Business Interpretation Framework

The score components should be examined together.

### High Headroom + High Acceptance

Potentially attractive growth candidate.

Customers respond positively while current sales remain relatively low.

### High Headroom + High Operational Readiness

Potentially scalable entity with strong observed delivery performance.

### High Headroom + High Activity

Potentially under-scaled entity with meaningful observed demand.

### High Headroom + Weak Acceptance

Requires caution.

Low sales may reflect customer dissatisfaction rather than untapped opportunity.

### High Headroom + Weak Operations

Additional demand could create further service problems.

Operational improvements may need to precede growth investment.

---

# 20. Key Analytical Insight

The central distinction is:

> **Performance is not the same as opportunity.**

A high-revenue seller may already have captured substantial demand and therefore receive a relatively low headroom score.

A smaller seller may receive a stronger opportunity score when it combines:

* lower current revenue;
* strong customer acceptance;
* reliable delivery; and
* meaningful activity.

The scorecard is therefore designed to identify **potential growth candidates**, rather than simply the current marketplace winners.

---

# 21. Limitations

## 21.1 Relative Scoring

Percentile scores are relative to the eligible comparison population.

An entity's score can change when the underlying population changes.

## 21.2 No Profitability Measure

Sales value is not the same as profit.

The scorecard does not include:

* seller costs;
* marketplace fees;
* discounts;
* returns;
* contribution margin; or
* customer acquisition cost.

## 21.3 Review Limitations

Average review scores may be affected by:

* review participation;
* review volume;
* order composition; and
* customer characteristics.

## 21.4 Delivery Attribution

On-time delivery measures the observed outcome.

It does not establish which party caused a late delivery.

## 21.5 No Causal Inference

A high score does not prove that additional marketing, visibility, assortment, or investment will cause revenue to increase.

---

# 22. Validation Checklist

Before interpreting the final dashboard:

* [ ] Investigation 39 thresholds are used.
* [ ] Sellers require at least 10 delivered orders.
* [ ] Categories require at least 100 delivered orders.
* [ ] Only delivered orders are included.
* [ ] Seller activity uses distinct order IDs.
* [ ] Category activity uses distinct order IDs.
* [ ] Category NULL values are excluded.
* [ ] Seller revenue uses `price + freight_value`.
* [ ] Category revenue uses `price + freight_value`.
* [ ] Seller and category populations are standardized separately.
* [ ] Revenue headroom is the inverse of revenue percentile.
* [ ] Higher reviews produce higher acceptance scores.
* [ ] Higher delivery rates produce higher readiness scores.
* [ ] Higher activity produces higher activity scores.
* [ ] Score weights total 100%.
* [ ] Opportunity tiers use the documented thresholds.
* [ ] The reusable dashboard view is created before querying Q13 and Q14.
* [ ] The final view contains all required score components.

---

# 23. Expected Deliverables

## SQL Deliverable

```text
34_revenue_opportunity_scorecard.sql
```

Contains all 15 investigation questions and the reusable:

```text
revenue_opportunity_dashboard
```

## Investigation Report

```text
40_revenue_opportunity_scorecard.md
```

Documents:

* business problem;
* relationship to Investigation 39;
* analytical questions;
* eligibility;
* metric construction;
* standardization;
* revenue headroom;
* weighted scoring;
* opportunity classification;
* business interpretation;
* limitations; and
* validation.

---

# 24. Final Analytical Takeaway

Investigation 40 transforms the activity-qualified seller and category populations from Investigation 39 into a decision-oriented opportunity framework.

The analytical progression is:

```text
Activity Qualification
        ↓
Current Performance
        ↓
Relative Position
        ↓
Revenue Headroom
        ↓
Customer Acceptance
        ↓
Operational Readiness
        ↓
Market Activity
        ↓
Weighted Opportunity Score
        ↓
Business Prioritization
```

The central principle is:

> **Today's largest revenue generator is not automatically tomorrow's greatest growth opportunity.**

The scorecard therefore provides a structured screening mechanism for identifying sellers and product categories that warrant deeper commercial investigation.

It does not claim to forecast growth; it identifies **relative opportunity conditions** within the eligible marketplace population.
