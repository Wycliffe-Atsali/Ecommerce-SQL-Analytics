# Investigation 28 Report

## Window Functions – Introduction to `ROW_NUMBER()`

**Project:** Retail SQL Business Analysis – Brazilian E-Commerce (Olist) Dataset

**Phase:** Phase 7 – Window Functions

**Investigation:** 28

**Database:** PostgreSQL

**SQL Techniques:** Window Functions, `OVER()`, `PARTITION BY`, `ORDER BY`, `ROW_NUMBER()`, Common Table Expressions (CTEs), Joins

---

# Executive Summary

This investigation introduced SQL Window Functions through the implementation of the `ROW_NUMBER()` function. Unlike aggregate functions that summarise data into grouped results, window functions perform calculations across related rows while preserving every record in the dataset.

Using customer, order, seller and payment information from the Olist e-commerce database, this investigation demonstrated how `ROW_NUMBER()` can be used to create sequential rankings within logical groups. Business scenarios included identifying customers' first and most recent purchases, sequencing customer order histories, ranking seller transactions by price, ranking payments within payment methods, and determining the earliest order in each Brazilian state.

The investigation establishes the conceptual foundation for more advanced ranking and analytical window functions that will be explored throughout Phase 7.

---

# Business Objectives

The primary objectives of this investigation were to:

- Introduce the concept of SQL Window Functions.
- Understand the purpose of the `OVER()` clause.
- Learn how `PARTITION BY` creates independent analytical groups.
- Apply `ROW_NUMBER()` to generate sequential rankings.
- Compare window functions with traditional aggregate queries.
- Solve realistic business reporting problems using row-level analytics.
- Prepare for more advanced ranking techniques such as `RANK()` and `DENSE_RANK()`.

---

# Business Questions

This investigation addressed the following analytical questions:

1. How can every order be numbered chronologically?
2. How can every order be numbered in reverse chronological order?
3. How can customers be sequentially listed alphabetically?
4. How can sellers be sequentially listed alphabetically?
5. How can customer purchases be numbered according to purchase history?
6. Which order represents each customer's first purchase?
7. Which order represents each customer's most recent purchase?
8. How can orders be numbered within each order status?
9. How can seller transactions be ranked according to selling price?
10. How can payments be ranked within each payment method?
11. How can only the first purchase for every customer be retrieved?
12. How can only the latest purchase for every customer be retrieved?
13. Which transaction represents each seller's highest-priced sale?
14. Which order was the first recorded within each customer state?
15. How can a complete customer purchasing timeline be produced using sequential order numbers?

---

# SQL Techniques Used

## Window Functions

Window functions perform calculations across a defined set of related rows while preserving every row in the result set.

Unlike aggregate functions, window functions do not reduce the number of rows returned.

### `OVER()`

The `OVER()` clause defines the window over which a calculation is performed.

It transforms functions such as `ROW_NUMBER()` into analytical functions capable of operating across multiple related rows.

### `PARTITION BY`

`PARTITION BY` divides the dataset into logical groups.

Each partition is processed independently, allowing numbering and calculations to restart for every customer, seller, payment type or order status.

### `ORDER BY` within `OVER()`

The `ORDER BY` clause inside the window determines the sequence used for ranking.

It should not be confused with the final `ORDER BY` statement used to sort query results.

### `ROW_NUMBER()`

`ROW_NUMBER()` assigns a unique sequential number to every row within a partition.

Unlike `RANK()`, duplicate ordering values do not receive the same row number.

### Common Table Expressions (CTEs)

CTEs were used extensively to improve readability by separating ranking logic from filtering operations.

This approach improves maintainability and follows common industry best practices.

---

# Key Findings

## Customer Purchase Sequencing

`ROW_NUMBER()` made it possible to identify the complete purchasing journey for every customer by assigning a chronological sequence number to each purchase.

This creates a clear customer timeline without losing transaction-level detail.

## First Purchase Identification

Ranking purchases in ascending order enabled efficient identification of every customer's first purchase.

This technique forms the basis of customer acquisition reporting and onboarding analysis.

## Latest Purchase Identification

Ranking purchases in descending order allowed the most recent purchase for every customer to be identified.

This approach is commonly used in customer retention analysis and CRM reporting.

## Seller Transaction Ranking

Seller transactions were ranked according to selling price, making it possible to identify each seller's highest-value sales while preserving all transaction records.

## Payment Analysis

Payments were independently ranked within each payment method.

This demonstrated how financial transactions can be compared without aggregating the underlying data.

## Geographic Chronology

Partitioning by customer state made it possible to identify the earliest recorded purchase within each Brazilian state.

This technique supports regional performance analysis and market expansion studies.

---

# Business Interpretation

Window functions significantly expand the analytical capabilities available to SQL professionals.

Instead of summarising data into grouped results, they enrich every record with additional analytical context while preserving the original dataset.

The techniques demonstrated in this investigation have numerous practical applications, including:

- Customer acquisition reporting
- Customer lifecycle analysis
- Purchase journey analysis
- Sales performance evaluation
- Regional business expansion analysis
- Transaction monitoring
- Customer relationship management (CRM)
- Fraud detection and duplicate record management

Many production reporting systems rely heavily on window functions because they provide analytical insight without sacrificing row-level detail.

---

# Best Practices

Several SQL best practices were reinforced throughout this investigation.

- Use meaningful aliases for generated ranking columns.
- Include deterministic tie-breakers (such as `order_id`) when ordering by timestamps.
- Avoid unnecessary table joins.
- Separate ranking logic using Common Table Expressions.
- Keep business logic separate from presentation logic.
- Use descriptive aliases that communicate business meaning.
- Apply window functions whenever row-level detail must be preserved alongside analytical calculations.

Following these practices improves readability, reliability and long-term maintainability.

---

# Challenges Encountered

The primary conceptual challenge was understanding the difference between aggregate functions and window functions.

While `GROUP BY` summarises multiple rows into a single result, window functions retain every row while adding analytical calculations.

Another important consideration involved deterministic ordering.

When ranking rows using timestamps, additional ordering columns such as `order_id` should be included to ensure consistent and reproducible results whenever identical timestamps occur.

---

# Analyst Reflection

This investigation represents an important milestone in progressing from intermediate SQL to advanced analytical SQL.

Learning `ROW_NUMBER()` required adopting a different perspective on data analysis.

Rather than reducing information through aggregation, window functions enrich each record with valuable analytical context.

This capability enables significantly more sophisticated reporting and forms the foundation for many real-world business intelligence solutions.

Mastering `ROW_NUMBER()` also prepares analysts for more advanced window functions such as `RANK()`, `DENSE_RANK()`, `NTILE()`, `LAG()`, `LEAD()`, `FIRST_VALUE()` and `LAST_VALUE()`.

---

# Business Recommendations

Based on this investigation, organisations should consider:

- Tracking every customer's purchasing journey using sequential order numbers.
- Monitoring customer acquisition by identifying first purchases.
- Measuring customer engagement using latest purchase activity.
- Ranking seller transactions to identify high-value sales.
- Applying window functions in operational dashboards to preserve detailed transactional information.
- Incorporating customer sequence analysis into retention and loyalty programmes.
- Leveraging window functions for future predictive analytics and customer segmentation initiatives.

---

# Conclusion

This investigation successfully introduced SQL Window Functions through the implementation of `ROW_NUMBER()`.

The investigation demonstrated how `OVER()`, `PARTITION BY` and `ORDER BY` work together to perform analytical calculations while preserving individual records.

Unlike traditional aggregation techniques, window functions provide additional analytical context without reducing the size of the dataset, making them an essential tool for modern business intelligence and data analytics.

The knowledge gained during this investigation provides the foundation for the remaining Phase 7 investigations, where more advanced ranking, comparison and time-based analytical functions will be explored.

---
**End of Investigation 28**