/*====================================================================
Retail SQL Business Analysis Portfolio

File: 11_customer_review_analysis.sql

Phase 5 – Relational Analysis (JOINs)

Investigation 17: Customer Review & Satisfaction Analysis

Business Objective
------------------
Evaluate customer satisfaction across the marketplace by
analysing review scores for completed orders, product
categories, and sellers.

The investigation aims to identify high-performing and
low-performing product categories, evaluate seller quality,
and provide business recommendations for improving customer
experience.

Tables Used
-----------
- order_reviews
- orders
- order_items
- products
- sellers

Relationship Paths
------------------

Overall Reviews

order_reviews
      │
      ▼
orders


Product Satisfaction

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


Seller Satisfaction

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

Important Note
--------------
Reviews are recorded at the ORDER level rather than the
PRODUCT level.

When an order contains multiple products, the same review
score is associated with every product in that order.

Consequently, product-level and seller-level review analysis
should be interpreted as an approximation rather than a
direct measurement of individual product quality.

====================================================================*/



/*===============================================================
SECTION A – OVERALL CUSTOMER SATISFACTION
===============================================================*/


/*-----------------------------------------------------------------
Q1. What is the average review score across all delivered orders?
-----------------------------------------------------------------*/

SELECT
    ROUND(AVG(r.review_score),2) AS average_review_score
FROM order_reviews AS r
INNER JOIN orders AS o
    ON r.order_id = o.order_id
WHERE o.order_status = 'delivered';



/*-----------------------------------------------------------------
Q2. How many reviews were submitted for each review score?
-----------------------------------------------------------------*/

SELECT
    r.review_score,
    COUNT(*) AS total_reviews
FROM order_reviews AS r
GROUP BY r.review_score
ORDER BY r.review_score;



/*-----------------------------------------------------------------
Q3. What percentage of reviews are positive (4–5 stars)?
-----------------------------------------------------------------*/

SELECT
    ROUND(
        COUNT(*) FILTER (WHERE review_score IN (4,5))
        * 100.0 /
        COUNT(*),
        2
    ) AS positive_review_percentage
FROM order_reviews;



/*-----------------------------------------------------------------
Q4. What percentage of reviews are negative (1–2 stars)?
-----------------------------------------------------------------*/

SELECT
    ROUND(
        COUNT(*) FILTER (WHERE review_score IN (1,2))
        * 100.0 /
        COUNT(*),
        2
    ) AS negative_review_percentage
FROM order_reviews;



/*-----------------------------------------------------------------
Q5. Which review score occurs most frequently?
-----------------------------------------------------------------*/

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY total_reviews DESC
LIMIT 1;





/*===============================================================
SECTION B – PRODUCT SATISFACTION
===============================================================*/


/*-----------------------------------------------------------------
Q6. Average review score for each product category
-----------------------------------------------------------------*/

SELECT
    p.product_category_name AS category,
    ROUND(AVG(r.review_score),2) AS average_review_score
FROM order_reviews AS r
INNER JOIN order_items AS oi
    ON r.order_id = oi.order_id
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY average_review_score DESC;



/*-----------------------------------------------------------------
Q7. Top 10 highest-rated product categories
-----------------------------------------------------------------*/

SELECT
    p.product_category_name AS category,
    ROUND(AVG(r.review_score),2) AS average_review_score
FROM order_reviews AS r
INNER JOIN order_items AS oi
    ON r.order_id = oi.order_id
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY average_review_score DESC
LIMIT 10;



/*-----------------------------------------------------------------
Q8. Bottom 10 product categories by average review score
-----------------------------------------------------------------*/

SELECT
    p.product_category_name AS category,
    ROUND(AVG(r.review_score),2) AS average_review_score
FROM order_reviews AS r
INNER JOIN order_items AS oi
    ON r.order_id = oi.order_id
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY average_review_score ASC
LIMIT 10;



/*-----------------------------------------------------------------
Q9. Which product categories receive the largest number of reviews?
-----------------------------------------------------------------*/

SELECT
    p.product_category_name AS category,
    COUNT(*) AS total_reviews
FROM order_reviews AS r
INNER JOIN order_items AS oi
    ON r.order_id = oi.order_id
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_reviews DESC
LIMIT 10;



/*-----------------------------------------------------------------
Q10. Compare product popularity with customer satisfaction.

Observation:

High sales volume does not necessarily correspond with
higher customer satisfaction.

Several high-volume categories achieve average review scores,
while some lower-volume categories receive excellent ratings.

Sales volume alone should therefore not be used as a proxy
for customer satisfaction.

-----------------------------------------------------------------*/





/*===============================================================
SECTION C – SELLER SATISFACTION
===============================================================*/


/*-----------------------------------------------------------------
Q11. Average review score received by each seller
-----------------------------------------------------------------*/

SELECT
    s.seller_id AS seller,
    ROUND(AVG(r.review_score),2) AS average_review_score
FROM order_reviews AS r
INNER JOIN order_items AS oi
    ON r.order_id = oi.order_id
INNER JOIN sellers AS s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY average_review_score DESC;



/*-----------------------------------------------------------------
Q12. Top 10 sellers with the highest average review score
-----------------------------------------------------------------*/

SELECT
    s.seller_id AS seller,
    ROUND(AVG(r.review_score),2) AS average_review_score
FROM order_reviews AS r
INNER JOIN order_items AS oi
    ON r.order_id = oi.order_id
INNER JOIN sellers AS s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY average_review_score DESC
LIMIT 10;



/*-----------------------------------------------------------------
Q13. Sellers combining high revenue and excellent reviews
-----------------------------------------------------------------*/

SELECT
    s.seller_id AS seller,
    ROUND(SUM(oi.price),2) AS total_revenue,
    ROUND(AVG(r.review_score),2) AS average_review_score
FROM order_reviews AS r
INNER JOIN order_items AS oi
    ON r.order_id = oi.order_id
INNER JOIN sellers AS s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY
    average_review_score DESC,
    total_revenue DESC;





/*===============================================================
SECTION D – BUSINESS INSIGHTS
===============================================================*/


/*-----------------------------------------------------------------
Q14. Quality Improvement Priorities

The following categories recorded the lowest customer
satisfaction and should be prioritised for further quality
investigation:

- seguros_e_servicos
- fraldas_higiene
- portateis_cozinha_e_preparadores_de_alimentos

In addition, high-volume product categories should receive
continuous quality monitoring because improvements in these
categories have the greatest potential business impact.

-----------------------------------------------------------------*/



/*-----------------------------------------------------------------
Q15. Business Recommendations

• Investigate low-performing product categories to identify
  recurring quality issues.

• Maintain quality standards for categories already achieving
  consistently high customer satisfaction.

• Focus improvement initiatives on high-volume categories to
  maximise business impact.

• Develop dashboards to monitor customer satisfaction trends
  across products, sellers, and categories.

• Combine review analysis with delivery performance metrics to
  determine whether poor ratings originate from product quality
  or fulfilment issues.

• Regularly review customer feedback to support continuous
  marketplace improvement and strengthen customer retention.

-----------------------------------------------------------------*/