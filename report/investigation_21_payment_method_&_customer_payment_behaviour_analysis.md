# Investigation 21: Payment Method & Customer Payment Behaviour Analysis

## Project Information

| Project | Retail SQL Business Analysis |
|----------|------------------------------|
| Investigation | 21 |
| Title | Payment Method & Customer Payment Behaviour Analysis |
| Database | PostgreSQL |
| Dataset | Brazilian E-Commerce Public Dataset by Olist |
| Analysis Type | Payment Analytics |
| Primary Table | `order_payments` |
| Supporting Table | `orders` |

---

# Business Objective

The objective of this investigation was to analyze customer payment behaviour by examining payment methods, payment values, installment usage, and revenue contribution.

Understanding how customers choose to pay provides valuable insights into customer preferences, payment flexibility, and revenue generation. These insights help businesses optimize payment options, improve checkout experiences, reduce payment friction, and support financial planning.

---

# Business Context

The payment stage is one of the most critical points in an e-commerce transaction.

Even if customers successfully browse products and place items in their shopping carts, poor payment experiences can lead to abandoned purchases.

Management wants to understand:

- Which payment methods customers prefer.
- Which payment methods generate the highest revenue.
- Whether installment payments are widely adopted.
- Whether customers using certain payment methods spend more than others.
- How payment behaviour influences business performance.

These insights can improve customer satisfaction while maximizing completed transactions.

---

# Business Questions

This investigation addressed the following questions:

1. How many payment methods exist?
2. How many payment records belong to each payment method?
3. What percentage of payment records belongs to each payment method?
4. Which payment method is used most frequently?
5. How much revenue does each payment method generate?
6. Which payment method generates the highest revenue?
7. What is the average payment value for each payment method?
8. Which payment method has the highest average payment value?
9. What is the average number of installments used by each payment method?
10. What is the maximum installment count recorded for each payment method?
11. How many payment records used a single installment?
12. How many payment records used multiple installments?
13. What percentage of credit card payments used more than one installment?
14. Does the most frequently used payment method also generate the highest revenue?
15. What business recommendations can be made from customer payment behaviour?

---

# Database Thinking

## Primary Table

### `order_payments`

Contains:

- Payment type
- Payment value
- Number of installments
- Order identifier

---

## Supporting Table

### `orders`

Used only where order-level context is required.

---

# Relationship Path

```text
orders
     │
order_id
     │
order_payments
```

---

# Analysis Grain

Most of this investigation was performed at the **payment record level** because each row in `order_payments` represents a payment transaction.

However, when answering order-level questions, `COUNT(DISTINCT order_id)` was used to avoid counting multiple payment records belonging to the same order.

Selecting the correct analytical grain ensured accurate business metrics.

---

# Methodology

The investigation followed the established analytical workflow:

```text
Business Problem

↓

Identify Required Tables

↓

Determine Analytical Grain

↓

Write SQL

↓

Interpret Results

↓

Generate Business Recommendations
```

The focus throughout the investigation remained on understanding customer payment preferences and their financial implications.

---

# SQL Techniques Used

## Aggregate Functions

- COUNT()
- COUNT(DISTINCT)
- SUM()
- AVG()
- MAX()
- ROUND()

## SQL Features

- GROUP BY
- ORDER BY
- LIMIT
- FILTER
- Conditional Aggregation
- INNER JOIN

---

# Data Quality Considerations

## Revenue Measurement

Revenue throughout this investigation was calculated using:

```sql
payment_value
```

This accurately represents the monetary value received through each payment transaction.

---

## Multiple Payment Records

An individual order may contain more than one payment record.

To prevent inflated order counts, `COUNT(DISTINCT order_id)` was used whenever order-level metrics were required.

---

## Undefined Payment Types

A very small number of records contained the payment type:

```text
not_defined
```

These records were retained in the analysis but treated as exceptional cases rather than representative customer behaviour.

Without additional operational data, it is not possible to determine whether these records represent cancelled transactions, incomplete payments, or system anomalies.

---

# Key Findings

## 1. Customer Payment Preferences

The dataset contains multiple payment methods, indicating that customers are offered several payment options during checkout.

However, payment usage is highly concentrated in a single dominant payment method.

---

## 2. Credit Cards Dominate Transactions

Credit cards represent the largest share of payment records.

This indicates that customers strongly prefer credit card payments over alternative payment methods.

---

## 3. Credit Cards Generate the Highest Revenue

The most frequently used payment method also generated the highest total revenue.

This suggests that customer preference and revenue contribution are closely aligned.

---

## 4. Installment Payments Are Common

Many customers choose installment plans instead of paying in a single transaction.

This highlights the importance of flexible payment options in encouraging purchases.

---

## 5. Payment Value Differs by Method

Average payment values vary across payment methods.

This indicates that customer spending behaviour differs depending on the payment option selected.

---

## 6. Multiple Installments

Installment usage demonstrates that financing options play an important role in customer purchasing behaviour.

Businesses should continue monitoring installment trends because they influence customer affordability and conversion rates.

---

# Business Interpretation

The investigation demonstrates that payment behaviour extends beyond simply completing transactions.

Customer payment choices provide valuable insight into purchasing habits, financial flexibility, and checkout preferences.

The dominance of credit card payments suggests that maintaining a fast, reliable, and secure credit card checkout process should remain a strategic priority.

Additionally, installment payments appear to encourage customers to complete purchases that may otherwise be financially difficult if paid in full.

Together, these findings highlight the importance of balancing convenience, flexibility, and security throughout the payment process.

---

# Business Recommendations

## Recommendation 1

Continue investing in a reliable and user-friendly credit card checkout experience because it represents the primary source of customer payments and revenue.

---

## Recommendation 2

Maintain installment payment options since they improve affordability and may increase customer willingness to complete purchases.

---

## Recommendation 3

Regularly monitor the performance of less frequently used payment methods to determine whether they should be promoted, redesigned, or simplified.

---

## Recommendation 4

Investigate the small number of `not_defined` payment records to determine whether they represent operational issues, cancelled transactions, or data quality concerns.

---

## Recommendation 5

Develop dashboards that continuously monitor payment method popularity, revenue contribution, average payment value, and installment usage to support ongoing business decisions.

---

# Challenges Encountered

## Selecting the Correct Denominator

Percentage calculations required careful selection of the denominator.

For example, payment method percentages were calculated using the total number of payment records rather than records from unrelated tables.

---

## Correct Analytical Grain

Because orders may contain multiple payment records, distinguishing between payment-level and order-level analysis was essential.

Using `COUNT(DISTINCT order_id)` prevented duplicate counting where appropriate.

---

## FILTER Clause

Calculating the percentage of credit card payments made using installments greater than one required conditional aggregation with the `FILTER` clause.

This provided a concise and readable solution compared to more complex alternatives.

---

# Analyst Reflection

This investigation reinforced the importance of understanding the business process behind the data before writing SQL.

Although the queries themselves were relatively straightforward, selecting the correct analytical grain and denominator significantly influenced the accuracy of the results.

The analysis also demonstrated how payment behaviour can reveal valuable insights into customer preferences and purchasing decisions, extending beyond simple financial reporting.

---

# Interview Notes

Potential interview discussion topics include:

- Why `payment_value` is the appropriate revenue measure for payment analysis.
- The importance of matching the denominator to the business process when calculating percentages.
- Differences between payment-level and order-level analysis.
- When to use `COUNT(DISTINCT order_id)` after joins.
- Advantages of the `FILTER` clause for conditional aggregation.
- How installment payments influence customer purchasing behaviour.

---

# Skills Demonstrated

This investigation demonstrates proficiency in:

- Payment analytics
- Revenue analysis
- Customer payment behaviour analysis
- Installment analysis
- Aggregate SQL functions
- Conditional aggregation
- PostgreSQL `FILTER` clause
- Business KPI development
- Data quality assessment
- Business interpretation
- Executive reporting

---

# Conclusion

Investigation 21 explored how customers complete their purchases by examining payment methods, transaction values, and installment behaviour. The analysis revealed that **credit cards are both the most frequently used payment method and the largest contributor to total revenue**, highlighting their strategic importance to the business.

The investigation also demonstrated that installment payments play a significant role in customer purchasing behaviour, suggesting that payment flexibility encourages successful transactions and may increase customer spending.

From a technical perspective, this investigation reinforced best practices for payment analytics, including selecting the correct analytical grain, using appropriate denominators for percentage calculations, applying the `FILTER` clause for conditional aggregation, and distinguishing between payment-level and order-level metrics.

Overall, the investigation illustrates how payment data can be transformed into actionable business intelligence, enabling organizations to optimize payment experiences, improve customer satisfaction, and support long-term financial decision-making.