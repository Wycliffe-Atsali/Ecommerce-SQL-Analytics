# Database Profile

## Overview

The Retail SQL Business Analysis database contains nine normalized tables representing customers, orders, products, sellers, payments, reviews, and geographic reference data.

The database was profiled after successful PostgreSQL implementation to validate data quality before performing business analysis.

---

## Dataset Summary

| Table | Rows |
|--------|-----:|
| customers | 99,441 |
| sellers | 3,095 |
| products | 32,951 |
| orders | 99,441 |
| order_items | 112,650 |
| order_payments | 103,886 |
| order_reviews | 99,224 |
| geolocation | 1,000,163 |
| product_category_name_translation | 71 |

---

## Key Validation Findings

- All datasets imported successfully.
- Primary keys validated after import.
- Duplicate `review_id` values confirmed.
- Duplicate ZIP code prefixes confirmed.
- Seller identifiers are unique.
- Customer identifiers behave as expected.
- Payment data contains no NULL payment values.
- Geographic coordinate data is complete.
- Several business columns contain optional NULL values, including review titles and review messages.

---

## Overall Assessment

The database demonstrates high data completeness and is suitable for exploratory analysis, business reporting, and advanced SQL analytics.