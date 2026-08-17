# Additional Phase --- Technology Guide

## Purpose

This document explains how the technologies used throughout the Olist
SQL project fit together and provides a practical guide for future
development.

The core project is complete through **Phase 10**. This guide does not
introduce another analytical phase or investigation.

------------------------------------------------------------------------

# 1. Technology Stack

  Technology   Main Purpose
  ------------ --------------------------------------------------------
  PostgreSQL   Relational database engine
  pgAdmin 4    PostgreSQL administration and query interface
  SQL          Database querying and analysis
  VS Code      SQL development, documentation, and repository editing
  Git          Version control
  GitHub       Remote repository and portfolio hosting
  Markdown     Project and analytical documentation

A useful mental model is:

> **VS Code → write and organise SQL and documentation**

> **PostgreSQL → store and process the data**

> **pgAdmin 4 → connect to and work with PostgreSQL**

> **Git → track project changes**

> **GitHub → store and present the project remotely**

------------------------------------------------------------------------

# 2. PostgreSQL

PostgreSQL is the database management system used for the project.

It stores the Olist tables, enforces relationships, executes SQL,
performs joins and aggregations, manages views and indexes, and produces
execution plans.

The project's core tables are:

-   `customers`
-   `orders`
-   `order_items`
-   `order_payments`
-   `order_reviews`
-   `products`
-   `sellers`
-   `geolocation`
-   `product_category_name_translation`

> **SQL is the language. PostgreSQL is the database system executing
> that language.**

------------------------------------------------------------------------

# 3. pgAdmin 4

pgAdmin 4 is the graphical interface used to work with PostgreSQL.

It provides tools for:

-   Connecting to PostgreSQL
-   Browsing databases and schemas
-   Inspecting tables and columns
-   Examining constraints and indexes
-   Opening the Query Tool
-   Executing SQL
-   Inspecting results
-   Examining execution plans
-   Managing PostgreSQL objects

> **PostgreSQL is the database engine; pgAdmin 4 is one interface used
> to work with that engine.**

------------------------------------------------------------------------

# 4. VS Code

VS Code acts as the primary development and documentation environment.

It is used for:

-   SQL development
-   Markdown editing
-   Repository navigation
-   Searching across project files
-   Git integration
-   Reviewing changes
-   Portfolio documentation

The main working areas are:

``` text
database/
sql/
report/
additional_phase/
README.md
CHANGELOG.md
PROJECT_STRUCTURE.md
```

------------------------------------------------------------------------

# 5. Git and GitHub

Git provides version control for the project.

The basic workflow is:

``` text
Edit
  ↓
git status
  ↓
git diff
  ↓
git add
  ↓
git diff --cached
  ↓
git commit
  ↓
git push
```

GitHub hosts the remote repository and provides the public-facing
portfolio representation of the project.

------------------------------------------------------------------------

# 6. Markdown

Markdown is used for the documentation layer.

Important project-level Markdown files include:

``` text
README.md
CHANGELOG.md
PROJECT_STRUCTURE.md
additional_phase/audit.md
additional_phase/technology.md
```

The 48 investigation reports in `report/` are also written in Markdown.

Markdown allows the project to communicate methodology, findings,
recommendations, technical decisions, and reflections alongside the SQL
code.

------------------------------------------------------------------------

# 7. How the Technologies Fit Together

``` text
                 Olist CSV Data
                       │
                       ▼
                  PostgreSQL
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
          pgAdmin               SQL
             │                   │
             └─────────┬─────────┘
                       ▼
                    Analysis
                       │
                       ▼
                    VS Code
               ┌───────┴───────┐
               ▼               ▼
              SQL          Markdown
               │               │
               └───────┬───────┘
                       ▼
                      Git
                       │
                       ▼
                    GitHub
```

The technologies therefore serve different but connected purposes.

------------------------------------------------------------------------

# 8. SQL Performance

Investigation 46 introduced PostgreSQL query-performance analysis using:

``` sql
EXPLAIN
```

and:

``` sql
EXPLAIN (ANALYZE, BUFFERS)
```

These capabilities help evaluate:

-   Sequential scans
-   Index scans
-   Bitmap scans
-   Join strategies
-   Sort operations
-   Aggregation
-   Estimated versus actual rows
-   Execution time
-   Buffer activity

The performance principle is:

> **Measure → modify → measure again**

rather than assuming an optimisation automatically improves performance.

------------------------------------------------------------------------

# 9. Recommended Technology Progression

The current project provides a strong SQL and PostgreSQL foundation.

A practical progression is:

``` text
Current Position
      │
      ▼
PostgreSQL + SQL
      │
      ▼
Python
      │
      ▼
Pandas + NumPy
      │
      ▼
Statistics + Visualisation
      │
      ▼
Power BI / BI
      │
      ▼
Data Modelling
      │
      ▼
ETL / ELT
      │
      ▼
Cloud / Data Warehousing
      │
      ▼
Advanced Analytics / Machine Learning
```

------------------------------------------------------------------------

# 10. Python

Python is a natural next major analytical technology after SQL.

It extends the workflow into a broader programming environment for:

-   Automation
-   Data processing
-   File handling
-   Statistical analysis
-   Visualisation
-   Modelling
-   Reusable analytical workflows

The initial focus should be:

-   Python syntax
-   Variables and data structures
-   Functions
-   Loops
-   File handling
-   Error handling
-   Modules
-   Virtual environments

------------------------------------------------------------------------

# 11. Pandas and NumPy

After Python fundamentals:

### Pandas

Useful for:

-   DataFrames
-   Data cleaning
-   Transformation
-   Exploratory analysis
-   Aggregation
-   Combining datasets
-   Exporting results

### NumPy

Useful for:

-   Numerical arrays
-   Vectorised calculations
-   Numerical operations
-   Scientific-computing foundations

A useful conceptual transition is:

``` text
SQL tables
    ↓
Pandas DataFrames
```

------------------------------------------------------------------------

# 12. Data Visualisation

Potential future technologies include:

-   Matplotlib
-   Seaborn
-   Plotly

The objective is not simply to produce charts.

The more important skill is choosing the visualisation that communicates
an analytical finding effectively.

------------------------------------------------------------------------

# 13. Business Intelligence

A BI platform such as Power BI can extend the analytical workflow into
interactive dashboards.

``` text
PostgreSQL
    ↓
SQL transformations
    ↓
Analytical dataset
    ↓
Power BI / BI tool
    ↓
Dashboard
    ↓
Business decision
```

Future skills can include:

-   Data loading
-   Data modelling
-   Relationships
-   Measures
-   DAX
-   Filters
-   Drill-through
-   Dashboard design
-   Executive storytelling

------------------------------------------------------------------------

# 14. ETL / ELT and Data Warehousing

Once SQL, Python, and BI are comfortable, the next conceptual step is
understanding production data movement.

Relevant topics include:

-   Extract, Transform, Load
-   Extract, Load, Transform
-   Data pipelines
-   Data quality
-   Scheduling
-   Orchestration
-   Fact tables
-   Dimension tables
-   Star schemas
-   Snowflake schemas
-   Slowly changing dimensions
-   Data marts
-   OLTP versus OLAP

------------------------------------------------------------------------

# 15. Cloud Data Platforms

Potential future areas include:

-   Cloud storage
-   Cloud databases
-   Cloud data warehouses
-   Cloud ETL/ELT
-   Identity and access management
-   Data orchestration

Potential platforms include:

-   AWS
-   Microsoft Azure
-   Google Cloud

The priority should be understanding the underlying architecture before
collecting platform-specific certifications.

------------------------------------------------------------------------

# 16. Advanced Analytics and Machine Learning

Machine learning should follow the analytical foundations established by
SQL and Python.

A sensible progression is:

``` text
SQL
  ↓
Python
  ↓
Pandas / NumPy
  ↓
Statistics
  ↓
Visualisation
  ↓
Data Modelling
  ↓
Machine Learning
```

The Olist project provides a useful foundation for future modelling
because it contains customer behaviour, transactions, reviews, delivery
performance, products, and sellers.

------------------------------------------------------------------------

# 17. Choosing What to Learn Next

A useful decision rule is:

> **Learn the next technology because it solves a problem your current
> technology does not solve efficiently.**

  Analytical Need                                    Appropriate Technology
  -------------------------------------------------- -------------------------------
  Relational database analysis                       SQL + PostgreSQL
  Database administration and interactive querying   pgAdmin 4
  Programming and automation                         Python
  DataFrame analysis                                 Pandas
  Numerical computing                                NumPy
  Visual communication                               Matplotlib / Seaborn / Plotly
  Interactive dashboards                             Power BI / Tableau
  Data movement                                      ETL / ELT
  Analytical infrastructure                          Data warehousing / cloud
  Predictive modelling                               Statistics / Machine Learning

------------------------------------------------------------------------

# 18. The Olist Project as a Foundation

The purpose of learning additional technologies is not to abandon the
SQL project.

The project can instead become a foundation for future portfolio work:

``` text
SQL version
    ↓
Customer and revenue analysis

Python version
    ↓
Deeper exploratory analysis

Visualisation version
    ↓
Visual explanation of findings

BI version
    ↓
Executive dashboard

Machine-learning version
    ↓
Customer churn or repeat-purchase modelling
```

This creates a connected portfolio progression rather than a collection
of unrelated projects.

------------------------------------------------------------------------

# Final Technology Statement

The overall development path can be summarised as:

> **SQL → Python → Pandas/NumPy → Statistics → Visualisation → BI → Data
> Modelling → ETL/ELT → Cloud/Data Warehousing → Advanced Analytics**

The goal is not simply to accumulate technologies.

The goal is to understand:

> **which technology is appropriate for a particular analytical problem,
> how the technologies connect, and how data and insight move through
> the analytical workflow.**
