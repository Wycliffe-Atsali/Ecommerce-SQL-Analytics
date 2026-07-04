# Investigation 13 – Customer Review Analysis

## Business Objective

Evaluate customer satisfaction by analysing review scores, review activity over time, and the completeness of customer feedback.

---

## Business Questions

1. How are customer review scores distributed?
2. Which review scores dominate customer feedback?
3. What period does the review dataset cover?
4. How complete are customer reviews?
5. What is the overall average review score?
6. How can review scores be classified into satisfaction levels?
7. How many reviews contain no written feedback?
8. Produce a review score dashboard.
9. Produce an executive customer experience summary.
10. Reflect on the implications of the findings.

---

## Key Findings

- Average review score: **4.09 / 5**.
- Five-star reviews account for the largest share of customer feedback.
- Review activity covers approximately October 2016 through October 2018.
- Many customers provide only numeric ratings without written comments.
- Review scores can be effectively grouped into high, moderate, and low satisfaction categories using `CASE`.

---

## Business Interpretation

Overall customer satisfaction appears strong, with positive ratings significantly outweighing negative ones. However, the presence of one-star reviews indicates that a meaningful minority of customers experienced poor service. Reviews without written comments should not automatically be treated as missing data, as many customers may intentionally choose to provide only a numeric rating.

---

## Analyst Reflection

This investigation introduced `CASE` expressions, enabling customer feedback to be classified into meaningful business categories directly within SQL. Beyond reporting aggregate metrics, the analysis highlighted opportunities for deeper investigation, such as exploring the relationship between review scores, revenue, delivery performance, and customer retention.

---

## Interview Notes

### Why is `CASE` useful?

`CASE` allows SQL to categorise data into business-friendly groups, making reports easier to interpret and reducing the need for additional processing in reporting tools.

### Are missing review comments a data quality issue?

Not necessarily. Many customers may choose to leave only a numeric rating, so the absence of written feedback can reflect user behaviour rather than incomplete data.

---

**Status:** ✅ Completed