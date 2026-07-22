# Investigation 20: Sales Trend & Time Series Analysis

## Project Information

| Project | Retail SQL Business Analysis |
|----------|------------------------------|
| Investigation | 20 |
| Title | Sales Trend & Time Series Analysis |
| Database | PostgreSQL |
| Dataset | Brazilian E-Commerce Public Dataset by Olist |
| Analysis Type | Time Series Analysis |
| Primary Tables | `orders`, `order_payments` |

---

# Business Objective

Analyze historical sales performance over time to identify growth patterns, seasonal demand, peak sales periods, and purchasing trends that support operational planning and strategic business decision-making.

This investigation introduces **time as the primary analytical dimension**, allowing business performance to be evaluated across years, months, and weekdays rather than by customers or products alone.

---

# Business Context

Every successful e-commerce company continuously monitors how sales change over time.

Understanding sales trends enables management to answer important strategic questions such as:

- Is the business growing over time?
- Which months generate the highest revenue?
- When should inventory levels be increased?
- Which weekdays experience the greatest customer activity?
- Are higher order volumes always associated with higher revenue?

The answers to these questions help organizations improve forecasting, staffing, inventory management, budgeting, and promotional planning.

---

# Business Questions

This investigation answers the following business questions:

1. What is the earliest recorded purchase date?
2. What is the latest recorded purchase date?
3. How many orders were placed each year?
4. How many orders were placed each month?
5. How much revenue was generated each year?
6. How much revenue was generated each month?
7. Which month generated the highest revenue?
8. What is the average order value for each month?
9. Which weekday receives the highest number of orders?
10. Which weekday generates the highest revenue?
11. Which weekday has the highest average order value?
12. Which month experienced the highest order volume?
13. Which month generated the highest average revenue per order?
14. Is there a relationship between monthly order volume and revenue?
15. What operational recommendations can be made from the observed sales trends?

---

# Database Thinking

## Primary Table

### `orders`

Provides:

- Order identifier
- Purchase timestamp
- Customer purchasing timeline

---

## Supporting Table

### `order_payments`

Provides:

- Revenue generated per order
- Payment values used for financial analysis

---

# Relationship Path

```text
orders
     │
order_id
     │
order_payments
```

---

# Analysis Grain

Different questions required different levels of aggregation.

| Business Question | Analysis Grain |
|-------------------|----------------|
| Earliest purchase | Dataset |
| Orders by year | Year |
| Orders by month | Month |
| Revenue by month | Month |
| Weekday analysis | Day of Week |
| Average order value | Order |
| Trend comparison | Month |

Selecting the correct time grain before writing SQL ensured that the analysis accurately reflected business performance over time.

---

# Methodology

The investigation followed the project's business-first analytical workflow.

```text
Business Problem

↓

Identify Time Dimension

↓

Determine Required Tables

↓

Select Appropriate Time Grain

↓

Write SQL

↓

Interpret Trends

↓

Generate Business Recommendations
```

Unlike previous investigations, this analysis emphasized **temporal patterns** rather than customer or product relationships.

---

# SQL Techniques Used

The investigation introduced several important PostgreSQL time functions.

### Aggregate Functions

- COUNT()
- COUNT(DISTINCT)
- SUM()
- MIN()
- MAX()
- ROUND()

### Date Functions

- DATE_TRUNC()
- TO_CHAR()

### Other Techniques

- INNER JOIN
- ORDER BY
- LIMIT
- Business KPI Development
- Time-Series Analysis

---

# Data Quality Considerations

## Revenue Source

Revenue was calculated using:

```sql
order_payments.payment_value
```

This represents the total amount paid by customers and is therefore the most appropriate measure for sales trend analysis.

---

## Time Grouping

The investigation standardized on:

```sql
DATE_TRUNC()
```

rather than grouping by month names or month numbers.

For example:

```sql
DATE_TRUNC('month', order_purchase_timestamp)
```

This preserves complete business periods.

Grouping only by month names would incorrectly combine January 2017 with January 2018 into a single category, producing misleading results.

---

## Average Order Value

Average Order Value was calculated using:

```sql
COUNT(DISTINCT order_id)
```

instead of:

```sql
COUNT(order_id)
```

because an order may contain multiple payment records after joining with the `order_payments` table.

This ensured that averages reflected unique customer orders rather than payment rows.

---

# Key Findings

## 1. Business Timeline

The dataset captures customer purchases over multiple years, providing sufficient historical information for trend analysis.

---

## 2. Monthly Sales Trends

Order volume fluctuated throughout the business timeline, indicating seasonal variations in customer purchasing behaviour.

---

## 3. Revenue Trends

Revenue generally followed the same pattern as order volume.

Months with higher order counts typically generated higher total revenue.

---

## 4. Peak Sales Period

The highest revenue month occurred during **November 2017**, generating approximately **1.19 million** in total revenue.

This period likely reflects increased consumer spending associated with Black Friday and early holiday shopping.

---

## 5. Weekly Purchasing Behaviour

Customer activity varied throughout the week.

Analyzing weekdays provides useful operational insights for staffing, customer support scheduling, and marketing campaign timing.

---

## 6. Average Order Value

Although total revenue was strongly influenced by order volume, average order value also contributed to monthly financial performance.

Months with similar order counts did not always generate identical revenue because customer spending per order varied.

---

## 7. Order Volume vs Revenue

Comparing monthly order counts with monthly revenue demonstrated a clear positive relationship.

Higher order volumes generally resulted in higher revenue.

However, revenue remained dependent upon both:

- Number of orders
- Average spending per order

This distinction is important when evaluating overall business performance.

---

# Business Interpretation

The investigation demonstrates that customer purchasing behaviour changes throughout the year rather than remaining constant.

Understanding these seasonal patterns allows management to anticipate future demand and allocate business resources more effectively.

Peak sales months require additional operational capacity, while slower periods create opportunities for targeted promotional campaigns that stimulate customer demand.

Rather than reacting to fluctuations after they occur, businesses can use historical sales trends to make proactive decisions regarding staffing, inventory, budgeting, and marketing investments.

---

# Business Recommendations

## Recommendation 1

Increase inventory levels ahead of historically high-demand months to minimize stock shortages and improve customer satisfaction.

---

## Recommendation 2

Schedule additional warehouse personnel, logistics staff, and customer support representatives during peak sales periods.

---

## Recommendation 3

Launch promotional campaigns before historically slower months to increase customer demand rather than concentrating discounts only during already successful periods.

---

## Recommendation 4

Continue leveraging seasonal events such as Black Friday while ensuring sufficient operational capacity to handle increased order volumes.

---

## Recommendation 5

Incorporate historical monthly sales patterns into demand forecasting models to improve procurement planning, budgeting, and long-term business strategy.

---

# Challenges Encountered

## Selecting the Correct Time Grain

A major analytical decision involved choosing between:

- EXTRACT()
- TO_CHAR()
- DATE_TRUNC()

Ultimately, `DATE_TRUNC()` provided the most appropriate solution because it preserved complete business periods.

---

## Avoiding Duplicate Order Counts

Joining `orders` with `order_payments` introduced the possibility of duplicate order records.

Using `COUNT(DISTINCT order_id)` ensured that averages were calculated using unique orders rather than payment records.

---

## Distinguishing Revenue from Order Volume

Although order volume and revenue were strongly correlated, they were not identical measures.

Revenue also depended on customer spending behaviour, making Average Order Value an important supporting KPI.

---

# Analyst Reflection

This investigation marked an important transition from descriptive reporting to time-based business intelligence.

Rather than simply summarizing historical performance, the analysis focused on identifying recurring patterns that can guide future business decisions.

The introduction of PostgreSQL date functions also reinforced the importance of selecting the correct analytical grain before writing SQL.

Understanding *when* business events occur is just as important as understanding *what* occurred.

---

# Interview Notes

Potential interview discussion topics include:

- Why `DATE_TRUNC()` is preferred over grouping by month names.
- Difference between `DATE_TRUNC()`, `EXTRACT()`, and `TO_CHAR()`.
- Choosing the correct analytical grain for time-series analysis.
- Why `COUNT(DISTINCT order_id)` is necessary after joining payment data.
- Relationship between order volume and revenue.
- Using historical trends to support forecasting and operational planning.

---

# Skills Demonstrated

This investigation demonstrates proficiency in:

- Time-series analysis
- Business trend analysis
- Revenue analytics
- Sales performance measurement
- PostgreSQL date functions
- Aggregate analysis
- KPI development
- Business interpretation
- Executive reporting
- Operational decision support

---

# Conclusion

Investigation 20 expanded the project's analytical scope by introducing **time as a core business dimension**. Through the analysis of yearly, monthly, and weekly purchasing patterns, it revealed how customer activity and revenue evolve over time and how these trends influence operational planning.

The investigation showed that revenue generally increases alongside order volume, with **November 2017** emerging as the strongest sales period, likely driven by seasonal shopping events. It also highlighted that average order value plays a supporting role in overall revenue performance, reinforcing the need to evaluate multiple KPIs together rather than relying on a single metric.

From a technical perspective, this investigation strengthened the use of PostgreSQL date functions, particularly `DATE_TRUNC()`, and reinforced best practices for handling one-to-many joins using `COUNT(DISTINCT)`. These techniques are fundamental for building reliable time-series analyses and are commonly expected in professional Business Intelligence and Data Analyst roles.

Overall, this investigation demonstrates the ability to transform transactional sales data into actionable business insights, providing a strong foundation for forecasting, strategic planning, and executive decision-making.