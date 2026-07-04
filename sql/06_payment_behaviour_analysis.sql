/*======================================================================================================================
INVESTIGATION 12 — PAYMENT BEHAVIOUR ANALYSIS

Business Objective
------------------
Analyse customer payment behaviour by examining payment methods, installment usage,
transaction values, and revenue contribution to support financial decision-making.

Skills Practiced
----------------
• COUNT()
• SUM()
• AVG()
• MIN()
• MAX()
• ROUND()
• GROUP BY
• HAVING
• Business interpretation

======================================================================================================================*/

-- Q1. Payment method performance

SELECT
    payment_type,
    COUNT(*) AS transaction_count,
    SUM(payment_value) AS total_revenue,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;


-- Q2. Installment behaviour

SELECT
    payment_installments,
    COUNT(*) AS transaction_count
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments ASC;


-- Q3. Installment plans with average payment value above 500

SELECT
    payment_installments,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM order_payments
GROUP BY payment_installments
HAVING AVG(payment_value) > 500
ORDER BY average_payment_value DESC;


-- Q4. Payment method summary

SELECT
    payment_type,
    MIN(payment_value) AS minimum_payment,
    ROUND(AVG(payment_value), 2) AS average_payment,
    MAX(payment_value) AS maximum_payment
FROM order_payments
GROUP BY payment_type
ORDER BY average_payment DESC;


-- Q5. Revenue by installment plan

SELECT
    payment_installments,
    SUM(payment_value) AS total_revenue
FROM order_payments
GROUP BY payment_installments
ORDER BY total_revenue DESC;


-- Q6. Installment quality report

SELECT
    payment_installments,
    COUNT(*) AS transaction_count,
    SUM(payment_value) AS total_revenue,
    ROUND(AVG(payment_value), 2) AS average_payment
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments ASC;


-- Q7. Payment method consistency

SELECT
    payment_type,
    MIN(payment_value) AS minimum_payment,
    MAX(payment_value) AS maximum_payment
FROM order_payments
GROUP BY payment_type;


-- Q8. Zero-value payments investigation

SELECT
    payment_type,
    payment_value,
    COUNT(*) AS zero_value_records
FROM order_payments
WHERE payment_value = 0.00
GROUP BY payment_type, payment_value;


-- Q9. Finance dashboard summary

SELECT
    payment_type,
    COUNT(*) AS transaction_count,
    SUM(payment_value) AS total_revenue,
    ROUND(AVG(payment_value), 2) AS average_payment,
    MIN(payment_value) AS minimum_payment,
    MAX(payment_value) AS maximum_payment
FROM order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;


/*======================================================================================================================

KEY FINDINGS
------------------------------------------------------------------------------------------------------------------------
• Credit cards dominate both transaction volume and total revenue.
• Most customers choose a single payment installment, although longer installment plans
  contribute substantially to revenue for higher-value purchases.
• Zero-value payments exist and are associated with voucher and not_defined payment
  types, indicating records that warrant further investigation.
• Executive-level summaries can be produced efficiently using aggregate SQL functions.

------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
------------------------------------------------------------------------------------------------------------------------
This investigation focused on understanding customer payment behaviour rather than
simply describing payment records. It highlighted the importance of interpreting
aggregate metrics in a business context while identifying anomalies that may require
additional investigation through joins and more advanced SQL techniques.

======================================================================================================================*/