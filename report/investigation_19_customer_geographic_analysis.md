# Investigation 19: Customer Geographic Analysis

## Project Information

| Project | Retail SQL Business Analysis |
|----------|------------------------------|
| Investigation | 19 |
| Title | Customer Geographic Analysis |
| Database | PostgreSQL |
| Dataset | Brazilian E-Commerce Public Dataset by Olist |
| Analysis Type | Relational Analysis (JOINs) |
| Primary Tables | `customers`, `orders` |
| Supporting Table | `order_payments` |

---

# Business Objective

Analyze the geographical distribution of customers and purchasing activity across Brazil to understand where customers are concentrated, identify the company's strongest regional markets, evaluate regional spending patterns, and uncover opportunities for future business growth.

---

# Business Context

For a nationwide e-commerce business, understanding **where customers are located** is just as important as understanding **what they purchase**.

Geographic analysis enables organizations to answer strategic questions such as:

- Which states contribute the largest customer base?
- Which regions generate the highest revenue?
- Where should marketing campaigns be concentrated?
- Which markets deserve additional operational investment?
- Which regions represent untapped growth opportunities?

These insights support strategic planning across marketing, logistics, customer relationship management, and executive decision-making.

---

# Business Questions

This investigation answers the following questions:

1. How many customer states exist in the dataset?
2. How many customers are located in each state?
3. Which ten states have the largest customer populations?
4. Which ten cities contain the highest number of customers?
5. How many orders originate from each customer state?
6. Which five states generate the highest order volumes?
7. What is the average number of orders placed by each unique customer within every state?
8. How much revenue has each customer state generated?
9. Which five states generate the highest revenue?
10. What is the average order value for each customer state?
11. Which customers have spent the most money?
12. Which states have the highest average customer lifetime value?
13. Which states have many customers but relatively low average order values?
14. Which states have relatively few customers but high average order values?
15. Which states represent the company's strongest overall markets?

---

# Database Thinking

This investigation required understanding both customer identity and purchasing behaviour.

## Primary Tables

### `customers`

Provides customer location information:

- Customer ID
- Unique Customer ID
- City
- State

### `orders`

Links customers to purchases.

### `order_payments`

Provides order-level revenue used to measure customer spending.

---

# Relationship Path

```text
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

# Analysis Grain

Unlike previous investigations, multiple analytical grains were required.

| Business Question | Analysis Grain |
|-------------------|----------------|
| Customer distribution | Customer |
| Order counts | Order |
| Revenue by state | State |
| Average order value | Order |
| Customer lifetime value | Customer |

Selecting the correct grain before writing SQL was essential for producing meaningful business metrics.

---

# Methodology

The investigation followed the established analytical workflow:

```text
Business Problem

↓

Identify Required Business Entities

↓

Determine Relationships

↓

Select Appropriate JOIN Strategy

↓

Choose Correct Analysis Grain

↓

Develop SQL Queries

↓

Interpret Results

↓

Produce Business Recommendations
```

The analysis progressed from simple customer distribution to increasingly strategic regional performance metrics.

---

# SQL Techniques Used

This investigation reinforced and introduced several important PostgreSQL concepts:

- INNER JOIN
- Multi-table joins
- Aggregate functions
- Conditional aggregation
- `COUNT(DISTINCT)`
- `SUM()`
- `AVG()`
- `ROUND()`
- Common Table Expressions (CTEs)
- Customer Lifetime Value approximation
- Business KPI development
- Multi-level aggregation

---

# Data Quality Considerations

Several important modelling decisions influenced this investigation.

## Customer Identity

The Olist dataset assigns a new `customer_id` every time a customer places an order.

Therefore:

- `customer_id` identifies an individual purchase.
- `customer_unique_id` identifies the actual customer.

Whenever customer behaviour was analysed, `customer_unique_id` was used to avoid counting returning customers multiple times.

---

## Revenue Measurement

Revenue was calculated using `order_payments.payment_value`.

Although `order_items.price` measures merchandise value, customer spending is better represented by payment values because they reflect the total amount paid for each order.

This distinction was intentionally applied to maintain the correct business interpretation.

---

# Key Findings

## 1. Customer Distribution

Customers are unevenly distributed across Brazil.

A relatively small number of states account for the majority of the customer base.

---

## 2. Largest Customer Market

São Paulo (SP) contains the largest concentration of customers, making it the company's most significant market by customer population.

---

## 3. Order Distribution

States with larger customer populations generally produced higher order volumes.

This demonstrates a strong relationship between customer concentration and purchasing activity.

---

## 4. Revenue Distribution

Revenue generation closely followed customer concentration.

São Paulo, Rio de Janeiro, and Minas Gerais consistently ranked among the highest-performing states.

---

## 5. Average Order Value

Although high-population states generated greater total revenue, several smaller markets demonstrated comparatively high average order values.

This suggests the existence of premium regional markets despite smaller customer bases.

---

## 6. Customer Lifetime Value

Average customer lifetime value varied across states.

This indicates that customer purchasing behaviour differs geographically and that not all markets contribute equally to long-term customer value.

---

## 7. Strategic Market Segmentation

The analysis identified two distinct types of regional markets:

- High-volume markets that generate consistent revenue through large customer populations.
- Smaller markets where customers spend more per order.

Both market types represent valuable business opportunities requiring different strategic approaches.

---

# Business Interpretation

The results indicate that geographic location plays a significant role in overall business performance.

Large customer markets such as São Paulo, Rio de Janeiro, and Minas Gerais continue to drive revenue because of their substantial customer populations and purchasing activity.

However, customer value is not determined solely by population size.

Some smaller states demonstrated stronger average order values and customer lifetime values, suggesting that targeted marketing campaigns or premium product offerings could generate significant returns in these regions.

These findings highlight the importance of balancing customer acquisition strategies with customer value optimization.

---

# Business Recommendations

## Recommendation 1

Continue prioritizing customer acquisition and retention initiatives in São Paulo, Rio de Janeiro, and Minas Gerais.

These remain the company's strongest strategic markets.

---

## Recommendation 2

Develop targeted marketing campaigns for smaller states exhibiting high average order values.

These regions may represent profitable niche markets.

---

## Recommendation 3

Monitor Customer Lifetime Value by state as an ongoing strategic KPI.

This enables marketing investments to focus on acquiring customers who generate the greatest long-term value.

---

## Recommendation 4

Investigate regions where customer populations are high but average order values remain relatively low.

These markets may benefit from cross-selling, upselling, or personalized promotional campaigns.

---

## Recommendation 5

Develop regional executive dashboards displaying:

- Customer population
- Order volume
- Revenue
- Average order value
- Customer Lifetime Value

These dashboards will support data-driven regional business decisions.

---

# Challenges Encountered

## Choosing the Correct Customer Identifier

One of the most important challenges was distinguishing between `customer_id` and `customer_unique_id`.

Using the incorrect identifier would overestimate the number of unique customers and distort customer behaviour metrics.

---

## Selecting the Appropriate Revenue Metric

A key business decision involved determining whether revenue should be measured using:

- `order_items.price`
- `order_payments.payment_value`

Because this investigation focused on customer spending rather than product sales, `payment_value` provided the more appropriate business metric.

---

## Customer Lifetime Value

The dataset does not contain information such as customer acquisition cost, churn, or future purchases.

Therefore, Customer Lifetime Value was approximated as the total amount spent by each unique customer across all recorded orders.

Although simplified, this provides a useful comparative metric for regional analysis.

---

# Analyst Reflection

This investigation emphasized that SQL analysis extends beyond writing technically correct queries.

Producing meaningful business insights required selecting the correct analytical grain, choosing appropriate business metrics, and understanding the structure of the underlying dataset.

The introduction of Customer Lifetime Value and Common Table Expressions also demonstrated how complex business questions can be solved through structured analytical thinking.

---

# Interview Notes

Potential interview discussion topics include:

- Difference between `customer_id` and `customer_unique_id`.
- Why customer behaviour should be measured using unique customers.
- Choosing between `payment_value` and `price` depending on the business question.
- Approximating Customer Lifetime Value using transactional data.
- Benefits of Common Table Expressions over nested subqueries.
- Importance of selecting the correct analytical grain.
- Translating SQL outputs into strategic business recommendations.

---

# Skills Demonstrated

This investigation demonstrates proficiency in:

- Relational database analysis
- Multi-table joins
- Geographic business intelligence
- Customer analytics
- Revenue analysis
- Customer Lifetime Value approximation
- Common Table Expressions (CTEs)
- Multi-level aggregation
- Executive reporting
- Strategic business interpretation

---

# Conclusion

Investigation 19 explored how customer geography influences business performance by combining customer demographics, order activity, and revenue into a comprehensive regional analysis.

The investigation identified São Paulo, Rio de Janeiro, and Minas Gerais as the company's strongest markets, driven by their large customer populations, high order volumes, and substantial revenue generation. At the same time, it revealed that smaller markets can achieve strong average order values and customer lifetime values, highlighting opportunities for targeted growth strategies.

Beyond the business insights, this investigation reinforced several advanced analytical concepts, including selecting the correct analytical grain, distinguishing between customer identifiers, using payment-based revenue metrics, and introducing Common Table Expressions to solve multi-stage business problems. These skills reflect the type of structured thinking expected of a Junior Data Analyst working on real-world business intelligence projects.