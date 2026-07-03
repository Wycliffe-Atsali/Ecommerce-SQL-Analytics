# Investigation 01 – Orders Table Exploration

## Business Objective

The objective of this investigation was to gain an initial understanding of the `orders` table before performing any business analysis. The investigation focused on understanding the structure of the table, the overall size of the dataset, the order lifecycle, and identifying any potential data quality issues that could influence later analyses.

---

# Business Questions

The following questions guided this investigation:

1. What does a typical order record look like?
2. How many orders exist in the dataset?
3. Which order statuses are recorded?
4. How many unique order statuses exist?
5. What time period does the dataset cover?
6. How many orders do not have a recorded customer delivery date?
7. Which order statuses are associated with missing customer delivery dates?

---

# Key Findings

| Finding | Result |
|---------|--------|
| Total Orders | 99,441 |
| Dataset Coverage | 2016-09-04 to 2018-10-17 |
| Unique Order Statuses | 8 |
| Orders Without Customer Delivery Date | 2,965 |

The following order statuses were identified:

- approved
- canceled
- created
- delivered
- invoiced
- processing
- shipped
- unavailable

---

# Business Interpretation

The `orders` table serves as the central transaction table within the database, recording each customer purchase and its progression through the order lifecycle.

The dataset covers approximately two years of e-commerce activity, providing sufficient historical data for time-based analyses such as sales trends, seasonality, and delivery performance.

The investigation also revealed that some orders marked as `delivered` do not contain a customer delivery timestamp. While unexpected, this reflects the reality of working with operational datasets and highlights the importance of validating data quality before performing downstream analyses.

---

# Analyst Reflection

A key lesson from this investigation was the importance of validating assumptions rather than relying on intuition.

Initially, it was expected that orders with a status of `delivered` would always include a customer delivery timestamp. Exploratory SQL revealed that this assumption was not universally true.

This reinforces an important analytical principle:

> Never assume the data reflects the business process perfectly. Validate every assumption using SQL.

---

# Interview Notes

This investigation demonstrates the ability to:

- Explore an unfamiliar dataset using SQL.
- Interpret business processes from relational data.
- Apply `SELECT`, `DISTINCT`, `COUNT`, `MIN`, `MAX`, `ORDER BY`, `LIMIT`, and `WHERE`.
- Identify potential data quality issues before analysis.
- Translate SQL results into meaningful business insights.