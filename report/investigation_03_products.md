# Investigation 03 – Products

## Business Objective

Understand the structure and quality of the product catalog before performing
product performance, inventory, or sales analyses.

---

# Business Questions

1. How many products exist in the catalog?
2. How many unique product categories are available?
3. Which product categories are represented?
4. How many products have no assigned category?
5. What is the shortest recorded product name?
6. What is the longest recorded product name?
7. What is the smallest recorded product weight?
8. What is the largest recorded product weight?
9. How many products have missing weight information?
10. How many products have missing dimension information?

---

# Results

| Question | Result |
|----------|--------:|
| Total Products | 32,951 |
| Unique Categories | 73 |
| Products Without Category | 610 |
| Shortest Product Name | 5 characters |
| Longest Product Name | 76 characters |
| Smallest Recorded Weight | 0 g |
| Largest Recorded Weight | 40,425 g |
| Missing Weight | 2 |
| Missing Width | 2 |
| Missing Height | 2 |
| Missing Length | 2 |

---

# Key Findings

- The catalog contains **32,951 products** distributed across **73 categories**.
- **610 products** are missing a category assignment.
- Product names range from **5 to 76 characters**.
- Four products have a recorded weight of **0 g**, which is unlikely to represent valid physical products.
- Only **2 products** are missing weight information.
- Product dimension data is nearly complete, with only **2 missing values** in each measurement field.

---

# Business Interpretation

The product catalog is largely complete, making it suitable for future analyses involving product categories, logistics, and inventory. However, the missing category assignments and implausible zero-weight values should be reviewed before using this data in operational reporting or shipping analyses.

This investigation demonstrates that data exploration is an essential first step before conducting business analysis. Identifying incomplete or suspicious values early helps prevent inaccurate conclusions in later stages of a project.

---

# Analyst Reflection

This investigation reinforced the importance of questioning the data rather than assuming its correctness.

While exploring the table, several observations required additional reasoning, including duplicate minimum values and products with zero recorded weight. These findings illustrate that exploratory analysis is not limited to retrieving information—it also involves evaluating the reliability and quality of the underlying data.

---

# Interview Notes

### Why is a weight of 0 g different from a NULL weight?

A value of **0 g** indicates that a weight was explicitly recorded as zero, whereas **NULL** indicates that the weight is unknown or missing. These values have different business meanings and should not be treated as equivalent.

### Why avoid using `LIMIT` to identify minimum values?

Using `LIMIT` only returns the first matching rows based on sorting. If multiple records share the minimum value, some may be excluded. A more robust solution is to compare values against the true minimum using a subquery, ensuring all qualifying records are returned.

---

**Status:** ✅ Completed