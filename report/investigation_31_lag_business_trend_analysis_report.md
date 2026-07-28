# Investigation 31 Report

## LAG() – Business Trend Analysis

**Project:** Retail SQL Business Analysis – Brazilian E-Commerce (Olist) Dataset

**Phase:** Phase 7 – Window Functions

**Investigation:** 31

**Database:** PostgreSQL

**SQL Script:** 25 – `25_lag_business_trend_analysis.sql`

**SQL Techniques:** Window Functions, `LAG()`, `PARTITION BY`, `ORDER BY`, Common Table Expressions (CTEs), Date/Time Arithmetic, Aggregate Functions, `INNER JOIN`

---

# Executive Summary

This investigation explored PostgreSQL's `LAG()` window function, a powerful analytical feature used to retrieve values from previous rows without requiring self-joins or complex subqueries. Unlike ranking functions that assign positions or groups, `LAG()` enables analysts to compare each record with a previous event, making it essential for trend analysis and time-series reporting.

Using the Olist Brazilian E-Commerce dataset, previous order timestamps, payment values and seller prices were retrieved and compared with current values to measure changes over time. The investigation also demonstrated how `PARTITION BY` allows comparisons to restart within logical business groups such as customers, sellers, payment methods and order statuses.

The resulting analyses provide practical examples of customer purchase trends, payment behaviour and seller pricing history, all of which are common requirements in business intelligence and operational reporting.

---

# Business Objectives

The objectives of this investigation were to:

- Understand the purpose and syntax of the `LAG()` window function.
- Retrieve previous values within ordered datasets.
- Compare current and previous business events.
- Calculate changes in payments and product prices.
- Measure time intervals between customer purchases.
- Apply `PARTITION BY` to perform entity-specific trend analysis.
- Build business-ready trend reports suitable for dashboards and executive reporting.

---

# Business Questions

This investigation addressed the following business questions:

1. What was the previous order's purchase timestamp?
2. What was the previous payment value?
3. What was each customer's previous purchase date?
4. What was each seller's previous product price?
5. How much did each payment change compared with the previous payment?
6. How much time elapsed between consecutive customer purchases?
7. How did seller product prices change over time?
8. What was the previous order within each order status?
9. What was the previous payment within each payment type?
10. What payment occurred two transactions earlier?
11. How can customer purchase trend reports be produced?
12. How can seller pricing trend reports be generated?
13. Which payment transactions increased compared with the immediately previous payment?
14. Which customers returned after unusually long periods without purchasing?
15. How can customer payment trend reports be prepared for business reporting?

---

# SQL Techniques Used

## `LAG()`

`LAG()` retrieves values from preceding rows according to a specified ordering.

```sql
LAG(column_name)
OVER(
    ORDER BY column_name
)
```

The function enables comparisons between the current record and one or more previous records.

---

## `PARTITION BY`

`PARTITION BY` allows previous-value calculations to restart independently for different business entities.

Examples include:

- Customer purchase history.
- Seller pricing history.
- Payment method analysis.
- Order status tracking.

Without partitioning, previous values may belong to unrelated records, producing misleading results.

---

## Common Table Expressions (CTEs)

CTEs were used to separate window calculations from business calculations such as differences and intervals.

This improves readability, modularity and maintainability while following SQL best practices.

---

## Date and Time Arithmetic

Timestamp subtraction was used to calculate the elapsed time between consecutive purchases.

This enables customer purchasing frequency analysis and retention monitoring.

---

## Offset Parameters

The investigation demonstrated the use of different offsets.

```sql
LAG(payment_value)
```

returns the immediately previous value, while

```sql
LAG(payment_value, 2)
```

retrieves the value from two rows earlier.

Offsets provide flexibility when analysing historical trends.

---

# Key Findings

## Previous Purchase Tracking

Customer purchase histories were successfully reconstructed by retrieving previous purchase timestamps for each customer.

This enables businesses to analyse purchasing frequency and customer engagement.

---

## Payment Trend Analysis

Payment values were compared against previous transactions, making it possible to identify increases and decreases over time.

Such analyses are commonly used in financial reporting and revenue monitoring.

---

## Seller Pricing History

Seller transactions were analysed independently using `PARTITION BY`, allowing product price changes to be monitored within each seller's catalogue.

This supports pricing strategy evaluation and seller performance analysis.

---

## Operational Order Monitoring

Order histories were analysed within each order status, allowing operational workflows to be examined chronologically.

---

## Customer Retention Analysis

Time intervals between purchases highlighted customers who returned after extended periods of inactivity.

These insights can support retention campaigns and customer re-engagement initiatives.

---

# Business Interpretation

Unlike ranking functions that classify or order records, `LAG()` focuses on historical comparison.

Instead of asking:

> **"Who ranks first?"**

it answers:

> **"What happened immediately before this event?"**

This perspective is fundamental to business analytics because organisations frequently evaluate performance by comparing current results with previous activity.

Examples include:

- Month-over-month revenue.
- Customer purchasing frequency.
- Product price changes.
- Operational processing times.
- Financial performance trends.

---

# Practical Business Applications

The techniques demonstrated in this investigation have direct applications across multiple business functions.

### Customer Analytics

- Purchase frequency analysis.
- Customer retention monitoring.
- Churn detection.
- Loyalty programme evaluation.

### Sales Analytics

- Revenue trend analysis.
- Payment comparisons.
- Sales performance monitoring.

### Pricing Analytics

- Seller pricing history.
- Product price trend analysis.
- Pricing strategy evaluation.

### Operations

- Order processing timelines.
- Workflow monitoring.
- Operational efficiency reporting.

### Executive Reporting

- Period-over-period KPI analysis.
- Trend dashboards.
- Business performance reporting.

---

# Best Practices

The investigation reinforced several important SQL development practices.

- Always define a meaningful `ORDER BY` clause when using `LAG()`.
- Use `PARTITION BY` whenever comparisons should restart within business entities.
- Separate analytical calculations using CTEs for improved readability.
- Calculate differences in outer queries rather than repeating window functions.
- Use descriptive aliases that clearly distinguish current and previous values.
- Handle the first row appropriately by accepting `NULL` values or supplying a default value when appropriate.

---

# Challenges Encountered

One of the most important learning points involved determining the correct scope for comparisons.

Several business questions required clarification regarding whether comparisons should be performed across the entire dataset or independently for each customer or seller. This reinforced the importance of understanding business requirements before implementing SQL solutions.

Another challenge involved identifying "unusually long" purchase gaps. SQL can calculate the elapsed time between purchases, but defining what qualifies as unusual requires a business rule or analytical assumption. In this investigation, a threshold of **30 days** was used as an example for identifying extended inactivity.

---

# Analyst Reflection

This investigation marked an important progression from ranking and segmentation towards trend analysis.

Rather than examining isolated records, `LAG()` made it possible to compare current events with historical activity, revealing patterns that are not visible through simple aggregations alone.

The investigation also demonstrated the value of combining window functions with CTEs and calculated columns to produce clear, maintainable SQL suitable for production reporting.

These techniques closely reflect the workflows used by data analysts when building business intelligence solutions.

---

# Business Recommendations

Based on the analyses performed, organisations should consider:

- Monitoring customer purchase intervals to identify early signs of churn.
- Tracking seller pricing changes to evaluate pricing strategies.
- Analysing payment trends to detect unusual transaction behaviour.
- Incorporating historical comparisons into executive dashboards.
- Using previous-value analysis to monitor operational performance over time.
- Combining `LAG()` with customer segmentation techniques to improve retention strategies.
- Expanding trend reporting with running totals and moving averages for deeper business insights.

---

# Conclusion

This investigation successfully demonstrated the use of PostgreSQL's `LAG()` window function for historical comparison and trend analysis.

By retrieving previous values within ordered datasets and combining them with arithmetic calculations, the investigation produced practical reports for customer purchasing behaviour, payment analysis, seller pricing history and operational monitoring.

The techniques introduced provide a strong analytical foundation for more advanced window functions such as `LEAD()`, `FIRST_VALUE()`, `LAST_VALUE()`, running totals and moving averages, which build upon the same principles of ordered analytical processing.

---

**End of Investigation 31**