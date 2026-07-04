# Investigation 08 – Sales Performance

## Business Objective

Analyse payment transactions to understand overall sales performance and customer payment behaviour using aggregate SQL functions.

---

## Business Questions

1. How many payment transactions exist?
2. What is the total recorded payment value?
3. What is the average payment value?
4. What are the minimum, maximum, and average payment values?
5. How many transactions were made using each payment method?
6. What is the total payment value by payment method?
7. What is the average payment value by payment method?
8. What are the minimum and maximum payment values for each payment method?
9. How many transactions were made for each installment count?
10. What is the total payment value for each installment count?

---

## Key Findings

- The dataset contains **103,886** payment records.
- Customers recorded more than **BRL 16 million** in total payment value.
- The average payment transaction was approximately **BRL 154.10**.
- Credit cards account for the largest number of transactions and the highest total payment value.
- Boleto is the second most frequently used payment method.
- Three `not_defined` payment records have a payment value of **0.00**, representing exceptional cases that warrant further investigation.
- Installment payments vary considerably, creating opportunities for future behavioural analysis.

---

## Business Interpretation

Payment data suggests that credit cards are the dominant payment method, both in frequency and value, making them a key driver of recorded customer payments. The presence of multiple payment records for some orders also indicates that customers can split payments across methods or installments.

While unusual `not_defined` payment records were identified, further investigation using order information would be required before determining their business meaning.

---

## Analyst Reflection

This investigation marked the transition from exploratory data validation to aggregate business reporting. By combining multiple aggregate functions with `GROUP BY`, the analysis moved beyond describing individual records to summarising trends that support business decision-making.

The investigation also reinforced the importance of using precise language when interpreting results, distinguishing between observations supported by the data and hypotheses requiring additional evidence.

---

## Interview Notes

**Why use aggregate functions instead of examining individual rows?**

Aggregate functions summarise large datasets into meaningful business metrics such as totals, averages, minimums, and maximums, enabling decision-makers to quickly understand overall performance.

**What is the purpose of `GROUP BY`?**

`GROUP BY` partitions rows into categories so aggregate functions can calculate summary statistics for each group rather than across the entire dataset.

---

**Status:** ✅ Completed