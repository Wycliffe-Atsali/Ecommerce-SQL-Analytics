# Investigation 11 – Seller Performance

## Business Objective

Analyse the geographical distribution of sellers across Brazil and identify areas with the highest concentration of merchants using aggregate SQL functions and multi-column grouping.

---

## Business Questions

1. How many sellers operate in each state?
2. Which states have more than 100 sellers?
3. Which cities have the highest number of sellers?
4. Which cities have more than 20 sellers?
5. How many sellers operate within each state-city combination?
6. Which state-city combinations contain more than 10 sellers?
7. How many unique seller cities exist within each state?
8. Which state has the greatest geographical seller coverage?
9. What percentage of sellers operate in each state?
10. Produce a summary showing seller count and unique cities by state.

---

## Key Findings

- Seller activity is concentrated within a limited number of Brazilian states.
- Multi-column grouping revealed detailed regional seller distribution.
- States differ significantly in both seller count and geographical coverage.
- Counting distinct cities provides a broader measure of marketplace reach than seller counts alone.

---

## Business Interpretation

Understanding where sellers are concentrated helps marketplace operators identify regions with strong merchant ecosystems and areas where seller acquisition efforts may be required. Analysing both seller counts and geographical coverage supports logistics planning, marketplace expansion, and regional business strategy.

---

## Analyst Reflection

This investigation introduced multi-column `GROUP BY`, enabling more granular geographical analysis. It also demonstrated that some business metrics, such as percentages of total sellers, require more advanced SQL techniques including subqueries, CTEs, or window functions, which will be introduced in later phases.

---

## Interview Notes

### Why use multiple columns in a `GROUP BY` clause?

Grouping by multiple columns creates groups based on unique combinations of values, allowing more detailed summaries than grouping by a single column.

### Why use `COUNT(DISTINCT seller_city)`?

It measures geographical coverage by counting unique locations rather than the number of seller records.

---

**Status:** ✅ Completed