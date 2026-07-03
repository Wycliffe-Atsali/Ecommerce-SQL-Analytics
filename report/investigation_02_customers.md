# Investigation 02 – Customers Table Exploration

## Business Objective

The objective of this investigation was to understand the structure, completeness, and geographic distribution of customer data before beginning customer behaviour and retention analyses.

---

# Business Questions

1. What information is stored for each customer?
2. How many customer records exist?
3. How many unique customers exist?
4. Which Brazilian states are represented?
5. How many states are represented?
6. Which cities appear in the dataset?
7. Are any ZIP code prefixes missing?
8. Are any cities missing?
9. Are any states missing?
10. Which state contains the most customer records?

---

# Key Findings

| Finding | Result |
|---------|--------|
| Customer Records | 99,441 |
| Unique Customers | 96,096 |
| Difference | 3,345 |
| States Represented | 27 |
| Largest State | SP |
| Customers in SP | 41,746 |

---

# Business Interpretation

The investigation confirms that the customer dataset is geographically comprehensive, containing records from all 27 Brazilian federal units.

Comparison between `customer_id` and `customer_unique_id` revealed that the dataset contains more customer records than unique customers, indicating that some customers placed multiple orders.

This distinction is important because analyses involving customer counts, retention, and lifetime value should use `customer_unique_id` rather than `customer_id` to avoid counting the same customer multiple times.

---

# Analyst Reflection

One of the most valuable insights from this investigation was understanding that database keys are designed to represent different business concepts.

Although `customer_id` uniquely identifies each customer record, it does not necessarily represent a unique customer. The `customer_unique_id` provides a more accurate representation of individual customers across multiple purchases.

This reinforces the importance of selecting the correct identifier before performing customer-level analyses.

---

# Interview Notes

This investigation demonstrates the ability to:

- Explore a dimension table using SQL.
- Distinguish between surrogate business records and unique business entities.
- Apply `COUNT`, `DISTINCT`, `GROUP BY`, `ORDER BY`, and `WHERE`.
- Interpret customer demographics and geographic coverage.
- Translate SQL results into business insights.