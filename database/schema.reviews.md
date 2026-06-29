# Database Schema Review

## Overview

This document summarizes the database design decisions made while building the PostgreSQL database for the **Brazilian E-Commerce Public Dataset by Olist**.

Rather than simply recreating the original dataset, the objective of this project was to apply professional database design principles while preserving compatibility with the source data. Throughout the design process, careful consideration was given to primary keys, foreign keys, normalization, data types, referential integrity, and business requirements.

The final schema consists of nine tables organized into entity, transaction, and lookup tables, providing a solid foundation for data import, SQL analysis, and business reporting.

---

# Overall Database Design

The database follows a normalized relational design that separates business entities, business transactions, and reference data into independent tables.

The schema consists of:

* **Entity Tables**

  * customers
  * products
  * sellers

* **Transaction Tables**

  * orders
  * order_items
  * order_payments
  * order_reviews

* **Lookup Tables**

  * geolocation
  * product_category_name_translation

This structure minimizes data redundancy while maintaining clear business relationships between customers, orders, products, sellers, payments, reviews, and geographic information.

The `orders` table serves as the central table of the database, connecting customers with products, sellers, payments, and reviews.

---

# Primary Key Strategy

Different primary key strategies were selected based on the characteristics of each table.

## Natural Keys

Natural keys were used whenever the dataset already contained a stable business identifier.

Examples include:

* customer_id
* product_id
* seller_id
* order_id
* review_id
* product_category_name

Using these identifiers preserves compatibility with the original dataset and simplifies data import.

## Composite Primary Keys

Some tables require more than one column to uniquely identify a record.

### order_items

The combination of:

* order_id
* order_item_id

uniquely identifies each product within an order.

### order_payments

The combination of:

* order_id
* payment_sequential

uniquely identifies each payment associated with an order.

Composite keys accurately represent the underlying business process and prevent duplicate records.

## Surrogate Key

The `geolocation` table does not contain a reliable natural primary key because ZIP code prefixes and geographic coordinates are not guaranteed to be unique.

To solve this, a surrogate key (`geolocation_id`) was introduced using PostgreSQL's `GENERATED ALWAYS AS IDENTITY`.

This provides every row with a stable, unique identifier while preserving the original geographic data.

---

# Foreign Key Strategy

Foreign key constraints were implemented where stable business relationships exist.

Examples include:

* orders → customers
* order_items → orders
* order_items → products
* order_items → sellers
* order_payments → orders
* order_reviews → orders

These constraints help enforce referential integrity and prevent orphaned records.

## Deliberately Omitted Foreign Keys

Not every logical relationship was enforced with a foreign key.

### products → product_category_name_translation

Although these tables are logically related through `product_category_name`, no foreign key constraint was created because the original dataset contains products with missing category values. Preserving the source data without modification was prioritized during the import process.

### customers / sellers → geolocation

Customers and sellers reference ZIP code prefixes, while the `geolocation` table contains multiple geographic records for the same ZIP prefix. Because there is no one-to-one relationship, a foreign key constraint was intentionally omitted. Geographic analysis can instead be performed by joining on the ZIP code prefix when appropriate.

---

# Normalization Review

The database was designed following the principles of Third Normal Form (3NF).

Key examples include:

* Customer information is stored only once.
* Product details are separated from orders.
* Seller information is maintained independently.
* Payments and reviews are separated from orders.
* Geographic information is stored in its own lookup table.
* Product category translations are maintained in a dedicated reference table.

This reduces redundancy, improves consistency, and simplifies future maintenance.

---

# Lookup Tables

Two lookup tables improve data quality and reporting.

## geolocation

Stores geographic reference information used to enrich customer and seller records for regional analysis, logistics, and delivery performance.

## product_category_name_translation

Provides English translations for Portuguese product categories, enabling international reporting without duplicating translation data across every product.

---

# Data Type Decisions

Several deliberate data type choices were made throughout the project.

| Data Type     | Reason                                           |
| ------------- | ------------------------------------------------ |
| VARCHAR       | Variable-length identifiers and text values.     |
| CHAR(2)       | Brazilian state abbreviations.                   |
| INTEGER       | Whole-number quantities and ZIP code prefixes.   |
| SMALLINT      | Small numeric ranges such as review scores.      |
| DECIMAL(10,2) | Monetary values requiring exact precision.       |
| DECIMAL(10,7) | Geographic coordinates requiring high precision. |
| TIMESTAMP     | Business events requiring both date and time.    |
| TEXT          | Longer free-form review comments.                |

These choices balance storage efficiency, accuracy, and future analytical requirements.

---

# Key Design Decisions

Several important design decisions were made while building the schema.

* Introduced a surrogate key for the `geolocation` table because no suitable natural key existed.
* Used composite primary keys where a single column could not uniquely identify records.
* Preserved original dataset column names to simplify data import.
* Avoided unnecessary foreign key constraints where they conflicted with the characteristics of the source data.
* Preferred normalization over duplicating business information across multiple tables.

These decisions reflect practical database design rather than simply reproducing the original CSV files.

---

# Lessons Learned

This project reinforced several important database design principles.

* Database design begins with understanding the business process rather than writing SQL.
* Every table should have a clearly defined business purpose.
* Primary key selection depends on the nature of the data.
* Composite keys accurately model many real-world business processes.
* Foreign keys should represent genuine business relationships.
* Lookup tables improve consistency and reduce redundancy.
* Real-world datasets often require balancing ideal design with practical implementation constraints.
* Understanding the data is more important than immediately writing SQL.

---

# Future Improvements

If this database were expanded into a production system, several improvements could be made.

* Add `CHECK` constraints for review scores, payment values, freight values, and installment counts.
* Create lookup tables for order statuses and payment types.
* Introduce additional indexes to improve query performance.
* Further normalize geographic information into dedicated city and state tables.
* Add audit columns such as `created_at` and `updated_at`.
* Implement user roles and permission management.
* Create stored procedures for recurring administrative tasks.
* Build a data warehouse layer to support large-scale analytical reporting.

These enhancements would improve scalability, maintainability, and performance in a production environment.

---

# Final Reflection

This project was designed as more than a SQL exercise. It provided practical experience in designing a normalized relational database that reflects real business processes.

Throughout the project, emphasis was placed on understanding why each table exists, selecting appropriate keys and constraints, applying normalization principles, and documenting every significant design decision.

The completed schema provides a strong foundation for the next phases of the project, including data import, validation, business analysis, and reporting.

Most importantly, this project demonstrates not only the ability to write SQL but also the ability to think critically about database design, data quality, and the business problems that relational databases are intended to solve.


---