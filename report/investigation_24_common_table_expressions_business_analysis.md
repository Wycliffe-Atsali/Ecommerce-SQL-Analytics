# Investigation 24 – Common Table Expressions (CTEs) Business Analysis

## Business Objective

The objective of this investigation was to introduce **Common Table Expressions (CTEs)** as a method for simplifying complex SQL queries and improving query readability. The investigation demonstrates how reusable intermediate result sets can support customer, seller, category, and revenue analysis while reducing repetitive SQL code.

---

# Business Context

As business reporting grows in complexity, analysts often need to reuse the same aggregated datasets across multiple analyses. Writing the same aggregation repeatedly increases the likelihood of errors and makes SQL difficult to maintain.

Common Table Expressions (CTEs) address this problem by allowing intermediate datasets to be defined once and referenced multiple times within a query. This investigation demonstrates how CTEs improve analytical workflows while producing the same business insights as nested subqueries.

---

# Learning Objectives

By completing this investigation, the following skills were developed:

- Understand the purpose of Common Table Expressions (CTEs).
- Create reusable analytical datasets.
- Replace repeated subqueries with cleaner SQL.
- Chain multiple CTEs together.
- Improve SQL readability and maintainability.
- Produce professional business reports using modular SQL.

---

# Database Thinking

Before writing SQL, the required business entities were identified.

### Customer Revenue

```
Customers
    ↓
Orders
    ↓
Order Payments
```

### Seller Revenue

```
Sellers
    ↓
Order Items
```

### Product Category Revenue

```
Products
    ↓
Order Items
```

### Monthly Revenue

```
Orders
    ↓
Order Payments
```

Each relationship produces an aggregated dataset that can be reused throughout the investigation.

---

# Methodology

The investigation followed these steps:

1. Build reusable revenue summaries using CTEs.
2. Calculate customer revenue.
3. Calculate seller revenue.
4. Calculate product category revenue.
5. Calculate monthly revenue.
6. Compare values against overall averages.
7. Demonstrate multiple CTEs (CTE chaining).
8. Evaluate the benefits of CTEs over nested subqueries.

---

# Business Questions

The investigation answered the following questions:

1. How can customer revenue be stored in a reusable CTE?
2. Which customers spend more than the average customer?
3. Who are the highest revenue customers?
4. What are the average, highest, and lowest customer revenues?
5. How can seller revenue be summarised using a CTE?
6. Which sellers generate above-average revenue?
7. Who are the highest-performing sellers?
8. How can category revenue be calculated using a CTE?
9. Which product categories outperform the average category?
10. How can monthly revenue be summarised using a CTE?
11. Which months exceed average monthly revenue?
12. How can customer revenue be summarised using reusable logic?
13. How can multiple CTEs be chained together?
14. Why are CTEs preferred over repeated subqueries?
15. How can CTEs improve long-term business reporting?

---

# SQL Techniques Used

This investigation introduced and reinforced:

- `WITH`
- Common Table Expressions (CTEs)
- Multiple CTEs
- CTE chaining
- Aggregate functions
- `SUM()`
- `AVG()`
- `COUNT()`
- `MAX()`
- `MIN()`
- Nested subqueries
- `ORDER BY`
- `GROUP BY`
- Multi-table joins

---

# Key Findings

The investigation produced several important technical and business findings.

### Customer Analysis

- Customer revenue can be calculated once and reused across multiple reports.
- Above-average customers were easily identified using reusable CTE logic.
- Customer summaries became significantly cleaner than equivalent nested subqueries.

### Seller Analysis

- Seller revenue calculations became easier to read and maintain.
- High-performing sellers were identified using reusable datasets.
- Business logic no longer required repeated aggregations.

### Product Category Analysis

- Revenue by category was simplified using reusable summary tables.
- Above-average product categories were easily identified.
- Analytical reports became more structured.

### Revenue Analysis

- Monthly revenue summaries could be reused across multiple business questions.
- Time-series reporting became easier to maintain.
- Complex reports required substantially less duplicated SQL.

---

# Business Interpretation

This investigation demonstrates an important shift in analytical thinking.

Instead of writing SQL to answer one question at a time, CTEs encourage analysts to first create reusable business datasets that can support many related analyses.

This approach reduces duplicated logic, simplifies debugging, and improves collaboration across analytics teams.

---

# Challenges Encountered

Several learning challenges emerged during this investigation.

### Transition from Subqueries

Initially, nested subqueries appeared to be the natural solution. However, repeated code quickly became difficult to maintain.

### Reusable Thinking

The investigation required a shift from solving individual questions to designing reusable intermediate datasets.

### Multiple CTEs

Understanding that one CTE can reference another represented an important conceptual milestone.

---

# Analyst Reflection

This investigation marked a transition from writing functional SQL to writing maintainable SQL.

Common Table Expressions significantly improved query readability while reducing duplicated business logic.

The introduction of chained CTEs demonstrated how increasingly complex analytical workflows can be organised into logical, reusable steps.

This approach closely resembles SQL development practices used in professional analytics teams.

---

# Interview Notes

Possible interview questions include:

- What is a Common Table Expression (CTE)?
- How does a CTE differ from a subquery?
- When would you choose a CTE instead of a nested subquery?
- Can one CTE reference another CTE?
- What are the advantages of chaining multiple CTEs?
- Do CTEs permanently store data?
- How do CTEs improve SQL maintainability?

---

# Skills Demonstrated

By completing this investigation, the following skills were demonstrated:

- Common Table Expressions (CTEs)
- SQL modularisation
- Reusable business logic
- Aggregate analysis
- Revenue analysis
- Multi-table joins
- PostgreSQL `WITH` clause
- Query optimisation through readability
- Professional SQL documentation

---

# Business Recommendations

Based on the analysis, the following recommendations are proposed:

1. Standardise reusable analytical logic using Common Table Expressions.
2. Replace repeated nested subqueries with descriptive CTEs where appropriate.
3. Adopt consistent CTE naming conventions to improve readability.
4. Use chained CTEs for complex reporting pipelines.
5. Prepare frequently used CTE logic for future implementation as SQL Views.
6. Encourage analytics teams to prioritise maintainability alongside query correctness.

---

# Conclusion

This investigation introduced Common Table Expressions as a powerful tool for writing cleaner, more maintainable SQL.

By creating reusable intermediate datasets, complex business analyses became easier to understand, debug, and extend. Compared with nested subqueries, CTEs provided a more structured approach to customer, seller, category, and revenue reporting.

Beyond learning new SQL syntax, this investigation reinforced a professional mindset: rather than solving isolated problems, analysts should design reusable analytical building blocks that support multiple business questions.

This investigation serves as the foundation for the next stage of the project, where these reusable query patterns will evolve into persistent database objects through the use of **SQL Views**.