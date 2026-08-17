# How to Run the Project

This document provides the steps required to set up, reproduce, and navigate the Retail SQL Business Analysis project using the files contained in the repository.

The project uses PostgreSQL for database management, pgAdmin 4 for database administration and SQL execution, Visual Studio Code for SQL and Markdown development, and Git/GitHub for version control and project distribution.

# 1. Project Requirements

The following tools are required:

* PostgreSQL
* pgAdmin 4
* Visual Studio Code
* Git

The project uses the Brazilian E-Commerce Public Dataset by Olist.

The repository contains the nine CSV datasets required by the database schema in the:

```text
data/
```

directory.

# 2. Clone the Repository

Clone the repository from GitHub and navigate into the project directory.

```bash
git clone <repository-url>
cd Ecommerce-SQL-Analytics
```

Open the project in Visual Studio Code:

```bash
code .
```

The repository contains the following core directories:

```text
data/
database/
sql/
report/
results/
additional_phase/
```

The main project documentation is located in:

```text
README.md
CHANGELOG.md
PROJECT_STRUCTURE.md
```

# 3. Create the PostgreSQL Database

Open pgAdmin 4.

From the browser panel:

```text
Servers
└── PostgreSQL
    └── Databases
```

Right-click **Databases** and select:

```text
Create → Database
```

Create the PostgreSQL database that will contain the Olist tables.

Once created, select the database from the pgAdmin browser.

# 4. Open the Query Tool

The SQL used to create and analyse the database can be executed through the pgAdmin Query Tool.

In pgAdmin:

```text
Databases
└── <your database>
    └── Right-click
        └── Query Tool
```

Alternatively, depending on the pgAdmin interface, select the database and open:

```text
Tools → Query Tool
```

The Query Tool provides the environment used to execute SQL statements against the selected PostgreSQL database.

# 5. Create the Database Tables

The database schema is defined in:

```text
database/create_tables.sql
```

Open this file in Visual Studio Code or pgAdmin's Query Tool.

Execute the SQL against the newly created PostgreSQL database.

The project contains nine core Olist tables:

```text
customers
geolocation
orders
order_items
order_payments
order_reviews
products
sellers
product_category_name_translation
```

The database documentation and schema references are available in:

```text
database/
```

including:

```text
database_profile.md
schema.dbml
schema.png
schema.reviews.md
schema_notes.md
```

# 6. Import the CSV Data

The corresponding CSV files are located in:

```text
data/
```

The nine datasets should be imported into their respective PostgreSQL tables.

The import process should preserve the table structure established by:

```text
database/create_tables.sql
```

When importing through pgAdmin, ensure that each CSV is mapped to the correct table and that the column order and data types are compatible with the database schema.

# 7. Validate the Database

After importing the data, validate that the database was populated correctly.

The repository contains:

```text
report/import_validation.sql
```

Run the validation queries against the PostgreSQL database.

Additional documentation is available in:

```text
report/data_quality_report.md
report/implementation_notes.md
```

These documents provide the project's existing validation and implementation context.

# 8. Review the Database Structure

The database structure can be inspected directly through pgAdmin.

Navigate through:

```text
Databases
└── <your database>
    └── Schemas
        └── public
            └── Tables
```

Expanding individual tables allows you to inspect:

* Columns
* Data types
* Primary keys
* Foreign keys
* Constraints
* Indexes
* Table data

The repository also contains a visual representation of the schema:

```text
database/schema.png
```

# 9. Run the SQL Investigations

The project's analytical SQL files are located in:

```text
sql/
```

The files are numbered according to the project's SQL development sequence:

```text
01_data_exploration.sql
02_sales_analysis.sql
03_customer_analysis.sql
...
38_sql_optimisation_performance.sql
```

Open the required SQL file in Visual Studio Code and execute its queries through the pgAdmin Query Tool.

The SQL files contain the analytical queries used throughout the project.

# 10. Navigate from an Investigation to Its Report

Each investigation has a corresponding Markdown report in:

```text
report/
```

The reports document the analytical investigation surrounding the SQL work.

The general workflow is:

```text
Investigation
      ↓
SQL Analysis
      ↓
Query Results
      ↓
Findings
      ↓
Business Interpretation
      ↓
Report
```

For example:

```text
Investigation 35
        ↓
sql/29_rfm_customer_segmentation.sql
        ↓
report/investigation_35_rfm_customer_segmentation.md
```

Because SQL files and investigations are not strictly one-to-one, some SQL files support more than one investigation.

The complete investigation and SQL mapping is documented in:

```text
README.md
PROJECT_STRUCTURE.md
```

# 11. Review Generated Results

The repository contains:

```text
results/
```

This directory stores selected analytical outputs produced during the project.

The current repository includes:

```text
results/executive_business_review_results.csv
```

These results provide an example of how analytical outputs can be retained separately from the SQL scripts and reports.

# 12. Use Visual Studio Code for Development

Visual Studio Code is used primarily for:

* Writing SQL
* Reviewing SQL scripts
* Writing Markdown reports
* Reviewing repository files
* Managing project documentation
* Working with Git

The project can be opened from the repository root:

```bash
code .
```

A typical workflow is:

```text
Visual Studio Code
      │
      ├── SQL development
      ├── Markdown documentation
      └── Git version control
             │
             ▼
          GitHub
```

SQL execution itself is performed against PostgreSQL through the pgAdmin Query Tool.

# 13. Navigate the Project by Phase

The project progresses from foundational database work through increasingly advanced analytical work.

The overall analytical workflow is:

```text
Database Implementation
        ↓
Exploratory Analysis
        ↓
Aggregate Analysis
        ↓
Relational Analysis
        ↓
Advanced SQL
        ↓
Window Functions
        ↓
Strategic Business Analytics
        ↓
Executive Reporting
        ↓
Business Recommendations
        ↓
SQL Optimisation & Technical Review
        ↓
Project Complete
```

The corresponding investigations, SQL files, and reports can be identified through:

```text
README.md
PROJECT_STRUCTURE.md
```

# 14. Review the Documentation

The repository contains several levels of documentation.

## Project Overview

```text
README.md
```

Provides the overall project purpose, methodology, phases, investigations, SQL skills, and project status.

## Project History

```text
CHANGELOG.md
```

Documents major project milestones and changes over time.

## Project Structure

```text
PROJECT_STRUCTURE.md
```

Provides a concise reference to the repository's files and structure.

## Database Documentation

```text
database/
```

Contains schema, implementation, and database-related documentation.

## Investigation Reports

```text
report/
```

Contains the Markdown reports for the project's 48 investigations.

## Additional Documentation

```text
additional_phase/
```

Contains supporting portfolio documentation that is separate from the 48 core investigations.

# 15. Recommended Reproduction Workflow

For someone reproducing the project from the beginning, the recommended sequence is:

```text
1. Clone repository
        ↓
2. Install PostgreSQL and pgAdmin 4
        ↓
3. Create PostgreSQL database
        ↓
4. Open pgAdmin Query Tool
        ↓
5. Execute database/create_tables.sql
        ↓
6. Import the nine CSV datasets
        ↓
7. Execute report/import_validation.sql
        ↓
8. Review database documentation
        ↓
9. Open SQL files from sql/
        ↓
10. Execute investigations through pgAdmin
        ↓
11. Review corresponding reports from report/
        ↓
12. Review analytical results
        ↓
13. Review executive and project documentation
```

# 16. Important Repository Principle

The repository separates data, database implementation, SQL analysis, results, and documentation.

```text
data/
    Raw Olist datasets

database/
    PostgreSQL implementation and schema documentation

sql/
    Analytical SQL development

results/
    Selected analytical outputs

report/
    Investigation reports

additional_phase/
    Supporting portfolio documentation
```

This separation allows the project to be reproduced while keeping the analytical code, database implementation, and business documentation clearly organised.

# 17. Project Completion

The core analytical project is considered complete after Phase 10, consisting of:

* 48 completed investigations.
* 38 SQL analysis files.
* 10 completed core phases.

The documents contained within `additional_phase/` are supporting portfolio documentation and do not constitute additional business investigations.

The repository can therefore be used in two ways:

**As a learning project:** follow the phases sequentially from database implementation through the final technical investigations.

**As a portfolio project:** begin with `README.md`, review the project structure and key findings, then explore the relevant SQL scripts and investigation reports.
