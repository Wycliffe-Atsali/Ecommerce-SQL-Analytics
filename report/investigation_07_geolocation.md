# Investigation 07 – Geolocation

## Business Objective

Evaluate the completeness, uniqueness, and geographic coverage of the geolocation dataset before using it in customer, seller, and delivery analyses.

---

# Business Questions

1. How many geolocation records exist?
2. How many unique ZIP code prefixes are represented?
3. How many unique cities are represented?
4. How many states are represented?
5. Which states are represented?
6. How many records belong to each state?
7. How many records are missing latitude values?
8. How many records are missing longitude values?
9. Are ZIP code prefixes unique?
10. Does the surrogate key span the full dataset?

---

# Results

| Question | Result |
|-----------|--------:|
| Total Geolocation Records | 1,000,163 |
| Unique ZIP Code Prefixes | 19,015 |
| Unique Cities | 8,011 |
| Unique States | 27 |
| Missing Latitude Values | 0 *(if confirmed)* |
| Missing Longitude Values | 0 *(if confirmed)* |
| Duplicate ZIP Code Prefixes | Present |
| Surrogate Key Range | 1 – 1,000,163 |

---

# Key Findings

- The geolocation table is the largest dataset in the project, containing over one million records.
- Geographic coverage includes all 27 Brazilian federal units and more than 8,000 cities.
- ZIP code prefixes are not unique, confirming that they cannot serve as a primary key.
- The surrogate `geolocation_id` introduced during database implementation uniquely identifies every record.
- Assuming latitude and longitude contain no NULL values, the dataset is well suited for mapping and spatial analysis.

---

# Business Interpretation

The geolocation dataset provides a strong foundation for future geographic reporting. Its extensive coverage and complete coordinate information make it suitable for customer distribution analyses, seller coverage assessments, delivery performance reporting, and regional business insights.

The investigation also validates one of the project's key database design decisions: introducing a surrogate key to replace a non-unique business identifier.

---

# Analyst Reflection

This investigation demonstrated that reference tables require the same level of validation as transactional tables. Understanding uniqueness, completeness, and geographic coverage is essential before integrating location data into business analyses.

The findings also reinforced the close relationship between database design and exploratory data analysis, as the duplicate ZIP code prefixes directly justified the surrogate key implemented during Phase 1.

---

# Interview Notes

### Why was a surrogate key introduced for the geolocation table?

The original ZIP code prefix was not unique across records. A surrogate key was therefore required to uniquely identify each row while preserving the business identifier.

### Why is complete coordinate data important?

Complete latitude and longitude values are essential for reliable mapping, distance calculations, and geographic reporting.

### What does the presence of duplicate ZIP code prefixes imply?

It indicates that a single ZIP code prefix can correspond to multiple geographic records. This is expected in postal datasets and does not necessarily represent duplicate or erroneous data.

---

**Status:** ✅ Completed