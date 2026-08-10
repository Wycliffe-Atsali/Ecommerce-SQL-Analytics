# Investigation 38: Delivery Performance & Operational Analysis

---

## Executive Summary

Delivery performance is one of the most influential operational drivers of customer satisfaction in an e-commerce marketplace. While revenue generation, customer acquisition, and product performance determine commercial success, efficient order fulfillment determines whether customers receive the experience they were promised.

This investigation evaluates operational performance by measuring how efficiently sellers fulfill customer orders throughout the delivery process. Rather than focusing solely on delivery speed, the analysis incorporates multiple operational dimensions—including delivery duration, delivery delays, on-time delivery rates, freight costs, and customer review scores—to provide a comprehensive assessment of seller logistics performance.

The investigation progresses from individual operational metrics to an integrated delivery performance framework. Each seller is evaluated using standardized KPIs that are converted onto a common 100-point scale, allowing metrics with different units to be compared objectively. These standardized metrics are then combined into a weighted scorecard that produces an overall Delivery Performance Score, enabling consistent benchmarking across all sellers regardless of order volume.

Finally, sellers are classified into operational performance categories ranging from **Operational Excellence** to **Critical Risk**, providing business stakeholders with a practical framework for identifying high-performing logistics partners, monitoring operational risks, and prioritizing improvement initiatives.

---

# Business Problem

Marketplace success depends not only on attracting customers but also on delivering purchases reliably and efficiently.

Customers expect orders to arrive:

- Within the promised delivery window.
- In good condition.
- At a reasonable shipping cost.
- With minimal uncertainty throughout the delivery process.

When delivery performance deteriorates, businesses often experience:

- Lower customer satisfaction.
- Increased negative reviews.
- Higher customer support costs.
- More refund and compensation requests.
- Reduced customer retention.
- Damage to marketplace reputation.

Because thousands of sellers operate simultaneously within the Olist marketplace, management requires a standardized method for evaluating operational performance across all sellers.

Simple metrics such as average delivery time provide only a partial picture of operational efficiency. A seller may deliver quickly but incur excessive freight costs, while another may deliver slightly slower but maintain exceptional reliability and customer satisfaction.

This investigation addresses that challenge by combining multiple operational KPIs into a unified performance framework that supports consistent, data-driven evaluation.

---

# Investigation Objectives

The primary objective of this investigation is to measure seller operational performance throughout the delivery lifecycle.

Specific objectives include:

- Measure average delivery duration for every seller.
- Identify sellers experiencing the greatest delivery delays.
- Calculate on-time delivery performance.
- Evaluate customer satisfaction using review scores.
- Measure freight costs associated with seller operations.
- Compare delivery performance across customer states.
- Compare delivery performance across product categories.
- Rank sellers according to operational efficiency.
- Examine the relationship between delivery delays and customer reviews.
- Consolidate operational KPIs into a single reporting framework.
- Standardize delivery metrics onto a common performance scale.
- Develop a weighted delivery scorecard.
- Classify sellers into operational performance categories.
- Identify top-performing operational sellers.
- Summarize the characteristics of each performance classification.

---

# Business Questions

This investigation answers the following business questions:

1. Which sellers have the shortest average delivery times?
2. Which sellers experience the greatest delivery delays?
3. What percentage of deliveries arrive on or before the estimated delivery date?
4. How do customer review scores differ across sellers?
5. Which sellers incur the highest freight costs?
6. Which customer states experience the slowest deliveries?
7. Which product categories require the longest delivery times?
8. Which sellers consistently achieve the highest on-time delivery performance?
9. Which sellers rank worst in delivery delays?
10. Are delivery delays associated with lower customer review scores?
11. How can multiple delivery KPIs be combined into a single operational dashboard?
12. How can operational KPIs be standardized for objective comparison?
13. How should sellers be classified according to delivery performance?
14. Which sellers demonstrate the strongest overall operational performance?
15. What operational characteristics distinguish each delivery performance category?

---

# Datasets Used

The investigation combines operational information from several related tables:

| Table | Purpose |
|--------|----------|
| **orders** | Delivery dates, estimated delivery dates, purchase timestamps and order status |
| **order_items** | Seller information, freight values and product references |
| **order_reviews** | Customer satisfaction through review scores |
| **customers** | Customer geographic location for regional analysis |
| **products** | Product category information for category-level comparisons |

Together, these tables provide a complete view of the order fulfillment process, from purchase through final delivery and post-purchase customer feedback.

---

# Methodology

Unlike earlier investigations that focused primarily on commercial performance, this investigation evaluates operational excellence by examining how effectively sellers fulfill customer orders after a purchase has been made.

The analysis follows a progressive analytical framework in which each business question builds upon the previous one. Instead of producing isolated metrics, the investigation gradually develops a comprehensive delivery performance scorecard capable of comparing every seller using standardized operational KPIs.

The methodology consists of five analytical stages:

---

## Stage 1: Operational KPI Measurement

The investigation begins by calculating the fundamental metrics that describe delivery performance.

These include:

- Average delivery duration
- Average delivery delay
- On-time delivery percentage
- Average customer review score
- Freight charges

Each KPI measures a different aspect of seller operations.

For example:

- Delivery duration measures overall fulfillment speed.
- Delivery delay measures how frequently sellers fail to meet customer expectations.
- On-time delivery percentage measures operational consistency.
- Customer reviews measure post-purchase satisfaction.
- Freight charges represent shipping cost efficiency.

Together, these metrics provide a balanced view of operational performance.

---

## Stage 2: Comparative Operational Analysis

Once the individual KPIs have been calculated, the investigation compares operational performance across multiple business dimensions.

Comparisons include:

- Seller-level performance
- Customer state performance
- Product category performance

These comparisons help determine whether delivery performance varies across geographic regions, product categories, or individual sellers.

Rather than identifying only the fastest or slowest sellers, this stage highlights operational patterns that may require managerial attention.

---

## Stage 3: Operational Benchmarking

Individual operational metrics become significantly more valuable when converted into rankings.

This investigation ranks sellers according to:

- Delivery delays
- On-time delivery performance

Ranking transforms raw operational measurements into business benchmarks, allowing decision-makers to quickly identify operational leaders and underperforming sellers.

Benchmarking also supports future performance monitoring by providing a repeatable evaluation framework.

---

## Stage 4: Operational Relationship Analysis

Operational metrics rarely exist in isolation.

This investigation therefore examines whether delivery performance influences customer satisfaction by measuring the statistical relationship between delivery delays and customer review scores.

Using PostgreSQL's `CORR()` function, the analysis evaluates the strength and direction of the relationship between:

- Average delivery delay
- Average customer review score

Although correlation does not establish causation, it provides valuable evidence regarding whether delivery performance contributes to the overall customer experience.

---

## Stage 5: Delivery Performance Framework

The final stage consolidates all operational KPIs into a single performance framework.

Instead of evaluating sellers using separate metrics, the investigation produces one standardized operational score representing overall delivery performance.

The framework consists of four sequential steps:

1. Calculate operational KPIs.
2. Standardize all KPIs onto a common 100-point scale.
3. Apply business-defined KPI weights.
4. Compute an overall Delivery Performance Score.

This approach allows sellers with different operational profiles to be compared objectively using one composite performance metric.

---

# KPI Standardization

The operational metrics used throughout this investigation are measured using different units.

For example:

| KPI | Original Unit |
|------|---------------|
| Delivery Time | Days |
| Delivery Delay | Days |
| On-Time Delivery | Percentage |
| Review Score | Rating (1–5) |
| Freight Charges | Brazilian Real (BRL) |

Because these measurements are expressed on different scales, they cannot be combined directly into a single score.

To address this challenge, every KPI is standardized to a common 1–100 scale.

Standardization ensures that each metric contributes proportionally to the final performance score while preserving its relative importance.

For metrics that naturally exist as percentages, such as on-time delivery rate, no additional transformation is required.

Metrics measured in different units, including delivery duration and freight charges, are standardized using `NTILE(100)`, which ranks sellers into one hundred equally sized performance groups.

Customer review scores are converted from the original 1–5 scale to a percentage using the following formula:

```text
(Review Score ÷ 5) × 100
```

This produces a consistent scoring framework that enables meaningful comparison across all operational KPIs.

---

# Delivery Performance Scorecard

The final stage of this investigation transforms multiple operational metrics into a single delivery performance score.

Operational KPIs are naturally measured using different units. Delivery duration and delivery delays are measured in days, freight charges are measured in Brazilian Real (BRL), review scores use a five-point rating system, while on-time delivery is already expressed as a percentage. Because these measurements cannot be combined directly, each KPI is first standardized onto a common 100-point scale.

This investigation applies the following weighting strategy:

| KPI                         | Weight |
| --------------------------- | ------ |
| On-Time Delivery Percentage | 40%    |
| Delivery Performance Score  | 25%    |
| Customer Review Score       | 20%    |
| Freight Efficiency Score    | 15%    |

The weighting reflects business priorities. Delivering orders within the promised timeframe is considered the most important operational objective, followed by overall delivery speed, customer satisfaction, and finally freight efficiency.

The weighted scorecard provides a balanced evaluation of seller logistics performance while preventing any single metric from dominating the final assessment.

---

# Seller Performance Classification

Once weighted scores are calculated, sellers are grouped into five operational performance categories.

| Delivery Score | Classification         |
| -------------- | ---------------------- |
| 90–100         | Operational Excellence |
| 75–89          | Reliable               |
| 60–74          | Needs Monitoring       |
| 45–59          | High Risk              |
| Below 45       | Critical Risk          |

These classifications simplify operational reporting by converting numerical scores into actionable business categories. Rather than reviewing hundreds of individual seller metrics, managers can quickly identify which sellers consistently exceed expectations and which require operational intervention.

---

# Key Business Insights

This investigation demonstrates several important operational analytics concepts.

First, delivery performance extends beyond delivery speed. Sellers must balance fast fulfillment, reliable on-time delivery, reasonable shipping costs, and positive customer experiences to achieve strong operational performance.

Second, customer satisfaction should not be evaluated independently of logistics performance. The inclusion of correlation analysis allows the business to investigate whether delayed deliveries are associated with lower review scores, providing quantitative evidence to support operational decision-making.

Third, standardized scorecards provide a more objective method for comparing sellers than individual KPIs. A seller with slightly slower deliveries may still outperform competitors through exceptional reliability and consistently positive customer feedback.

Finally, seller classifications provide a scalable framework for monitoring marketplace operations. Instead of reviewing thousands of sellers individually, management can prioritize operational improvement efforts based on performance category.

---

# Technical Skills Demonstrated

This investigation showcases several advanced SQL techniques commonly used in business intelligence and analytics projects, including:

* Common Table Expressions (CTEs)
* Multi-table joins across operational datasets
* Aggregate calculations
* Window functions (`RANK()` and `NTILE()`)
* Statistical correlation using `CORR()`
* KPI standardization
* Weighted scorecard development
* Performance classification using `CASE`
* Operational dashboard construction

Together, these techniques demonstrate how SQL can be used not only for querying relational databases but also for building reusable analytical frameworks capable of supporting strategic business decisions.

---

# Conclusion

Delivery performance is a critical component of customer experience and marketplace success. Through the integration of delivery duration, delivery reliability, freight costs, and customer satisfaction, this investigation develops a comprehensive operational assessment framework capable of evaluating seller performance from multiple perspectives.

The resulting delivery scorecard provides a repeatable and scalable methodology for benchmarking operational excellence, identifying high-performing sellers, and highlighting areas requiring improvement. More importantly, it demonstrates how SQL can be applied beyond data extraction to design decision-support systems that transform raw operational data into meaningful business intelligence.

This investigation further reinforces the progression of the project from descriptive reporting toward strategic analytics, illustrating how advanced SQL techniques can be combined with business reasoning to solve real-world operational challenges.
