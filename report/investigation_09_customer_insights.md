# Investigation 09 – Customer Insights

## Business Objective

Analyse customer distribution across Brazilian states and cities to identify major customer markets and demonstrate the use of aggregate SQL functions for business reporting.

---

## Business Questions

1. How many customer records exist in each state?
2. Which states have more than 1,000 customer records?
3. Which states have fewer than 500 customer records?
4. What is the average number of customer records per state?
5. Which cities have the largest number of customer records?
6. Which cities have more than 500 customer records?
7. How many unique customers exist in each state?
8. Which states have the highest number of unique customers?
9. Which ZIP code prefixes contain the most customer records?
10. Compare customer records and unique customers for each state.

---

## Key Findings

- Customer records are concentrated within a relatively small number of Brazilian states.
- São Paulo (SP) continues to represent the company's largest customer market.
- Several metropolitan cities contain significantly higher customer concentrations than the national average.
- Customer records exceed unique customers because repeat buyers receive new customer records while retaining the same `customer_unique_id`.
- `HAVING` provides an efficient method for filtering grouped business metrics after aggregation.

---

## Business Interpretation

Understanding geographic customer concentration enables businesses to prioritise marketing campaigns, allocate logistics resources, and identify regions with the greatest commercial potential.

Comparing customer records with unique customers also provides insight into repeat purchasing behaviour, highlighting why selecting the correct identifier is essential when measuring customer metrics.

---

## Analyst Reflection

This investigation formally introduced `HAVING`, extending previous knowledge of `GROUP BY` by allowing aggregate results to be filtered after grouping.

The analysis also reinforced the importance of selecting appropriate business metrics and demonstrated that some analytical questions require nested aggregation techniques, laying the foundation for future lessons on subqueries and Common Table Expressions.

---

## Interview Notes

### Why can't aggregate functions be used inside a `WHERE` clause?

Because `WHERE` filters individual rows before grouping occurs. Aggregate functions such as `COUNT()` and `SUM()` are calculated only after groups have been created.

---

### When should `HAVING` be used?

`HAVING` filters grouped results after aggregation and is commonly used to identify groups that satisfy business conditions, such as states with more than 1,000 customers.

---

**Status:** ✅ Completed