# Investigation 43 — Executive Business Insights

## 1. Investigation Overview

### Business Objective

Translate the validated analytical results from the preceding strategic investigations into an executive-level assessment of marketplace health, customer economics, operational performance, seller risk, and growth opportunities.

The purpose of this investigation is not to introduce new analytical techniques. It is to synthesize the strongest evidence produced throughout the project into a coherent business narrative and convert descriptive metrics into actionable management insights.

### Analytical Approach

Investigation 43 uses previously validated outputs from the project's customer, operational, seller, product/category, regional, KPI, CLV, RFM, and growth analyses.

The workflow was:

1. Review the retained SQL evidence.
2. Validate the definitions and populations used by each KPI.
3. Identify the strongest patterns and business contrasts.
4. Interpret metrics in business context.
5. Distinguish evidence from inference.
6. Convert findings into management recommendations.
7. Document limitations and interpretation boundaries.

This investigation therefore represents the transition from **SQL analysis to executive business communication**.

---

# 2. Executive Summary

The Olist marketplace demonstrates meaningful commercial scale and broadly positive customer experience, but the quality of that growth is constrained by very weak customer retention and uneven operational performance.

The strongest evidence is the customer base: approximately **97% of active customers are one-time purchasers**, while repeat customers account for only **3%**. One-time customers nevertheless generated approximately **94.4% of historical delivered-order revenue**, making re-engagement the clearest identifiable commercial opportunity in the analysis.

Operationally, delivery performance shows a substantial long tail. The median delivery time is **10.22 days**, compared with an average of **12.56 days**, and the maximum observed delivery time is **209.63 days**. Customer satisfaction also varies materially across delivery bands: orders delivered in under five days received an average review score of **4.45**, compared with **3.65** for orders taking 15+ days. This is an association in the observed data, not proof that delivery speed alone causes lower satisfaction.

The seller ecosystem is broadly diversified and mostly healthy. The top 10 eligible sellers account for **14.19%** of seller-attributed sales and the top 20 account for **23.10%**. These figures demonstrate concentration but should not automatically be labelled a risk without an external or management benchmark. Seller performance is also broadly distributed, with **84 Elite sellers**, while only **18 of 1,238 eligible sellers (1.45%)** are classified as High Risk.

Growth opportunities appear to be selective rather than universal. Twelve product categories are classified as Commercially Strong, one category is classified as High Value / Lower Demand, and the regional opportunity indicator highlights several markets with attractive combinations of revenue, customer activity, AOV and delivery characteristics. These opportunity scores are relative prioritisation indicators, not forecasts of incremental revenue.

If management could focus on only three priorities, the evidence supports:

1. **Re-engage the large one-time customer population.**
2. **Improve delivery performance in the slower-delivery tail and weaker regions.**
3. **Pursue selective growth in commercially attractive categories, sellers and regions while maintaining seller-quality controls.**

---

# 3. Overall Business Health

## Analysis

The marketplace demonstrates substantial historical commercial activity. The executive snapshot records:

| Metric | Value |
|---|---:|
| Delivered-order revenue | R$15.42M |
| Delivered orders | 96,478 |
| Active customers | 93,357 |
| Average order value | R$159.86 |
| Average historical customer revenue | R$165.20 |
| Repeat purchase rate | 3.0% |
| Average delivery time | 12.56 days |
| Average review score | 4.16 / 5 |

The commercial scale is meaningful: almost 100,000 delivered orders and more than 93,000 active customers generated over R$15 million in historical revenue.

Revenue growth, however, was positive but uneven. The growth-consistency output contains **21 month-over-month observations**, of which **13 were positive-growth months (61.9%)** and **8 were negative-growth months (38.1%)**.

The detailed Revenue Growth vs Customer Activity analysis confirms the 21-period count:

| Business Pattern | Periods |
|---|---:|
| Revenue Up / Customers Up | 11 |
| Revenue Down / Customers Down | 7 |
| Revenue Up / Customers Down | 2 |
| Revenue Down / Customers Up | 1 |
| **Total** | **21** |

The earlier reference to 13 month-over-month periods was incorrect. **Thirteen is the number of positive-growth periods, not the total number of month-over-month observations.**

The strongest revenue month was **November 2017 at approximately R$1.15M**. January 2017 showed exceptionally high percentage growth because it followed December 2016's exceptionally small revenue base. This percentage should therefore be interpreted in the context of the low starting point rather than as evidence of normalised sustainable growth.

Customer experience is broadly positive at an average review score of **4.16**, but operational performance is less consistent. The difference between average and median delivery time, together with the **209.63-day maximum**, indicates a meaningful delivery tail.

## Business Finding

The marketplace demonstrates meaningful commercial scale and broadly positive customer experience, but its growth quality is constrained by weak customer retention and uneven operational performance.

## Why It Matters

The business has enough scale for retention and operational improvements to have meaningful commercial consequences. The central challenge is therefore not simply generating more transactions; it is improving the quality and durability of the customer relationship while protecting service performance as the marketplace grows.

---

# 4. Customer Economics & Retention

## Analysis

Customer retention is the clearest weakness identified in the analysis.

The customer-retention output shows:

| Customer Type | Customers | Share |
|---|---:|---:|
| One-time customers | 90,557 | 97.0% |
| Repeat customers | 2,801 | 3.0% |

The re-engagement analysis reinforces the finding:

| Metric | One-Time | Repeat |
|---|---:|---:|
| Historical revenue | R$14.56M | R$864K |
| Revenue share | 94.4% | 5.6% |
| Average historical revenue/customer | R$160.76 | R$308.59 |

This creates an important commercial distinction.

The repeat customer base is small, but individual repeat customers have historically generated substantially more revenue on average. At the same time, the one-time population is enormous.

The customer-value distribution also indicates skewness:

| Metric | Value |
|---|---:|
| Median historical customer revenue | R$107.78 |
| Average historical customer revenue | R$165.20 |
| Third quartile | R$182.56 |
| Top 10% customer revenue contribution | 38.25% |

The gap between the median and average indicates that a smaller group of higher-value customers pulls the average upward. The top 10% contribution of 38.25% further demonstrates meaningful customer-value concentration.

The monthly activity analysis provides additional nuance. Of 21 month-over-month observations:

- 11 were Revenue Up / Customers Up.
- 7 were Revenue Down / Customers Down.
- 2 were Revenue Up / Customers Down.
- 1 was Revenue Down / Customers Up.

This suggests that revenue growth frequently coincided with broader customer activity, but customer counts do not explain every revenue movement. Changes in customer value and purchasing behaviour also matter.

## Business Finding 1 — Retention Weakness

The marketplace has acquired a very large customer base but has converted very few customers into repeat purchasers: **97% of active customers are one-time customers**.

This is the strongest customer-related executive finding.

## Business Finding 2 — Re-engagement Opportunity

The one-time customer population represents the largest identifiable re-engagement opportunity because it contains 97% of active customers and accounts for 94.4% of historical revenue, while repeat customers generate substantially higher average historical revenue per customer.

## Recommendation

Implement a structured customer re-engagement programme focused on previously delivered customers who have not purchased again.

Potential segmentation dimensions include:

- historical customer value;
- recency;
- previously purchased category;
- order characteristics;
- customer purchasing frequency;
- observed customer segment.

The objective should not simply be to increase order count. The key measures should be **incremental repeat-purchase conversion** and the resulting change in customer revenue.

---

# 5. Operations & Customer Satisfaction

## Analysis

Overall delivery performance shows a substantial long tail:

| Metric | Value |
|---|---:|
| Minimum delivery time | 0.53 days |
| Median delivery time | 10.22 days |
| Average delivery time | 12.56 days |
| Third quartile | 15.72 days |
| Maximum delivery time | 209.63 days |

The median provides a more representative description of the typical delivered order than the average alone, while the higher average and very high maximum demonstrate the effect of slower deliveries.

Regional performance also varies materially. Among the slowest states by average delivery time were:

| State | Average Delivery |
|---|---:|
| RR | 29.39 days |
| AP | 27.19 days |
| AM | 26.43 days |
| AL | 24.54 days |
| PA | 23.77 days |

The delivery-band analysis provides the strongest customer-experience evidence:

| Delivery Band | Orders | Average Delivery | Average Review |
|---|---:|---:|---:|
| Under 5 days | 13,374 | 3.38 days | 4.45 |
| 5–10 days | 32,885 | 7.48 days | 4.36 |
| 10–15 days | 23,470 | 12.27 days | 4.27 |
| 15+ days | 26,095 | 23.77 days | 3.65 |

The difference between the fastest and slowest bands is substantial: average review scores decline from **4.45** for orders delivered in under five days to **3.65** for orders taking 15+ days.

This supports an observed association between slower delivery and lower customer satisfaction.

It does not prove that delivery speed alone causes lower reviews. Other factors—including seller quality, product expectations, geography, logistics complexity and order characteristics—could also contribute.

## Business Finding

Delivery performance is not simply an operational KPI; the observed data shows a strong association between slower delivery and lower customer satisfaction, particularly once delivery exceeds 15 days.

## Recommendation

Prioritise operational investigation of the long-delivery tail, especially in regions with persistently high average delivery times.

Management should identify whether the underlying causes are:

- seller handling times;
- carrier performance;
- geographic constraints;
- fulfilment processes;
- seller/logistics combinations;
- other operational bottlenecks.

Delivery improvement should therefore be treated as both an operational initiative and a potential customer-retention enabler.

---

# 6. Seller Ecosystem & Marketplace Risk

## Analysis

Seller concentration is measurable but not automatically alarming.

Among eligible sellers meeting the project's minimum activity threshold of 10 delivered orders:

| Concentration Measure | Share of Seller-Attributed Sales |
|---|---:|
| Top 10 sellers | 14.19% |
| Top 20 sellers | 23.10% |

These figures demonstrate concentration, but they do not by themselves establish that the marketplace is excessively concentrated. A risk conclusion would require an explicit benchmark, management tolerance or additional evidence of dependency.

Seller performance is broadly distributed:

| Seller Classification | Sellers | Share |
|---|---:|---:|
| Elite Seller | 84 | 6.79% |
| High Performer | 298 | 24.07% |
| Strong Performer | 338 | 27.30% |
| Average Performer | 353 | 28.51% |
| Needs Improvement | 165 | 13.33% |

The seller-risk framework is similarly concentrated:

| Risk Level | Sellers | Share |
|---|---:|---:|
| Lower Risk | 1,125 | 90.87% |
| Moderate Risk | 95 | 7.67% |
| High Risk | 18 | 1.45% |

The evidence therefore points toward targeted seller management rather than a systemic seller crisis.

## Business Finding

The seller ecosystem is broadly healthy, with most eligible sellers classified as Lower Risk and only a small minority classified as High Risk.

Seller concentration remains measurable and should be monitored, but it should not automatically be labelled a business risk without an explicit benchmark.

## Risk Implication

The most important seller-management issue is therefore not marketplace-wide instability. It is the identification and monitoring of individual sellers whose revenue contribution, customer satisfaction or delivery performance makes their weaknesses commercially important.

## Recommendation

Maintain differentiated seller management:

- recognise and retain strong performers;
- provide targeted improvement support to Average and Needs Improvement sellers;
- closely monitor High Risk sellers;
- apply additional scrutiny to high-revenue sellers with weak reviews or delivery performance.

---

# 7. Growth Opportunities & Strategic Priorities

## Analysis

The category analysis identifies **12 Commercially Strong categories** and **one High Value / Lower Demand category** among the analysed categories.

The largest Commercially Strong categories include:

| Category | Seller-Attributed Sales |
|---|---:|
| beleza_saude | R$1.41M |
| relogios_presentes | R$1.26M |
| esporte_lazer | R$1.12M |
| utilidades_domesticas | R$758K |
| cool_stuff | R$692K |
| automotivo | R$669K |

These categories combine commercially meaningful sales with the characteristics defined by the investigation's classification methodology.

The regional opportunity indicator highlights:

| State | Opportunity Score |
|---|---:|
| PA | 68.27 |
| CE | 61.54 |
| PB | 61.54 |
| RJ | 59.62 |
| BA | 59.62 |
| AL | 57.69 |

PA is particularly notable because it combines relatively high AOV with high delivery time. This suggests potential commercial attractiveness but also an operational constraint that management should investigate before aggressively expanding.

The consolidated growth-opportunity analysis identifies:

- **316 eligible seller opportunities**
- **9 Very High Opportunity sellers**
- **307 High Opportunity sellers**
- **13 High Opportunity product categories**
- **51 eligible product categories**

The highest seller opportunity score is **87.41**, while the highest product-category opportunity score is **79.50**.

The opportunity model combines relative measures of:

- revenue headroom;
- customer acceptance;
- operational readiness;
- market activity.

These scores should be interpreted as **relative prioritisation indicators**, not forecasts of incremental revenue.

## Business Finding

The evidence supports selective expansion rather than broad-based expansion. Commercially strong categories, high-opportunity sellers and selected regions provide identifiable areas for further investigation, but operational readiness and customer acceptance should determine where expansion is prioritised.

---

# 8. Strategic Opportunities

## Opportunity 1 — Re-engage Existing Customers

The one-time customer population is substantially larger than the repeat customer population and already represents 94.4% of historical revenue.

This is likely to provide a more immediate opportunity than relying exclusively on new customer acquisition.

**Priority: Highest**

## Opportunity 2 — Selectively Scale High-Opportunity Sellers and Categories

The opportunity model identifies a sizeable pool of sellers and categories that score highly across relative opportunity dimensions.

Management should prioritise entities with strong customer acceptance and operational readiness rather than simply selecting those with the lowest current revenue.

**Priority: High**

## Opportunity 3 — Investigate High-Potential Regions with Operational Constraints

Regions such as PA and CE score highly on the regional opportunity indicator while also exhibiting longer delivery times than faster-performing regions.

The strategic opportunity is therefore not simply:

> Expand geographically.

It is:

> **Expand where commercial opportunity exists while simultaneously addressing operational constraints.**

**Priority: Selective / Conditional**

---

# 9. Strongest Executive Findings

## 1. Retention Is the Largest Commercial Weakness and Opportunity

**Finding:** 97% of active customers are one-time purchasers.

**Evidence:** 90,557 one-time customers versus 2,801 repeat customers; one-time customers account for 94.4% of historical revenue.

**Business meaning:** The marketplace has already acquired a very large customer base, but very few customers have demonstrated repeat purchasing behaviour.

**Why it matters:** Converting even a small proportion of existing one-time customers into repeat buyers could create incremental value without requiring the business to acquire an entirely new customer population.

---

## 2. Delivery Performance Is Closely Associated with Customer Satisfaction

**Finding:** Customer reviews decline substantially as delivery time increases.

**Evidence:** Average review score falls from 4.45 for orders delivered under five days to 3.65 for orders taking 15+ days.

**Business meaning:** Slower fulfilment is associated with materially weaker customer experience.

**Why it matters:** Delivery improvement may protect both customer satisfaction and the marketplace's ability to retain customers.

**Caveat:** The analysis demonstrates association, not causation.

---

## 3. Growth Is Meaningful but Uneven

**Finding:** Revenue growth is positive in 13 of 21 month-over-month observations.

**Evidence:** 61.9% of observed periods showed positive growth, while 38.1% showed negative growth. The detailed analysis contains 21 monthly observations: 11 Revenue Up / Customers Up, 7 Revenue Down / Customers Down, 2 Revenue Up / Customers Down and 1 Revenue Down / Customers Up.

**Business meaning:** Growth is substantial but not consistently upward, and customer activity explains many—but not all—monthly revenue movements.

**Why it matters:** Management should focus on repeatable growth mechanisms rather than interpreting isolated high-growth months as evidence of sustained momentum.

---

## 4. The Seller Ecosystem Is Broadly Healthy, with Targeted Risk

**Finding:** Most eligible sellers are not classified as high risk.

**Evidence:** 90.87% are Lower Risk, 7.67% Moderate Risk and 1.45% High Risk. There are 84 Elite sellers.

**Business meaning:** Seller performance problems appear concentrated rather than systemic.

**Why it matters:** A targeted seller-management programme is more appropriate than a broad marketplace intervention.

---

## 5. Growth Opportunities Should Be Selective and Operationally Grounded

**Finding:** The marketplace contains identifiable high-opportunity sellers, categories and regions, but the opportunity model does not guarantee future revenue.

**Evidence:** 9 Very High Opportunity sellers, 307 High Opportunity sellers and 13 High Opportunity categories; the highest seller opportunity score is 87.41 and highest category score is 79.50.

**Business meaning:** There are commercially attractive areas for further investigation, but expansion should favour entities with strong customer acceptance and operational readiness.

**Why it matters:** Selective expansion reduces the risk of scaling demand into areas where fulfilment or customer experience cannot support it.

---

# 10. Management Recommendations

## Recommendation 1 — Launch a Structured Customer Re-engagement Programme

**Problem / opportunity:** 97% of active customers are one-time purchasers.

**Recommended action:** Develop segmented reactivation campaigns based on historical purchase behaviour, product category, time since last purchase and customer value.

**Expected business benefit:** Increase repeat-purchase conversion and extract additional value from an already-acquired customer population.

**Primary KPI:** Repeat-purchase conversion rate.

**Supporting KPIs:** Reactivation revenue, repeat customer share, revenue per reactivated customer.

---

## Recommendation 2 — Treat Delivery Improvement as Both an Operational and Customer-Experience Initiative

**Problem / opportunity:** Orders taking 15+ days receive materially lower average reviews than faster orders.

**Recommended action:** Investigate the operational drivers of the long-delivery tail, prioritising weaker regions and sellers with repeated delivery issues.

**Expected business benefit:** Reduce extreme delivery delays, improve customer experience and potentially support customer retention.

**Primary KPIs:** Median delivery time, 15+ day delivery share, average review score by delivery band.

---

## Recommendation 3 — Scale Selectively Through High-Performing Sellers and Categories

**Problem / opportunity:** The opportunity model identifies high-opportunity sellers and categories.

**Recommended action:** Establish a controlled expansion pipeline using opportunity score, customer acceptance and operational readiness as screening criteria.

**Expected business benefit:** Direct growth resources toward areas with stronger evidence of commercial potential rather than expanding indiscriminately.

---

## Recommendation 4 — Establish Targeted Seller-Risk Management

**Problem / opportunity:** A small group of sellers presents elevated operational or customer-experience risk.

**Recommended action:** Create monitoring thresholds for high-risk sellers and particularly scrutinise high-revenue sellers with weak reviews or delivery performance.

**Expected business benefit:** Protect customer experience and reduce the possibility that a small number of problematic sellers create disproportionate reputational or operational damage.

---

# 11. If Management Could Focus on Only Three Priorities

## Priority 1 — Convert One-Time Customers into Repeat Customers

This is the strongest evidence-based priority.

The customer base is large, but repeat purchasing is exceptionally low. Re-engagement should therefore be treated as the primary commercial growth initiative.

## Priority 2 — Improve the Delivery Experience

The 10.22-day median is substantially more representative than the average, but the long tail is significant. The 15+ day segment also shows a materially lower average review score.

Operational improvement should therefore be treated as a customer-retention initiative as well as a logistics initiative.

## Priority 3 — Pursue Selective, Evidence-Led Expansion

The marketplace contains attractive sellers, categories and regions, but the opportunity scores are relative indicators rather than revenue forecasts.

Expansion should therefore focus on areas where commercial opportunity is supported by customer acceptance and operational readiness.

---

# 12. Analytical Limitations & Interpretation Notes

## Historical Customer Revenue vs Predictive CLV

The **R$165.20** metric should be interpreted as average historical customer revenue under the project's delivered-order definition, rather than as a predictive customer lifetime value forecast.

It describes realised historical transaction value. It does not estimate future customer revenue, expected retention duration or discounted future cash flows.

## Seller Concentration

The 14.19% top-10 and 23.10% top-20 seller shares demonstrate concentration, but they should not automatically be described as a business risk.

A risk conclusion would require a benchmark, management tolerance or additional evidence of dependency.

## Opportunity Scores

Seller, category and regional opportunity scores are relative analytical indicators.

They are useful for prioritising further investigation but should not be interpreted as forecasts of incremental revenue or guaranteed commercial outcomes.

## Delivery and Customer Satisfaction

The relationship between delivery speed and review score is descriptive/associational.

The analysis does not establish that delivery time alone causes lower satisfaction.

## Historical Dataset Limitation

The analysis is based on historical Olist marketplace transactions and therefore describes observed marketplace behaviour during the available period.

It should not automatically be treated as a forecast of future marketplace performance.

## Population Consistency Note

The executive snapshot reports **93,357 active customers and 96,478 delivered orders**, while one supporting query reports a one-customer difference in the active-customer population.

This indicates that the executive evidence queries should be reconciled at the SQL-definition level before publication if exact cross-query equality is required.

The primary executive KPI figures in this report use the authoritative snapshot values established during the investigation review.

---

# 13. Final Executive Conclusion

The marketplace demonstrates meaningful commercial scale and broadly positive customer experience, but its growth quality is constrained by weak customer retention and uneven operational performance.

The most important commercial opportunity is not simply acquiring more customers. It is converting the large existing one-time customer population into repeat purchasers.

At the same time, the delivery analysis indicates that operational performance has a meaningful relationship with customer experience, particularly among orders taking more than 15 days. Improving delivery reliability should therefore be viewed as part of the customer-retention strategy.

The seller ecosystem does not appear to present a broad systemic crisis. Most eligible sellers are classified as Lower Risk, while seller concentration remains moderate and should be monitored rather than automatically labelled as problematic.

Finally, the marketplace has identifiable growth opportunities across sellers, categories and regions. However, these opportunities should be pursued selectively, using customer acceptance and operational readiness alongside commercial potential.

The executive strategy emerging from the evidence is therefore:

> **Retain and re-engage existing customers → improve the delivery experience → selectively scale the strongest commercial opportunities.**

---

# 14. Investigation 43 — Portfolio Takeaway

Investigation 43 represents the transition from analytical SQL work to executive business communication.

The investigation demonstrates the ability to:

- consolidate evidence from multiple analytical domains;
- distinguish metrics from business insights;
- identify the most material commercial issues;
- interpret relationships without overstating causation;
- convert analytical findings into recommendations;
- identify limitations and benchmark requirements;
- prioritise management actions based on evidence.

The most important analytical lesson is that **a metric becomes an insight only when its business meaning, implication and decision relevance are clearly established**.

The investigation therefore closes the analytical portion of the project by transforming the outputs of the preceding investigations into an executive narrative suitable for portfolio presentation and business discussion.
