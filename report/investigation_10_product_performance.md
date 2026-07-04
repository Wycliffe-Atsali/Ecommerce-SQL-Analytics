# Investigation 10 – Product Performance

## Business Objective

Analyse the product catalogue to understand category distribution, product characteristics, and potential data quality issues using aggregate SQL functions.

---

## Business Questions

1. How many products exist in each category?
2. Which categories contain more than 500 products?
3. What is the average product weight for each category?
4. Which categories have an average weight greater than 1,000 grams?
5. What are the minimum, maximum, and average product name lengths by category?
6. How many products have missing category names?
7. What is the average product description length by category?
8. Which five categories have the highest average product description length?
9. How many products have a recorded weight of zero grams?
10. Produce a summary report showing product count, average weight, and average name length by category.

---

## Key Findings

- Product counts vary significantly across categories.
- Several categories contain more than 500 products, indicating core product lines.
- Average product weights differ considerably between categories.
- Only a small number of products have missing category names.
- Four products have a recorded weight of zero grams, suggesting potential data quality issues.
- Multi-metric summary reports provide richer insights than individual aggregate measures.

---

## Business Interpretation

Understanding product distribution helps inventory planners prioritise storage, forecasting, and procurement activities. Aggregate statistics also identify unusual records that may require data quality review before downstream analysis.

---

## Analyst Reflection

This investigation introduced `ROUND()` to improve report readability and reinforced the importance of matching SQL calculations to business questions. Combining several aggregate functions into a single report demonstrated how SQL supports executive-level summaries while maintaining analytical precision.

---

## Interview Notes

### Why is `ROUND()` commonly used in reporting?

`ROUND()` improves readability by limiting decimal precision, making averages and other calculated metrics easier for business users to interpret.

### Should `ROUND()` be used inside a `HAVING` clause?

Generally no. Filtering should use the original aggregate values, while `ROUND()` is better reserved for presentation in the final output.

---

**Status:** ✅ Completed