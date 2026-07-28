# Investigation 32 Report

## LEAD() – Business Forecasting and Forward Trend Analysis

**Project:** Retail SQL Business Analysis – Brazilian E-Commerce (Olist) Dataset

**Phase:** Phase 7 – Window Functions

**Investigation:** 32

**Database:** PostgreSQL

**SQL Script:** 26 – `26_lead_business_forecasting_analysis.sql`

**SQL Techniques:** Window Functions, `LEAD()`, `PARTITION BY`, `ORDER BY`, Common Table Expressions (CTEs), Date and Time Arithmetic, `INNER JOIN`

---

# Executive Summary

This investigation explored PostgreSQL's `LEAD()` window function, which retrieves values from subsequent rows within an ordered dataset. Unlike `LAG()`, which looks backwards at historical records, `LEAD()` enables analysts to compare current records with future events, making it a valuable tool for forecasting, customer lifecycle analysis and operational planning.

Using the Brazilian Olist E-Commerce dataset, forward-looking reports were created to examine customer purchasing behaviour, payment progression, seller pricing trends and future business events. By combining `LEAD()` with `PARTITION BY`, the investigation produced customer-specific and seller-specific forecasts while maintaining logical analytical boundaries.

The investigation demonstrated how forward-looking SQL analysis can support predictive reporting and business decision-making without requiring complex self-joins.

---

# Business Objectives

The objectives of this investigation were to:

- Understand the syntax and behaviour of the `LEAD()` window function.
- Compare current business events with future events.
- Forecast customer purchasing behaviour.
- Analyse future payment trends.
- Monitor seller pricing progression.
- Calculate the time remaining until future customer purchases.
- Produce forecasting datasets suitable for dashboards and business intelligence reporting.

---

# Business Questions

This investigation answered the following business questions:

1. What is the next order purchase timestamp?
2. What is the next payment value?
3. When is each customer's next purchase?
4. What is the next product price recorded by each seller?
5. How much does the next payment differ from the current payment?
6. How long until each customer's next purchase?
7. How do seller prices change between consecutive sales?
8. What is the next order within each order status?
9. What is the next payment within each payment type?
10. What payment occurs two transactions later?
11. How can customer purchase forecast reports be produced?
12. How can seller pricing forecast reports be generated?
13. Which payments are followed by larger payments?
14. Which customers return within 30 days of a purchase?
15. How can customer payment forecasting reports be created?

---

# SQL Techniques Used

## LEAD()

`LEAD()` retrieves data from a following row within an ordered window.

```sql
LEAD(column_name)
OVER(
    ORDER BY column_name
)
```

This enables forward-looking comparisons without requiring self-joins.

---

## PARTITION BY

`PARTITION BY` divides data into independent groups before `LEAD()` is applied.

Examples include:

- Customer purchase history.
- Seller pricing history.
- Payment method forecasting.
- Order status progression.

Each partition produces an independent sequence of future values.

---

## ORDER BY

The ordering clause determines what PostgreSQL considers to be the "next" record.

Without a logical ordering, `LEAD()` cannot determine future events accurately.

---

## Common Table Expressions (CTEs)

CTEs were used to:

- Improve readability.
- Separate forecasting calculations from reporting logic.
- Calculate projected differences.
- Build reusable analytical datasets.

This structure reflects SQL development best practices.

---

## Date and Time Arithmetic

Timestamp subtraction was used to calculate the remaining time until future customer purchases.

These calculations support customer retention analysis and lifecycle forecasting.

---

# Key Findings

## Customer Purchase Forecasting

`LEAD()` successfully identified each customer's next purchase date, making it possible to estimate purchasing frequency and customer engagement.

---

## Payment Forecasting

Current payments were compared with subsequent payments to identify increasing and decreasing payment patterns.

This provides useful insight into future revenue trends.

---

## Seller Pricing Trends

Seller transactions were analysed independently using `PARTITION BY`, allowing pricing progression to be monitored for each seller.

This supports pricing strategy analysis and competitive monitoring.

---

## Operational Forecasting

Order progression within each order status demonstrated how `LEAD()` can be used to analyse operational workflows and event sequences.

---

## Customer Engagement

Customers returning within 30 days were successfully identified, providing a practical indicator of repeat purchasing behaviour and customer loyalty.

---

# Business Interpretation

Whereas `LAG()` answers:

> **"What happened before this event?"**

`LEAD()` answers:

> **"What happens next?"**

This forward-looking perspective is fundamental to forecasting and planning.

Businesses frequently require information about future events rather than historical comparisons.

Typical examples include:

- Next customer purchase.
- Next payment.
- Next shipment.
- Next product price.
- Next operational milestone.

`LEAD()` provides these insights directly within SQL.

---

# Practical Business Applications

The techniques demonstrated in this investigation can be applied across numerous business functions.

### Customer Analytics

- Customer lifecycle forecasting.
- Repeat purchase prediction.
- Customer engagement analysis.
- Retention monitoring.

### Revenue Analytics

- Revenue forecasting.
- Payment progression.
- Sales trend analysis.

### Pricing Strategy

- Seller price monitoring.
- Product pricing evolution.
- Competitive pricing analysis.

### Operations

- Workflow progression.
- Event sequencing.
- Operational planning.

### Executive Reporting

- Forecast dashboards.
- Forward-looking KPIs.
- Predictive operational reporting.

---

# Best Practices

The investigation reinforced several SQL best practices.

- Always define an appropriate `ORDER BY` clause.
- Use `PARTITION BY` when forecasting within business entities.
- Keep window calculations separate from business calculations using CTEs.
- Use meaningful aliases such as `next_payment` and `next_purchase_timestamp`.
- Apply offsets when analysing events multiple rows ahead.
- Handle final rows appropriately by allowing `NULL` values or supplying default values where necessary.

---

# Challenges Encountered

The primary challenge involved correctly determining when forward-looking comparisons should restart.

Several business questions required forecasting within individual customers or sellers rather than across the entire dataset. Applying `PARTITION BY` ensured that future values remained logically associated with the correct business entity.

Another consideration involved defining meaningful business thresholds, such as identifying customers whose next purchase occurred within 30 days. These thresholds represent business rules that should be documented whenever they are applied.

---

# Analyst Reflection

This investigation extended the concepts introduced with `LAG()` by shifting the focus from historical analysis to forecasting.

Rather than comparing current events with past activity, the investigation demonstrated how SQL can anticipate future business events using ordered datasets.

Combining `LEAD()` with CTEs and calculated columns resulted in clear, reusable SQL that mirrors real-world business intelligence workflows.

These techniques are commonly used in production reporting environments to support operational planning and predictive analytics.

---

# Business Recommendations

Based on this investigation, organisations should consider:

- Monitoring the time until customers' next purchases to improve retention strategies.
- Identifying customers likely to repurchase quickly for targeted marketing campaigns.
- Tracking future payment progression to support revenue forecasting.
- Monitoring seller pricing trends to identify pricing strategy changes.
- Incorporating forward-looking metrics into executive dashboards.
- Combining `LEAD()` with segmentation techniques to improve customer lifecycle analysis.
- Expanding forecasting models with running totals and moving averages for deeper analytical insights.

---

# Conclusion

This investigation successfully demonstrated PostgreSQL's `LEAD()` window function for forward-looking business analysis.

By retrieving subsequent values within ordered datasets, `LEAD()` enabled customer purchase forecasting, payment progression analysis, seller pricing trend evaluation and operational event forecasting.

Together with the previous investigation on `LAG()`, this investigation established a comprehensive understanding of sequential window analysis in PostgreSQL. These techniques form an essential foundation for advanced analytical reporting, including running totals, moving averages, cumulative metrics and executive dashboard development.

---

**End of Investigation 32**