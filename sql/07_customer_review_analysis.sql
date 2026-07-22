/*======================================================================================================================
INVESTIGATION 13 — CUSTOMER REVIEW ANALYSIS

Business Objective
------------------
Analyse customer review behaviour by examining review scores, review activity,
and review completeness to better understand customer satisfaction.

Skills Practiced
----------------
• COUNT()
• AVG()
• MIN()
• MAX()
• ROUND()
• GROUP BY
• HAVING
• CASE
• Conditional aggregation

======================================================================================================================*/

-- Q1. Review score distribution

SELECT
    review_score,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_score
ORDER BY review_count DESC;


-- Q2. Review scores with more than 10,000 reviews

SELECT
    review_score,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_score
HAVING COUNT(*) > 10000
ORDER BY review_count DESC;


-- Q3. Review timeline

SELECT
    MIN(review_answer_timestamp) AS earliest_review,
    MAX(review_answer_timestamp) AS latest_review
FROM order_reviews;


-- Q4. Review completeness report

SELECT
    COUNT(*) AS total_reviews,

    SUM(
        CASE
            WHEN review_comment_title IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS reviews_with_titles,

    SUM(
        CASE
            WHEN review_comment_title IS NULL THEN 1
            ELSE 0
        END
    ) AS reviews_without_titles,

    SUM(
        CASE
            WHEN review_comment_message IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS reviews_with_messages,

    SUM(
        CASE
            WHEN review_comment_message IS NULL THEN 1
            ELSE 0
        END
    ) AS reviews_without_messages

FROM order_reviews;


-- Q5. Average review score

SELECT
    ROUND(AVG(review_score),2) AS average_review_score
FROM order_reviews;


-- Q6. Satisfaction classification

SELECT
    review_score,
    COUNT(*) AS review_count,

    CASE
        WHEN review_score IN (4,5)
            THEN 'High Satisfaction'

        WHEN review_score = 3
            THEN 'Moderate Satisfaction'

        ELSE 'Low Satisfaction'
    END AS satisfaction_level

FROM order_reviews
GROUP BY review_score
ORDER BY review_score;


-- Q7. Reviews with no title and no message

SELECT
    COUNT(*) AS reviews_without_written_feedback
FROM order_reviews
WHERE review_comment_title IS NULL
AND review_comment_message IS NULL;


-- Q8 & Q9. Customer experience dashboard

SELECT
    review_score,
    COUNT(*) AS review_count,
    MIN(review_answer_timestamp) AS earliest_review,
    MAX(review_answer_timestamp) AS latest_review
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;


/*======================================================================================================================

KEY FINDINGS
------------------------------------------------------------------------------------------------------------------------
• The average customer review score is approximately 4.09, indicating generally
  positive customer satisfaction.
• Five-star reviews are the most common rating.
• Review activity spans approximately two years.
• Many reviews contain only a numeric score without written feedback,
  suggesting that customers frequently choose quick evaluations.
• CASE expressions enable qualitative classification directly within SQL.

------------------------------------------------------------------------------------------------------------------------
ANALYST REFLECTION
------------------------------------------------------------------------------------------------------------------------
This investigation introduced CASE expressions and conditional aggregation,
allowing quantitative metrics to be combined with business-oriented
classifications. It demonstrated how SQL can transform raw review data into
customer experience reports suitable for operational decision-making.

======================================================================================================================*/