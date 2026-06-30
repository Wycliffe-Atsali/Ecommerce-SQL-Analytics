# Retail SQL Business Analysis

A professional PostgreSQL portfolio project built using the Brazilian E-Commerce Public Dataset by Olist.

## Project Status

🚧 Currently in development.

### Completed

- Database design
- PostgreSQL schema implementation
- Data import for all nine tables
- Data validation
- Entity Relationship Diagram (ERD)
- Schema documentation
- Schema refinement based on implementation findings

### In Progress

- Data quality assessment
- Implementation documentation

### Upcoming

- Exploratory SQL analysis
- Business analysis
- Executive reporting
- Business recommendations
- Portfolio refinement

---

## Schema Evolution

Although the initial database schema was carefully designed before implementation, one design assumption was refined after validating the imported data.

During the import of the `order_reviews` dataset, duplicate `review_id` values were discovered. Investigation confirmed that the duplicate review identifiers referenced different orders, meaning `review_id` could not reliably function as the table's primary key.

To preserve every source record while maintaining entity integrity, the schema was revised by introducing a surrogate key (`review_key`) as the primary key. The original `review_id` remains as a business identifier.

This demonstrates an iterative database design process in which implementation findings informed schema improvements rather than forcing the data to fit the original design.

---

This repository documents the complete lifecycle of building a PostgreSQL analytics database—from schema design and implementation to validation, business analysis, and reporting.