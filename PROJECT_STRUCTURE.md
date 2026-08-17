# Project Structure

This document provides a concise file-level guide to the **Retail SQL
Business Analysis** repository.

The README remains the primary project overview. This document exists
only to make the repository easy to navigate.

## Repository Structure

``` text
Ecommerce-SQL-Analytics/
│
├── additional_phase/
│   ├── audit.md
│   └── technology.md
├── data/
│   ├── olist_customers_dataset.csv
│   ├── olist_geolocation_dataset.csv
│   ├── olist_orders_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_products_dataset.csv
│   ├── olist_sellers_dataset.csv
│   └── product_category_name_translation.csv
├── database/
│   ├── create_tables.sql
│   ├── database_profile.md
│   ├── schema.dbml
│   ├── schema.png
│   ├── schema.reviews.md
│   └── schema_notes.md
├── images/
├── presentation/
├── report/
│   ├── data_quality_report.md
│   ├── implementation_notes.md
│   ├── import_validation.sql
│   ├── investigation_01_orders.md
│   ├── investigation_02_customers.md
│   ├── investigation_03_products.md
│   ├── investigation_04_sellers.md
│   ├── investigation_05_payments.md
│   ├── investigation_06_reviews.md
│   ├── investigation_07_geolocation.md
│   ├── investigation_08_sales_performance.md
│   ├── investigation_09_customer_insights.md
│   ├── investigation_10_product_performance.md
│   ├── investigation_11_seller_performance.md
│   ├── investigation_12_payment_behaviour_analysis.md
│   ├── investigation_13_review_analysis.md
│   ├── investigation_14_customer_purchase_behaviour.md
│   ├── investigation_15_product_sales_performance.md
│   ├── investigation_16_seller_performance_analysis.md
│   ├── investigation_17_customer_review_analysis.md
│   ├── investigation_18_delivery_performance_analysis.md
│   ├── investigation_19_customer_geographic_analysis.md
│   ├── investigation_20_sales_trend_time_series_analysis.md
│   ├── investigation_21_payment_method_&_customer_payment_behaviour_analysis.md
│   ├── investigation_22_customer_retention_&_repeat_purchase_analysis.md
│   ├── investigation_23_subqueries_business_analysis.md
│   ├── investigation_24_common_table_expressions_business_analysis.md
│   ├── investigation_25_sql_views_business_reporting.md
│   ├── investigation_26_multi_cte_business_analysis.md
│   ├── investigation_27_sql_integration_business_analysis.md
│   ├── investigation_28_window_functions_row_number_report.md
│   ├── investigation_29_rank_and_dense_rank_report.md
│   ├── investigation_30_ntile_customer_and_business_segmentation_report.md
│   ├── investigation_31_lag_business_trend_analysis_report.md
│   ├── investigation_32_lead_business_forecasting_analysis_report.md
│   ├── investigation_33_window_aggregation_business_analysis_report.md
│   ├── investigation_34_customer_lifetime_value.md
│   ├── investigation_35_rfm_customer_segmentation.md
│   ├── investigation_36_seller_performance_scorecard.md
│   ├── investigation_37_product_portfolio_analysis.md
│   ├── investigation_38_delivery_performance_&_operational_efficiency_analysis.md
│   ├── investigation_39_revenue_opportunity_analysis.md
│   ├── investigation_40_revenue_opportunity_scorecard.md
│   ├── investigation_41_executive_KPI_dashboard_dataset.md
│   ├── investigation_42_final_executive_business_review.md
│   ├── investigation_43_executive_business_insights.md
│   ├── investigation_44_business_recommendations.md
│   ├── investigation_45_project_reflection_and_analytical_insights.md
│   ├── investigation_46_sql_optimisation_performance.md
│   ├── investigation_47_technical_interview_preparation.md
│   └── investigation_48_project_retrospective.md
├── results/
│   └── executive_business_review_results.csv
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_sales_analysis.sql
│   ├── 03_customer_analysis.sql
│   ├── 04_product_analysis.sql
│   ├── 05_seller_analysis.sql
│   ├── 06_payment_behaviour_analysis.sql
│   ├── 07_customer_review_analysis.sql
│   ├── 08_customer_purchasing_behaviour.sql
│   ├── 09_product_sales_performance.sql
│   ├── 10_seller_performance_analysis.sql
│   ├── 11_customer_review_analysis.sql
│   ├── 12_delivery_performance_analysis.sql
│   ├── 13_customer_geographic_analysis.sql
│   ├── 14_sales_trend_time_series_analysis.sql
│   ├── 15_payment_method_customer_payment_behaviour.sql
│   ├── 16_customer_retention_repeat_purchase_analysis.sql
│   ├── 17_subqueries_business_analysis.sql
│   ├── 18_common_table_expressions_business_analysis.sql
│   ├── 19_multi_cte_business_analysis.sql
│   ├── 20_sql_views_business_reporting.sql
│   ├── 21_sql_integration_business_analysis.sql
│   ├── 22_window_functions_row_number.sql
│   ├── 23_rank_and_dense_rank.sql
│   ├── 24_ntile_customer_and_business_segmentation.sql
│   ├── 25_lag_business_trend_analysis.sql
│   ├── 26_lead_business_forecasting_analysis.sql
│   ├── 27_window_aggregation_business_analysis.sql
│   ├── 28_customer_lifetime_value_analysis.sql
│   ├── 29_rfm_customer_segmentation.sql
│   ├── 30_seller_performance_scorecard.sql
│   ├── 31_product_portfolio_analysis.sql
│   ├── 32_delivery_performance_operational_analysis.sql
│   ├── 33_revenue_opportunity_analysis.sql
│   ├── 34_revenue_opportunity_scorecard.sql
│   ├── 35_executive_business_review.sql
│   ├── 36_final_executive_business_review.sql
│   ├── 37_executive_business_insights.sql
│   └── 38_sql_optimisation_performance.sql
├── .gitignore
├── CHANGELOG.md
├── PROJECT_STRUCTURE.md
└── README.md
```

## Directory Guide

  -----------------------------------------------------------------------
  Directory                           Purpose
  ----------------------------------- -----------------------------------
  `additional_phase/`                 Final portfolio refinement
                                      documentation

  `data/`                             Nine Olist source CSV files

  `database/`                         PostgreSQL creation, schema, and
                                      database documentation

  `images/`                           Project visual assets

  `presentation/`                     Presentation-related material

  `report/`                           48 investigation reports and
                                      supporting analytical documentation

  `results/`                          Selected analytical outputs

  `sql/`                              38 analytical SQL scripts
  -----------------------------------------------------------------------

## Core Project Files

  File                     Purpose
  ------------------------ -------------------------------
  `README.md`              Primary project overview
  `CHANGELOG.md`           Chronological project history
  `PROJECT_STRUCTURE.md`   Repository navigation guide
  `.gitignore`             Git exclusion rules

## Investigation and SQL Relationship

The project contains:

> **48 investigation reports + 38 SQL analysis files + 10 completed
> phases**

  Phase        Investigations       SQL Coverage
  ---------- ---------------- ------------------
  Phase 3                1--7         SQL File 1
  Phase 4               8--13     SQL Files 2--7
  Phase 5              14--22    SQL Files 8--16
  Phase 6              23--27   SQL Files 17--21
  Phase 7              28--33   SQL Files 22--27
  Phase 8              34--42   SQL Files 28--36
  Phase 9              43--45        SQL File 37
  Phase 10             46--48        SQL File 38

The relationship is intentionally not one-to-one. Investigations 47 and
48 are primarily technical preparation and retrospective documentation
and therefore do not require separate SQL scripts.

## Additional Phase

``` text
additional_phase/
├── audit.md
└── technology.md
```

These are portfolio refinement documents and do not change the final
project scope.

## Final Project Scope

``` text
10 Completed Phases
        ↓
48 Investigations
        ↓
38 SQL Files
        ↓
48 Investigation Reports
        ↓
Business Findings & Recommendations
        ↓
Completed SQL Business Analysis Portfolio
```

The README remains the primary document for understanding the project
itself.
