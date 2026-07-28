# Investigation 33: Window Aggregation Business Analysis
## FIRST_VALUE(), LAST_VALUE(), Running Totals and Moving Averages

---

# Executive Summary

This investigation explored advanced SQL window aggregation functions used for cumulative analysis and business reporting. Unlike traditional aggregate functions that reduce multiple rows into a single result, window aggregation functions preserve row-level detail while calculating cumulative metrics across ordered datasets.

The investigation focused on four major analytical techniques:

- FIRST_VALUE()
- LAST_VALUE()
- Running Totals using SUM() OVER()
- Moving Averages using AVG() OVER()

These techniques enable analysts to answer complex business questions such as identifying first and latest customer purchases, monitoring cumulative revenue growth, tracking seller sales progression, and smoothing fluctuations through moving averages. Such calculations are fundamental in financial reporting, customer analytics, executive dashboards, and business intelligence systems.

---

# Business Objectives

The objectives of this investigation were to:

- Identify the earliest and latest values within ordered business data.
- Calculate cumulative revenue without collapsing transaction-level records.
- Analyse customer purchasing progression over time.
- Monitor cumulative seller sales.
- Produce rolling averages for trend analysis.
- Demonstrate advanced window frame specifications.
- Build business-ready datasets suitable for executive reporting.

---

# Business Questions

The investigation addressed the following analytical questions:

1. What was the first order placed in the dataset?
2. What was the final recorded order?
3. When did each customer place their first order?
4. What was each seller's first recorded sale?
5. How does cumulative revenue grow over time?
6. How do seller sales accumulate across transactions?
7. How does customer spending accumulate throughout their purchasing history?
8. What is the moving average of payment values?
9. What is the moving average of seller product prices?
10. How can first and last order dates be displayed together?
11. What is each customer's latest purchase value?
12. How does cumulative revenue differ across payment methods?
13. How do seller revenues grow over time?
14. How can customer purchase history be summarised into a single analytical report?
15. How can multiple window aggregation functions be combined into a dashboard-ready dataset?

---

# SQL Techniques Used

The investigation introduced and reinforced several advanced SQL techniques, including:

- FIRST_VALUE()
- LAST_VALUE()
- SUM() OVER()
- AVG() OVER()
- Window Frames
- PARTITION BY
- ORDER BY
- ROWS BETWEEN
- INNER JOIN
- Running Totals
- Moving Averages
- Customer Lifetime Analysis
- Seller Performance Tracking

---

# Key Findings

## 1. FIRST_VALUE() Simplifies Historical Analysis

FIRST_VALUE() efficiently identifies the earliest value within an ordered window, making it useful for determining the first customer purchase, the first seller transaction, or the earliest event in a timeline.

---

## 2. LAST_VALUE() Requires Explicit Window Frames

Unlike FIRST_VALUE(), LAST_VALUE() can produce misleading results if the window frame is not defined explicitly. Using:

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
         AND UNBOUNDED FOLLOWING
```

ensures that the function evaluates the entire partition and returns the true final value.

---

## 3. Running Totals Preserve Transaction Detail

Running totals provide cumulative metrics while retaining every transaction. This enables analysts to observe revenue growth over time without losing the underlying detail.

Typical applications include:

- cumulative revenue
- cumulative customer spending
- cumulative seller sales

---

## 4. Moving Averages Reduce Volatility

Moving averages smooth short-term fluctuations, making long-term trends easier to interpret.

This is particularly valuable when analysing:

- sales performance
- customer payments
- pricing behaviour
- revenue growth

---

## 5. PARTITION BY Enables Independent Business Analysis

Partitioning calculations by customer, seller, or payment type allows each business entity to maintain its own independent cumulative calculations, providing more meaningful insights than global calculations.

---

## 6. Window Aggregates Support Executive Reporting

By combining multiple window functions in a single query, analysts can produce comprehensive datasets containing:

- first purchase
- latest purchase
- cumulative spending
- moving averages

These datasets are well suited for executive dashboards and performance monitoring.

---

# Business Interpretation

The techniques explored in this investigation have direct business applications.

Running totals help organisations monitor revenue growth and identify acceleration or slowdown in sales. FIRST_VALUE() and LAST_VALUE() support customer lifecycle analysis by revealing when relationships began and the most recent interactions. Moving averages reduce the impact of short-term volatility, enabling more reliable trend identification.

Combined together, these functions allow decision-makers to monitor operational performance while retaining the detail necessary for deeper investigation.

---

# Business Recommendations

Based on this investigation, the following recommendations are proposed:

- Incorporate cumulative revenue metrics into executive dashboards.
- Track customer lifetime spending using running totals.
- Use moving averages to identify sustained sales trends rather than reacting to daily fluctuations.
- Monitor seller revenue progression to identify high-performing and declining sellers.
- Apply FIRST_VALUE() and LAST_VALUE() to measure customer lifecycle duration and retention.
- Combine multiple window aggregation metrics into reusable reporting views for business intelligence tools.

---

# Analyst Reflection

This investigation represented a significant step in developing advanced SQL analytical skills. Understanding window aggregation functions demonstrated how SQL can perform sophisticated calculations without sacrificing row-level detail.

A particularly valuable lesson was recognising the importance of window frame definitions, especially when working with LAST_VALUE(). Mastering these concepts strengthens the ability to build accurate reports and scalable analytical solutions.

These techniques closely mirror those used in production environments for financial reporting, operational monitoring, and customer analytics.

---

# Conclusion

Investigation 33 completed the study of SQL window aggregation functions by introducing FIRST_VALUE(), LAST_VALUE(), running totals, and moving averages. These functions provide powerful tools for analysing sequential business data while preserving transactional detail.

Together with previous investigations covering ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE(), LAG(), and LEAD(), this investigation completes a comprehensive foundation in SQL window functions.

The knowledge gained forms an essential component of professional SQL development and prepares the project for the next phase of advanced business analytics, where these techniques will be applied to customer lifetime value, RFM segmentation, advanced KPIs, and executive reporting.