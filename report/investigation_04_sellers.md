# Investigation 04 – Sellers

## Business Objective

Understand the structure and geographic distribution of sellers registered on the marketplace while evaluating the completeness and quality of seller location data.

---

# Business Questions

1. How many sellers are registered?
2. How many unique seller cities exist?
3. How many seller states are represented?
4. Which seller states are represented?
5. How many sellers are located in each state?
6. How many sellers have missing city information?
7. How many sellers have missing state information?
8. What is the alphabetically first seller city?
9. What is the alphabetically last seller city?
10. Are seller IDs unique?

---

# Results

| Question | Result |
|-----------|--------:|
| Total Sellers | 3,095 |
| Unique Seller Cities | 611 |
| Seller States | 23 |
| Missing Seller City | 0 |
| Missing Seller State | 0 |
| Alphabetically First City | 04482255 |
| Alphabetically Last City | xaxim |
| Duplicate seller_id Values | None |

---

# Key Findings

- The marketplace contains **3,095 registered sellers**.
- Sellers are distributed across **611 unique cities** and **23 states**.
- Seller location information is complete, with no missing city or state values.
- A value of **04482255** appears in the `seller_city` column, suggesting a possible data-entry or import issue.
- Validation confirmed that every `seller_id` is unique.

---

# Business Interpretation

The seller dataset demonstrates strong overall data quality, making it suitable for future geographic and marketplace analyses.

Although the seller network spans a large portion of Brazil, it does not include all Brazilian federal units, indicating potential opportunities for geographic expansion.

The investigation also identified one suspicious city value, reinforcing the importance of validating categorical data before performing regional reporting.

---

# Analyst Reflection

This investigation demonstrated that exploratory analysis extends beyond counting records.

Verifying primary keys, assessing data completeness, and identifying unusual categorical values are important responsibilities for data analysts before building reports or dashboards.

The introduction of `GROUP BY` also enabled grouped summaries that better reflect real-world business reporting requirements.

---

# Interview Notes

### Why validate primary keys even when the database defines them?

Validating primary keys confirms that imported data maintains its expected uniqueness and helps identify any issues that may have occurred during data ingestion or migration.

---

### Why is the value "04482255" noteworthy?

It appears to be a postal code rather than a city name. Such inconsistencies can affect geographic reporting and should be investigated before using the data in production analyses.

---

### Why is `GROUP BY` important?

`GROUP BY` allows analysts to summarize data by categories, enabling business questions such as sellers per state, customers per city, or orders per month to be answered efficiently.

---

**Status:** ✅ Completed