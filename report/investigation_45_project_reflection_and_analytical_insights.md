# Investigation 45 — Project Reflection & Analytical Insights

## Phase 9 — Executive Reporting & Business Recommendations

---

## 1. Investigation Overview

### Objective

Reflect on the complete Olist SQL analytics project and evaluate the analytical journey from relational data exploration through advanced SQL analysis, strategic business analytics, executive interpretation, and management recommendations.

Unlike the preceding investigations, this investigation does not introduce a new business analysis. Its purpose is to assess:

- the most valuable SQL and analytical techniques learned;
- the major analytical challenges encountered;
- the methodological decisions and assumptions made;
- the limitations of the Olist dataset;
- the most important or unexpected findings;
- business questions that the available data could not answer;
- opportunities for future analytical development.

The investigation therefore evaluates not only **what the project found**, but also **how the analysis was conducted and how the quality of the conclusions was controlled**.

### Overall Analytical Journey

The project evolved through the following progression:

> **SQL Syntax → Relational Analysis → Analytical Modelling → Business Interpretation → Executive Decision Support**

The most important outcome was therefore not simply learning more SQL functions. It was developing the ability to use SQL as a tool for producing reliable business evidence.

---

# 2. The Analytical Journey

The project began with the practical implementation of a PostgreSQL database using the Brazilian E-Commerce Public Dataset by Olist.

The early phases established:

- relational database structure;
- table relationships;
- primary and foreign-key relationships;
- data validation;
- basic exploratory analysis;
- aggregate analysis;
- customer, product, seller, payment and review analysis.

The project then progressed into increasingly sophisticated analytical work:

```text
Database Design
      ↓
Data Validation
      ↓
Exploratory Analysis
      ↓
Aggregate Analysis
      ↓
Relational Analysis
      ↓
CTEs and Views
      ↓
Window Functions
      ↓
Strategic Business Analytics
      ↓
Executive Reporting
      ↓
Business Recommendations
      ↓
Analytical Reflection
```

This progression changed the nature of the work.

The project moved from asking:

> "How do I write this SQL query?"

toward:

> "What exactly am I measuring, why am I measuring it, and what does the evidence allow me to conclude?"

That shift represents the most important development in the project.

---

# 3. Most Valuable SQL and Analytical Techniques Learned

## 3.1 Relational Joins

Working with the nine-table Olist schema provided practical experience with relational data modelling.

The project required understanding relationships between:

- `customers`
- `orders`
- `order_items`
- `order_payments`
- `order_reviews`
- `products`
- `sellers`
- `geolocation`
- `product_category_name_translation`

This produced an important analytical lesson:

> **Join logic is analytical logic.**

A query can be syntactically correct while still producing an incorrect business result if the relationship between tables changes the intended grain.

This became particularly important when working with one-to-many relationships such as orders and order items or orders and payments.

---

## 3.2 Analytical Grain

One of the most valuable concepts developed throughout the project was explicitly defining the analytical grain before calculating metrics.

Examples included:

- one row per order;
- one row per customer;
- one row per seller;
- one row per product;
- one row per customer segment.

This became especially important in customer-level analyses.

For CLV and RFM, the analytical grain was:

> **One row per `customer_unique_id`**

This prevented transaction-level records from being incorrectly interpreted as separate customers.

The broader lesson was:

> **Aggregation should follow the business entity being measured, not simply the table from which the data originated.**

---

## 3.3 Aggregation and Conditional Aggregation

Early investigations developed practical understanding of:

- `COUNT()`;
- `COUNT(DISTINCT ...)`;
- `SUM()`;
- `AVG()`;
- `MIN()`;
- `MAX()`;
- `GROUP BY`;
- `HAVING`;
- conditional aggregation.

These techniques eventually became building blocks for:

- customer revenue;
- purchase frequency;
- seller activity;
- review performance;
- delivery metrics;
- product/category performance;
- executive KPIs.

The important progression was from learning aggregation syntax to understanding **what business entity the aggregation represents**.

---

## 3.4 CTEs

Common Table Expressions became increasingly important as the investigations became more complex.

Instead of solving an entire business question in one block of SQL, the analysis could be separated into logical stages:

```text
Population
    ↓
Metric Construction
    ↓
Standardisation
    ↓
Scoring
    ↓
Classification
    ↓
Validation
    ↓
Final Output
```

This structure was particularly valuable in:

- Customer Lifetime Value;
- RFM segmentation;
- seller performance scorecards;
- product portfolio analysis;
- delivery analysis;
- revenue opportunity analysis;
- executive KPI development.

CTEs therefore became more than a syntax feature. They became a way of making the **analytical reasoning visible inside the SQL**.

---

## 3.5 Views

Views introduced another important concept: reusable analytical outputs.

Rather than recreating complex analytical logic every time a result was needed, the project developed reusable views for downstream analysis and dashboarding.

This demonstrated how SQL can move from one-off analysis toward **repeatable analytical infrastructure**.

---

## 3.6 Window Functions

Window functions represented a major technical progression.

The project applied:

- `ROW_NUMBER()`;
- `RANK()`;
- `DENSE_RANK()`;
- `NTILE()`;
- `LAG()`;
- `LEAD()`;
- `FIRST_VALUE()`;
- `LAST_VALUE()`.

These were used for:

- ranking sellers;
- identifying recent customer activity;
- comparing observations;
- analysing purchase sequences;
- creating relative performance scores;
- supporting percentile-based frameworks.

A particularly important lesson was the difference between aggregation and window functions:

> **Aggregation reduces rows to a new grain, while window functions add analytical context without necessarily removing the underlying rows.**

---

## 3.7 Percentiles and Distribution Analysis

The project also developed practical experience with distribution analysis through functions such as:

- `PERCENTILE_CONT()`;
- `PERCENT_RANK()`;
- `NTILE()`.

These techniques were important because averages alone could not fully describe highly skewed e-commerce behaviour.

Percentiles were used to understand:

- revenue distributions;
- customer value;
- delivery-time distributions;
- relative customer positions;
- seller performance;
- opportunity scores.

This reinforced the lesson that **distribution matters as much as the average** when analysing commercial data.

---

## 3.8 Standardisation and Weighted Scoring

The later strategic investigations introduced a more advanced analytical problem.

Different metrics exist on different scales.

For example:

- revenue is measured in currency;
- order activity is measured in counts;
- review scores are measured from 1–5;
- delivery performance is expressed as a percentage;
- product diversity is measured as a count.

These metrics cannot be meaningfully combined in their raw form.

The project therefore developed the framework:

> **Raw Metric → Standardised Score → Weighted Score → Business Classification**

This was particularly important in the seller performance scorecard and opportunity analysis.

The key lesson was:

> A composite score is only meaningful when the metric definitions, standardisation method, weighting scheme and classification thresholds are explicitly justified.

---

# 4. Major Analytical Challenges

## 4.1 Understanding the Relational Structure

The Olist dataset required understanding several connected entities rather than treating the data as a single flat table.

The challenge was not simply learning foreign keys. It was understanding how business events move through the schema:

```text
Customer
   ↓
Order
   ↓
Order Items
   ↓
Product / Seller
   ↓
Payment / Review / Delivery
```

Understanding this structure was necessary before reliable business metrics could be constructed.

---

## 4.2 Preventing Double Counting

One of the most important practical challenges was avoiding inflated metrics caused by one-to-many joins.

For example:

```text
orders
   ↓
order_items
```

can create multiple rows for a single order.

Likewise, payment and review relationships require careful consideration when combined with order-level data.

This produced a key analytical habit:

> **Before aggregating, verify what one row represents after every major join.**

This was one of the most valuable lessons of the project because a query can execute successfully while still producing an incorrect business answer.

---

## 4.3 Defining Revenue

Revenue definition required deliberate methodological judgement.

For the main historical customer and marketplace revenue analyses, the project used:

> **`SUM(order_payments.payment_value)` for delivered orders**

This was selected as the consistent marketplace revenue definition for those analyses.

However, the project also recognised that item-level calculations such as:

> `order_items.price + freight_value`

can answer a different business question, particularly when attributing value to sellers or product categories.

The lesson was:

> **A metric should be defined according to the business question rather than selected solely because a column appears convenient.**

---

## 4.4 Defining the Customer

The distinction between:

- `customer_id`
- `customer_unique_id`

was another important analytical issue.

The project used `customer_unique_id` for customer-level behavioural and lifetime analysis because it more appropriately represents the underlying customer across transactions.

This decision became fundamental to:

- CLV;
- RFM;
- repeat-purchase analysis;
- customer segmentation.

---

## 4.5 Moving From Metrics to Business Meaning

Another major challenge was moving beyond descriptive results.

For example:

```text
Approximately 97% of active customers are one-time purchasers
```

is a metric.

The analytical interpretation is:

```text
Large one-time-customer population
        ↓
Weak observed repeat purchasing
        ↓
Potential retention opportunity
        ↓
Customer re-engagement strategy
        ↓
Repeat-purchase KPI
```

Likewise:

```text
Long delivery durations
        ↓
Lower average review scores
        ↓
Operational investigation
```

This transition from **metric → interpretation → action** became increasingly important during Phase 8 and Phase 9.

---

# 5. Data Quality and Dataset Limitations

## 5.1 Historical Dataset

The Olist dataset represents a historical period rather than current marketplace activity.

Therefore, findings describe observed historical behaviour and should not automatically be interpreted as forecasts of present-day performance.

---

## 5.2 Missing Customer Acquisition and Marketing Economics

The dataset does not provide:

- customer acquisition cost;
- campaign expenditure;
- marketing channel costs;
- campaign exposure;
- campaign response history.

As a result, the project can identify a large repeat-purchase opportunity but cannot establish the ROI of a specific retention campaign.

---

## 5.3 Limited Profitability Information

The available transaction data does not provide a complete profitability model.

Missing information includes:

- product margins;
- seller commissions;
- logistics costs;
- operating expenses;
- marketing costs;
- other marketplace-level costs.

Therefore:

> **Revenue should not be interpreted as profit.**

The project appropriately focused primarily on revenue and commercial activity where profitability data was unavailable.

---

## 5.4 Limited Causal Evidence

The dataset is observational.

It records what happened historically, but it does not provide controlled exposure to different interventions.

Therefore, the project cannot establish that:

- faster delivery causes higher review scores;
- incentives cause customers to repurchase;
- seller interventions cause improved performance;
- recommendations cause additional revenue.

This limitation became especially important when translating findings into management recommendations.

---

## 5.5 Delivery Data Limitations

The delivery timestamps allow delivery duration to be measured, but they do not provide a complete causal explanation for every delay.

A delay may reflect:

- seller handling;
- logistics;
- geography;
- fulfilment;
- route constraints;
- other operational factors.

Consequently, the project can identify patterns and areas for investigation but cannot always identify the precise operational cause.

---

# 6. Major Methodological Assumptions

| Decision | Analytical Rationale |
|---|---|
| Delivered orders used for historical customer and revenue analysis | Focuses analysis on completed transactions |
| `customer_unique_id` used for customer-level analysis | Better represents the underlying customer across transactions |
| `order_payments.payment_value` used as the primary marketplace revenue definition | Provides a consistent transaction-level revenue measure |
| Analytical grain explicitly defined | Reduces aggregation and join errors |
| RFM used for behavioural segmentation | Converts purchasing history into actionable customer groups |
| Metrics standardised before weighted scoring | Makes heterogeneous metrics comparable |
| Weighted seller scorecard used | Allows multiple performance dimensions to contribute according to business importance |
| Opportunity scores treated as prioritisation indicators | Prevents relative scores from being interpreted as revenue forecasts |
| Delivery/review relationship treated as associative | Avoids unsupported causal claims |
| 15+ day delivery band treated as analytical | Separates an analytical threshold from a universal operational SLA |

These assumptions are important because analytical results are shaped not only by SQL syntax but also by the definitions and decisions surrounding the SQL.

---

# 7. Unexpected and Particularly Valuable Findings

## 7.1 Approximately 97% of Active Customers Were One-Time Purchasers

This became one of the most important commercial findings in the project.

The result shifted the strategic discussion away from a purely acquisition-oriented perspective toward the potential value of increasing repeat purchasing among customers already acquired.

This finding ultimately became the highest-priority recommendation in Investigation 43.

---

## 7.2 One-Time Customers Represented a Large Revenue Base

The executive analysis showed that one-time customers were not simply a large population with negligible economic importance.

They represented a substantial proportion of historical delivered-order revenue.

This strengthened the interpretation that customer re-engagement could be commercially meaningful rather than merely a theoretical retention exercise.

---

## 7.3 Delivery Performance and Customer Reviews Were Associated

Orders taking 15+ days were associated with materially lower average review scores than faster deliveries.

The important analytical lesson was not simply the finding itself, but the interpretation.

The project deliberately avoided claiming:

> "Slow delivery causes poor reviews."

Instead, it concluded that:

> **Longer delivery duration is associated with weaker customer reviews and therefore warrants operational investigation.**

This distinction demonstrates the importance of separating association from causation.

---

## 7.4 High-Risk Sellers Represented a Targeted Rather Than Marketplace-Wide Problem

The seller scorecard identified a relatively small proportion of eligible sellers as High Risk.

This supported targeted intervention rather than imposing broad controls across the entire seller ecosystem.

The finding therefore changed the recommendation from a general seller-quality intervention to a more focused management approach.

---

## 7.5 Opportunity Does Not Equal Forecast

The revenue opportunity framework introduced another important analytical lesson.

A high opportunity score does not mean:

> "This entity will generate a specific amount of additional revenue."

Instead, it identifies an entity that is relatively attractive for further investigation.

This distinction became central to the final recommendation:

> **Validate opportunity through controlled pilots before committing significant investment.**

---

# 8. Business Questions the Project Could Not Answer

The project produced substantial descriptive and diagnostic evidence, but several commercially important questions remained outside the scope of the available data.

## Customer Economics

The project could not reliably determine:

- customer acquisition cost;
- true customer profitability;
- whether retention is cheaper than acquisition;
- which marketing channel produces the highest-value customers.

---

## Causal Questions

The project could not establish:

- whether faster delivery causes better reviews;
- whether discounts cause repeat purchasing;
- whether personalised recommendations increase conversion;
- whether seller interventions improve performance.

---

## Forecasting Questions

The project could not reliably forecast:

- future customer lifetime revenue;
- future customer churn;
- incremental revenue from opportunity scores;
- future seller performance;
- future regional demand.

---

## Profitability Questions

The project could not establish:

- category profitability;
- seller contribution margin;
- customer profitability;
- net profitability after logistics and operating costs.

These are not failures of the analytical process.

They demonstrate an important analytical principle:

> **The data defines the boundary of what can responsibly be concluded.**

---

# 9. Opportunities for Future Work

## 9.1 Customer Analytics

Future analysis could extend the project into:

- churn prediction;
- repeat-purchase propensity;
- predictive customer lifetime value;
- cohort analysis;
- next-purchase prediction;
- customer-level recommendation models.

---

## 9.2 Marketing Analytics

With campaign-level data, the project could investigate:

- campaign incrementality;
- A/B testing;
- customer acquisition cost;
- campaign ROI;
- marketing attribution;
- incentive effectiveness.

This would allow the project to move from identifying retention opportunities toward measuring the actual incremental impact of interventions.

---

## 9.3 Operational Analytics

With richer logistics data, future work could include:

- delivery-delay prediction;
- seller handling-time analysis;
- carrier performance;
- route-level analysis;
- operational root-cause modelling;
- service-level monitoring.

---

## 9.4 Commercial Analytics

With cost and margin data, the project could extend into:

- contribution-margin analysis;
- seller profitability;
- category profitability;
- price elasticity;
- promotion effectiveness;
- profitability-based customer segmentation.

---

## 9.5 Predictive and Causal Analytics

The project could eventually progress from:

> **Descriptive → Diagnostic → Predictive → Prescriptive Analytics**

Potential methods include:

- forecasting;
- propensity modelling;
- machine learning;
- survival analysis;
- causal inference;
- controlled experimentation.

This would allow future work to answer questions that historical descriptive SQL alone cannot answer.

---

# 10. Analytical Maturity Developed Through the Project

One of the strongest outcomes of the project is the development of a more disciplined analytical process.

The workflow evolved into:

```text
Business Question
        ↓
Define Population
        ↓
Define Analytical Grain
        ↓
Define Metrics
        ↓
Build SQL
        ↓
Validate Results
        ↓
Interpret Findings
        ↓
Assess Limitations
        ↓
Develop Business Implications
        ↓
Recommend Actions
        ↓
Define Success Metrics
```

This workflow became particularly visible in the strategic investigations.

The analysis did not stop when SQL returned a result.

The result had to be:

1. validated;
2. interpreted;
3. placed into business context;
4. checked against methodological limitations;
5. translated into an appropriate management implication.

This is a major distinction between **writing SQL queries** and **performing business analysis with SQL**.

---

# 11. Evolution of the Project's Analytical Philosophy

The project also developed several principles that should carry into future analytical work.

### Principle 1 — Define before calculating

A metric should have a clear:

- population;
- grain;
- definition;
- inclusion/exclusion rule.

### Principle 2 — Validate before interpreting

A plausible-looking result is not automatically a reliable result.

### Principle 3 — Separate observation from explanation

An observed relationship does not automatically establish causation.

### Principle 4 — Standardise before combining

Heterogeneous metrics should be placed on an appropriate common scale before weighted scoring.

### Principle 5 — Treat scores according to what they measure

A relative score is not automatically a forecast.

### Principle 6 — Recommendations should follow evidence

Management actions should be connected to validated findings rather than generic best practices.

### Principle 7 — Measure outcomes, not activities

Launching a campaign is not success.

Improving incremental repeat purchasing is success.

Launching an expansion initiative is not success.

Generating validated incremental commercial value is success.

---

# 12. Final Analytical Reflection

The Olist project began as an opportunity to develop practical SQL skills and evolved into a structured business analytics portfolio project.

The most important progression was not simply from basic SQL to advanced SQL.

It was from:

> **Querying data**

to:

> **Understanding data**

then:

> **Building analytical evidence**

then:

> **Interpreting evidence**

and finally:

> **Using evidence to support business decisions.**

The project demonstrated that technically sophisticated SQL is only one part of effective analytics.

Reliable business analysis also requires:

- clear definitions;
- correct analytical grain;
- careful joins;
- validation;
- appropriate metric construction;
- transparent assumptions;
- awareness of data limitations;
- cautious interpretation;
- measurable recommendations.

The project also reinforced the importance of analytical restraint.

A customer segment can identify an opportunity without proving future behaviour.

A delivery/review relationship can identify an operational concern without proving causation.

A scorecard can prioritise an entity without forecasting its future performance.

A revenue metric can describe commercial activity without measuring profitability.

Recognising these boundaries strengthened the quality of the final recommendations.

---

# 13. Final Project Learning

The central lesson from the project can be summarised as:

> **Good SQL produces accurate results. Good analytics produces defensible insights. Good business analysis connects those insights to measurable decisions without exceeding what the evidence supports.**

The project ultimately developed all three layers:

```text
SQL Capability
     ↓
Analytical Capability
     ↓
Business Decision Capability
```

The final strategic narrative developed in the later phase —:

> **RETAIN → IMPROVE → EXPAND**

— reflects this progression.

**Retain** by increasing the value of existing customers and protecting strong-performing sellers.

**Improve** by addressing delivery reliability and targeted operational weaknesses.

**Expand** by validating commercially attractive sellers, categories and regions before committing significant investment.

The most important conclusion of the entire project is therefore not simply that the marketplace should grow.

It is that:

> **Growth should be made more efficient and sustainable by increasing the value of existing customers, strengthening operational reliability, and scaling validated opportunities through controlled investment.**

---

# 14. Portfolio and Interview Value

The completed project demonstrates practical experience across several dimensions of SQL and business analytics.

### SQL Capability

- PostgreSQL;
- multi-table joins;
- aggregation;
- conditional aggregation;
- `COUNT(DISTINCT)`;
- CTEs;
- views;
- subqueries;
- date/time analysis;
- `CASE` expressions;
- window functions;
- ranking;
- percentile analysis;
- standardisation;
- weighted scoring.

### Data Modelling

- relational schema interpretation;
- primary and foreign-key relationships;
- analytical grain definition;
- one-to-many relationship management;
- customer identity resolution.

### Analytical Reasoning

- metric definition;
- population selection;
- score construction;
- segmentation;
- opportunity prioritisation;
- validation;
- limitation assessment.

### Business Communication

- executive KPI development;
- insight generation;
- evidence-based recommendations;
- prioritisation;
- KPI definition;
- risk framing;
- causal restraint.

The project therefore demonstrates more than the ability to write SQL.

It demonstrates the ability to use SQL as part of an end-to-end analytical workflow.

---

# 15. Investigation Outcome

Investigation 45 completes the reflective component of the project by evaluating the analytical journey rather than introducing another business question.

The investigation establishes that the project's most important development was the progression from technical SQL execution toward disciplined business analysis.

The strongest lessons were:

1. **Analytical grain must be defined before aggregation.**
2. **Join logic can materially affect business metrics.**
3. **Metric definitions must reflect the business question.**
4. **Complex SQL is most useful when structured into transparent analytical stages.**
5. **Composite scores require explicit standardisation and weighting assumptions.**
6. **Historical observational data supports evidence-based prioritisation but does not automatically establish causation or forecast future outcomes.**
7. **Recommendations should be measurable and tied directly to validated evidence.**
8. **Understanding what the data cannot answer is an essential part of analytical maturity.**

The project therefore concludes with a stronger analytical framework than the one with which it began:

> **Define → Analyse → Validate → Interpret → Challenge → Recommend → Measure**

This framework provides a foundation for future projects involving more advanced predictive, experimental and causal analytics.
