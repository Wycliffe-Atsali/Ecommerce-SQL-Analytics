# Investigation 05 – Payments

## Business Objective

Understand how customer payments are recorded by exploring payment methods, installment usage, and transaction completeness before conducting financial analysis.

---

# Business Questions

1. How many payment records exist?
2. How many payment methods are available?
3. Which payment methods are represented?
4. How many payments use each payment method?
5. What is the minimum number of payment installments?
6. What is the maximum number of payment installments?
7. How many payment records have missing payment types?
8. How many payment records have missing payment values?
9. What is the smallest recorded payment value?
10. What is the largest recorded payment value?

---

# Results

| Question | Result |
|-----------|--------:|
| Total Payment Records | 103,886 |
| Payment Methods | 5 |
| Most Common Payment Method | credit_card |
| Minimum Installments | 0 |
| Maximum Installments | 24 |
| NULL Payment Types | 0 |
| NULL Payment Values | 0 |
| Minimum Payment Value | 0.00 |
| Maximum Payment Value | 13,664.08 |

---

# Key Findings

- The payments table contains more records than the orders table, indicating that some orders are associated with multiple payment records.
- Five payment methods are represented, including the explicit category `not_defined`.
- Credit cards are by far the most frequently used payment method.
- Payment information is complete, with no NULL values for payment type or payment amount.
- Zero-installment and zero-value payments should be investigated further to determine whether they represent valid business scenarios or data quality issues.

---

# Business Interpretation

The payment dataset is highly complete and suitable for financial analysis. However, exploratory analysis identified several records that warrant further investigation before drawing conclusions about customer payment behaviour.

Understanding these anomalies will improve the reliability of future revenue and payment analyses.

---

# Analyst Reflection

This investigation demonstrated the importance of distinguishing between explicit categorical values (such as `not_defined`) and genuinely missing data (`NULL`).

It also highlighted that analysts should avoid making assumptions about unusual values without supporting evidence, instead documenting them for future investigation.

---

# Interview Notes

### Why are there more payment records than orders?

The payments table records payment transactions rather than orders. A single order may have multiple payment records, resulting in more payment rows than order rows.

### Why is `not_defined` different from NULL?

`not_defined` is an explicit value stored in the database, while `NULL` represents missing information. They have different business meanings and should not be treated the same during analysis.

### Why investigate zero-value payments?

A payment of zero may represent a valid business scenario, such as a voucher covering the full order value, or it may indicate a data quality issue. Further analysis is required before drawing conclusions.

---

**Status:** ✅ Completed