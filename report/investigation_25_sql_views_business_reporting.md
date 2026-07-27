# Investigation 25: SQL Views for Business Reporting

## Business Objective

The objective of this investigation was to learn how SQL Views can be used to create reusable business reporting objects. Unlike subqueries and Common Table Expressions (CTEs), Views are stored permanently in the database and can be queried repeatedly without rewriting complex SQL logic.

This investigation focused on transforming frequently used analytical queries into reusable reporting assets suitable for business intelligence dashboards and recurring operational reporting.

---

# Business Context

As organisations grow, analysts frequently perform the same business analyses repeatedly.

Examples include:

- Customer revenue reports
- Seller performance reports
- Product category performance
- Monthly sales reporting

Rewriting these complex JOIN and aggregation queries every time increases the likelihood of:

- SQL duplication
- Maintenance challenges
- Inconsistent business metrics
- Reduced analyst productivity

SQL Views solve this problem by providing a reusable reporting layer that centralises business logic.

---

# Learning Objectives

By completing this investigation, the following concepts were reinforced:

- Creating SQL Views
- Using `CREATE OR REPLACE VIEW`
- Querying Views like database tables
- Reusing analytical logic
- Comparing Views with CTEs
- Building reusable reporting datasets
- Designing reporting structures suitable for Business Intelligence

---

# Database Thinking

Before writing SQL, the required reporting entities were identified.

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

Each relationship represents a reusable reporting dataset that is likely to be queried many times throughout the project.

---

# Methodology

The investigation followed four stages:

1. Create reusable Views.
2. Query the Views for business insights.
3. Compare View-based analysis with previous CTE and subquery solutions.
4. Evaluate where Views are most appropriate within business reporting workflows.

---

# Business Questions Answered

The investigation addressed the following questions:

1. Create a customer revenue View.
2. Retrieve all customer revenue records.
3. Identify customers spending above average.
4. Find the top 10 highest-revenue customers.
5. Create a seller revenue View.
6. Retrieve seller revenue records.
7. Identify above-average sellers.
8. Find the top-performing sellers.
9. Create a product category revenue View.
10. Identify categories performing above average.
11. Create a monthly revenue View.
12. Identify months exceeding average revenue.
13. Evaluate the advantages of Views.
14. Compare Views with CTEs.
15. Recommend Views suitable for operational reporting.

---

# SQL Techniques Used

Throughout the investigation, the following SQL features were applied:

- `CREATE VIEW`
- `CREATE OR REPLACE VIEW`
- `SELECT`
- `JOIN`
- `GROUP BY`
- `SUM()`
- `AVG()`
- `ORDER BY`
- `LIMIT`
- Scalar subqueries
- Aggregate analysis

---

# Key Findings

### Customer Reporting

The customer revenue View successfully centralised customer spending calculations, allowing revenue analysis without repeatedly joining three separate tables.

---

### Seller Reporting

Seller revenue reporting became significantly simpler once encapsulated in a View, making it easier to identify high-performing sellers.

---

### Category Reporting

Product category revenue was converted into a reusable reporting object suitable for merchandising analysis and performance monitoring.

---

### Monthly Revenue Reporting

Monthly sales summaries became available through a single View, providing a clean foundation for trend analysis and executive dashboards.

---

### Reusability

The primary advantage observed was the elimination of duplicated SQL logic. Once created, each View behaved like a normal table and could be queried repeatedly.

---

# Business Interpretation

Views represent an important architectural improvement rather than simply another SQL feature.

Instead of embedding complex joins inside every report, Views encapsulate business logic into reusable datasets.

This approach provides:

- Consistent calculations across reports
- Reduced development time
- Easier maintenance
- Improved collaboration between analysts
- Simpler dashboard development

These benefits become increasingly valuable as analytical projects grow in size and complexity.

---

# Business Recommendations

Based on this investigation, the following Views would provide the greatest value if exposed to reporting teams:

### `customer_revenue_view`

Supports customer segmentation, lifetime value analysis, and marketing initiatives.

### `seller_revenue_view`

Enables seller performance monitoring and incentive programmes.

### `category_revenue_view`

Supports merchandising decisions by highlighting high-performing product categories.

### `monthly_revenue_view`

Provides a reusable dataset for executive dashboards, forecasting, and trend analysis.

Together, these Views establish a reusable semantic reporting layer that promotes consistency across analytical outputs.

---

# Challenges Encountered

Several practical considerations were identified during the investigation.

### Recreating Existing Views

Attempting to create a View with an existing name resulted in an error.

This was resolved using:

```sql
CREATE OR REPLACE VIEW
```

During development, this is the preferred approach because it allows the View definition to be updated without manually dropping it.

Another option is:

```sql
DROP VIEW IF EXISTS view_name;

CREATE VIEW view_name AS ...
```

This approach is useful when structural changes prevent `CREATE OR REPLACE VIEW` from succeeding.

---

# Analyst Reflection

This investigation demonstrated how SQL Views improve the organisation of analytical projects.

Compared with subqueries and CTEs, Views provide a cleaner and more maintainable approach for recurring business analysis.

Understanding when to use a View versus a CTE is an important skill for designing scalable SQL solutions and mirrors practices commonly used in production analytics environments.

---

# Interview Notes

Possible interview questions arising from this investigation include:

### What is a SQL View?

A View is a stored SQL query that behaves like a virtual table, allowing complex business logic to be reused across multiple analyses.

---

### When would you choose a View instead of a CTE?

A View is appropriate when the same logic will be reused frequently across reports or dashboards. A CTE is better suited for temporary transformations within a single query.

---

### Why are Views useful in Business Intelligence?

Views provide a consistent reporting layer, reduce duplicated SQL, simplify dashboard development, and ensure business metrics are calculated uniformly across reports.

---

### What is the purpose of `CREATE OR REPLACE VIEW`?

It updates an existing View without requiring it to be dropped manually, making iterative development more efficient.

---

# Skills Demonstrated

### SQL Skills

- SQL Views
- Reusable query design
- Multi-table JOINs
- Aggregate reporting
- Scalar subqueries
- Business reporting architecture

### Business Skills

- Customer analytics
- Seller performance analysis
- Product category analysis
- Revenue reporting
- Time-series reporting
- Business Intelligence preparation
- Reusable reporting design

---

# Conclusion

This investigation completed the progression from subqueries to Common Table Expressions and finally to SQL Views.

Views provide a persistent, reusable reporting layer that simplifies recurring analytical tasks and promotes consistency across business reports.

By encapsulating complex SQL logic into reusable database objects, analysts can build scalable reporting solutions that closely resemble those used in professional Business Intelligence and data warehouse environments.

This investigation concludes the SQL Views section of Phase 6 and prepares the foundation for more advanced analytical techniques in subsequent investigations.