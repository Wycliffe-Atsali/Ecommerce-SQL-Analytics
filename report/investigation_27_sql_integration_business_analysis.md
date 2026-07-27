# Investigation 27 – SQL Integration Business Analysis

**Phase:** Phase 6 – Advanced SQL Techniques  
**Investigation:** 27  
**Topic:** Integrating Subqueries, Common Table Expressions (CTEs), and Views  
**Dataset:** Brazilian E-Commerce Public Dataset (Olist)  
**Database:** PostgreSQL

---

# Business Objective

The objective of this investigation was to demonstrate how multiple advanced SQL techniques can be integrated to solve real-world business problems.

Rather than learning Subqueries, CTEs, and Views as isolated features, this investigation focused on understanding when each approach is most appropriate. The analysis emphasised reusable business logic, readable SQL, and scalable analytical workflows that resemble those used in professional data analytics teams.

---

# Business Questions

The investigation sought to answer the following business questions:

1. Which customers generate above-average revenue?
2. How can customers be classified into Premium and Standard segments?
3. How many customers belong to each revenue segment?
4. What percentage of customers are classified as Premium?
5. Which sellers generate above-average revenue?
6. Who are the top-performing sellers?
7. What are the average, maximum, and minimum seller revenues?
8. Which product categories generate above-average revenue?
9. How many product categories perform above the average?
10. What percentage of categories exceed the average revenue?
11. Which months generate above-average revenue?
12. Which month generated the highest revenue?
13. What percentage of months performed above average?
14. When should analysts use Subqueries, CTEs, or Views?
15. Which SQL approach should become the organisational standard for reusable analytical reporting?

---

# SQL Concepts Demonstrated

Throughout this investigation, the following SQL concepts were applied:

- `CREATE OR REPLACE VIEW`
- Common Table Expressions (`WITH`)
- Scalar Subqueries
- Aggregate Functions
- `CASE`
- `GROUP BY`
- `ORDER BY`
- `COUNT()`
- `SUM()`
- `AVG()`
- `ROUND()`
- Business KPI Development
- Reusable SQL Design

---

# Summary of Findings

## 1. Customer Revenue Analysis

The reusable `customer_revenue_view` successfully simplified customer revenue analysis by eliminating the need to repeatedly join the `customers`, `orders`, and `order_payments` tables.

Customers were segmented into two groups:

- Premium Customers
- Standard Customers

using a CTE built on top of the reusable View.

This demonstrated how Views and CTEs complement one another when building analytical workflows.

---

## 2. Seller Performance

The `seller_revenue_view` provided an efficient way to analyse seller performance.

Using the View, it became straightforward to:

- Identify above-average sellers.
- Rank the highest-performing sellers.
- Calculate marketplace revenue benchmarks.

This significantly reduced duplicated SQL code compared to rebuilding the joins for every query.

---

## 3. Product Category Analysis

The reusable `category_revenue_view` enabled rapid identification of the marketplace's strongest-performing categories.

The investigation calculated:

- Categories above average revenue.
- Percentage of high-performing categories.
- Overall category distribution.

This type of analysis helps management understand revenue concentration across product lines.

---

## 4. Monthly Revenue Analysis

Using `monthly_revenue_view`, monthly business performance was analysed without recreating complex joins.

The investigation identified:

- Months exceeding average revenue.
- The single highest-performing month.
- The percentage of months outperforming the overall average.

These metrics provide valuable insights into seasonality and business performance trends.

---

# Business Interpretation

The investigation demonstrated that different SQL constructs are suited to different analytical scenarios.

### Subqueries

Subqueries are best suited to simple, one-time calculations where intermediate results do not need to be reused. They provide concise solutions for filtering against aggregated values but can become difficult to read when nested extensively.

### Common Table Expressions (CTEs)

CTEs improve readability by breaking complex analytical workflows into logical steps. They simplify debugging, make transformations easier to understand, and allow intermediate datasets to be referenced multiple times within a single query.

### Views

Views provide reusable business logic stored within the database. They eliminate duplicated SQL, promote consistency across reports, and allow analysts to work from a shared definition of key business metrics. Views are particularly valuable for dashboards, recurring reports, and commonly used KPIs.

---

# Business Recommendations

Based on the findings from this investigation, the following recommendations are proposed:

- Standardise frequently used KPIs as database Views to provide a consistent source of truth.
- Use CTEs to organise complex analytical workflows into readable and maintainable steps.
- Reserve Subqueries for simple, one-off calculations where additional structures are unnecessary.
- Encourage analysts to build reports using reusable Views to reduce duplicated SQL and improve collaboration.
- Maintain consistent business definitions across analytical projects to ensure reliable reporting.

---

# Key Learning Outcomes

By completing this investigation, the following skills were demonstrated:

- Building reusable SQL Views.
- Combining Views with Common Table Expressions.
- Using Subqueries alongside reusable database objects.
- Creating business-oriented customer segmentation.
- Developing reusable analytical workflows.
- Writing maintainable SQL suitable for collaborative environments.
- Applying professional SQL design principles.

---

# Analyst Reflection

This investigation served as the capstone of Phase 6 by integrating all advanced SQL concepts covered throughout the phase.

A key lesson learned was that Subqueries, CTEs, and Views should not be viewed as competing techniques. Instead, each has a specific role within the SQL toolkit:

- **Subqueries** solve isolated calculations efficiently.
- **CTEs** organise complex analytical logic into clear, sequential steps.
- **Views** provide reusable business objects that promote consistency across multiple reports.

Understanding when to use each construct is just as important as understanding the syntax itself. This investigation reinforced that effective SQL development involves not only producing correct results but also writing code that is readable, maintainable, reusable, and scalable.

---

# Phase 6 Summary

Phase 6 marked a significant transition from writing functional SQL queries to designing professional, reusable analytical solutions.

Across five investigations, the following advanced SQL concepts were mastered:

- Subqueries
- Common Table Expressions (CTEs)
- Multiple CTE Workflows
- Database Views
- SQL Integration (Subqueries + CTEs + Views)

The progression throughout the phase mirrored real-world SQL development, moving from isolated calculations to modular query design and reusable database objects.

By the end of Phase 6, the project had evolved from performing exploratory analyses to creating scalable analytical workflows suitable for production reporting environments.

---

# Conclusion

Investigation 27 successfully integrated Subqueries, Common Table Expressions, and Views into a unified analytical workflow.

The investigation demonstrated how reusable SQL design improves efficiency, reduces code duplication, and supports professional business reporting. By applying the appropriate SQL construct for each analytical task, the resulting solutions became easier to understand, maintain, and extend.

With the completion of this investigation, **Phase 6 – Advanced SQL Techniques** has been successfully completed, providing a strong foundation for **Phase 7 – Window Functions**, where the analysis will shift from grouped aggregations to row-level analytical calculations, ranking functions, running totals, moving averages, and advanced business intelligence techniques.