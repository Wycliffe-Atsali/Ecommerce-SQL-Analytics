# Investigation 17: Customer Review & Satisfaction Analysis

---

## Business Objective

The objective of this investigation was to evaluate customer satisfaction across the Olist marketplace using customer review data. The analysis focused on overall review performance, product category satisfaction, and seller performance to identify opportunities for improving customer experience and marketplace quality.

Customer reviews provide one of the most valuable indicators of marketplace performance because they reflect the customer's perception of both product quality and the purchasing experience. Understanding these patterns enables the business to identify strengths, uncover areas requiring improvement, and make data-driven operational decisions.

---

# Business Context

Revenue and sales volume alone do not fully describe marketplace success.

A marketplace may generate high sales while still delivering poor customer experiences.

Customer satisfaction influences:

- Customer retention
- Marketplace reputation
- Repeat purchases
- Seller credibility
- Long-term business growth

This investigation therefore complements previous financial analyses by incorporating customer feedback into marketplace performance evaluation.

---

# Database Thinking

## Tables Used

| Table | Purpose |
|--------|----------|
| order_reviews | Customer review scores |
| orders | Order status |
| order_items | Products contained within each order |
| products | Product categories |
| sellers | Seller information |

---

## Relationship Path

### Overall Review Analysis

```text
order_reviews
      │
      ▼
orders
```

### Product Satisfaction

```text
order_reviews
      │
      ▼
orders
      │
      ▼
order_items
      │
      ▼
products
```

### Seller Satisfaction

```text
order_reviews
      │
      ▼
orders
      │
      ▼
order_items
      │
      ▼
sellers
```

Unlike previous investigations, customer reviews are not directly linked to products or sellers. Reviews exist only at the order level, requiring multiple joins to associate customer feedback with marketplace entities.

---

# Analytical Limitation

This investigation highlights an important limitation of the Olist dataset.

Customer reviews are recorded **per order**, while products are recorded **per order item**.

If an order contains multiple products, the same review score is associated with every product contained in that order.

Therefore:

- Product review scores should be interpreted as approximations.
- Seller review scores should also be interpreted cautiously.
- Individual product quality cannot be measured directly from this dataset.

Recognising and documenting this limitation is essential to producing reliable business analysis.

---

# Methodology

The investigation followed the relational analysis workflow established during Phase 5.

1. Define the business question.
2. Identify the required tables.
3. Determine table relationships.
4. Apply appropriate INNER JOIN operations.
5. Aggregate customer review metrics.
6. Interpret findings from a business perspective.
7. Document analytical limitations.

---

# Business Questions

## Section A – Overall Customer Satisfaction

1. What is the average review score across delivered orders?
2. How many reviews exist for each review score?
3. What percentage of reviews are positive (4–5 stars)?
4. What percentage of reviews are negative (1–2 stars)?
5. Which review score occurs most frequently?

---

## Section B – Product Satisfaction

6. What is the average review score for each product category?
7. Which categories receive the highest customer ratings?
8. Which categories receive the lowest customer ratings?
9. Which categories receive the largest number of reviews?
10. Is there a relationship between sales volume and customer satisfaction?

---

## Section C – Seller Satisfaction

11. What is the average review score received by each seller?
12. Which sellers consistently receive the highest ratings?
13. Which sellers combine strong revenue with excellent customer satisfaction?

---

## Section D – Business Insights

14. Which product categories should be prioritised for quality improvement?

15. What recommendations should be presented to management?

---

# SQL Techniques Used

This investigation utilised:

- INNER JOIN
- Multi-table joins
- COUNT()
- COUNT(DISTINCT)
- AVG()
- SUM()
- ROUND()
- FILTER
- GROUP BY
- ORDER BY
- LIMIT
- WHERE

The introduction of the `FILTER` clause simplified percentage calculations for positive and negative customer reviews.

---

# Key Findings

The analysis produced several important insights regarding customer satisfaction.

### Overall Satisfaction

- Customer review scores are generally positive across the marketplace.
- Positive reviews (4–5 stars) account for the majority of customer feedback.
- Five-star reviews occur most frequently, indicating high overall customer satisfaction.

### Product Categories

- Customer satisfaction varies across product categories.
- Some lower-volume categories achieve excellent review scores.
- Certain categories consistently receive lower ratings and should be investigated further.

### Sales Volume vs Satisfaction

Comparison between sales volume and review scores indicates that:

- High sales volume does not necessarily result in higher customer satisfaction.
- Product popularity should not be interpreted as evidence of product quality.

### Seller Performance

Many high-performing sellers maintain both strong revenue generation and positive customer review scores.

This demonstrates that commercial success and customer satisfaction can coexist when operational performance remains consistently high.

---

# Business Interpretation

Customer satisfaction should be considered alongside operational and financial performance.

Revenue identifies commercial success.

Customer reviews measure customer experience.

Neither metric should be evaluated independently.

Marketplace management should therefore monitor:

- Revenue
- Sales volume
- Customer satisfaction
- Seller performance

simultaneously when evaluating marketplace health.

---

# Recommendations

Based on the analysis, the following recommendations are proposed:

- Investigate low-rated product categories to identify recurring quality issues.
- Maintain quality assurance processes for consistently high-performing categories.
- Prioritise quality improvements within high-volume product categories because they have the greatest commercial impact.
- Encourage sellers with consistently excellent customer feedback by recognising and rewarding high performance.
- Develop executive dashboards that monitor review trends alongside revenue and sales metrics.
- Perform periodic customer satisfaction reviews to identify emerging quality concerns before they affect marketplace performance.

---

# Challenges Encountered

## Order-Level Reviews

Customer reviews are associated with orders rather than individual products.

This required joining multiple normalized tables before meaningful product and seller analysis could be performed.

---

## Data Granularity

The investigation reinforced the importance of understanding table granularity.

Although reviews could be connected to products through `order_items`, this relationship duplicates review scores whenever multiple products appear within the same order.

Recognising this limitation prevented incorrect business conclusions.

---

## Business Interpretation

Not every analytical question results in a positive correlation.

The comparison between sales volume and customer satisfaction demonstrated that popularity alone is not a reliable indicator of customer experience.

Learning to report the absence of a relationship is an important analytical skill.

---

# Analyst Reflection

This investigation represented an important step beyond financial analysis.

Instead of measuring business performance purely through revenue, the analysis incorporated customer perception into marketplace evaluation.

A key lesson from this investigation was that successful data analysis requires understanding both the strengths and limitations of available data.

Rather than ignoring imperfections within the dataset, documenting these limitations improves analytical transparency and increases confidence in the conclusions presented.

This investigation also strengthened my ability to combine operational, financial, and customer-focused metrics into a single business narrative.

---

# Interview Notes

Potential interview discussion points include:

- Why are customer reviews difficult to attribute directly to products?
- What is meant by data granularity?
- Why should analysts document dataset limitations?
- Why was the `FILTER` clause used when calculating review percentages?
- Can high sales volume be used as a proxy for customer satisfaction?
- How would you redesign the database to support product-level reviews?

---

# Skills Demonstrated

## SQL

- INNER JOIN
- Multi-table joins
- Aggregate functions
- Conditional aggregation using FILTER
- GROUP BY
- ORDER BY
- LIMIT
- WHERE

## Data Analysis

- Customer satisfaction analysis
- Product quality evaluation
- Seller performance assessment
- Comparative business analysis
- Trend identification

## Database Concepts

- Relational database analysis
- Data granularity
- Primary and foreign key relationships
- One-to-many relationships
- Analytical limitations
- Business metric validation

---

# Conclusion

This investigation successfully evaluated customer satisfaction across the Olist marketplace by integrating review data with products and sellers through relational database joins.

The analysis demonstrated that customer satisfaction provides valuable business insight beyond revenue and sales volume alone. It also highlighted the importance of understanding data granularity, documenting dataset limitations, and validating analytical assumptions before drawing conclusions.

By combining customer feedback with operational and financial metrics, this investigation provides a more complete understanding of marketplace performance and establishes a strong foundation for future analyses involving delivery performance and customer retention.