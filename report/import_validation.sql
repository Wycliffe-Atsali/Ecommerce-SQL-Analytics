/*
============================================================
IMPORT VALIDATION SCRIPT
Project: Retail SQL Business Analysis
Dataset: Brazilian E-Commerce Public Dataset by Olist

Purpose:
Validate that all tables were imported successfully before
beginning exploratory data analysis.

Author: Atsali Akolo
Database: PostgreSQL
============================================================
*/

------------------------------------------------------------
-- ROW COUNT VALIDATION
------------------------------------------------------------

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_sellers
FROM sellers;

SELECT COUNT(*) AS total_geolocations
FROM geolocation;

SELECT COUNT(*) AS total_product_categories
FROM product_category_name_translation;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT COUNT(*) AS total_order_payments
FROM order_payments;

SELECT COUNT(*) AS total_order_reviews
FROM order_reviews;

------------------------------------------------------------
-- PRIMARY KEY VALIDATION
------------------------------------------------------------

-- Customers
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Products
SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Sellers
SELECT seller_id, COUNT(*)
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- Orders
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- COMPOSITE PRIMARY KEY VALIDATION
------------------------------------------------------------

-- Order Items

SELECT
    order_id,
    order_item_id,
    COUNT(*)
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- Order Payments

SELECT
    order_id,
    payment_sequential,
    COUNT(*)
FROM order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- FOREIGN KEY VALIDATION
------------------------------------------------------------

-- Orders → Customers

SELECT COUNT(*) AS missing_customers
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

------------------------------------------------------------

-- Order Items → Orders

SELECT COUNT(*) AS missing_orders
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

------------------------------------------------------------

-- Order Items → Products

SELECT COUNT(*) AS missing_products
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

------------------------------------------------------------

-- Order Items → Sellers

SELECT COUNT(*) AS missing_sellers
FROM order_items oi
LEFT JOIN sellers s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

------------------------------------------------------------

-- Order Payments → Orders

SELECT COUNT(*) AS missing_payment_orders
FROM order_payments op
LEFT JOIN orders o
ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

------------------------------------------------------------

-- Order Reviews → Orders

SELECT COUNT(*) AS missing_review_orders
FROM order_reviews r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

------------------------------------------------------------
-- NULL VALUE VALIDATION
------------------------------------------------------------

SELECT COUNT(*) AS missing_customer_ids
FROM customers
WHERE customer_id IS NULL;

SELECT COUNT(*) AS missing_order_ids
FROM orders
WHERE order_id IS NULL;

SELECT COUNT(*) AS missing_product_ids
FROM products
WHERE product_id IS NULL;

SELECT COUNT(*) AS missing_seller_ids
FROM sellers
WHERE seller_id IS NULL;

------------------------------------------------------------
-- END OF VALIDATION
------------------------------------------------------------