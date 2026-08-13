# Investigation 44 — Business Recommendations

## 1. Investigation Overview

### Business Objective

Translate the validated findings from Investigations 34–42 into practical, evidence-based management recommendations that can support customer retention, operational improvement, seller management, and selective marketplace growth.

### Recommendation Framework

The recommendations are organised around a central strategic narrative:

> **Retain → Improve → Expand**

- **Retain** customers and strong-performing sellers by strengthening repeat purchasing and preserving marketplace quality.
- **Improve** delivery performance and targeted seller or regional weaknesses that may undermine customer experience.
- **Expand** selectively into validated sellers, categories, and regions only after commercial and operational evidence supports investment.

The recommendations are based on historical observational analysis. The SQL investigations identify patterns, relationships, and areas of opportunity; they do not independently establish that a proposed intervention will cause a particular business outcome.

---

# 2. Immediate Actions

## Q1 — Customer Re-engagement

### Evidence

Approximately **97% of active customers are one-time purchasers**, making customer re-engagement the clearest identifiable commercial opportunity in the analysis.

### Business Problem

The marketplace has acquired a substantial customer population, but relatively few customers have demonstrated repeat purchasing behaviour.

### Recommended Action

Launch a targeted customer re-engagement programme rather than treating all one-time customers identically.

Customers should be prioritised using:

- Recency since last delivered purchase
- Historical customer revenue
- Previous product or category purchased
- Customer-value or RFM characteristics
- Appropriate incentive eligibility

### Expected Impact

Increase repeat-purchase conversion, repeat-order volume, and revenue generated from previously acquired customers.

### KPIs

- Repeat-purchase rate
- Repeat-order conversion rate
- Incremental repeat revenue
- Re-engagement response rate

### Limitation

Historical analysis does not prove that an incentive, recommendation, or campaign will cause customers to return. Effectiveness should therefore be evaluated through controlled experiments or well-defined baseline comparisons.

---

## Q2 — Delivery Problem Identification

### Evidence

The analysis identifies a meaningful relationship between delivery duration and review performance. Orders taking **15+ days** fall into the investigation's long-delay analytical band and are associated with substantially lower average review scores than faster deliveries.

### Recommended Action

Introduce operational monitoring that flags:

- 15+ day deliveries
- States with persistently long delivery times
- Sellers with repeated delivery problems
- Extreme delivery outliers
- Problematic seller/logistics combinations

The **15+ day threshold is an analytical band used in this investigation, not a universal operational SLA**. Management should refine the operational threshold using contractual and service-level expectations.

### Expected Impact

Earlier identification of delivery problems should help reduce the long delivery tail and support improvements in customer experience.

### KPIs

- Percentage of delivered orders taking 15+ days
- Median delivery time
- State-level delivery performance
- Repeat long-delay rate by seller

### Limitation

The analysis demonstrates an association between delivery duration and customer reviews; it does not establish that delivery speed alone causes lower satisfaction.

---

## Q3 — High-Risk Seller Intervention

### Evidence

Only a small percentage of eligible sellers are classified as **High Risk**.

### Recommended Action

Use a targeted seller-intervention model rather than a marketplace-wide intervention.

High-risk sellers should receive focused reviews of:

- Delivery performance
- Customer feedback
- Sales exposure
- Operational consistency
- Recurring service failures

### Expected Impact

Concentrate marketplace-management resources on sellers presenting the strongest evidence of customer or operational risk.

### KPIs

- High-risk seller rate
- Risk-rate movement over time
- Repeat-risk incidence
- Customer satisfaction among monitored sellers

---

## Q4 — Protect Strong-Performing Sellers

### Evidence

The seller analysis identifies a substantial group of **Elite, High Performer, and Strong Performer** sellers.

### Recommended Action

Retain and develop strong sellers while ensuring that incentives or preferential treatment remain conditional on sustained customer and operational performance.

Potential actions include:

- Recognition and performance programmes
- Seller-development support
- Access to validated growth opportunities
- Improved support channels where justified

### Expected Impact

Preserve high-quality marketplace supply while supporting controlled seller growth.

### KPIs

- Retention rate of strong-performing sellers
- Seller performance stability
- Delivery performance
- Review performance
- Revenue contribution from retained strong sellers

---

# 3. Medium-Term Improvements

## Q5 — Customer Retention Programme

Build a structured retention programme around customer segments rather than a single broad campaign.

### Recommended Lifecycle

1. Identify customers using RFM and customer-value characteristics.
2. Trigger communications based on recency.
3. Personalise recommendations using previous categories or purchasing behaviour.
4. Apply incentives selectively.
5. Measure repeat purchasing against an appropriate baseline or control group.
6. Refine the programme using observed response rates.

### Expected Impact

Increase repeat purchasing and strengthen the economic value generated from previously acquired customers.

### KPIs

- Repeat-purchase rate
- Customer reactivation rate
- Repeat revenue
- Order frequency
- Customer-value movement

### Limitation

The historical dataset identifies the retention opportunity but cannot establish campaign ROI without campaign-cost and experimental data.

---

## Q6 — Delivery-Performance Improvement

### Evidence

Longer delivery durations are associated with weaker review outcomes, while the delivery distribution contains a substantial long tail.

### Recommended Action

Investigate the delivery process across:

- Seller handling time
- Carrier/logistics performance
- Regional constraints
- Fulfilment processes
- Seller–carrier combinations
- Recurring outlier routes

Management should distinguish seller-controlled delays from logistics- or geography-driven delays before assigning responsibility.

### Expected Impact

Reduce avoidable delays and potentially improve customer satisfaction.

### KPIs

- Median delivery time
- Percentage of 15+ day deliveries
- Delivery-time variance
- On-time delivery rate against the relevant SLA
- Review score by delivery band

### Limitation

The observed delivery–review relationship is associative rather than causal.

---

## Q7 — Seller-Performance Management

Seller management should be differentiated by performance tier rather than applied uniformly.

| Seller Group | Management Approach |
|---|---|
| **Elite / High Performer** | Retain, recognise, and selectively support expansion while maintaining quality standards. |
| **Strong Performer** | Develop and monitor for progression toward higher performance. |
| **Average Performer** | Provide targeted improvement guidance and monitor key service metrics. |
| **Needs Improvement** | Establish corrective-action plans with measurable targets. |
| **High Risk** | Apply focused intervention, root-cause analysis, and closer monitoring. |

### Expected Impact

Improve seller quality while protecting high-performing marketplace supply.

### KPIs

- Movement between seller-performance tiers
- Seller retention
- Review performance
- Delivery performance
- Revenue contribution by tier

---

## Q8 — Opportunity Prioritisation

### Evidence

The opportunity models identify potentially attractive sellers, categories, and regions.

### Recommended Action

Treat opportunity scores as **prioritisation indicators rather than revenue forecasts**.

Before allocating material investment, validate opportunities against:

- Demand evidence
- Customer acceptance
- Operational readiness
- Existing sales scale
- Implementation cost
- Expected incremental economics
- Operational constraints

Where uncertainty is high, management should pilot before broad rollout.

### Expected Impact

Create a disciplined expansion process and reduce the risk of investing heavily in historically attractive but operationally difficult opportunities.

### KPIs

- Opportunities validated
- Opportunity-to-pilot conversion
- Incremental revenue from validated opportunities
- Incremental margin where available
- Operational performance after expansion

### Limitation

The opportunity score is based on historical relative performance. It does not forecast future revenue or guarantee commercial success.

---

# 4. Long-Term Strategy

## Q9 — Sustainable Customer Growth

The long-term strategy should shift from an acquisition-only growth mindset toward a balanced **acquisition + retention** model.

The approximately **97% one-time-customer finding** indicates a large identifiable opportunity among previously acquired customers. However, the dataset does not contain acquisition costs or campaign economics, so it cannot establish that retention is universally cheaper or more profitable than acquisition.

The strategic direction should therefore be:

> **Acquire → Activate → Retain → Increase Customer Value**

The objective is not to reduce customer acquisition, but to ensure that customer acquisition is followed by stronger activation and repeat purchasing.

---

## Q10 — Marketplace Operating Model

The marketplace should optimise the broader relationship:

> **Customers → Sellers → Delivery → Satisfaction → Repeat Purchase → Revenue**

Growth should therefore be pursued alongside:

- Customer retention
- Seller quality
- Delivery reliability
- Customer satisfaction
- Repeat purchasing
- Sustainable revenue growth

This supports the overall **Retain → Improve → Expand** framework.

A revenue increase should not automatically be considered successful if it is accompanied by deterioration in delivery performance, seller quality, or customer satisfaction.

---

## Q11 — Geographic Expansion

Regions such as **PA, CE, and PB** may show attractive commercial opportunity while also displaying weaker delivery performance.

### Recommended Approach

Improve operational readiness before aggressive geographic expansion.

Management should first diagnose:

- Carrier availability
- Regional fulfilment constraints
- Seller concentration
- Handling time
- Route performance

Controlled expansion can follow once the relevant constraints are sufficiently understood.

### Expected Impact

Reduce the risk of expanding demand faster than the marketplace can reliably fulfil it.

### Limitation

Regional opportunity scores identify relative attractiveness; they do not establish a specific future revenue outcome.

---

## Q12 — Category and Seller Expansion

Management should use a portfolio approach that balances growth opportunity with evidence of operational readiness.

### Scaling Proven Categories

Continue supporting categories with demonstrated demand and commercial performance where operational execution is adequate.

### Developing High-Value / Lower-Demand Categories

Test whether stronger discovery, assortment, merchandising, or targeted marketing can unlock additional demand.

### Expanding High-Opportunity Sellers

Require adequate demand, customer acceptance, and operational readiness before significant expansion.

### Avoiding Overexpansion

Do not scale every category, seller, or region simply because it receives a high opportunity score.

Expansion should follow **validation and controlled testing**.

---

# 5. Recommendation Prioritisation

## Q13 — Three Highest-Priority Recommendations

### 1. Highest Priority — Customer Re-engagement and Retention

**Why:** Approximately 97% of active customers are one-time purchasers.

**Action:** Establish segmented re-engagement journeys based on recency, historical customer value, previous purchasing behaviour, and RFM characteristics.

**Expected benefit:** Increase repeat purchasing and revenue generated from previously acquired customers.

**Primary KPI:** Repeat-purchase rate.

**Supporting KPIs:** Incremental repeat revenue and reactivation rate.

---

### 2. Second Priority — Reduce the Long Delivery Tail

**Why:** Deliveries taking 15+ days are associated with substantially lower review scores than faster deliveries.

**Action:** Establish systematic monitoring of long-delay orders and investigate seller, logistics, and regional causes.

**Expected benefit:** Reduce avoidable delivery delays and improve customer experience.

**Primary KPI:** Percentage of delivered orders taking 15+ days, with the operational threshold refined against management SLA expectations.

**Supporting KPIs:** Median delivery time, on-time performance, and review score by delivery band.

---

### 3. Third Priority — Selective, Evidence-Validated Expansion

**Why:** The analysis identifies commercially attractive sellers, categories, and regions, but opportunity scores are relative indicators rather than forecasts.

**Action:** Prioritise opportunities through controlled pilots that validate demand, customer acceptance, operational readiness, and incremental economics before broader investment.

**Expected benefit:** Capture growth while limiting the risk of premature expansion.

**Primary KPI:** Incremental revenue from validated opportunities, evaluated against an appropriate baseline or controlled test where feasible.

---

# 6. What Management Should Not Do

## Q14 — Management Guardrails

Management should avoid the following:

### 1. Indiscriminate Geographic Expansion

A high regional opportunity score does not guarantee operational readiness. Expansion should follow operational diagnosis and validation, particularly where delivery performance is weak.

### 2. Treating Seller Concentration as Automatically Dangerous

The concentration findings are descriptive. Without an external benchmark or explicit risk threshold, concentration should not automatically be classified as a business risk.

### 3. Assuming Delivery Causes Poor Reviews

The analysis establishes an association between delivery duration and review outcomes, not causal proof. Management should investigate and test interventions rather than attributing dissatisfaction solely to delivery speed.

### 4. Treating Opportunity Scores as Revenue Forecasts

Opportunity scores identify relatively attractive candidates for further investigation. They do not estimate how much additional revenue a seller, category, or region will generate.

### 5. Applying Marketplace-Wide Seller Intervention

High-risk sellers represent only a small portion of eligible sellers. A targeted intervention model is therefore better aligned with the evidence than applying the same intervention to the entire seller base.

---

# 7. Success Measurement

## Q15 — Success Metrics

| Priority | Recommendation | Primary KPI | Supporting KPIs |
|---|---|---|---|
| **1** | Customer re-engagement and retention | Repeat-purchase rate | Reactivation rate, incremental repeat revenue, order frequency |
| **2** | Delivery-performance improvement | % of delivered orders taking 15+ days | Median delivery time, on-time rate against SLA, review score by delivery band |
| **3** | Selective opportunity expansion | Incremental revenue from validated opportunities | Incremental margin, pilot conversion rate, customer response, operational performance |

### Measurement Principle

The most important measurement principle is to evaluate **business outcomes rather than implementation activity**.

For example:

> Launching a re-engagement campaign is not itself a measure of success.  
> Increasing incremental repeat purchasing is.

Similarly, identifying an attractive opportunity does not constitute successful expansion. The business should measure whether a validated intervention produces incremental commercial value while maintaining acceptable customer and operational outcomes.

For selective expansion in particular, incremental impact should ideally be evaluated against an appropriate baseline or controlled test rather than simply comparing post-intervention revenue with historical performance.

---

# 8. Final Management Recommendation

The evidence from Investigations 34–42 supports a clear strategic sequence:

# RETAIN → IMPROVE → EXPAND

## RETAIN

Build stronger repeat purchasing among the existing customer base, beginning with the large one-time-customer population.

At the seller level, retain strong-performing sellers whose sustained performance contributes to marketplace quality and commercial activity.

## IMPROVE

Reduce the long delivery tail and address targeted seller and regional operational weaknesses that may undermine customer experience.

The objective is not simply to increase average performance, but to identify and reduce the operational failures that create disproportionately poor customer outcomes.

## EXPAND

Once customer retention and operational execution are being actively managed, selectively invest in validated high-opportunity sellers, categories, and regions through controlled investment and testing.

Expansion should therefore follow evidence of demand, customer acceptance, operational readiness, and incremental economics.

---

# 9. Executive Conclusion

The strongest strategic conclusion from the project is not simply that the marketplace should **grow**.

The evidence suggests that growth should become **more efficient, more reliable, and more sustainable**.

The recommended sequence is:

> **Strengthen the value of the existing customer base → improve marketplace operational reliability → scale validated growth opportunities.**

This produces the overarching management framework:

> **RETAIN → IMPROVE → EXPAND**

The framework connects the major findings from the project into a coherent business strategy:

- **Retain** customers and strong sellers.
- **Improve** delivery and targeted operational weaknesses.
- **Expand** only where commercial opportunity is supported by operational readiness and validation.

This approach recognises both the opportunities identified by the analysis and the limitations of historical observational data. It therefore provides management with a practical direction for action without overstating what the SQL analysis can prove.

---

# 10. Analytical Limitations Relevant to the Recommendations

The recommendations should be interpreted within the limitations established throughout the project.

1. **Historical observational data** cannot establish that a proposed intervention will cause a specific outcome.
2. The dataset does not provide **marketing campaign costs**, limiting direct measurement of customer-acquisition or retention ROI.
3. Opportunity scores are **relative prioritisation frameworks**, not forward-looking revenue forecasts.
4. The relationship between delivery duration and reviews is **associative rather than causal**.
5. Seller concentration is descriptive and should not automatically be interpreted as a risk without an appropriate benchmark.
6. Operational SLAs used by a real marketplace may differ from analytical thresholds used in this project.
7. Controlled experimentation and post-intervention measurement would be required to establish the incremental effect of the proposed actions.

These limitations do not invalidate the recommendations. Instead, they define how the recommendations should be implemented: as **testable, measurable business hypotheses rather than guaranteed outcomes**.

---

# 11. Investigation Outcome

Investigation 43 converts the strategic findings from Investigations 34–42 into an actionable management framework.

The investigation establishes three priorities:

1. **Customer retention and re-engagement** as the highest-priority commercial opportunity.
2. **Delivery-performance improvement** as the primary operational/customer-experience priority.
3. **Selective, evidence-validated expansion** as the preferred approach to sustainable marketplace growth.

The resulting recommendation is:

> **RETAIN → IMPROVE → EXPAND**

This completes the business-recommendation stage of the analytical project and provides the foundation for the final reflection on the complete analytical journey in **Investigation 44 — Project Reflection & Analytical Insights**.
