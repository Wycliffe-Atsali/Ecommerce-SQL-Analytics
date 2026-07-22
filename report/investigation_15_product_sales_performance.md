# Investigation 15: Product Sales Performance Analysis

## Business Objective

The objective of this investigation was to evaluate product sales performance by analysing product demand, revenue generation, category performance, and seller contribution. The analysis combines product, order item, seller, and payment information to identify the products and categories driving business performance and to support inventory planning, merchandising, and strategic decision-making.

---

# Business Context

Products represent the primary source of revenue for an e-commerce platform. Understanding which products are purchased most frequently, generate the highest revenue, and contribute most significantly to business growth enables management to make informed decisions regarding inventory allocation, pricing strategies, supplier relationships, and marketing investment.

Unlike previous investigations focused primarily on customer behaviour, this investigation shifts the analytical perspective toward product performance while reinforcing relational database analysis using multiple table joins.

---

# Database Thinking

## Tables Used

| Table | Purpose |
|--------|----------|
| products | Product information and category |
| order_items | Individual products purchased in each order |
| sellers | Seller responsible for each product |
| order_payments | Payment information (used carefully for order-level context) |

---

## Relationship Path

```text
products
(product_id)
      │
      ▼
order_items
(order_id, seller_id)
      │
      ▼
orders
(order_id)
```

For product-level revenue analysis, `order_items.price` was used because it represents the price of each individual item sold. Using `payment_value` would duplicate revenue whenever an order contains multiple products.

---

# Methodology

The investigation followed a structured relational analysis workflow:

1. Identify the required business information.
2. Determine which tables contain the required data.
3. Map relationships using primary and foreign keys.
4. Apply appropriate `INNER JOIN` and `LEFT JOIN` operations.
5. Aggregate product and category metrics.
6. Interpret results from a business perspective.

---

# Business Questions

## Section A – Product Demand

1. Which products have been sold the most times?
2. Which are the Top 10 best-selling products?
3. Which product categories contain the largest number of products?
4. Which product categories have sold the most items?
5. Which products have never been sold?

---

## Section B – Product Revenue

6. Which products generated the highest revenue?
7. Which are the Top 10 highest-revenue products?
8. What is the average revenue generated per product?
9. Which product categories generate the highest revenue?
10. What is the average revenue per product category?

---

## Section C – Seller & Product Relationships

11. Which sellers offer the largest number of unique products?
12. Which products are sold by the largest number of sellers?
13. Which seller generated the highest product revenue?

---

## Section D – Business Insights

14. Which product categories should receive additional inventory investment?
15. What recommendations should be presented to management?

---

# SQL Techniques Used

- INNER JOIN
- LEFT JOIN
- Multi-table joins
- COUNT()
- COUNT(DISTINCT)
- SUM()
- AVG()
- ROUND()
- GROUP BY
- ORDER BY
- LIMIT
- HAVING

---

# Key Findings

- Certain product categories consistently recorded the highest sales volume and revenue generation.
- Categories such as **cama_mesa_banho** and **beleza_saude** demonstrated particularly strong commercial performance.
- Every product in the dataset had been sold at least once, indicating that the catalogue has experienced customer demand across all listed products.
- Product revenue should be calculated using `order_items.price` rather than `order_payments.payment_value` to avoid double counting revenue for multi-item orders.
- Seller performance varied significantly, with a small number of sellers contributing a disproportionately large share of product revenue.

---

# Business Interpretation

High-performing categories represent opportunities for increased inventory investment and targeted promotional campaigns.

Conversely, categories with relatively low sales volume or revenue may require pricing adjustments, marketing support, or inventory optimisation.

The investigation also highlighted the importance of understanding data granularity when performing revenue analysis. Selecting an inappropriate measure can produce misleading business conclusions despite syntactically correct SQL.

---

# Recommendations

Based on the analysis, the following recommendations are proposed:

- Increase inventory allocation for consistently high-performing categories such as **cama_mesa_banho** and **beleza_saude**.
- Strengthen commercial relationships with top-performing sellers.
- Investigate lower-performing product categories to determine whether pricing, visibility, or customer demand is limiting performance.
- Continue monitoring category-level performance to support inventory planning and seasonal forecasting.
- Establish validation checks when analysing revenue to ensure that table granularity does not introduce duplicate calculations.

---

# Challenges Encountered

Several analytical challenges emerged during this investigation:

- Understanding the relationship between products, order items, sellers, and payments.
- Recognising that `order_items` functions as a bridge table connecting products and orders.
- Identifying the difference in granularity between order-level and product-level data.
- Avoiding double counting caused by joining tables with different levels of detail.
- Selecting the appropriate revenue measure for product analysis.

These challenges reinforced the importance of understanding database design before constructing aggregate queries.

---

# Analyst Reflection

This investigation further strengthened my understanding of relational database analysis by extending multi-table joins beyond customer behaviour to product performance.

The most valuable lesson was recognising that accurate SQL analysis depends not only on correct syntax but also on understanding the level of detail represented by each table. Although multiple queries initially appeared correct, reviewing the underlying data model demonstrated how incorrect aggregation can lead to misleading business insights.

This investigation reinforced the importance of analysing database grain before performing revenue calculations.

---

# Interview Notes

Potential interview discussion topics include:

- Why was `order_items.price` preferred over `order_payments.payment_value`?
- What is meant by table granularity or data grain?
- How can joins introduce double counting?
- Why was `LEFT JOIN` appropriate when identifying unsold products?
- What role does a bridge table play within a relational database?

---

# Skills Demonstrated

## SQL

- INNER JOIN
- LEFT JOIN
- Multi-table joins
- Aggregate analysis
- COUNT(DISTINCT)
- SUM()
- AVG()
- HAVING
- GROUP BY
- ORDER BY

## Data Analysis

- Product performance analysis
- Category analysis
- Revenue analysis
- Seller performance evaluation
- Inventory insights

## Database Concepts

- Bridge tables
- Relational analysis
- Data granularity
- Fact table design
- Revenue aggregation
- Business metric validation

---

# Conclusion

This investigation expanded relational analysis by focusing on product performance rather than customer behaviour.

The analysis demonstrated how multiple related tables can be combined to evaluate sales performance, identify high-performing products and categories, and support inventory and merchandising decisions. It also highlighted the importance of understanding table granularity when designing revenue metrics, providing a strong foundation for more advanced analytical techniques introduced in subsequent investigations.