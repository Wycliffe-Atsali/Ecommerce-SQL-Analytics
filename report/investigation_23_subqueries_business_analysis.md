# Investigation 23 – Subqueries for Business Analysis

## Phase 6 – Advanced SQL: Subqueries, CTEs & Views

---

# Business Objective

The objective of this investigation was to introduce SQL subqueries through practical business scenarios rather than isolated syntax exercises.

Instead of comparing values against manually entered numbers, subqueries were used to calculate dynamic business benchmarks such as average revenue, average product price, and average customer spending. These benchmarks were then incorporated into larger SQL queries to identify entities performing above average.

This investigation marks the transition from intermediate SQL querying to more advanced analytical query design.

---

# Business Context

Business analysts frequently need to answer questions that compare an individual entity against the performance of an entire business.

Examples include:

- Which customers spend more than the average customer?
- Which sellers outperform the average seller?
- Which product categories generate above-average revenue?
- Which months exceed average monthly sales?

Since these benchmark values change as new data is added, hardcoding values into SQL queries is impractical. Subqueries solve this problem by calculating comparison values dynamically.

---

# Learning Objective

This investigation introduced the first advanced SQL concept of Phase 6.

The primary learning outcomes were to understand:

- What a subquery is
- When subqueries should be used
- How SQL executes nested queries
- How to compare records against dynamically calculated values
- How subqueries support business decision-making

---

# Database Thinking

The investigation required analysing several business entities across different levels of granularity.

### Customer Analysis

```
customers
    │
customer_id
    │
orders
    │
order_id
    │
order_payments
```

---

### Seller Analysis

```
sellers
    │
seller_id
    │
order_items
```

---

### Product Analysis

```
products
    │
product_id
    │
order_items
```

---

### Product Category Analysis

```
products
    │
product_category_name
    │
order_items
```

---

### Geographic Analysis

```
customers
    │
customer_state
    │
orders
    │
order_payments
```

---

### Time-Series Analysis

```
orders
    │
order_purchase_timestamp
    │
order_payments
```

---

# SQL Concepts Demonstrated

This investigation introduced several important SQL techniques.

## Scalar Subqueries

Using a single value returned from a nested query.

Example:

- Average payment value
- Average product price

---

## Derived Tables

Creating temporary result sets inside the `FROM` clause before applying additional filtering.

---

## Aggregate Comparisons

Comparing values against calculated averages instead of manually entered thresholds.

---

## Nested Business Logic

Using multiple query layers to answer increasingly complex business questions.

---

## Dynamic Benchmarking

Replacing fixed comparison values with calculations generated directly from the database.

---

# Business Questions Investigated

The investigation answered the following questions:

1. How many products are priced above the average price?
2. Which products are priced above average?
3. How many payments exceed the average payment value?
4. Which payment records exceed the average payment value?
5. Which customers spend more than the average customer?
6. Who are the top high-spending customers?
7. Which sellers generate above-average revenue?
8. Who are the top-performing sellers?
9. Which products are ordered more frequently than average?
10. Which product categories generate above-average revenue?
11. Which customer states generate above-average revenue?
12. Which months outperform the average monthly revenue?
13. How can the top 20% revenue-generating customers be identified? *(Deferred to Window Functions.)*
14. What overall patterns emerge across above-average performers?
15. What business recommendations can be made from the findings?

---

# Key Findings

The investigation produced several important insights.

- Approximately **32,128** products were priced above the overall average product price.
- Approximately **27,889** customers spent more than the average customer.
- Approximately **628** sellers generated revenue above the average seller.
- Approximately **20** product categories exceeded average category revenue.
- Approximately **13** months generated revenue above the overall monthly average.

These findings demonstrate that business performance is highly concentrated among a relatively small proportion of entities.

---

# Business Interpretation

The investigation showed that averages provide meaningful performance benchmarks across different business dimensions.

Rather than identifying only the single highest-performing entity, analysts can classify all entities that outperform the company average. This approach is considerably more useful for operational reporting because it identifies broader groups that consistently contribute to business success.

The investigation also demonstrated that above-average performance differs depending on the level of analysis. A customer, seller, product, category, and month each require different relationship paths and aggregation strategies.

---

# Challenges Encountered

Several important learning moments occurred during this investigation.

## Repetition of Derived Tables

Many queries repeated the same aggregation logic inside multiple subqueries.

Although correct, this repetition made the SQL lengthy and more difficult to maintain.

This naturally motivates the use of **Common Table Expressions (CTEs)**, which will be introduced in the next investigation.

---

## Top 20% Revenue Analysis

The attempt to identify the top 20% of customers by revenue could not be completed using subqueries alone.

This problem requires ranking rows and calculating cumulative distributions, making it much more suitable for SQL Window Functions.

The investigation intentionally postponed this analysis until Phase 7.

---

# Analyst Reflection

This investigation represented an important milestone in the SQL learning journey.

Rather than writing queries that simply retrieved information, the focus shifted toward constructing layered analytical logic capable of solving more sophisticated business problems.

One particularly valuable lesson was recognising when SQL begins to become repetitive. Although subqueries successfully solved the problems presented, they also highlighted opportunities for writing cleaner and more maintainable SQL using CTEs.

This transition reflects how SQL skills evolve from writing functional queries to designing efficient analytical workflows.

---

# Business Recommendations

Based on the findings, the following recommendations are proposed:

- Develop loyalty campaigns targeting customers who already spend above average.
- Analyse operational practices of high-performing sellers and share best practices across the seller network.
- Prioritise inventory management for consistently above-average products.
- Increase marketing investment in high-performing product categories.
- Allocate regional marketing budgets according to the strongest-performing customer states.
- Investigate the business drivers behind above-average sales months to improve seasonal planning.

---

# Interview Discussion

This investigation demonstrates several interview-ready SQL concepts.

Potential discussion topics include:

- Explaining when subqueries should be used.
- Comparing subqueries with JOIN-based solutions.
- Understanding query execution order.
- Recognising situations where CTEs improve readability.
- Knowing when Window Functions provide a superior solution.

These topics commonly appear in Junior Data Analyst and SQL interview assessments.

---

# Skills Demonstrated

- Scalar Subqueries
- Derived Tables
- Aggregate Functions
- Dynamic Benchmarking
- Multi-table JOINs
- Business Performance Analysis
- Customer Analytics
- Seller Analytics
- Product Analytics
- Revenue Analysis
- Time-Series Benchmarking
- Professional SQL Documentation

---

# Conclusion

Investigation 23 introduced subqueries as a practical tool for solving business problems that depend on dynamically calculated benchmarks.

By combining nested queries with aggregate functions and relational joins, the investigation demonstrated how SQL can answer sophisticated analytical questions without relying on manually supplied comparison values.

The investigation also provided a natural bridge to Common Table Expressions (CTEs), where repeated subqueries can be simplified into reusable intermediate result sets. This progression mirrors professional SQL development practices and establishes a strong foundation for the remaining topics in Phase 6.