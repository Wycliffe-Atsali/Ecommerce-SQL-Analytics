/*==============================================================================
 Investigation 36
 Seller Performance Scorecard
 Phase 8 – Strategic Business Analytics

 Repository:
 Retail-SQL-Business-Analysis

 Dataset:
 Brazilian E-Commerce Public Dataset (Olist)

 Database:
 PostgreSQL

 Author:
 Atsali Akolo

 ------------------------------------------------------------------------------
 BUSINESS CONTEXT
 ------------------------------------------------------------------------------

 Seller performance cannot be evaluated using revenue alone. High-performing
 sellers should consistently generate revenue while maintaining customer
 satisfaction, fulfilling orders efficiently, delivering on time, and offering
 a diverse product portfolio.

 This investigation develops a weighted Seller Performance Scorecard by
 combining multiple business KPIs into a single Seller Performance Index.
 The resulting scorecard can support seller benchmarking, performance
 monitoring, strategic partnerships, and executive decision-making.

 ------------------------------------------------------------------------------
 BUSINESS OBJECTIVES
 ------------------------------------------------------------------------------

 • Calculate seller revenue.
 • Measure operational performance.
 • Evaluate customer satisfaction.
 • Assess delivery reliability.
 • Measure seller product diversity.
 • Standardise KPIs onto a common scoring scale.
 • Develop a weighted Seller Performance Index.
 • Classify sellers into performance categories.

 ------------------------------------------------------------------------------
 KPI FRAMEWORK
 ------------------------------------------------------------------------------

 KPI                         Weight

 Revenue                     35%
 Orders Fulfilled            25%
 Review Score                20%
 On-Time Delivery            15%
 Product Diversity            5%

 Total Weight               100%

 ------------------------------------------------------------------------------
 KPI STANDARDISATION APPROACH
 ------------------------------------------------------------------------------

 Different KPIs are measured using different units.

 Revenue              -> Currency
 Orders               -> Count
 Reviews              -> Rating (1–5)
 Delivery             -> Percentage
 Products             -> Count

 To enable comparison, each KPI is converted onto a common 0–100 scale.

 Standardisation Method

 • Revenue
     NTILE(100)

 • Orders Fulfilled
     NTILE(100)

 • Review Score
     (Average Review / 5) × 100

 • On-Time Delivery
     Already expressed as a percentage

 • Product Diversity
     NTILE(100)

==============================================================================*/


/*==============================================================================
 SECTION 1 – SELLER REVENUE
==============================================================================*/

WITH seller_revenue AS
(
    SELECT

        oi.seller_id AS seller,

        ROUND(
            SUM(op.payment_value),
            2
        ) AS total_revenue

    FROM order_items AS oi

    JOIN order_payments AS op
        ON oi.order_id = op.order_id

    GROUP BY
        oi.seller_id
),


/*==============================================================================
 SECTION 2 – ORDERS FULFILLED
==============================================================================*/

seller_orders AS
(
    SELECT

        oi.seller_id AS seller,

        COUNT(DISTINCT o.order_id)
            AS orders_fulfilled

    FROM order_items AS oi

    JOIN orders AS o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY
        oi.seller_id
),


/*==============================================================================
 SECTION 3 – CUSTOMER REVIEW PERFORMANCE
==============================================================================*/

seller_reviews AS
(
    SELECT

        oi.seller_id AS seller,

        ROUND(
            AVG(orv.review_score),
            2
        ) AS average_review_score

    FROM order_items AS oi

    JOIN orders AS o
        ON oi.order_id = o.order_id

    JOIN order_reviews AS orv
        ON oi.order_id = orv.order_id

    WHERE
        o.order_status = 'delivered'

    GROUP BY
        oi.seller_id
),


/*==============================================================================
 SECTION 4 – DELIVERY PERFORMANCE
==============================================================================*/

seller_delivery AS
(
    SELECT

        oi.seller_id AS seller,

        COUNT(DISTINCT o.order_id)
            AS delivered_orders,

        COUNT(

            DISTINCT CASE

                WHEN
                    o.order_delivered_customer_date
                    <=
                    o.order_estimated_delivery_date

                THEN o.order_id

            END

        ) AS orders_on_time,

        ROUND(

            COUNT(

                DISTINCT CASE

                    WHEN
                        o.order_delivered_customer_date
                        <=
                        o.order_estimated_delivery_date

                    THEN o.order_id

                END

            ) * 100.0

            /

            COUNT(DISTINCT o.order_id),

            2

        ) AS on_time_delivery_rate

    FROM order_items AS oi

    JOIN orders AS o
        ON oi.order_id = o.order_id

    WHERE
        o.order_status = 'delivered'

    GROUP BY
        oi.seller_id
),


/*==============================================================================
 SECTION 5 – PRODUCT DIVERSITY
==============================================================================*/

seller_products AS
(
    SELECT

        seller_id AS seller,

        COUNT(DISTINCT product_id)
            AS product_diversity

    FROM order_items

    GROUP BY
        seller_id
),


/*==============================================================================
 SECTION 6 – CONSOLIDATED SELLER KPI DATASET

 This CTE combines every KPI into a single analytical dataset.
 Subsequent score calculations will reference this dataset only,
 improving readability and maintainability.
==============================================================================*/

seller_summary AS
(
    SELECT

        sr.seller,

        sr.total_revenue,

        so.orders_fulfilled,

        rv.average_review_score,

        sd.delivered_orders,

        sd.orders_on_time,

        sd.on_time_delivery_rate,

        sp.product_diversity

    FROM seller_revenue AS sr

    INNER JOIN seller_orders AS so
        ON sr.seller = so.seller

    INNER JOIN seller_reviews AS rv
        ON sr.seller = rv.seller

    INNER JOIN seller_delivery AS sd
        ON sr.seller = sd.seller

    INNER JOIN seller_products AS sp
        ON sr.seller = sp.seller
)

/*==============================================================================
 END OF PART 1

 Part 2:
 • KPI Standardisation
 • Weighted Seller Performance Score
 • Seller Performance Classification
 • Executive Dashboard
==============================================================================*/

/*==============================================================================
 SECTION 7 – KPI STANDARDISATION

 Business Problem

 Each KPI is measured using a different unit.

 Revenue               -> Currency
 Orders                -> Count
 Review Score          -> Rating (1–5)
 Delivery Performance  -> Percentage
 Product Diversity     -> Count

 Before combining them into a single score, every KPI is converted onto a
 common 0–100 scale.

 Standardisation Methods

 • Revenue               -> NTILE(100)
 • Orders Fulfilled      -> NTILE(100)
 • Review Score          -> (Review Score / 5) × 100
 • Delivery Performance  -> Already expressed as %
 • Product Diversity     -> NTILE(100)

==============================================================================*/

,
seller_scores AS
(
    SELECT

        seller,

        total_revenue,

        orders_fulfilled,

        average_review_score,

        delivered_orders,

        orders_on_time,

        on_time_delivery_rate,

        product_diversity,

        /*--------------------------------------------
          Revenue Score
        --------------------------------------------*/

        NTILE(100)
        OVER (
            ORDER BY total_revenue
        ) AS revenue_score,

        /*--------------------------------------------
          Order Fulfilment Score
        --------------------------------------------*/

        NTILE(100)
        OVER (
            ORDER BY orders_fulfilled
        ) AS orders_score,

        /*--------------------------------------------
          Customer Review Score
        --------------------------------------------*/

        ROUND(
            (average_review_score / 5.0) * 100,
            2
        ) AS review_score,

        /*--------------------------------------------
          Delivery Performance Score
        --------------------------------------------*/

        on_time_delivery_rate
            AS delivery_score,

        /*--------------------------------------------
          Product Diversity Score
        --------------------------------------------*/

        NTILE(100)
        OVER (
            ORDER BY product_diversity
        ) AS product_score

    FROM seller_summary
),

/*==============================================================================
 SECTION 8 – WEIGHTED SELLER PERFORMANCE INDEX

 Business Rule

 Revenue                35%
 Orders                 25%
 Reviews                20%
 Delivery               15%
 Product Diversity       5%

 Total                 100%

==============================================================================*/

weighted_scores AS
(
    SELECT

        seller,

        total_revenue,

        orders_fulfilled,

        average_review_score,

        on_time_delivery_rate,

        product_diversity,

        revenue_score,

        orders_score,

        review_score,

        delivery_score,

        product_score,

        /* Individual weighted contributions */

        ROUND(revenue_score * 0.35,2)
            AS weighted_revenue,

        ROUND(orders_score * 0.25,2)
            AS weighted_orders,

        ROUND(review_score * 0.20,2)
            AS weighted_reviews,

        ROUND(delivery_score * 0.15,2)
            AS weighted_delivery,

        ROUND(product_score * 0.05,2)
            AS weighted_products,

        /* Final Seller Performance Score */

        ROUND(

              (revenue_score * 0.35)

            + (orders_score * 0.25)

            + (review_score * 0.20)

            + (delivery_score * 0.15)

            + (product_score * 0.05)

        ,2)

        AS seller_performance_score

    FROM seller_scores
),

/*==============================================================================
 SECTION 9 – SELLER CLASSIFICATION

 Business Classification

 Elite Seller           ≥ 90

 High Performer         ≥ 75

 Strong Performer       ≥ 60

 Average Performer      ≥ 45

 Needs Improvement      < 45

==============================================================================*/

seller_performance AS
(
    SELECT

        *,

        CASE

            WHEN seller_performance_score >= 90
                THEN 'Elite Seller'

            WHEN seller_performance_score >= 75
                THEN 'High Performer'

            WHEN seller_performance_score >= 60
                THEN 'Strong Performer'

            WHEN seller_performance_score >= 45
                THEN 'Average Performer'

            ELSE 'Needs Improvement'

        END AS seller_category

    FROM weighted_scores
)

/*==============================================================================
 SECTION 10 – EXECUTIVE SELLER SCORECARD

 This dataset can be connected directly to a BI dashboard.

==============================================================================*/

SELECT

    seller,

    total_revenue,

    orders_fulfilled,

    average_review_score,

    on_time_delivery_rate,

    product_diversity,

    revenue_score,

    orders_score,

    review_score,

    delivery_score,

    product_score,

    weighted_revenue,

    weighted_orders,

    weighted_reviews,

    weighted_delivery,

    weighted_products,

    seller_performance_score,

    seller_category

FROM seller_performance

ORDER BY seller_performance_score DESC;

/*==============================================================================
 END OF PART 2

 Part 3

 • Top 20 Sellers
 • Seller Category Summary
 • Executive KPI Analysis
 • Strategic Business Queries
 • Investigation Summary

==============================================================================*/

/*==============================================================================
 SECTION 11 – TOP 20 SELLERS

 Business Purpose

 Identify the marketplace's highest-performing sellers based on the
 weighted Seller Performance Score.

 This output can support:

 • Preferred seller programmes
 • Strategic partnerships
 • Marketplace promotions
 • Seller recognition initiatives

==============================================================================*/

SELECT

    seller,

    seller_performance_score,

    seller_category,

    total_revenue,

    orders_fulfilled,

    average_review_score,

    on_time_delivery_rate,

    product_diversity

FROM seller_performance

ORDER BY seller_performance_score DESC

LIMIT 20;



/*==============================================================================
 SECTION 12 – SELLER PERFORMANCE CATEGORY SUMMARY

 Business Purpose

 Understand the characteristics of each seller performance category.

 Management can quickly identify:

 • Number of sellers
 • Average revenue
 • Average operational performance
 • Customer satisfaction
 • Product diversity

==============================================================================*/

SELECT

    seller_category,

    COUNT(*) AS total_sellers,

    ROUND(AVG(total_revenue),2)
        AS average_revenue,

    ROUND(AVG(orders_fulfilled),2)
        AS average_orders,

    ROUND(AVG(average_review_score),2)
        AS average_review_score,

    ROUND(AVG(on_time_delivery_rate),2)
        AS average_on_time_delivery,

    ROUND(AVG(product_diversity),2)
        AS average_product_diversity,

    ROUND(AVG(seller_performance_score),2)
        AS average_performance_score

FROM seller_performance

GROUP BY seller_category

ORDER BY average_performance_score DESC;



/*==============================================================================
 SECTION 13 – EXECUTIVE KPI SUMMARY

 Business Purpose

 Provide a high-level overview of seller performance across the marketplace.

==============================================================================*/

SELECT

    COUNT(*) AS total_sellers,

    ROUND(AVG(seller_performance_score),2)
        AS average_marketplace_score,

    ROUND(MAX(seller_performance_score),2)
        AS highest_score,

    ROUND(MIN(seller_performance_score),2)
        AS lowest_score,

    ROUND(AVG(total_revenue),2)
        AS average_seller_revenue,

    ROUND(AVG(orders_fulfilled),2)
        AS average_orders_completed,

    ROUND(AVG(average_review_score),2)
        AS average_review_score,

    ROUND(AVG(on_time_delivery_rate),2)
        AS average_delivery_performance

FROM seller_performance;



/*==============================================================================
 SECTION 14 – PERFORMANCE DISTRIBUTION

 Business Purpose

 Evaluate how sellers are distributed across performance categories.

==============================================================================*/

SELECT

    seller_category,

    COUNT(*) AS sellers,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS marketplace_percentage

FROM seller_performance

GROUP BY seller_category

ORDER BY marketplace_percentage DESC;



/*==============================================================================
 SECTION 15 – IMPROVEMENT OPPORTUNITIES

 Business Purpose

 Identify sellers who generate substantial revenue but perform poorly
 overall.

 These sellers may require operational support, customer service
 improvements, or logistics interventions.

==============================================================================*/

SELECT

    seller,

    seller_performance_score,

    seller_category,

    total_revenue,

    average_review_score,

    on_time_delivery_rate

FROM seller_performance

WHERE

    seller_category = 'Needs Improvement'

ORDER BY total_revenue DESC;



/*==============================================================================
 SECTION 16 – CONSISTENT HIGH PERFORMERS

 Business Purpose

 Identify sellers that combine strong financial performance with
 excellent operational execution.

 Business Use Cases

 • Preferred Marketplace Sellers
 • Strategic Partnerships
 • Premium Seller Programmes
 • Marketing Campaigns

==============================================================================*/

SELECT

    seller,

    seller_performance_score,

    total_revenue,

    orders_fulfilled,

    average_review_score,

    on_time_delivery_rate,

    product_diversity

FROM seller_performance

WHERE seller_category = 'Elite Seller'

ORDER BY seller_performance_score DESC;



/*==============================================================================
 SECTION 17 – INVESTIGATION CONCLUSION

 Key Deliverables

 ✓ Seller KPI Dataset

 ✓ KPI Standardisation

 ✓ Weighted Seller Performance Index

 ✓ Seller Performance Classification

 ✓ Executive Dashboard Dataset

 ✓ Seller Ranking

 ✓ Category-Level Business Summary

 ✓ Marketplace KPI Summary

 ✓ Improvement Opportunity Identification

==============================================================================*/


/*==============================================================================
 END OF INVESTIGATION 36

 Investigation Completed

 Phase 8 – Strategic Business Analytics

==============================================================================*/