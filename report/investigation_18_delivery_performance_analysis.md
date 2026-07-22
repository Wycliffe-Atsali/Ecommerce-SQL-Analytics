# Investigation 18: Delivery Performance Analysis

## Project Information

| Project | Retail SQL Business Analysis |
|----------|------------------------------|
| Investigation | 18 |
| Title | Delivery Performance Analysis |
| Database | PostgreSQL |
| Dataset | Brazilian E-Commerce Public Dataset by Olist |
| Analysis Type | Relational Analysis (JOINs) |
| Primary Table | `orders` |
| Supporting Table | `customers` |

---

# Business Objective

Evaluate the efficiency and reliability of the company's delivery operations by analyzing delivery timelines, shipping delays, and adherence to promised delivery dates.

The objective of this investigation is to measure operational logistics performance, identify potential delivery bottlenecks, and generate business insights that can improve customer satisfaction and supply chain efficiency.

---

# Business Context

For an e-commerce company, the customer experience extends beyond product quality. Delivery speed and reliability significantly influence customer satisfaction, repeat purchases, and brand reputation.

Customers expect their orders to arrive within the estimated delivery window. Delays can result in negative reviews, increased support requests, and reduced customer loyalty.

From a business perspective, management wants to understand:

- How long deliveries typically take.
- Whether promised delivery dates are being met.
- Which regions experience slower deliveries.
- Where operational improvements should be prioritized.
- Whether delivery estimates accurately reflect actual performance.

These insights help logistics teams optimize carrier performance, improve delivery estimates, and enhance the overall customer experience.

---

# Business Questions

This investigation answers the following business questions:

1. How many total orders exist?
2. How many orders have been successfully delivered?
3. How many orders are missing delivery information?
4. What is the distribution of order statuses?
5. How many orders contain complete delivery-related timestamps?
6. What is the average delivery duration?
7. What are the minimum, maximum, and median delivery times?
8. Which orders experienced the longest delivery durations?
9. How many delivered orders arrived on or before the estimated delivery date?
10. How many delivered orders arrived after the estimated delivery date?
11. What percentage of delivered orders arrived on time?
12. Which customer states experience the longest delivery times?
13. Which customer states have the highest percentage of late deliveries?
14. How long does it take for approved orders to be handed to the shipping carrier?
15. On average, how many days earlier or later than the estimated delivery date are orders delivered?

---

# Database Thinking

Before writing SQL, the required business entities were identified.

## Primary Table

### `orders`

Contains all timestamps required to measure the delivery lifecycle:

- Purchase timestamp
- Order approval timestamp
- Carrier pickup timestamp
- Customer delivery timestamp
- Estimated delivery timestamp
- Order status

---

## Supporting Table

### `customers`

Used to associate delivery performance with customer locations.

Relationship:

```text
customers
      │
customer_id
      │
orders
```

---

# Relationship Paths

## Delivery Performance

```text
orders
```

---

## Regional Delivery Analysis

```text
customers
      │
customer_id
      │
orders
```

No additional tables were required because delivery events are stored entirely within the `orders` table.

---

# Analysis Grain

The analysis is performed at the **order level**.

Each row represents one customer order and one complete delivery lifecycle.

Choosing the correct grain is essential because delivery timestamps belong to an order rather than individual products or payments.

---

# Methodology

The investigation followed the established analytical workflow:

```text
Business Problem

↓

Database Thinking

↓

Identify Required Tables

↓

Determine Relationships

↓

Select Appropriate JOIN

↓

Develop SQL Queries

↓

Interpret Results

↓

Generate Business Recommendations
```

The analysis progressed from validating data quality to measuring operational KPIs and finally comparing delivery performance across customer regions.

---

# SQL Techniques Used

This investigation introduced and reinforced several PostgreSQL techniques, including:

- INNER JOIN
- Aggregate functions
- Conditional aggregation using `FILTER`
- Date and timestamp arithmetic
- `EXTRACT(EPOCH)`
- Time interval calculations
- `ROUND()`
- `ORDER BY`
- `GROUP BY`
- `COUNT()`
- `AVG()`
- `MIN()`
- `MAX()`
- `PERCENTILE_CONT()` for median calculation

---

# Data Quality Considerations

Before calculating delivery metrics, records were evaluated for completeness.

Orders missing essential timestamps were excluded from analyses where those timestamps were required.

Examples include:

- Missing customer delivery dates
- Missing carrier pickup dates
- Missing estimated delivery dates

This ensured that delivery metrics were based only on valid operational data.

---

# Key Findings

## 1. Strong Delivery Completion Rate

Out of approximately 99,000 orders, over 96,000 contained a recorded customer delivery date, indicating that the vast majority of orders were successfully fulfilled.

---

## 2. Delivery Duration

The average delivery duration was approximately **12 days** from purchase to customer delivery.

This provides a baseline KPI for monitoring future logistics performance.

---

## 3. On-Time Delivery Performance

Most delivered orders arrived on or before their estimated delivery date.

This suggests that delivery estimates were generally reliable and that logistics operations consistently met customer expectations.

---

## 4. Late Deliveries

Although relatively uncommon, several thousand orders arrived after their promised delivery date.

These orders represent opportunities for operational improvement and should be investigated further.

---

## 5. Regional Differences

Average delivery times varied across customer states.

Geographic location appears to influence logistics performance, likely due to transportation infrastructure, shipping distance, or carrier availability.

---

## 6. Carrier Processing Time

The average time between order approval and carrier pickup was relatively short, indicating efficient internal order processing before shipment.

---

## 7. Conservative Delivery Estimates

Orders were delivered, on average, several days before the estimated delivery date.

This suggests that estimated delivery dates may intentionally include additional buffer time to reduce the likelihood of missed promises.

---

# Business Interpretation

The findings indicate that the company's logistics network performs well overall.

High on-time delivery rates demonstrate effective coordination between order processing and shipping operations.

However, delivery performance is not uniform across all regions. Some states experience longer delivery durations and higher rates of late deliveries, suggesting that localized operational challenges exist.

Improving logistics performance in these regions could enhance customer satisfaction while reducing customer support costs and negative reviews.

---

# Business Recommendations

## Recommendation 1

Investigate customer states with the longest average delivery times.

Determine whether delays are caused by carrier performance, geographic distance, or warehouse capacity.

---

## Recommendation 2

Monitor late delivery rates by carrier and region to identify consistently underperforming logistics partners.

---

## Recommendation 3

Continue tracking on-time delivery percentage as a core operational KPI.

This metric provides a direct measure of customer service performance.

---

## Recommendation 4

Review estimated delivery calculations.

If deliveries consistently arrive well before estimated dates, customer expectations may be managed more accurately through refined delivery estimates.

---

## Recommendation 5

Develop an executive dashboard that monitors:

- Average delivery time
- On-time delivery percentage
- Late delivery percentage
- Average carrier pickup time
- Regional delivery performance

This would support continuous operational monitoring and strategic decision-making.

---

# Challenges Encountered

Several analytical considerations arose during this investigation.

## Accurate Time Calculations

Using `EXTRACT(DAY FROM interval)` returns only the day component of an interval and ignores remaining hours and minutes.

To improve accuracy, delivery durations were calculated using:

```sql
EXTRACT(EPOCH FROM (timestamp_difference)) / 86400
```

This approach preserves fractional days and produces more precise averages.

---

## KPI Design

Initially, on-time delivery percentages were calculated using all orders as the denominator.

This was refined so that both the numerator and denominator referred only to delivered orders.

This adjustment ensured that the KPI accurately reflected logistics performance rather than overall order volume.

---

## Data Completeness

Not every order contains all delivery-related timestamps.

Cancelled, unavailable, or in-progress orders were excluded from analyses requiring completed delivery information.

---

# Analyst Reflection

This investigation strengthened practical experience with timestamp arithmetic and operational KPI design.

A key takeaway was that accurate business metrics depend not only on correct SQL syntax but also on selecting the appropriate population for analysis.

The investigation also reinforced the importance of choosing the correct analytical grain and validating data quality before performing calculations.

---

# Interview Notes

Potential interview discussion points include:

- Why delivery analysis should be performed at the order level.
- The difference between delivery duration and delivery punctuality.
- Advantages of using `EXTRACT(EPOCH)` over `EXTRACT(DAY)`.
- Appropriate use of `PERCENTILE_CONT()` for median calculations.
- Importance of matching KPI numerators and denominators.
- Handling missing timestamps in operational datasets.
- Business implications of regional delivery performance differences.

---

# Skills Demonstrated

This investigation demonstrates proficiency in:

- Multi-table joins
- Operational KPI analysis
- Timestamp arithmetic
- Conditional aggregation
- Statistical analysis
- Median calculation
- Regional performance analysis
- Business interpretation
- Data quality validation
- Executive reporting

---

# Conclusion

Investigation 18 evaluated the company's delivery performance from both operational and customer perspectives.

The analysis showed that the logistics network successfully delivers the majority of orders within the promised delivery window while maintaining an average delivery time of approximately twelve days.

Regional differences in delivery performance highlight opportunities for targeted operational improvements, while consistently early deliveries suggest that estimated delivery dates may include conservative buffers.

Beyond reinforcing advanced SQL techniques such as timestamp arithmetic, conditional aggregation, and ordered-set aggregates, this investigation emphasized an equally important analytical principle: meaningful business insights depend on selecting the correct level of analysis, validating data quality, and designing KPIs that accurately represent the business process being measured.

This investigation marks another step toward developing production-ready analytical workflows suitable for real-world Business Intelligence and Data Analytics environments.