# Investigation 29 Report

## Window Functions – Understanding `RANK()` and `DENSE_RANK()`

**Project:** Retail SQL Business Analysis – Brazilian E-Commerce (Olist) Dataset

**Phase:** Phase 7 – Window Functions

**Investigation:** 29

**Database:** PostgreSQL

**SQL Techniques:** Window Functions, `RANK()`, `DENSE_RANK()`, `PARTITION BY`, `ORDER BY`, Common Table Expressions (CTEs), Joins

---

# Executive Summary

This investigation expanded upon the introduction to SQL window functions by exploring the behaviour and practical applications of `RANK()` and `DENSE_RANK()`. These ranking functions enable analysts to assign meaningful rankings to rows while appropriately handling duplicate values.

Using the Brazilian E-Commerce (Olist) dataset, ranking techniques were applied to products, sellers, payments, customers and geographical data. Unlike `ROW_NUMBER()`, which always generates unique sequential numbers, `RANK()` and `DENSE_RANK()` preserve equal rankings for identical values, making them better suited for competitive comparisons and business reporting.

The investigation demonstrated how different ranking functions influence analytical outcomes and highlighted the importance of selecting the appropriate ranking method based on business requirements.

---

# Business Objectives

The primary objectives of this investigation were to:

- Understand the purpose and behaviour of `RANK()`.
- Learn how `DENSE_RANK()` differs from `RANK()`.
- Compare `ROW_NUMBER()`, `RANK()` and `DENSE_RANK()`.
- Apply ranking functions to real-world business scenarios.
- Rank products, sellers, payments and customer purchases.
- Develop an understanding of business situations where ranking gaps are either desirable or undesirable.
- Prepare for more advanced analytical window functions in subsequent investigations.

---

# Business Questions

This investigation answered the following business questions:

1. How can products be ranked according to selling price?
2. How can products be ranked using dense rankings?
3. How can payments be ranked according to payment value?
4. How can payments be ranked without ranking gaps?
5. How can products be ranked within each product category?
6. How can sellers rank their product sales by price?
7. How can customer purchases be ranked within each customer's purchasing history?
8. How can dense rankings be applied to customer purchase histories?
9. How do `RANK()` and `DENSE_RANK()` behave when comparing payments within each payment method?
10. How can orders be ranked chronologically within each order status?
11. Which products represent each seller's highest-priced sales?
12. Which products are the highest-priced within each product category?
13. Which orders represent the earliest purchases within each customer state?
14. How do `ROW_NUMBER()`, `RANK()` and `DENSE_RANK()` differ when applied to the same dataset?
15. How can seller performance reports benefit from multiple ranking methods?

---

# SQL Techniques Used

## Window Functions

Window functions allow calculations to be performed across related rows without reducing the number of records returned.

Unlike aggregate functions, every transaction remains visible while additional analytical information is added.

---

## `RANK()`

`RANK()` assigns identical rankings to rows that contain equal ordering values.

When ties occur, subsequent rankings are skipped.

Example:

| Price | Rank |
|------:|----:|
| 1000 | 1 |
| 900 | 2 |
| 900 | 2 |
| 700 | 4 |

This behaviour closely resembles competitive rankings used in sporting events and sales competitions.

---

## `DENSE_RANK()`

`DENSE_RANK()` also assigns identical rankings to tied values.

However, unlike `RANK()`, no ranking numbers are skipped.

Example:

| Price | Dense Rank |
|------:|----------:|
| 1000 | 1 |
| 900 | 2 |
| 900 | 2 |
| 700 | 3 |

Dense rankings are particularly useful for business dashboards and customer segmentation.

---

## `PARTITION BY`

`PARTITION BY` divides a dataset into independent analytical groups.

Each ranking begins again within its own partition, making it possible to rank customers, sellers, payment methods and product categories independently.

---

## Common Table Expressions (CTEs)

CTEs improved readability by separating ranking calculations from filtering and reporting logic.

This structure follows industry best practices for writing maintainable SQL.

---

# Key Findings

## Product Price Rankings

Products were successfully ranked according to selling price using both `RANK()` and `DENSE_RANK()`.

This demonstrated how identical product prices influence rankings depending on the selected ranking function.

---

## Customer Purchase Rankings

Customer purchases were ranked chronologically within each customer's purchasing history.

This provides valuable insight into customer purchasing behaviour while preserving every transaction.

---

## Seller Performance Rankings

Seller transactions were ranked according to product selling price.

The analysis also identified each seller's highest-priced product sales, including situations where multiple products shared the highest value.

---

## Payment Rankings

Payments were ranked within each payment method.

Comparing `RANK()` and `DENSE_RANK()` highlighted how duplicate payment values influence the final ranking sequence.

---

## Product Category Rankings

Products were ranked within their respective categories, allowing fair comparisons among similar products instead of across the entire catalogue.

---

## Geographic Analysis

Ranking customer orders within each state identified the earliest recorded purchases across Brazil.

This provides a useful starting point for analysing regional market growth and customer acquisition.

---

# Business Interpretation

Ranking functions play an important role in business intelligence because they allow analysts to compare records without losing transactional detail.

The investigation demonstrated that different ranking methods answer different business questions.

`RANK()` is appropriate when competitive positions should reflect ties, even if later rankings contain gaps.

`DENSE_RANK()` is better suited to reporting environments where continuous ranking sequences improve readability.

Choosing the appropriate ranking function is therefore not simply a technical decision but a business decision driven by reporting requirements.

---

# Comparison of Ranking Functions

| Function | Duplicate Values | Ranking Gaps | Typical Use Cases |
|-----------|-----------------|--------------|-------------------|
| `ROW_NUMBER()` | No | No | Customer timelines, deduplication, first or latest records |
| `RANK()` | Yes | Yes | Competitions, leaderboards, sales rankings |
| `DENSE_RANK()` | Yes | No | Dashboards, segmentation, reporting |

Understanding these differences enables analysts to produce reports that accurately reflect business expectations.

---

# Best Practices

Several SQL best practices were reinforced during this investigation.

- Select the ranking function according to the business requirement rather than personal preference.
- Use meaningful aliases for ranking columns.
- Apply `PARTITION BY` whenever rankings should restart within logical groups.
- Avoid unnecessary joins to improve query efficiency.
- Use CTEs to separate ranking calculations from reporting logic.
- Preserve ties when the business requires equal rankings.
- Clearly document why a particular ranking function was selected.

---

# Challenges Encountered

The primary challenge was understanding that `RANK()` and `DENSE_RANK()` produce identical results until duplicate ordering values appear.

Only when ties occur does the behavioural difference become visible.

Another important consideration involved choosing whether rankings should restart within partitions or continue across the entire dataset.

Recognising the appropriate business context is essential for selecting the correct solution.

---

# Analyst Reflection

This investigation strengthened the understanding of analytical ranking techniques in SQL.

While `ROW_NUMBER()` focuses on assigning unique sequential numbers, `RANK()` and `DENSE_RANK()` introduce a more business-oriented approach by recognising ties between records.

These functions are commonly used in production reporting systems because they support accurate comparisons while preserving meaningful business relationships.

Mastering these ranking techniques provides an essential foundation for more advanced analytical functions such as `NTILE()`, `LAG()`, `LEAD()`, `FIRST_VALUE()` and `LAST_VALUE()`.

---

# Business Recommendations

Based on this investigation, organisations should consider:

- Using `RANK()` for competitive sales and performance leaderboards where tied positions should be recognised.
- Applying `DENSE_RANK()` in dashboards and executive reports where continuous rankings improve clarity.
- Incorporating ranking functions into customer behaviour and retention analyses.
- Ranking products within categories instead of across the entire catalogue to produce fairer comparisons.
- Monitoring seller performance using ranked transaction reports.
- Leveraging ranking functions in operational dashboards to improve business decision-making.

---

# Conclusion

This investigation successfully demonstrated the practical application of `RANK()` and `DENSE_RANK()` within PostgreSQL using the Olist e-commerce dataset.

The analysis highlighted the importance of selecting the correct ranking function based on business objectives rather than purely technical considerations.

By comparing the behaviour of `ROW_NUMBER()`, `RANK()` and `DENSE_RANK()`, the investigation established a strong foundation for more advanced analytical techniques that will be explored throughout the remainder of Phase 7.

The concepts introduced here are widely used in modern business intelligence, reporting systems and technical interviews, making them an essential component of every SQL analyst's skill set.

---

**End of Investigation 29**