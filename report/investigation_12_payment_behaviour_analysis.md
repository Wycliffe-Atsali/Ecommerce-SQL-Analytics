# Investigation 12 – Payment Behaviour Analysis

## Business Objective

Analyse customer payment behaviour to understand payment preferences, installment usage, revenue contribution, and potential data quality issues.

---

## Business Questions

1. Which payment methods generate the most transactions and revenue?
2. How frequently is each installment option used?
3. Which installment plans have an average payment value greater than 500?
4. What are the minimum, average, and maximum payment values for each payment method?
5. Which installment plans generate the highest total revenue?
6. Produce a financial summary by installment option.
7. Which payment methods show the widest range of transaction values?
8. Investigate zero-value payment records.
9. Produce an executive finance dashboard summarising payment performance.
10. Reflect on key findings and future investigations.

---

## Key Findings

- Credit cards are the dominant payment method by both transaction volume and revenue.
- Most customers pay using a single installment, while longer installment plans support higher-value purchases.
- Installment plans 1, 2, and 10 contribute a significant share of total revenue.
- Nine zero-value payment records were identified, all associated with voucher or not_defined payment types.

---

## Business Interpretation

Payment behaviour suggests that customers generally prefer immediate payment while still using installment plans for larger purchases. The presence of zero-value transactions and undefined payment types highlights opportunities for further investigation into promotional payments, voucher usage, or data quality issues.

---

## Analyst Reflection

This investigation demonstrated how aggregate SQL functions can be combined to build finance-focused reports. Rather than simply calculating metrics, the analysis focused on interpreting payment behaviour, identifying unusual records, and generating questions for future investigation. This approach mirrors how analysts support decision-making within finance teams.

---

## Interview Notes

### Why use `HAVING` instead of `WHERE` when filtering average payment values?

`HAVING` filters grouped results after aggregate calculations have been performed, whereas `WHERE` filters individual rows before grouping.

### What would you investigate next?

- Zero-value payments.
- Undefined payment types.
- Relationships between payment methods and order status.
- Revenue by product category and payment method.

---

**Status:** ✅ Completed