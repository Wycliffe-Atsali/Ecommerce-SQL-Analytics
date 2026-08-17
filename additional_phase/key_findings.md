# Key Findings

## Overview

This document summarises the most important business findings identified throughout the **Retail SQL Business Analysis** project.

The purpose is not to reproduce all 48 investigations. Instead, it provides a concise executive view of the findings that have the greatest relevance to:

* Customer growth
* Revenue
* Customer retention
* Seller performance
* Operations
* Customer experience
* Revenue opportunity
* Executive decision-making

The findings are derived from the completed investigation reports and should be interpreted within the scope and limitations of the historical Olist dataset.

---

# 1. Customer Retention Is the Strongest Identifiable Growth Opportunity

Approximately **97% of active customers are one-time customers**.

This is the strongest customer-related finding in the project.

The marketplace successfully generated a large customer population, but very few customers made more than one purchase.

The one-time customer population also represents approximately **94.4% of historical revenue**, while repeat customers generate substantially higher average historical revenue per customer.

### Business implication

The largest identifiable customer opportunity is therefore not simply acquiring more customers, but increasing the proportion of existing customers who make a subsequent purchase.

### Strategic direction

Focus retention and re-engagement efforts on previously delivered customers using dimensions such as:

* Recency
* Historical customer value
* Previous purchasing behaviour
* Purchased category
* RFM segment

The primary success measure should be **incremental repeat-purchase conversion**, rather than simply increasing the number of communications or orders.

---

# 2. Customer Value Is Highly Uneven

The CLV investigation demonstrates that customer value should not be treated as uniform across the customer population.

The project developed a customer-value framework combining:

* Lifetime Revenue
* Purchase Frequency
* Average Order Value
* Purchasing Lifespan

These metrics were standardised using `PERCENT_RANK()` and combined into a weighted Customer Value Score.

The analysis therefore demonstrates that customer revenue alone does not fully describe customer value.

### Business implication

A customer generating high revenue through a combination of repeated purchases, strong order value and longer purchasing activity represents a different commercial opportunity from a customer who generated similar revenue through a single transaction.

### Strategic direction

Customer strategies should therefore differentiate between:

* High-value customers
* Medium-value customers
* Lower-value customers
* Recently active customers
* At-risk or inactive customers

This provides a stronger foundation for targeted retention and customer development.

---

# 3. RFM Analysis Provides an Actionable Customer Segmentation Framework

The RFM investigation developed a customer-level framework based on:

* **Recency** — how recently a customer purchased
* **Frequency** — how often they purchased
* **Monetary** — how much delivered-order revenue they generated

The resulting framework produces both a continuous **0–100 RFM score** and behavioural customer segments.

The framework uses:

* Recency weighting: **30%**
* Frequency weighting: **30%**
* Monetary weighting: **40%**

### Business implication

The analysis provides a way to move beyond a simple customer-value ranking and identify different behavioural situations.

For example, customers can differ because they:

* Purchased recently but infrequently
* Purchased frequently and generated high revenue
* Have historically generated high revenue but have become inactive
* Are relatively recent but have low monetary value

### Strategic direction

RFM provides a practical foundation for differentiated:

* Retention
* Re-engagement
* Cross-selling
* Customer development
* Customer-value monitoring

---

# 4. Delivery Performance Has a Strong Observed Relationship With Customer Satisfaction

The delivery analysis identified a substantial long tail in delivery performance:

| MetricResult          |             |
| --------------------- | ----------- |
| Minimum delivery time | 0.53 days   |
| Median delivery time  | 10.22 days  |
| Average delivery time | 12.56 days  |
| Third quartile        | 15.72 days  |
| Maximum delivery time | 209.63 days |

More importantly, customer review scores declined as delivery time increased.

| Delivery BandAverage Review |          |
| --------------------------- | -------- |
| Under 5 days                | **4.45** |
| 5–10 days                   | **4.36** |
| 10–15 days                  | **4.27** |
| 15+ days                    | **3.65** |

The difference between the fastest and slowest delivery groups is substantial.

### Business implication

Delivery performance is not merely an operational KPI. The historical data shows an **observed association between slower delivery and lower customer satisfaction**.

The analysis does not establish causality. Seller quality, geography, logistics complexity, product expectations and other factors may also contribute.

### Strategic direction

The long-delivery tail should be investigated operationally, particularly in regions with persistently high delivery times.

---

# 5. Delivery Performance Varies Significantly by Geography

The analysis identified substantial regional variation in average delivery time.

Examples of states with particularly high average delivery durations included:

| StateAverage Delivery |            |
| --------------------- | ---------- |
| RR                    | 29.39 days |
| AP                    | 27.19 days |
| AM                    | 26.43 days |
| AL                    | 24.54 days |
| PA                    | 23.77 days |

### Business implication

Delivery problems should not necessarily be treated as a single marketplace-wide issue.

Geography appears to be an important dimension for identifying operational bottlenecks.

### Strategic direction

Operational improvement should investigate the interaction between:

* Geography
* Seller
* Carrier
* Fulfilment
* Delivery duration
* Customer satisfaction

rather than relying only on an overall marketplace average.

---

# 6. Seller Performance Requires a Multi-Dimensional View

The seller analysis developed a weighted performance scorecard rather than ranking sellers solely by revenue.

The framework combines:

* Revenue
* Orders fulfilled
* Review performance
* On-time delivery
* Product diversity

The project standardised these metrics and combined them into a composite seller performance score. The use of a scorecard allows seller performance to be evaluated across multiple dimensions rather than through one KPI alone.

### Business implication

A seller generating substantial revenue is not automatically the strongest operational performer.

Likewise, a seller with excellent reviews may have limited commercial scale.

### Strategic direction

Seller management should distinguish between:

* Commercial strength
* Customer experience
* Operational reliability
* Product breadth

This supports more targeted seller development and marketplace management.

---

# 7. Revenue Opportunity Should Not Be Defined Simply as Low Revenue

The revenue opportunity investigations deliberately moved beyond asking:

> **Who currently generates the most revenue?**

Instead, the framework asks which sellers and product categories combine:

* Revenue headroom
* Customer acceptance
* Operational readiness
* Market activity

The opportunity scorecard therefore evaluates relatively lower-scale entities that may possess favourable characteristics for further growth.

Eligibility thresholds were introduced to reduce the influence of entities with very small activity volumes. Sellers require at least **10 delivered orders**, while product categories require at least **100 delivered orders** for the opportunity scorecard.

### Business implication

The highest-revenue seller or category is not necessarily the highest-priority growth opportunity.

### Strategic direction

Growth analysis should distinguish between:

**Current performance**

and

**Potential opportunity signals**

The project's opportunity scores are therefore prioritisation tools, **not revenue forecasts**.

---

# 8. Revenue Opportunity Exists at Both Seller and Product-Category Levels

The opportunity framework was applied separately to:

* Sellers
* Product categories

This allows the analysis to identify opportunities from both sides of the marketplace.

For sellers, the analysis evaluates customer acceptance, operational readiness, market activity and revenue headroom.

For product categories, the same conceptual framework can identify categories that may warrant additional commercial investigation.

### Business implication

Revenue growth should not be viewed exclusively as a customer acquisition problem.

Potential opportunities exist across the marketplace ecosystem:

```
```

```
Customer
   ↓
Product Category
   ↓
Seller
   ↓
Operational Experience
   ↓
Revenue Opportunity
```

---

# 9. Revenue Analysis Requires Careful Metric Definition

One of the most important methodological findings from the project was that **revenue is not a universal metric with one correct definition**.

For historical customer and marketplace revenue analysis, the project generally uses:

```
```

```
SUM(order_payments.payment_value)
```

for delivered orders.

However, seller and product-category opportunity analysis uses item-level sales value:

```
```

```
order_items.price + order_items.freight_value
```

because `order_items` directly identifies the seller and product associated with each transaction.

### Business implication

The appropriate revenue definition depends on the business question.

### Analytical lesson

A metric should therefore be defined **before** SQL implementation and according to the intended analytical purpose.

---

# 10. Join Design Is Critical to Trustworthy Business Metrics

The project repeatedly demonstrated that technically valid SQL can still produce incorrect business results when joins change the analytical grain.

This was particularly important when working across:

```
```

```
Customer
   ↓
Order
   ↓
Order Items
   ↓
Product / Seller
   ↓
Payment / Review
```

One-to-many relationships can duplicate order-level values when tables are joined without controlling the grain.

The project therefore adopted the principle:

> **Before aggregating, verify what one row represents after every major join.**

This became particularly important in customer value, RFM and revenue opportunity analysis.

### Business implication

Data modelling and SQL correctness are inseparable from business accuracy.

---

# 11. The Project Progressed From SQL Syntax to Analytical Framework Design

The most important overall finding from the project is methodological.

The work progressed from:

```
```

```
SQL Syntax
    ↓
Relational Analysis
    ↓
Advanced SQL
    ↓
Window Functions
    ↓
Business Metrics
    ↓
Analytical Frameworks
    ↓
Executive Reporting
    ↓
Recommendations
```

By the later investigations, SQL was no longer being used simply to answer isolated questions.

It was being used to construct:

* CLV frameworks
* RFM segmentation
* Seller scorecards
* Revenue opportunity models
* Executive KPI datasets
* Business recommendation frameworks

This represents the project's transition from **SQL technique development to business analytics**.

---

# 12. The Final Business Narrative

Taken together, the investigations suggest a coherent strategic narrative:

```
```

```
Large Customer Base
        ↓
Very High One-Time Purchase Rate
        ↓
Retention / Re-engagement Opportunity
        ↓
Customer Value & RFM Segmentation
        ↓
Targeted Customer Development
        ↓
Operational Improvement
        ↓
Better Delivery Experience
        ↓
Potential Customer Satisfaction Benefits
        ↓
Seller & Category Opportunity Identification
        ↓
Prioritised Revenue Growth Opportunities
```

This ultimately became the foundation for the project's **Retain → Improve → Expand** recommendation framework.

The recommendations were deliberately framed as evidence-based management actions rather than causal claims, with future interventions expected to be measured using appropriate baselines, pilots or controlled tests where feasible.

---

# 13. Key Findings at a Glance

| AreaKey FindingBusiness Significance |                                                                                    |                                                                     |
| ------------------------------------ | ---------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| Customer Retention                   | **97% of active customers are one-time customers**                                 | Major identifiable re-engagement opportunity                        |
| Customer Revenue                     | One-time customers account for **94.4% of historical revenue**                     | Large customer base with limited observed repeat behaviour          |
| Customer Value                       | Customer value varies across revenue, frequency, AOV and lifespan                  | Supports differentiated customer strategies                         |
| RFM                                  | Recency, Frequency and Monetary behaviour can be combined into actionable segments | Supports targeted retention and development                         |
| Delivery                             | Average delivery is **12.56 days**, with a substantial long tail                   | Operational performance is an important business issue              |
| Customer Experience                  | Reviews decline from **4.45** for <5-day deliveries to **3.65** for 15+ days       | Strong observed association between delivery speed and satisfaction |
| Geography                            | Delivery performance varies materially by state                                    | Operational improvement should be geographically targeted           |
| Sellers                              | Performance varies across revenue, activity, reviews and delivery                  | Seller management should use multi-dimensional scorecards           |
| Revenue Opportunity                  | Low current revenue does not necessarily mean low growth potential                 | Opportunity analysis should consider multiple dimensions            |
| Analytical Quality                   | Join grain and metric definitions materially affect results                        | SQL correctness is essential to trustworthy business decisions      |

---

# 14. Interpretation & Limitations

These findings describe **historical patterns in the Olist dataset**.

They should therefore not automatically be interpreted as:

* Current marketplace performance
* Forecasted revenue
* Causal relationships
* Guaranteed commercial outcomes

In particular:

* The RFM and CLV frameworks are historical rather than predictive.
* Revenue opportunity scores identify relative opportunities rather than forecast incremental revenue.
* The relationship between delivery time and review score is observational rather than causal.
* The dataset does not contain all commercial variables required to estimate campaign ROI or customer acquisition economics.

The findings should therefore be treated as **evidence for prioritisation and further investigation**, rather than as proof that a specific intervention will produce a specific financial result.

---

# Conclusion

The most important business conclusion from the project is that the Olist marketplace's opportunities are not concentrated in a single KPI.

The analysis points toward an interconnected set of priorities:

**Retain valuable customers → improve operational experience → identify scalable seller and category opportunities → expand through evidence-based commercial actions.**

This represents the central business narrative developed across the project's 48 investigations.
