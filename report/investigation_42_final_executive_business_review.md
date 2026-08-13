# Investigation 42 — Final Executive Business Review

## 1. Investigation Overview

**Business Area:** Strategic Business Analytics — Executive Business Review

**Objective:** Consolidate marketplace health, customer behaviour, operational performance, seller/category performance, business risk, and revenue-growth opportunity into a reusable executive evidence layer.

The investigation moves from measurement to prioritisation:

```text
Executive KPI Baseline
        ↓
Revenue & Customer Scale
        ↓
Revenue Trend & Concentration
        ↓
Customer Health
        ↓
Delivery & Satisfaction
        ↓
Seller & Category Performance
        ↓
Regional & Customer Opportunities
        ↓
Growth Opportunity Scorecard
        ↓
Business Risk
        ↓
Candidate Findings
        ↓
Management Action Evidence
        ↓
Final Executive Review Dataset
```

---

## 2. Business Problem

Senior management needs more than isolated KPIs. The objective is to establish a coherent view of:

- marketplace scale and revenue;
- customer value and retention;
- delivery and customer experience;
- seller and category performance;
- regional opportunity;
- revenue concentration and business risk; and
- observable growth opportunities.

The central question is:

> **What does the marketplace's current business health look like, where are the strongest observable opportunities, and what evidence should management use when deciding where to act?**

---

## 3. Core Analytical Definitions

### Delivered-order population

Operational and customer-performance analysis primarily uses:

```sql
order_status = 'delivered'
```

### Marketplace revenue

Marketplace-level revenue uses:

```text
order_payments.payment_value
```

This supports total revenue, AOV, customer lifetime revenue, revenue trends, and executive KPIs.

### Seller/category sales

Seller and product-category sales use:

```text
order_items.price + order_items.freight_value
```

`order_payments` has no direct seller attribution key, so payment value is not allocated directly to sellers/categories.

### Customer identity

Customer-level analysis uses `customer_unique_id` rather than `customer_id`.

### Historical CLV

Historical CLV is the average delivered-order lifetime revenue among customers with at least one delivered order. It is not a predictive CLV model.

### Repeat purchase rate

```text
Customers with >1 delivered order
---------------------------------- × 100
All active customers
```

---

## 4. Analytical Questions Q1–Q25

| Q | Question | Purpose |
|---:|---|---|
| 1 | Executive Business Snapshot | Establish the executive KPI baseline. |
| 2 | Revenue and Customer Scale | Measure delivered revenue, orders, active customers, AOV and customer value. |
| 3 | Revenue Trend | Evaluate monthly revenue and growth. |
| 4 | Revenue Growth Consistency | Examine revenue-performance consistency. |
| 5 | Seller Revenue Concentration | Measure concentration among major sellers. |
| 6 | Customer Retention Health | Measure one-time versus repeat purchasing. |
| 7 | Customer Value Concentration | Examine the distribution of customer lifetime revenue. |
| 8 | Customer Growth vs Customer Retention | Compare customer scale/value with retention. |
| 9 | Delivery Performance | Measure marketplace delivery performance. |
| 10 | Delivery Performance by State | Compare delivery outcomes geographically. |
| 11 | Delivery Performance vs Customer Satisfaction | Examine delivery/satisfaction differences. |
| 12 | Seller Performance Distribution | Classify sellers using the balanced performance scorecard. |
| 13 | Seller Performance vs Revenue Contribution | Connect seller performance to sales contribution. |
| 14 | Seller Risk | Identify seller-level risk signals. |
| 15 | Product Category Performance | Evaluate category demand and sales characteristics. |
| 16 | Regional Revenue Opportunities | Identify comparatively attractive regional conditions. |
| 17 | Customer Re-engagement Opportunity | Evaluate one-time versus repeat customer value. |
| 18 | Seller Expansion Opportunity | Shortlist sellers with strong opportunity scores. |
| 19 | Major Business Risk Indicators | Consolidate major marketplace risks. |
| 20 | Risk Prioritisation | Translate retention risk into a business priority. |
| 21 | Three Strongest Business Findings | Produce candidate evidence for executive interpretation. |
| 22 | Weakness Evidence | Quantify major weakness signals. |
| 23 | Strongest Growth Opportunities | Shortlist eligible entities with scores ≥60. |
| 24 | Management Action Evidence | Support practical management actions with evidence. |
| 25 | Final Executive Business Review Dataset | Combine business-health and growth-opportunity evidence. |

---

## 5. Revenue Opportunity Scorecard

The opportunity framework is deliberately different from a conventional performance ranking.

> **Performance asks who is performing best. Opportunity asks where there may be attractive room for growth.**

### Eligibility

| Entity | Minimum delivered-order activity |
|---|---:|
| Seller | 10 |
| Product Category | 100 |

### Score dimensions

| Dimension | Weight |
|---|---:|
| Revenue Headroom | 30% |
| Customer Acceptance | 30% |
| Operational Readiness | 25% |
| Market Activity | 15% |
| **Total** | **100%** |

Seller and product-category populations are standardised separately.

### Revenue headroom

Lower current sales indicate greater relative headroom:

```sql
(
    1 - PERCENT_RANK() OVER (
        PARTITION BY entity_type
        ORDER BY sales_value
    )
) * 100
```

### Final opportunity score

```text
Revenue Opportunity Score =
      Revenue Headroom       × 0.30
    + Customer Acceptance    × 0.30
    + Operational Readiness  × 0.25
    + Market Activity        × 0.15
```

### Opportunity tiers

| Score | Tier |
|---:|---|
| 80–100 | Very High Opportunity |
| 60–79.99 | High Opportunity |
| 40–59.99 | Moderate Opportunity |
| 20–39.99 | Low Opportunity |
| 0–19.99 | Very Low Opportunity |

The score is a relative prioritisation mechanism, **not a forecast of incremental revenue**.

---

## 6. Authoritative Views

### `executive_kpi_dashboard`

**Grain:** one row per KPI.

It exposes:

- Total Revenue
- Total Delivered Orders
- Active Customers
- Average Order Value
- Average Customer Lifetime Value
- Repeat Purchase Rate
- Average Delivery Time
- Average Review Score

Order-level revenue is calculated before customer-level metrics. Review evidence is reduced to an order-level average before the executive review KPI is calculated.

### `revenue_opportunity_dashboard`

**Grain:** one row per eligible seller or product category.

It exposes the raw metrics, four standardised score components, final opportunity score, and opportunity tier.

Missing review and delivery evidence is treated as zero before percentile scoring, preventing NULL values from being interpreted as high performance.

---

## 7. Executive Interpretation

A high opportunity score means an entity has relatively favourable conditions for potential expansion compared with other eligible entities of the same type.

It does **not** mean:

- guaranteed future growth;
- guaranteed profitability;
- a revenue forecast;
- a causal estimate of promotional impact; or
- proof that additional investment will succeed.

### Interpretation patterns

**High headroom + high acceptance** → potentially attractive growth candidate.

**High headroom + high operational readiness** → potentially scalable entity.

**High headroom + high activity** → potentially under-scaled entity with meaningful demand evidence.

**High headroom + weak acceptance** → caution; low sales may reflect dissatisfaction.

**High headroom + weak operations** → operational improvement may need to precede growth investment.

---

## 8. Q21–Q25 Executive Evidence Layer

### Q21 — Candidate findings

Q21 deliberately produces **candidate evidence** rather than mechanically selecting the three strongest findings. The final selection remains an analytical judgement step.

### Q22 — Weakness evidence

The corrected query calculates the one-time customer percentage using the full active-customer denominator and also reports seller concentration.

### Q23 — Growth shortlist

Q23 consumes the authoritative opportunity dashboard and filters for scores of at least 60. Eligibility is already enforced in the dashboard.

### Q24 — Management action evidence

Q24 converts measurable risk signals into evidence that can support management action.

### Q25 — Final executive dataset

Q25 combines:

1. **Business Health** — executive KPIs.
2. **Growth Opportunity** — eligible seller/category opportunity statistics.

This creates a compact evidence layer for executive reporting and final narrative interpretation.

---

## 9. SQL Techniques Applied

The investigation integrates:

- multi-table joins;
- aggregate functions;
- conditional aggregation;
- `FILTER`;
- `CASE` expressions;
- Common Table Expressions;
- window functions;
- `PERCENT_RANK()`;
- `LAG()`;
- percentile calculations;
- `NULLIF`;
- `COALESCE`;
- weighted scoring;
- reusable views; and
- executive evidence datasets.

This represents the project's transition from isolated SQL analysis to a reusable decision-support layer.

---

## 10. Validation Checklist

- [ ] Source tables exist and contain the expected data.
- [ ] Delivered-order filters are applied consistently.
- [ ] Marketplace revenue uses `payment_value`.
- [ ] Seller/category sales use `price + freight_value`.
- [ ] Customer analysis uses `customer_unique_id`.
- [ ] AOV is based on order-level revenue.
- [ ] Seller eligibility is ≥10 delivered orders.
- [ ] Category eligibility is ≥100 delivered orders.
- [ ] Seller/category percentile populations remain separate.
- [ ] Missing review/delivery evidence does not receive an artificially high percentile.
- [ ] Revenue headroom is inverse-ranked.
- [ ] Score weights sum to 100%.
- [ ] Opportunity tiers match the documented thresholds.
- [ ] `executive_kpi_dashboard` has one row per KPI.
- [ ] `revenue_opportunity_dashboard` has one row per eligible entity.
- [ ] Q21 remains a candidate-evidence dataset.
- [ ] Q22 uses the correct denominator.
- [ ] Q23 consumes the authoritative opportunity dashboard.
- [ ] Q25 combines business-health and growth-opportunity evidence.

---

## 11. Limitations

### Relative rather than absolute scoring

Percentile scores depend on the comparison population.

### No profitability measure

The scorecard does not include seller costs, marketplace fees, discounts, returns, contribution margin, or customer acquisition cost.

### Review limitations

Review averages may be affected by review participation and review volume.

### Delivery attribution

On-time delivery measures the observed outcome but does not identify the operational party responsible for a delay.

### No causal inference

A high opportunity score does not prove that additional marketing, visibility, or investment will cause revenue to increase.

---

## 12. Recommended Business Use

```text
Executive Evidence
      ↓
Identify important signals
      ↓
Inspect underlying KPIs
      ↓
Investigate business context
      ↓
Select management action
      ↓
Monitor subsequent performance
```

The final dataset should support business judgement rather than replace it.

---

## 13. Deliverables

- `42_final_executive_business_review.sql` — consolidated Q1–Q25 SQL layer with authoritative views defined once and corrected downstream dependencies.
- `42_final_executive_business_review.md` — methodology, question map, scoring framework, interpretation, limitations, and validation documentation.

---

## 14. Conclusion

This investigation consolidates the project's strategic SQL work into an executive business-review framework connecting:

**Marketplace Health → Customer Behaviour → Operations → Seller & Category Performance → Risk → Growth Opportunity → Management Action**

The final Q25 dataset provides a compact executive evidence layer, while the two authoritative views provide reusable foundations for downstream BI reporting and dashboard development.
