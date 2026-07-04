/*======================================================================================================================
INVESTIGATION 8 — SALES PERFORMANCE

Business Objective
------------------
Summarise payment transactions to understand overall sales performance and
customer payment behaviour.

Skills Practiced
----------------
• COUNT()
• SUM()
• AVG()
• MIN()
• MAX()
• GROUP BY

======================================================================================================================*/

-- -------------------------------------------------------------------------------------------------
-- Q1. Total payment transactions
-- -------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS total_transactions
FROM order_payments;


-- -------------------------------------------------------------------------------------------------
-- Q2. Total recorded payment value
-- -------------------------------------------------------------------------------------------------

SELECT SUM(payment_value) AS total_payment_value
FROM order_payments;


-- -------------------------------------------------------------------------------------------------
-- Q3. Average payment value
-- -------------------------------------------------------------------------------------------------

SELECT AVG(payment_value) AS average_payment_value
FROM order_payments;


-- -------------------------------------------------------------------------------------------------
-- Q4. Payment value summary
-- -------------------------------------------------------------------------------------------------

SELECT
    AVG(payment_value) AS average_payment_value,
    MIN(payment_value) AS minimum_payment_value,
    MAX(payment_value) AS maximum_payment_value
FROM order_payments;


-- -------------------------------------------------------------------------------------------------
-- Q5. Transactions by payment method
-- -------------------------------------------------------------------------------------------------

SELECT
    payment_type,
    COUNT(*) AS transaction_count
FROM order_payments
GROUP BY payment_type
ORDER BY transaction_count DESC;


-- -------------------------------------------------------------------------------------------------
-- Q6. Total payment value by payment method
-- -------------------------------------------------------------------------------------------------

SELECT
    payment_type,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- -------------------------------------------------------------------------------------------------
-- Q7. Average payment value by payment method
-- -------------------------------------------------------------------------------------------------

SELECT
    payment_type,
    AVG(payment_value) AS average_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY average_payment_value DESC;


-- -------------------------------------------------------------------------------------------------
-- Q8. Minimum and maximum payment value by payment method
-- -------------------------------------------------------------------------------------------------

SELECT
    payment_type,
    MIN(payment_value) AS minimum_payment_value,
    MAX(payment_value) AS maximum_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY maximum_payment_value DESC;


-- -------------------------------------------------------------------------------------------------
-- Q9. Transactions by installment count
-- -------------------------------------------------------------------------------------------------

SELECT
    payment_installments,
    COUNT(*) AS transaction_count
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;


-- -------------------------------------------------------------------------------------------------
-- Q10. Total payment value by installment count
-- -------------------------------------------------------------------------------------------------

SELECT
    payment_installments,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;


/*======================================================================================================================
KEY FINDINGS
------------------------------------------------------------------------------------------------------------------------
• The dataset contains 103,886 payment records.
• Total recorded customer payment value exceeds BRL 16 million.
• Credit cards dominate both transaction count and payment value.
• Boleto is the second most common payment method.
• Only three transactions use the "not_defined" payment type, all with zero payment value.
• Customers use a range of installment plans, providing a basis for future payment behaviour analysis.

------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
------------------------------------------------------------------------------------------------------------------------
This investigation introduced aggregate analysis using SUM() and AVG(), extending previous exploratory work beyond
simple counts and descriptive statistics. Grouping payment data revealed differences in customer payment behaviour and
highlighted how aggregate functions support business reporting.

The findings also demonstrated the importance of distinguishing observed facts from analytical hypotheses when
interpreting unusual records.
======================================================================================================================*/