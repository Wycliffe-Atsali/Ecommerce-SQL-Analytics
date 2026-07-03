# Investigation 06 – Reviews

## Business Objective

Explore customer review data to understand review coverage, score distribution, review completeness, and data quality before conducting customer satisfaction analysis.

---

# Business Questions

1. How many review records exist?
2. How many unique review IDs exist?
3. Which review scores are represented?
4. How many reviews were given for each score?
5. What is the earliest review creation date?
6. What is the latest review creation date?
7. How many reviews are missing a title?
8. How many reviews are missing a written message?
9. How many reviews contain only a numerical rating?
10. Are duplicate review IDs present?

---

# Results

| Question | Result |
|-----------|--------:|
| Total Reviews | 99,224 |
| Unique Review IDs | 98,410 |
| Review Scores | 1–5 |
| Most Common Score | 5 |
| Missing Review Titles | 87,656 |
| Missing Review Messages | 58,247 |
| Missing Both Title & Message | 56,518 |
| Duplicate review_id Values | Present |

---

# Key Findings

- Nearly every order received a customer review.
- Review scores span the full range from 1 to 5.
- Five-star reviews are the most common rating.
- Most customers do not provide review titles.
- More than half of all reviews consist solely of a numerical score.
- Duplicate `review_id` values confirm that the business identifier is not unique.

---

# Business Interpretation

The review dataset provides excellent coverage for future customer satisfaction analysis. However, analysts should recognize that review scores represent feedback only from customers who submitted reviews and may therefore be influenced by response bias.

The investigation also confirms that introducing the surrogate key `review_key` was the correct database design decision.

---

# Analyst Reflection

This investigation demonstrated how exploratory analysis can validate both business assumptions and earlier database design decisions.

Rather than viewing duplicate review IDs as simply an import issue, they were confirmed to be an inherent characteristic of the source data, reinforcing the importance of understanding business identifiers before selecting primary keys.

---

# Interview Notes

### Why was a surrogate key introduced?

Because `review_id` is not unique across the dataset and therefore cannot reliably function as a primary key.

### Why aren't missing review titles necessarily a problem?

Many customers submit ratings or written comments without titles. Missing titles alone do not significantly reduce the usefulness of review data.

### What does a high proportion of five-star reviews suggest?

The available review data indicates a generally positive customer experience, although analysts should consider potential response bias before generalizing to all customers.

---

**Status:** ✅ Completed