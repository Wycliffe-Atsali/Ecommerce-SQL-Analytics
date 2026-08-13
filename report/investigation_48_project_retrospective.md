# Investigation 48 — Project Retrospective

## 1. Investigation Overview

### Objective

Reflect on the development of the Olist SQL analytics project from its initial database and SQL foundations through advanced analytical work, strategic business analysis, executive reporting, and SQL performance optimisation.

The purpose of this retrospective is to evaluate:

- how SQL and analytical capabilities developed;
- the most important technical and analytical lessons;
- mistakes and challenges encountered;
- how the analytical methodology evolved;
- which parts of the project were most successful;
- limitations of the dataset and analysis;
- what would be changed if the project were restarted today.

### Core Retrospective Question

> **How has the project changed my understanding of SQL, analytical problem-solving, data quality, business analysis, and the process of turning relational data into trustworthy business decisions?**

---

# 2. Learning & Growth

## Question 1 — Looking back at the beginning of the project, how has your SQL ability changed, and what can you do now that you could not do then?

At the beginning, my focus was primarily on **learning SQL syntax and producing individual queries**. I was concerned with understanding `SELECT`, `WHERE`, `JOIN`, `GROUP BY`, aggregates, and eventually more advanced constructs.

The biggest change is that I now approach SQL as an **analytical problem-solving language rather than simply a querying language**.

I can now:

- Design and implement a relational PostgreSQL database.
- Determine the appropriate **analytical grain** before writing a query.
- Build complex multi-stage analyses using CTEs and views.
- Use window functions for ranking, segmentation, historical comparisons, and sequential analysis.
- Detect and prevent join multiplication and double-counting.
- Define business metrics before calculating them.
- Build customer, seller, product, revenue, and executive-level analyses.
- Convert raw metrics into standardized scores and composite business frameworks.
- Validate analytical results rather than assuming that technically valid SQL means the result is correct.
- Investigate query performance using `EXPLAIN (ANALYZE, BUFFERS)`.
- Translate SQL output into business recommendations.

The biggest progression is therefore from:

> **"Can I write this SQL query?"**

to:

> **"What business question am I answering, what should the data represent, how should I calculate it, and how do I know the answer is trustworthy?"**

---

## Question 2 — What was the single biggest technical lesson you learned from building this project?

The biggest technical lesson was:

> **SQL correctness depends on understanding the structure and grain of the data, not simply writing syntactically correct SQL.**

The Olist project repeatedly demonstrated that a query can execute successfully and return plausible numbers while still being wrong.

For example, joining `orders`, `order_items`, and `order_payments` without controlling the grain can multiply rows and inflate revenue.

Similarly, window functions, aggregations, CTEs, and joins all behave correctly according to SQL rules—but the analyst has to ensure those operations are being performed at the **correct analytical level**.

Investigation 46 reinforced the same lesson from a performance perspective: even an apparently sensible index does not automatically improve a query.

The broader technical lesson became:

> **Understand the data structure, formulate the analytical grain, construct the query deliberately, and then validate both the result and the execution behaviour.**

---

## Question 3 — What was the single biggest analytical/business lesson you learned?

The biggest lesson was:

> **A metric is only useful when its definition, population, grain, assumptions, and business interpretation are all clear.**

Early SQL work can make analysis feel like a calculation exercise:

> `SUM()` → result.

But the later investigations showed that the difficult question is often **what should actually be summed?**

For example, defining revenue required deciding whether the analysis should use:

- `order_payments.payment_value`; or
- `order_items.price + freight_value`.

Similarly, customer analysis required deciding whether the customer should be represented by `customer_id` or `customer_unique_id`, and historical business analysis generally required restricting the population to delivered orders.

I learned that:

> **The SQL query implements the analytical definition; it does not create the definition.**

That distinction is one of the most important things I would carry into a real analytics role.

---

# 3. Problems & Mistakes

## Question 4 — What was the biggest mistake or misconception you had during the project, and what did it teach you?

The biggest misconception was initially treating a technically valid SQL result as sufficient evidence that the analysis was correct.

As the project became more complex, I learned that correctness has several layers:

1. **Syntax correctness** — does the SQL execute?
2. **Logical correctness** — does the query perform the intended operations?
3. **Data correctness** — are the joins, filters and aggregations appropriate?
4. **Analytical correctness** — is the grain and population appropriate?
5. **Business correctness** — does the metric actually answer the intended business question?

The experience with joins and revenue calculations was particularly important because duplicate rows can produce numbers that look completely reasonable while being materially wrong.

This taught me to stop asking only:

> "Does the query work?"

and start asking:

> **"Why should I trust this result?"**

---

## Question 5 — Which part of the project was the most difficult, and how did you eventually overcome the difficulty?

The most difficult part was the transition from **advanced SQL techniques into integrated business analysis**.

Writing a window function or CTE in isolation is one thing. Building an analysis such as the seller scorecard required combining:

- multiple source tables;
- delivered-order filtering;
- seller-level aggregation;
- revenue;
- order volume;
- reviews;
- delivery performance;
- product diversity;
- metric standardisation;
- weighted scoring;
- classification.

The difficulty came from having to keep the **grain and meaning of every intermediate dataset** under control.

I overcame this by becoming much more deliberate about breaking complex investigations into stages:

> **Business objective → metric definition → analytical dataset → aggregation → standardisation → scoring → classification → validation → interpretation.**

That methodology made the later investigations much more manageable.

---

## Question 6 — If you encountered the same problem today, how would your approach be different?

Today I would **design the analytical structure before writing the final query**.

I would explicitly document:

- Business question.
- Population.
- Analytical grain.
- Revenue definition.
- Required joins.
- Required filters.
- Metric definitions.
- Expected output.
- Validation checks.

Then I would construct the query incrementally, validating each intermediate CTE before adding the next layer.

I would also check row counts and grain transitions much earlier.

Instead of debugging a 100-line query after it produces an unexpected result, I would ask at each stage:

> **"What should one row represent here, and how many rows should I expect?"**

That would make debugging considerably faster and reduce the chance of building complexity on top of an incorrect intermediate result.

---

# 4. Analytical Methodology

## Question 7 — How did your approach to analytical grain, metric definitions, joins and validation evolve throughout the project?

This was one of the biggest methodological changes.

Early in the project, I focused primarily on **getting the query to return the desired output**.

Later, I began explicitly defining the analytical grain.

For example:

- Customer analysis → one row per `customer_unique_id`.
- Seller analysis → one row per seller.
- RFM → one row per customer.
- Category analysis → one row per product category.
- Executive KPI analysis → KPI-specific aggregation levels.

I also became more deliberate about metric definitions.

For example:

> **Revenue:** generally `order_payments.payment_value` for marketplace-level revenue analysis.

> **Historical business population:** generally delivered orders.

> **Customer identity:** `customer_unique_id` for behavioural customer analysis.

Joins also changed from being simply a way to connect tables into something I actively evaluate for **cardinality and multiplication risk**.

Finally, validation evolved from checking whether SQL executed to checking:

- row counts;
- distinct counts;
- expected ranges;
- duplicate behaviour;
- intermediate results;
- reconciliation against known totals;
- execution plans for performance work.

---

## Question 8 — Looking back, what part of your analytical methodology worked particularly well, and why?

The strongest part was the methodology that developed during Phase 8:

> **Business Objective → Metric Definition → Analytical Dataset → Standardisation → Scoring → Classification → Business Interpretation → Recommendation.**

This worked particularly well because it prevented the analysis from becoming a collection of disconnected SQL calculations.

For example, the seller scorecard was not simply:

> "Calculate seller revenue."

It became a structured decision framework where multiple dimensions of performance were defined, standardised, weighted, combined, and interpreted.

The same philosophy carried into revenue opportunity analysis and executive reporting.

It provided a bridge between:

**raw relational data**

and

**business decisions.**

---

## Question 9 — What part of your methodology would you change or introduce earlier if you restarted the project?

I would introduce a formal **analytical dictionary and validation framework much earlier**.

For every investigation, I would document from the beginning:

| Definition | Example |
|---|---|
| Business objective | What decision/question is being addressed |
| Population | Which records are included |
| Grain | What one row represents |
| Revenue definition | Which monetary field is used |
| Time period | Which dates define the analysis |
| Exclusions | Cancelled/unavailable/etc. |
| Validation | How the result will be checked |

I would also introduce performance benchmarking earlier, although not necessarily at the depth of Investigation 46.

That would have reduced some of the repeated reasoning later in the project and made the analytical process more systematic from the beginning.

---

# 5. Business Analysis

## Question 10 — Which investigation or analytical component are you most proud of, and why?

I am most proud of the **transition from individual analyses into the Phase 8 strategic analytics framework**, particularly the combination of:

- Customer Lifetime Value;
- RFM segmentation;
- Seller Performance Scorecard;
- Product Portfolio Analysis;
- Revenue Opportunity Analysis;
- Executive KPI Dashboard;
- Final Executive Business Review.

The reason is that these investigations demonstrate that the project had moved beyond:

> **"I know SQL."**

into:

> **"I can use SQL to structure and investigate a business problem."**

The seller scorecard is particularly representative because it required multiple metrics to be brought together into a decision framework rather than simply reporting isolated numbers.

---

## Question 11 — Which analysis best demonstrates that you can translate SQL into genuine business insight rather than simply produce queries?

I would choose the **Revenue Opportunity Analysis and Revenue Opportunity Scorecard**, supported by the later executive review.

The important part was not merely identifying high or low revenue categories.

The analysis attempted to answer a more useful question:

> **Where might the business have meaningful opportunities based on multiple observable dimensions of performance?**

That required combining metrics, standardising them, constructing an opportunity score, interpreting the resulting classifications, and then translating those classifications into business actions.

It also forced an important distinction:

> **An opportunity score identifies an area worth investigating; it does not constitute a forecast or prove that an intervention will succeed.**

That distinction demonstrates analytical judgement rather than simply SQL proficiency.

---

## Question 12 — What did you learn about the difference between a technically correct SQL result and a trustworthy business result?

A technically correct result means:

> **PostgreSQL executed the instructions I gave it and produced the mathematically correct result for those instructions.**

A trustworthy business result requires much more.

I need to know:

- whether the correct population was selected;
- whether the analytical grain was correct;
- whether joins caused duplication;
- whether the metric was appropriately defined;
- whether missing data affected the result;
- whether the calculation matches the business concept;
- whether the result has reasonable validation checks;
- whether the interpretation goes beyond what the data can support.

This became one of the central lessons of the project:

> **SQL correctness is necessary, but it is not sufficient for analytical credibility.**

---

# 6. Dataset & Project Limitations

## Question 13 — What do you consider the three biggest limitations of the Olist dataset and/or your analysis?

### 1. Historical and relatively limited time horizon

The dataset represents historical marketplace activity from approximately **2016–2018**.

Therefore, the analysis describes historical behaviour rather than current Olist performance.

Changes in:

- customer behaviour;
- competition;
- logistics;
- product mix;
- marketplace strategy;
- economic conditions

could make historical patterns less representative of a current operation.

### 2. Limited profitability information

The dataset contains substantial information about transactions and payments, but it does not provide the full cost structure required for true profitability analysis.

For example, I do not have complete information about:

- seller costs;
- product acquisition costs;
- fulfilment costs;
- marketing costs;
- platform operating costs;
- customer acquisition costs;
- contribution margins.

Therefore, **revenue should not be interpreted as profit**.

### 3. Observational data limits causal conclusions

The project primarily analyses observed historical behaviour.

Therefore, relationships such as:

> poor delivery performance → lower review scores

may be interesting and potentially useful, but they do not automatically establish causation.

There may be other factors affecting both variables.

Consequently, the project is strongest at:

> **describing, comparing, segmenting, prioritising and identifying relationships**

rather than proving causal effects.

---

## Question 14 — If you were given better or additional business data, what would you analyse next and why?

I would prioritise **profitability, customer behaviour and operational causality**.

First, I would want detailed cost data so that revenue could be replaced or complemented by:

> **gross margin / contribution margin**

This would significantly improve seller, product and revenue-opportunity analysis.

Second, I would want richer customer information, including:

- acquisition source;
- customer acquisition cost;
- marketing exposure;
- customer demographics;
- customer-level profitability;
- retention/churn information.

That would allow the RFM and CLV frameworks to move from primarily historical segmentation toward more sophisticated **customer value and retention modelling**.

Third, I would want more detailed operational information, particularly:

- warehouse/fulfilment events;
- shipping carrier;
- promised delivery date;
- actual delivery stages;
- logistics costs;
- customer-service interactions.

That would allow stronger investigation of the relationship between operational performance and customer outcomes.

---

# 7. Final Reflection

## Question 15 — If you could restart this entire project today, what would you do differently from Day 1, and what would you deliberately keep unchanged?

I would change the **front-loaded methodology**, but I would keep the overall progression.

### What I Would Do Differently

From Day 1, I would establish:

1. **An analytical dictionary** containing metric definitions and business rules.
2. **Explicit analytical grain** for every investigation.
3. **A standard validation checklist** for every SQL analysis.
4. **A consistent investigation template** from the beginning.
5. **Earlier performance awareness** for complex analytical queries.
6. **Clearer separation between exploratory analysis and decision-oriented analysis.**
7. **Automated or semi-automated data-quality checks** earlier in the project.

I would also spend less time treating every SQL problem as an isolated syntax problem and more time thinking about the underlying data model.

### What I Would Deliberately Keep Unchanged

I would absolutely keep the **phased progression**:

> **Database foundation → SQL fundamentals → relational analysis → advanced SQL → window functions → strategic analytics → executive reporting → optimisation → retrospective.**

That progression mirrors how analytical capability actually develops.

I would also keep the decision to document investigations separately through **SQL scripts and Markdown reports**.

The SQL demonstrates implementation; the Markdown demonstrates reasoning and communication.

Most importantly, I would keep the project's evolution from:

> **SQL exercises**

to

> **business investigations**

to

> **executive recommendations.**

That is ultimately what makes the project more valuable than a collection of disconnected SQL queries.

---

# 8. Final Retrospective

If I had to summarise the entire project in one statement, I would say:

> **The project taught me that being a good SQL analyst is not primarily about writing increasingly complicated queries; it is about understanding data structure, defining the problem correctly, validating the evidence, and using SQL to produce conclusions that a business can actually trust.**

---

# 9. Key Lessons from the Project

The retrospective highlights several principles that will carry forward into future analytical work.

### 1. Start with the business question

SQL should implement an analytical requirement rather than become an exercise in producing complicated queries.

### 2. Define the grain before joining

Knowing what one row represents is essential for preventing duplication and incorrect aggregation.

### 3. Define metrics before calculating them

Terms such as revenue, customer, order, retention and performance must have explicit definitions.

### 4. Separate technical correctness from analytical correctness

A query can execute successfully while still answering the wrong question.

### 5. Validate intermediate results

Complex SQL should be constructed and tested incrementally rather than treated as one opaque query.

### 6. Standardisation enables comparison

Metrics with different units and scales must be transformed appropriately before being combined into composite scores.

### 7. Composite scores are decision tools, not objective truths

Weights, thresholds and scoring methods introduce judgement and should therefore be interpreted cautiously.

### 8. Observational analysis does not establish causation

Relationships identified in historical data should be treated as evidence for investigation rather than automatic proof of cause and effect.

### 9. Performance must be measured empirically

Indexes and optimisations should be tested against actual workloads and execution plans rather than assumed to improve performance.

### 10. Communication is part of analytics

A strong analyst must be able to move from:

> **Data → SQL → Evidence → Insight → Recommendation → Measurement**

rather than stopping at the query result.

---

# 10. Investigation Conclusion

Investigation 48 represents the conclusion of the project's reflective learning process.

The project began primarily as an exercise in learning PostgreSQL and SQL syntax. Over time, it evolved into a broader analytical workflow involving:

- relational database design;
- SQL querying;
- aggregation;
- relational analysis;
- CTEs and views;
- window functions;
- customer analytics;
- seller analytics;
- product analysis;
- revenue opportunity analysis;
- executive KPI development;
- business recommendations;
- SQL performance analysis.

The most important development was not simply the number of SQL techniques learned.

It was the development of a more disciplined analytical mindset.

The project demonstrated that effective SQL analysis requires the analyst to understand:

> **what the business is asking, what the data represents, what each row represents, how metrics should be defined, how tables should be joined, how results should be validated, and what conclusions the evidence can legitimately support.**

The final progression can therefore be summarised as:

> **SQL Syntax → Data Understanding → Analytical Reasoning → Business Analysis → Decision Support**

This represents the primary learning outcome of the project.

---

## Final Statement

> **The project taught me that being a good SQL analyst is not primarily about writing increasingly complicated queries; it is about understanding data structure, defining the problem correctly, validating the evidence, and using SQL to produce conclusions that a business can actually trust.**