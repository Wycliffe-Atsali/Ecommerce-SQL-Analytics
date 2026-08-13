# Changelog

All notable changes to this project will be documented in this file.

---

## [0.8.0] - 2026-08-13

### Added

- Completed **Phase 9 – Executive Reporting & Business Recommendations**.
- Added Investigation 43 – Executive Summary.
- Added Investigation 44 – Project Reflection & Analytical Insights.
- Added Investigation 45 – Business Recommendations.
- Added **SQL File 37**, supporting the Phase 9 analytical workflow.
- Added professionally documented Markdown reports for all Phase 9 investigations.
- Added executive-level synthesis of findings developed throughout Phases 3–8.
- Added consolidated project reflection covering analytical progression, major insights, methodological strengths and limitations.
- Added evidence-based business recommendations translating validated analytical findings into management actions.
- Added the **Retain → Improve → Expand** strategic recommendation framework.
- Added customer re-engagement and retention recommendations based on observed repeat-purchase behaviour.
- Added delivery-performance improvement recommendations focused on the long delivery tail.
- Added targeted seller-performance intervention recommendations.
- Added recommendations for protecting and developing strong-performing sellers.
- Added opportunity-validation recommendations for sellers, categories and geographic regions.
- Added recommendation prioritisation based on business evidence, expected impact and analytical confidence.
- Added explicit measurement principles for evaluating future interventions using baselines, controlled tests or pilots where feasible.

### Changed

- Updated `README.md` to reflect completion of Phase 9.
- Updated the total project investigation count from **42 to 45 completed investigations**.
- Added Investigations 43–45 to the project progress table.
- Updated the project from **8 to 9 completed analytical phases**.
- Updated the project roadmap so Phase 9 is marked as completed.
- Updated the next project stage to Phase 10 – Portfolio Refinement & Interview Preparation.
- Added the Phase 9 analytical methodology and outcomes to the project documentation.
- Expanded the README to document the relationship between investigations and SQL files.
- Clarified that SQL files and investigations are **not one-to-one**.
- Documented that Investigations 1–7 share SQL File 1.
- Documented that Phase 9 Investigations 43–45 share SQL File 37.
- Updated the README to reflect the complete project structure of **45 investigations supported by 37 SQL files across 9 phases**.
- Expanded the project narrative from analytical development toward executive communication and business decision support.
- Added executive reporting and business recommendation capabilities to the demonstrated analytical skill set.

### Analytical Improvements

- Consolidated findings from multiple investigations into executive-level business themes.
- Connected customer behaviour, seller performance, delivery performance, customer satisfaction and revenue opportunity into a unified business narrative.
- Distinguished historical evidence from forward-looking assumptions when developing recommendations.
- Explicitly separated observational findings from causal claims.
- Introduced controlled experimentation and baseline comparison as recommended methods for validating future interventions.
- Strengthened prioritisation of recommendations according to evidence, business impact and implementation considerations.
- Applied a structured **Retain → Improve → Expand** framework to translate analytical findings into strategic priorities.
- Incorporated operational readiness and incremental economics into opportunity-validation recommendations.
- Strengthened the distinction between opportunity scores and revenue forecasts.
- Added explicit consideration of analytical limitations when translating historical patterns into management actions.

### Documentation

- Added comprehensive Phase 9 investigation reports.
- Added executive summary documentation consolidating the project's major findings.
- Added project reflection documenting the progression from foundational SQL to strategic business analytics.
- Added business recommendation documentation covering immediate, medium-term and long-term actions.
- Added recommendation prioritisation and success metrics.
- Added explicit limitations and measurement principles to the final recommendation framework.
- Updated repository documentation to reflect the completion of the project's analytical and executive-reporting phases.

### Project Structure

The completed project now follows the following investigation-to-SQL structure:

| Phase | Investigations | SQL Files |
|---|---:|---:|
| Phase 3 | 1–7 | SQL File 1 |
| Phase 4 | 8–13 | SQL Files 2–7 |
| Phase 5 | 14–22 | SQL Files 8–16 |
| Phase 6 | 23–27 | SQL Files 17–21 |
| Phase 7 | 28–33 | SQL Files 22–27 |
| Phase 8 | 34–42 | SQL Files 28–36 |
| Phase 9 | 43–45 | SQL File 37 |
| **Total** | **45 investigations** | **37 SQL files** |

The SQL architecture intentionally does not require a one-to-one relationship between investigations and SQL files. Where multiple investigations form part of a shared analytical workflow, they may use the same SQL file.

### Project Status

Phase 9 is officially **complete**.

The project now contains:

- **45 completed business investigations**
- **37 SQL analysis files**
- **9 completed analytical phases**
- Database design and implementation
- Data validation and quality analysis
- Exploratory SQL analysis
- Aggregate SQL analysis
- Relational SQL analysis
- Advanced SQL techniques
- SQL window function analysis
- Strategic business analytics
- Customer Lifetime Value analysis
- RFM customer segmentation
- Seller performance scorecards
- Product portfolio analysis
- Delivery and customer experience analysis
- Revenue opportunity modelling
- Revenue opportunity scorecards
- Executive KPI development
- Executive business review
- Executive reporting
- Project reflection
- Business recommendations

The next planned stage is:

**Phase 10 – Portfolio Refinement & Interview Preparation**

---

## [0.7.0] - 2026-08-10

### Added

- Completed **Phase 8 – Advanced Business Analytics**.
- Added Investigation 34 – Customer Lifetime Value (CLV).
- Added Investigation 35 – RFM Customer Segmentation.
- Added Investigation 36 – Seller Performance & Scorecard Analysis.
- Added Investigation 37 – Product Portfolio Analysis.
- Added Investigation 38 – Delivery, Customer Experience & Performance Analysis.
- Added Investigation 39 – Revenue Opportunity Analysis.
- Added Investigation 40 – Revenue Opportunity Scorecard.
- Added Investigation 41 – Executive KPI & Business Dashboard Development.
- Added Investigation 42 – Final Executive Business Review.
- Added professionally documented SQL scripts and Markdown reports for all Phase 8 investigations.
- Added customer value analysis using Customer Lifetime Value methodology.
- Added RFM-based customer segmentation using Recency, Frequency and Monetary dimensions.
- Added seller performance measurement using revenue, order activity, customer reviews and delivery performance.
- Added weighted seller performance scorecards and seller classification tiers.
- Added revenue contribution analysis across business entities.
- Added delivery and customer experience performance metrics.
- Added revenue opportunity modelling for sellers and product categories.
- Added percentile-based metric standardisation using `PERCENT_RANK()`.
- Added weighted revenue opportunity scoring.
- Added opportunity-tier classification ranging from Very High Opportunity to Very Low Opportunity.
- Added reusable `revenue_opportunity_dashboard` analytical view.
- Added reusable `executive_kpi_dashboard` analytical view.
- Added executive KPI reporting covering revenue, delivered orders, active customers, average order value, customer lifetime value, repeat purchase rate, delivery time and review performance.
- Added final executive business review dataset consolidating business health and growth opportunity indicators.

### Changed

- Updated `README.md` to reflect completion of Phase 8.
- Updated the project investigation count from **33 to 42 completed investigations**.
- Added Investigations 34–42 to the project progress table.
- Expanded the README SQL skills section to include strategic business analytics techniques introduced during Phase 8.
- Added Phase 8 analytical methodology and outcomes to the project documentation.
- Updated the project roadmap so Phase 8 is marked as completed and Phase 9 becomes the next development stage.
- Expanded project documentation from advanced SQL technique demonstration toward strategic business analytics and executive decision support.
- Standardised Phase 8 analytical workflows around metric definition, scoring, classification and business interpretation.
- Strengthened the project's portfolio narrative by connecting SQL implementation with business performance measurement and executive reporting.

### Analytical Improvements

- Established explicit analytical populations and grains for strategic business metrics.
- Separated operational metrics from standardised scores.
- Applied percentile-based standardisation where metrics have different scales.
- Used weighted scoring models to combine multiple business dimensions.
- Introduced business classification tiers for seller performance and revenue opportunity.
- Added eligibility thresholds to reduce distortion from very low-activity entities.
- Consolidated executive-level metrics into reusable SQL views.
- Improved downstream investigation dependencies by using reusable analytical views rather than repeatedly rebuilding the same metric frameworks.
- Added final executive review datasets designed to support management-level interpretation and recommendation development.

### Documentation

- Added comprehensive Phase 8 business investigation reports.
- Added SQL methodology documentation covering customer value, segmentation, seller performance, opportunity scoring and executive KPI development.
- Added business interpretation and analyst reflection sections throughout Phase 8 documentation.
- Updated repository documentation to reflect the transition from SQL technique development to strategic business analytics.

### Project Status

Phase 8 is officially **complete**.

The project contained at this stage:

- **42 completed business investigations**
- **8 completed analytical phases**
- Database implementation and validation
- Exploratory analysis
- Aggregate analysis
- Relational analysis
- Advanced SQL techniques
- Window function analysis
- Strategic business analytics
- Executive KPI and opportunity frameworks

The next planned stage was:

**Phase 9 – Executive Reporting & Business Recommendations**

---

## [0.6.0] - 2026-07-28

### Added

- Completed Phase 7: SQL Window Functions.
- Added Investigation 28 – Introduction to Window Functions (`OVER()`, `PARTITION BY` & `ROW_NUMBER()`).
- Added Investigation 29 – Ranking Functions (`RANK()` & `DENSE_RANK()`).
- Added Investigation 30 – Data Segmentation with `NTILE()`.
- Added Investigation 31 – Historical Analysis using `LAG()`.
- Added Investigation 32 – Forward-Looking Analysis using `LEAD()`.
- Added Investigation 33 – Advanced Window Functions (`FIRST_VALUE()`, `LAST_VALUE()`, Running Totals & Moving Averages).
- Added professionally documented SQL scripts for all Phase 7 investigations.
- Added comprehensive business intelligence reports for every investigation, including executive summaries, business objectives, SQL techniques, findings, analyst reflections, business recommendations and conclusions.
- Introduced advanced analytical reporting using SQL window functions for ranking, segmentation, sequential analysis and cumulative calculations.

### Changed

- Updated README to reflect completion of Phase 7.
- Expanded repository documentation to include advanced analytical SQL techniques based on Window Functions.
- Improved SQL scripts with consistent naming conventions, enhanced inline documentation and business-focused commentary.
- Standardised SQL script numbering to align with repository conventions while maintaining investigation numbering throughout the project.
- Strengthened the project's analytical workflow by incorporating ranking analysis, customer segmentation, sequential event analysis, cumulative metrics and moving-average reporting commonly used in Business Intelligence.

---

## [0.5.0] - 2026-07-27

### Added

- Completed Phase 6: Advanced SQL Techniques.
- Added Investigation 23 – Subqueries Business Analysis.
- Added Investigation 24 – Common Table Expressions (CTEs).
- Added Investigation 25 – SQL Views.
- Added Investigation 26 – Multi-CTE Business Analysis.
- Added Investigation 27 – SQL Integration (Subqueries, CTEs & Views).
- Added professionally documented SQL scripts for all Phase 6 investigations.
- Added business intelligence reports documenting objectives, SQL queries, findings, business interpretations, analyst reflections, and recommendations.
- Introduced reusable analytical workflows using Common Table Expressions and SQL Views.
- Demonstrated modular SQL development through integrated use of Subqueries, CTEs and Views.

### Changed

- Updated README to reflect completion of Phase 6.
- Expanded repository documentation with advanced SQL concepts and reusable analytical workflows.
- Improved SQL scripts with consistent formatting, modular design and business-focused commentary.
- Strengthened the project's analytical methodology by introducing reusable SQL components suitable for production reporting.

---

## [0.4.0] - 2026-07-22

### Added

- Completed Phase 5: Relational SQL Analysis.
- Added Investigation 14 – Customer Purchasing Behaviour.
- Added Investigation 15 – Product Sales Performance.
- Added Investigation 16 – Seller Performance Analysis.
- Added Investigation 17 – Customer Review & Satisfaction Analysis.
- Added Investigation 18 – Delivery Performance Analysis.
- Added Investigation 19 – Geographic Customer & Revenue Analysis.
- Added Investigation 20 – Sales Trend & Time Series Analysis.
- Added Investigation 21 – Payment Method & Customer Payment Behaviour.
- Added Investigation 22 – Customer Retention & Repeat Purchase Analysis.
- Added professionally documented SQL scripts and business intelligence reports for all Phase 5 investigations.
- Introduced delivery performance metrics, customer segmentation, time-series analysis, customer retention analysis, geographic business analysis and multi-stage aggregation.

### Changed

- Updated README to reflect completion of Phase 5.
- Expanded repository documentation with advanced relational SQL analysis.
- Improved SQL scripts with consistent formatting, analyst observations and business recommendations.
- Strengthened the project's business-oriented analytical workflow through multi-table relational analysis.

---

## [0.3.0] - 2026-07-04

### Added

- Completed Phase 3: Exploratory SQL Analysis.
- Completed Phase 4: Aggregate SQL Analysis.
- Added 13 business-focused SQL investigations.
- Added investigation reports documenting business objectives, findings and analyst reflections.
- Introduced aggregate reporting using `GROUP BY`, `HAVING` and `CASE`.
- Added executive summary SQL queries for customer, seller, product, payment and review analysis.

### Changed

- Updated README to reflect project progress and completed investigations.
- Improved repository documentation with business-oriented SQL reporting.
- Refined SQL scripts with consistent formatting and analyst commentary.

---

## [0.2.0] - 2026-06-30

### Added

- PostgreSQL implementation completed.
- Imported all nine Olist datasets.
- Added implementation notes.
- Added data quality report.
- Added import validation SQL script.

### Changed

- Redesigned `order_reviews` to use a surrogate primary key (`review_key`).
- Updated ERD and schema documentation.

---

## [0.1.0] - 2026-06-28

### Added

- Initial database design.
- Created PostgreSQL schema.
- Added CREATE TABLE scripts.
- Added schema documentation.
- Added Entity Relationship Diagram (ERD).