# Investigation 30 Report

## NTILE() – Customer and Business Segmentation

**Project:** Retail SQL Business Analysis – Brazilian E-Commerce (Olist) Dataset

**Phase:** Phase 7 – Window Functions

**Investigation:** 30

**Database:** PostgreSQL

**SQL Techniques:** Window Functions, `NTILE()`, `PARTITION BY`, `ORDER BY`, Common Table Expressions (CTEs), Aggregate Functions, `CASE`, `GROUP BY`, `INNER JOIN`

---

# Executive Summary

This investigation introduced the SQL window function `NTILE()`, a powerful analytical tool used to divide data into approximately equal-sized groups known as buckets. Unlike ranking functions such as `ROW_NUMBER()`, `RANK()` and `DENSE_RANK()`, `NTILE()` focuses on segmentation rather than assigning positional rankings.

Using the Brazilian E-Commerce (Olist) dataset, `NTILE()` was applied to products, customers, sellers, payments and orders to create meaningful business segments such as pricing tiers, customer spending groups and chronological purchase buckets.

The investigation demonstrated how segmentation enables organisations to classify records into comparable groups, providing valuable insights for customer analytics, pricing strategies, marketing campaigns and executive reporting.

---

# Business Objectives

The objectives of this investigation were to:

- Understand the purpose and syntax of the `NTILE()` window function.
- Divide datasets into equal-sized analytical groups.
- Create quartiles, quintiles and deciles.
- Apply `NTILE()` within partitions using `PARTITION BY`.
- Perform customer revenue segmentation.
- Build seller and product pricing tiers.
- Develop business-ready customer classification reports.
- Prepare for more advanced analytical window functions.

---

# Business Questions

This investigation answered the following business questions:

1. How can products be divided into price quartiles?
2. How can payment transactions be grouped into payment-value quintiles?
3. How can orders be divided into chronological deciles?
4. How can customers be segmented alphabetically?
5. How can products be segmented within their own categories?
6. How can seller transactions be grouped into pricing quartiles?
7. How can each customer's purchasing history be divided into chronological groups?
8. How can payment transactions be segmented within each payment method?
9. How can orders be segmented within each order status?
10. How can seller product portfolios be divided into pricing quintiles?
11. Which customers belong to the highest revenue quartile?
12. Which products belong to the highest pricing quartile?
13. How can seller pricing reports be generated using quartiles?
14. How can customer purchase reports be organised into chronological buckets?
15. How can customers be classified into revenue-based spending segments?

---

# SQL Techniques Used

## `NTILE()`

`NTILE()` divides rows into approximately equal-sized buckets based on a specified ordering.

Unlike ranking functions, the objective is to create balanced analytical groups rather than assign unique or competitive rankings.

Example:

```sql
NTILE(4)
OVER(
    ORDER BY payment_value DESC
)
```

This divides payment transactions into four quartiles based on payment value.

---

## `PARTITION BY`

`PARTITION BY` creates independent segmentation groups.

For example:

- Products within each category.
- Transactions within each seller.
- Orders within each customer.
- Payments within each payment type.

Each partition receives its own independent set of buckets.

---

## Aggregate Functions

Customer revenue segmentation combined

- `SUM()`
- `GROUP BY`

with window functions to calculate total customer spending before assigning quartiles.

This approach mirrors common business intelligence workflows.

---

## Common Table Expressions (CTEs)

CTEs were used extensively to separate analytical calculations from reporting logic.

This improves readability, maintainability and debugging while following industry SQL best practices.

---

## CASE Expressions

`CASE` expressions transformed numeric quartile values into meaningful business labels such as:

- Top 25%
- Upper Middle 25%
- Lower Middle 25%
- Bottom 25%

This produces reports that are easier for non-technical stakeholders to interpret.

---

# Key Findings

## Product Price Segmentation

Products were successfully divided into pricing quartiles and quintiles, enabling comparisons between premium, mid-range and lower-priced products.

---

## Customer Revenue Segmentation

Customer lifetime revenue was aggregated before segmentation.

This produced meaningful customer groups based on purchasing value rather than individual transactions.

---

## Seller Performance Analysis

Seller transactions were segmented independently using `PARTITION BY`, allowing fair comparisons within each seller's own product catalogue.

---

## Payment Segmentation

Payment transactions were grouped into value-based segments both globally and within payment methods.

This enables analysis of transaction distributions across different payment channels.

---

## Chronological Order Analysis

Orders were segmented into chronological buckets, making it easier to analyse purchasing activity over time.

---

## Business Classification

Numeric segmentation results were transformed into descriptive customer classifications suitable for dashboards, marketing campaigns and executive reports.

---

# Business Interpretation

Unlike ranking functions that answer *"Who is first?"*, `NTILE()` answers a different business question:

> **"Which performance group does this record belong to?"**

This distinction makes `NTILE()` one of the most valuable analytical tools for business intelligence.

Organisations frequently use segmentation to:

- Identify premium customers.
- Develop loyalty programmes.
- Create pricing strategies.
- Prioritise marketing campaigns.
- Monitor seller performance.
- Analyse purchasing behaviour.

By creating balanced analytical groups, businesses can compare similar records without relying solely on absolute rankings.

---

# Practical Business Applications

The analytical techniques demonstrated in this investigation have direct real-world applications.

### Customer Analytics

- Customer Lifetime Value segmentation.
- Loyalty programme design.
- Customer retention analysis.

### Sales Analytics

- Sales representative performance bands.
- Revenue distribution analysis.
- Performance benchmarking.

### Product Analytics

- Premium product identification.
- Product pricing tiers.
- Category-specific pricing analysis.

### Marketing

- Targeted promotions.
- Audience segmentation.
- Campaign prioritisation.

### Executive Reporting

- KPI dashboards.
- Performance summaries.
- Revenue distribution reports.

---

# Best Practices

Several important SQL best practices were reinforced throughout this investigation.

- Choose the number of buckets according to business objectives.
- Use `PARTITION BY` whenever segmentation should restart within logical groups.
- Perform aggregations before segmentation when analysing customer or seller performance.
- Use descriptive aliases for analytical columns.
- Separate analytical calculations using CTEs.
- Convert numeric buckets into business-friendly labels using `CASE`.
- Avoid unnecessary joins that do not contribute to the final result.

---

# Challenges Encountered

One of the key learning points was recognising that `NTILE()` creates groups based on the **number of rows**, not on equal value ranges.

When the total number of rows cannot be divided evenly, SQL distributes the additional rows among the earliest buckets, ensuring that bucket sizes differ by at most one row.

Another important consideration was determining when segmentation should apply globally and when it should restart within partitions such as sellers, customers or payment types.

---

# Analyst Reflection

This investigation represented an important transition from ranking records to classifying them into meaningful business groups.

The ability to combine aggregate functions, window functions, CTEs and conditional logic demonstrates how SQL can be used to build analytical datasets suitable for business intelligence and decision-making.

Customer revenue segmentation, in particular, reflects a common real-world analytical workflow used in customer relationship management, marketing and executive reporting.

These techniques provide a strong foundation for more advanced analytical functions explored later in the project.

---

# Business Recommendations

Based on the results of this investigation, organisations should consider:

- Segmenting customers by lifetime revenue to support targeted retention strategies.
- Using pricing quartiles to evaluate product positioning within categories.
- Monitoring seller performance using segmented pricing reports.
- Building loyalty programmes around customer spending tiers.
- Using segmented dashboards instead of raw rankings for executive reporting.
- Applying revenue segmentation to improve marketing efficiency and campaign targeting.
- Incorporating `NTILE()` into recurring business intelligence reports for continuous performance monitoring.

---

# Conclusion

This investigation successfully demonstrated the use of PostgreSQL's `NTILE()` window function for business segmentation.

Unlike traditional ranking functions, `NTILE()` enables analysts to divide data into balanced groups that support meaningful comparisons across customers, products, sellers, payments and orders.

By combining `NTILE()` with aggregate functions, Common Table Expressions, conditional logic and partitioning, the investigation produced business-ready analytical reports suitable for customer segmentation, pricing analysis and executive dashboards.

The knowledge gained in this investigation provides a solid foundation for the remaining window functions in Phase 7, particularly `LAG()`, `LEAD()`, `FIRST_VALUE()`, `LAST_VALUE()`, running totals and moving averages.

---

**End of Investigation 30**