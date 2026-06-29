# Database Schema Notes

This document explains the purpose, relationships, and design decisions for each table in the Ecommerce Analytics database.

---

# 1. customers

## Purpose
Stores customer records associated with each order. The table contains customer location information and unique identifiers used throughout the database.

## Primary Key
- customer_id

## Foreign Keys
- None

## Relationships
- One customer can place many orders.
- Connected to the `orders` table through `customer_id`.

## Important Columns

| Column | Description |
|---------|-------------|
| customer_id | Unique identifier for each customer record. |
| customer_unique_id | Identifies the actual customer across multiple orders. |
| customer_zip_code_prefix | Customer ZIP/postal code prefix. |
| customer_city | Customer city. |
| customer_state | Two-letter Brazilian state abbreviation. |

## Design Decisions

- `customer_id` is used as the Primary Key because each customer record must be uniquely identifiable.
- `customer_unique_id` is not the Primary Key because one real customer may have multiple customer records over time.
- `customer_state` uses `CHAR(2)` because Brazilian state abbreviations always contain two characters.
- `customer_city` uses `VARCHAR(100)` because city names vary in length.

---

# 2. products

## Purpose

Stores descriptive information and physical characteristics of every product sold on the platform.

## Primary Key

- product_id

## Foreign Keys

- None (logical relationship with the Product Category Translation table)

## Relationships

- One product can appear in many order items.
- Product categories can be translated using the `product_category_name_translation` table.

## Important Columns

| Column | Description |
|---------|-------------|
| product_id | Unique product identifier. |
| product_category_name | Product category in Portuguese. |
| product_name_lenght | Length of the product name. |
| product_description_lenght | Length of the product description. |
| product_photos_qty | Number of product photos. |
| product_weight_g | Product weight in grams. |
| product_length_cm | Product length in centimeters. |
| product_height_cm | Product height in centimeters. |
| product_width_cm | Product width in centimeters. |

## Design Decisions

- `product_id` is the Primary Key.
- Physical measurements are stored as integers because they represent whole-number measurements.
- `product_category_name` is treated as a logical relationship rather than enforcing a foreign key constraint.
- Column names are kept exactly as they appear in the original dataset, including the spelling of `lenght`, to simplify data import.

---

# 3. orders

## Purpose

Stores every order placed on the e-commerce platform. This is the central transaction table that tracks an order throughout its lifecycle, from purchase to delivery.

## Primary Key

- order_id

## Foreign Keys

- customer_id → customers.customer_id

## Relationships

- Many orders belong to one customer.
- One order can contain many order items.
- One order can have multiple payment records.
- One order can have one review.

## Important Columns

| Column | Description |
|---------|-------------|
| order_id | Unique identifier for each order. |
| customer_id | Identifies the customer who placed the order. |
| order_status | Current status of the order (e.g., delivered, shipped, canceled). |
| order_purchase_timestamp | Date and time when the order was placed. |
| order_approved_at | Date and time when payment was approved. |
| order_delivered_carrier_date | Date and time when the carrier received the package. |
| order_delivered_customer_date | Date and time when the customer received the order. |
| order_estimated_delivery_date | Estimated delivery date communicated to the customer. |

## Business Process

The order lifecycle typically follows these stages:

1. Customer places an order.
2. Payment is approved.
3. Seller prepares the package.
4. Carrier collects the package.
5. Customer receives the package.

Not every order reaches every stage. For example, canceled orders may have purchase and approval timestamps but no delivery timestamps.

## Design Decisions

- `order_id` is the Primary Key because every order must be uniquely identifiable.
- `customer_id` is a Foreign Key that maintains referential integrity with the `customers` table.
- All event-related dates use the `TIMESTAMP` data type because the exact date and time are important for business analysis.
- Delivery timestamps are allowed to contain `NULL` values because canceled or unavailable orders are never shipped or delivered.
- The estimated delivery date is stored even for canceled orders because it represents a planned delivery promise rather than an actual event.

## Business Questions This Table Helps Answer

- What is the average delivery time?
- How long does payment approval take?
- Which percentage of orders are canceled?
- How many deliveries are late?
- Does delivery performance influence customer review scores?
- Which months have the highest order volume?
  
---

# 4. order_items

## Purpose

Stores every individual product purchased within an order. This table connects orders, products, and sellers while recording item-level pricing, shipping costs, and shipping deadlines.

## Primary Key

- Composite Primary Key:
  - order_id
  - order_item_id

## Foreign Keys

- order_id → orders.order_id
- product_id → products.product_id
- seller_id → sellers.seller_id

## Relationships

- Many order items belong to one order.
- Many order items reference one product.
- Many order items are fulfilled by one seller.

## Important Columns

| Column | Description |
|---------|-------------|
| order_id | References the order containing the item. |
| order_item_id | Sequential identifier for items within the same order. |
| product_id | Product purchased. |
| seller_id | Seller fulfilling the item. |
| shipping_limit_date | Deadline for shipping the item. |
| price | Selling price of the item. |
| freight_value | Shipping cost charged for the item. |

## Design Decisions

- A composite primary key (`order_id`, `order_item_id`) uniquely identifies each item within an order.
- `price` and `freight_value` use `DECIMAL(10,2)` to accurately store monetary values.
- Foreign keys enforce relationships with the `orders`, `products`, and `sellers` tables.
- One order can contain multiple products, making this table essential for modeling the many-to-many relationship between orders and products.

## Business Questions This Table Helps Answer

- Which products generate the most revenue?
- Which sellers sell the most products?
- What is the average freight cost per order item?
- Which products appear most frequently in customer orders?
- Which sellers charge the highest shipping costs?
- What is the average selling price by product category?

---

# 5. sellers

## Purpose

Stores information about merchants (sellers) participating in the Olist marketplace. Each seller can fulfill many order items and is associated with a geographic location.

## Primary Key

* seller_id

## Foreign Keys

* None

## Relationships

* One seller can fulfill many order items.
* Connected to the `order_items` table through `seller_id`.

## Important Columns

| Column                 | Description                                        |
| ---------------------- | -------------------------------------------------- |
| seller_id              | Unique identifier for each seller.                 |
| seller_zip_code_prefix | First five digits of the seller's ZIP/postal code. |
| seller_city            | City where the seller is located.                  |
| seller_state           | Two-letter Brazilian state abbreviation.           |

## Design Decisions

* `seller_id` is the Primary Key because it uniquely identifies each seller.
* `seller_zip_code_prefix` is stored as `INTEGER` because the dataset uses a numeric five-digit ZIP code prefix for geographic analysis.
* `seller_city` uses `VARCHAR(100)` to accommodate varying city name lengths.
* `seller_state` uses `CHAR(2)` because Brazilian state abbreviations always contain exactly two characters.
* Seller information is stored in its own table to avoid repeating seller details for every order item, following database normalization principles.

## Business Questions This Table Helps Answer

* Which sellers generate the highest revenue?
* Which sellers fulfill the most order items?
* Which states have the largest number of sellers?
* Which cities have the highest concentration of sellers?
* What is the average delivery performance by seller?
* Which sellers receive the highest customer review scores?

---

# 6. order_payments

## Purpose

Stores payment information for each order placed on the Olist marketplace. This table records the payment method, installment details, payment amount, and supports orders paid through multiple transactions.

## Primary Key

* Composite Primary Key:

  * order_id
  * payment_sequential

## Foreign Keys

* order_id → orders.order_id

## Relationships

* Many payment records belong to one order.
* One order can have one or more payment records.
* Connected to the `orders` table through `order_id`.

## Important Columns

| Column               | Description                                                           |
| -------------------- | --------------------------------------------------------------------- |
| order_id             | References the order associated with the payment.                     |
| payment_sequential   | Sequence number identifying each payment for the same order.          |
| payment_type         | Payment method used (e.g., credit card, boleto, voucher, debit card). |
| payment_installments | Number of installments used for the payment.                          |
| payment_value        | Monetary amount paid for the transaction.                             |

## Design Decisions

* A composite primary key (`order_id`, `payment_sequential`) uniquely identifies each payment record for an order.
* `order_id` is a foreign key that enforces referential integrity with the `orders` table.
* `payment_value` uses `DECIMAL(10,2)` to accurately store monetary values and avoid floating-point precision issues.
* `payment_type` is stored as `VARCHAR(20)` because it contains short categorical values.
* The design supports multiple payments for a single order, allowing customers to split payments across different payment methods or transactions.

## Business Questions This Table Helps Answer

* Which payment method is used most frequently?
* What percentage of customers pay using installments?
* What is the average payment value by payment method?
* How many orders involve multiple payment transactions?
* Which payment methods generate the highest revenue?
* What is the average number of installments selected by customers?

---

# 7. order_reviews

## Purpose

Stores customer reviews submitted for orders on the Olist marketplace. The table records customer satisfaction through a numeric review score, optional written feedback, and timestamps indicating when the review was created and when it was answered.

## Primary Key

* review_id

## Foreign Keys

* order_id → orders.order_id

## Relationships

* Many reviews are associated with one order (according to the dataset structure).
* Connected to the `orders` table through `order_id`.

## Important Columns

| Column                  | Description                                        |
| ----------------------- | -------------------------------------------------- |
| review_id               | Unique identifier for each review.                 |
| order_id                | References the order being reviewed.               |
| review_score            | Customer rating on a scale from 1 to 5.            |
| review_comment_title    | Optional title for the review.                     |
| review_comment_message  | Optional detailed customer feedback.               |
| review_creation_date    | Date the customer submitted the review.            |
| review_answer_timestamp | Date and time the company responded to the review. |

## Design Decisions

* `review_id` is used as the primary key because it uniquely identifies reviews in the observed dataset.
* `order_id` is a foreign key that maintains referential integrity with the `orders` table.
* `review_score` is stored as `SMALLINT` because only values between 1 and 5 are expected.
* Review titles and messages are optional and therefore allow `NULL` values.
* `TEXT` is used for review comments because customer feedback varies greatly in length.

## Business Questions This Table Helps Answer

* What is the average customer review score?
* What percentage of reviews are positive (4–5 stars) versus negative (1–2 stars)?
* Do late deliveries receive lower review scores?
* Which sellers and product categories receive the highest customer ratings?
* How quickly does the company respond to customer reviews?
* Has customer satisfaction changed over time?

---

# 8. geolocation

## Purpose

Stores geographic reference data that maps Brazilian ZIP code prefixes to approximate locations, including latitude, longitude, city, and state. This table supports geographic analysis of customers, sellers, deliveries, and regional business performance.

## Primary Key

* geolocation_id (Surrogate Key)

## Foreign Keys

* None

## Relationships

* Logical relationship with the `customers` table through `customer_zip_code_prefix`.
* Logical relationship with the `sellers` table through `seller_zip_code_prefix`.
* Used as a lookup table to enrich customer and seller records with geographic information.
* No foreign key constraints are enforced because a single ZIP code prefix may correspond to multiple geographic coordinates in the original dataset.

## Important Columns

| Column                      | Description                                                    |
| --------------------------- | -------------------------------------------------------------- |
| geolocation_id              | Surrogate key uniquely identifying each geolocation record.    |
| geolocation_zip_code_prefix | Brazilian ZIP/postal code prefix associated with the location. |
| geolocation_lat             | Latitude coordinate of the location.                           |
| geolocation_lng             | Longitude coordinate of the location.                          |
| geolocation_city            | City corresponding to the ZIP code prefix.                     |
| geolocation_state           | Two-letter Brazilian state abbreviation.                       |

## Design Decisions

* A surrogate key (`geolocation_id`) is introduced because the original dataset does not contain a reliable natural primary key.
* `geolocation_zip_code_prefix` is **not** used as the primary key because multiple records can share the same ZIP code prefix with different geographic coordinates.
* Latitude and longitude are stored as `DECIMAL(10,7)` to preserve geographic precision.
* `geolocation_state` uses `CHAR(2)` because Brazilian state abbreviations always contain two characters.
* No foreign key constraints are created between this table and the `customers` or `sellers` tables. Instead, joins are performed using the ZIP code prefix during analysis to preserve compatibility with the original dataset.

## Business Significance

This table enables analysts to incorporate geographic context into business analysis. By linking customer and seller ZIP code prefixes with location data, businesses can study regional sales patterns, customer distribution, seller coverage, and delivery performance.

## Business Questions This Table Helps Answer

* Which states and cities generate the highest sales?
* Where are the highest concentrations of customers and sellers located?
* Which regions experience the longest delivery times?
* Which geographic areas have high customer demand but relatively few sellers?
* How does regional distribution influence logistics costs and delivery efficiency?
* Which locations present opportunities for market expansion or new distribution centers?
* How are customers and sellers geographically distributed across Brazil?

---

# 9. product_category_name_translation

## Purpose

Stores English translations for Portuguese product category names. This lookup table enables reports, dashboards, and analyses to present category names in English while preserving the original Portuguese values stored in the source dataset.

## Primary Key

* product_category_name

## Foreign Keys

* None

## Relationships

* Logical relationship with the `products` table through `product_category_name`.
* Used as a lookup table to translate product categories for reporting and business analysis.
* No foreign key constraint is enforced to preserve compatibility with the original dataset during data import.

## Important Columns

| Column                        | Description                                  |
| ----------------------------- | -------------------------------------------- |
| product_category_name         | Product category name in Portuguese.         |
| product_category_name_english | English translation of the product category. |

## Design Decisions

* `product_category_name` is used as the primary key because it uniquely identifies each category in the dataset.
* A natural key is preferred over a surrogate key because the table is small, stable, and contains a single business identifier.
* `VARCHAR(100)` is used for both columns because category names vary in length.
* No foreign key constraint is created between this table and `products`, allowing products with missing category values to be imported without violating referential integrity.

## Business Significance

Although this table does not record business transactions, it improves the usability of the database by providing standardized English category names. This makes reports easier to understand for international stakeholders and supports multilingual business intelligence.

## Business Questions This Table Helps Support

* Which product categories generate the highest revenue?
* Which product categories receive the highest customer ratings?
* Which categories are purchased most frequently?
* Which product categories have the highest average selling price?
* How do product category trends change over time?
* How can reports and dashboards be presented to English-speaking stakeholders?

---