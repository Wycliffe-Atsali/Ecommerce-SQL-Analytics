# Investigation 22: Customer Retention & Repeat Purchase Analysis

---

## Business Objective

The objective of this investigation is to evaluate customer retention and purchasing behaviour by distinguishing between one-time, repeat, and loyal customers. While acquiring new customers is essential for business growth, retaining existing customers is generally more cost-effective and contributes significantly to long-term profitability.

This investigation aims to answer key business questions regarding customer loyalty, repeat purchasing behaviour, customer revenue contribution, and customer segmentation. The findings will help management understand how customers interact with the business over time and identify opportunities to improve customer retention strategies.

---

# Business Context

Customer retention is one of the most important performance indicators in e-commerce. Businesses that successfully encourage customers to make repeat purchases often experience higher customer lifetime value, lower acquisition costs, and more predictable revenue.

The Olist dataset records approximately 100,000 orders placed over a two-year period. This provides an opportunity to analyse customer purchasing patterns and determine whether customers are returning to make additional purchases.

The investigation focuses on measuring customer loyalty rather than individual transactions.

---

# Database Thinking

The analysis requires combining customer information, purchase history, and payment data.

### Tables Used

- customers
- orders
- order_payments

### Relationship Path

```text
customers
      │
customer_id
      │
      ▼
orders
      │
order_id
      │
      ▼
order_payments
```

---

## Important Business Rule

The dataset contains two customer identifiers:

- `customer_id`
- `customer_unique_id`

For customer retention analysis:

- `customer_id` represents an individual purchase record.
- `customer_unique_id` represents the actual customer across multiple purchases.

Therefore, all customer-level metrics throughout this investigation are based on **customer_unique_id**.

---

# Methodology

The investigation followed a structured analytical workflow:

1. Determine the total customer population.
2. Measure one-time and repeat customers.
3. Calculate customer retention KPIs.
4. Analyse purchasing frequency.
5. Evaluate customer revenue contribution.
6. Segment customers based on purchase frequency.
7. Compare revenue across customer segments.
8. Develop business recommendations.

Several questions required **multi-stage aggregation**, where customer-level metrics were calculated before producing overall business KPIs.

---

# Business Questions

1. How many unique customers has the business served?
2. How many customers purchased exactly once?
3. How many customers made repeat purchases?
4. What percentage of customers are repeat customers?
5. Which customers placed the highest number of orders?
6. What is the average number of orders per customer?
7. What is the maximum number of orders placed by a single customer?
8. Which customers generated the highest revenue?
9. How much revenue comes from repeat customers?
10. How much revenue comes from one-time customers?
11. How does average customer revenue compare between one-time and repeat customers?
12. How can customers be segmented according to purchasing behaviour?
13. How many customers belong to each segment?
14. How much revenue does each segment contribute?
15. What business actions could improve customer retention?

---

# SQL Techniques Used

- INNER JOIN
- Aggregate Functions (`COUNT`, `SUM`, `AVG`)
- `COUNT(DISTINCT)`
- `ROUND()`
- `CASE`
- `HAVING`
- Subqueries
- Window Functions (`SUM() OVER ()`)
- Customer Segmentation
- Multi-stage Aggregation

---

# Key Findings

### Customer Retention

The analysis distinguished customers into:

- One-Time Customers
- Repeat Customers
- Loyal Customers

This provides a clear understanding of customer purchasing behaviour and retention performance.

---

### Purchasing Behaviour

Customer purchasing activity varies significantly.

While many customers place only a single order, a smaller group returns for multiple purchases and contributes disproportionately to long-term business performance.

---

### Customer Revenue

Revenue analysis showed that customer spending should be evaluated at the **customer level**, rather than at the payment level.

Aggregating revenue before customer classification produced more meaningful business metrics.

---

### Customer Segmentation

Customers were successfully segmented into:

- One-Time Customer
- Repeat Customer
- Loyal Customer

Segmenting customers enables targeted marketing strategies instead of treating all customers equally.

---

### Revenue Contribution

Calculating revenue contribution for each customer segment demonstrated how different customer groups support the business financially.

The analysis also introduced revenue percentage calculations using window functions, providing an additional business KPI.

---

# Business Interpretation

This investigation demonstrates that customer retention analysis extends beyond counting purchases.

Businesses should understand:

- who returns,
- how frequently they purchase,
- how much revenue they contribute,
- and how different customer groups behave.

Understanding customer segments enables more effective marketing, improved customer experiences, and stronger long-term profitability.

---

# Business Recommendations

## 1. Encourage Second Purchases

The transition from a customer's first purchase to their second purchase is one of the most important stages in customer retention.

The business should introduce incentives such as:

- second-order discounts,
- free shipping,
- personalised vouchers,
- limited-time promotional offers.

---

## 2. Develop a Loyalty Programme

Reward customers who continue purchasing.

Examples include:

- reward points,
- exclusive discounts,
- VIP membership,
- early product access,
- free delivery.

---

## 3. Personalise Customer Communication

Following a customer's first purchase, personalised recommendations and follow-up emails can encourage repeat purchasing.

---

## 4. Monitor Customer Retention KPIs

Management should continuously monitor:

- Repeat Purchase Rate
- Average Orders per Customer
- Revenue by Customer Segment
- Customer Lifetime Value (CLV)

These KPIs provide a clearer picture of customer loyalty than sales volume alone.

---

## 5. Segment Marketing Campaigns

Different customer groups should receive different marketing strategies.

Examples include:

- Acquisition campaigns for new customers.
- Retention campaigns for one-time customers.
- Reward campaigns for loyal customers.

---

# Challenges Encountered

Several analytical challenges emerged during this investigation.

### Customer Identifier Selection

Initially, using `customer_id` appeared reasonable.

However, customer retention requires `customer_unique_id`, since customers may receive multiple customer IDs across different purchases.

---

### Multi-Stage Aggregation

Many business questions could not be answered with a single `GROUP BY`.

Instead, customer-level metrics had to be calculated first before producing business KPIs.

This represented a significant increase in analytical complexity compared with previous investigations.

---

### Analytical Grain

Average payment values do not represent customer value.

Revenue first needed to be aggregated per customer before meaningful comparisons could be made between customer segments.

---

# Analyst Reflection

This investigation represented an important transition from writing SQL queries to solving analytical business problems.

Unlike earlier investigations, which focused primarily on aggregating transactional data, this analysis required thinking at multiple levels of aggregation.

The investigation reinforced the importance of:

- choosing the correct analytical grain,
- distinguishing customers from transactions,
- building business KPIs from intermediate calculations,
- and translating SQL outputs into actionable business recommendations.

---

# Interview Notes

Possible interview discussion points include:

- Why use `customer_unique_id` instead of `customer_id`?
- What is customer retention?
- How would you identify repeat customers using SQL?
- Why is customer-level aggregation important?
- How do you avoid misleading averages?
- How can customer segmentation improve marketing decisions?
- Why are repeat customers valuable to an e-commerce business?

---

# Skills Demonstrated

- Customer Retention Analysis
- Customer Behaviour Analysis
- Revenue Analysis
- Customer Segmentation
- KPI Development
- Multi-table JOINs
- Multi-stage Aggregation
- Window Functions
- Business Intelligence Reporting
- Analytical Problem Solving

---

# Conclusion

Investigation 22 introduced customer retention as a core business intelligence problem. By combining customer, order, and payment data, the analysis measured repeat purchasing behaviour, quantified customer revenue contribution, and segmented customers according to purchasing frequency.

A key outcome of this investigation was learning that many business questions require multiple stages of aggregation rather than a single SQL query. This analytical pattern forms the foundation for more advanced SQL techniques such as Common Table Expressions (CTEs), window functions, cohort analysis, and customer lifetime value modelling.

The investigation concludes the relational analysis phase by demonstrating how SQL can be used not only to retrieve data but also to generate strategic insights that support long-term customer growth and business decision-making.