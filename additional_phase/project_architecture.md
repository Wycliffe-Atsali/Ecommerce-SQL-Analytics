# Project Architecture

This document provides a high-level overview of the **Retail SQL Business Analysis** project architecture, showing how the dataset, database, development tools, SQL analysis, documentation, version control, and final portfolio repository fit together.

The project architecture can be viewed from two perspectives:

1. **Technical architecture** — how the technologies and project components interact.
2. **Analytical architecture** — how the project progressed from raw data to business analysis and final recommendations.

---

## 1. Technical Project Architecture

```text
                    OLIST DATASET
                         │
                         ▼
                ┌─────────────────┐
                │   CSV DATASETS  │
                │                 │
                │  9 Olist Tables │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │    PostgreSQL   │
                │    Database     │
                └────────┬────────┘
                         │
             ┌───────────┴───────────┐
             │                       │
             ▼                       ▼
      ┌──────────────┐       ┌──────────────┐
      │   pgAdmin 4  │       │  VS Code     │
      │              │       │              │
      │ Database     │       │ SQL          │
      │ Management   │       │ Development  │
      │ Query Tool   │       │ Documentation│
      └──────┬───────┘       └──────┬───────┘
             │                      │
             └──────────┬───────────┘
                        ▼
                ┌─────────────────┐
                │  SQL Analysis   │
                │                 │
                │ 38 SQL Files    │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Investigation   │
                │ Reports         │
                │                 │
                │ 48 Reports      │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Business        │
                │ Insights &      │
                │ Recommendations │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Git / GitHub    │
                │                 │
                │ Portfolio       │
                │ Repository      │
                └─────────────────┘
```

---

## 2. Analytical Architecture

The project follows a progressive analytical development path:

```text
Raw Olist Data
      │
      ▼
Database Design & Implementation
      │
      ▼
Data Validation & Quality Assessment
      │
      ▼
Exploratory SQL Analysis
      │
      ▼
Aggregate SQL Analysis
      │
      ▼
Relational SQL Analysis
      │
      ▼
Advanced SQL Techniques
      │
      ▼
Window Function Analysis
      │
      ▼
Strategic Business Analytics
      │
      ▼
Customer & Seller Performance
      │
      ▼
Revenue Opportunity Analysis
      │
      ▼
Executive KPI Development
      │
      ▼
Executive Business Review
      │
      ▼
Executive Reporting
      │
      ▼
Business Recommendations
      │
      ▼
SQL Optimisation
      │
      ▼
Technical Interview Preparation
      │
      ▼
Project Retrospective
      │
      ▼
PROJECT COMPLETE
```

---

## 3. Analytical Methodology

The project progressively developed from individual SQL queries into a structured business-analysis methodology.

The core workflow became:

```text
Business Problem
       ↓
Business Objective
       ↓
Analytical Grain
       ↓
Population Definition
       ↓
Metric Definition
       ↓
SQL Construction
       ↓
Validation
       ↓
Business Findings
       ↓
Interpretation
       ↓
Recommendations
```

For more advanced investigations, the methodology expanded to:

```text
Business Objective
       ↓
Metric Definition
       ↓
Analytical Dataset
       ↓
Standardisation
       ↓
Scoring
       ↓
Classification
       ↓
Business Interpretation
       ↓
Executive Recommendation
```

This progression reflects the project's development from learning SQL syntax toward applying SQL as a tool for structured business analysis and decision support.

---

## 4. Repository Architecture

The final repository separates the main components of the project according to their purpose:

```text
Retail-SQL-Business-Analysis/
│
├── data/
│   └── Olist CSV datasets
│
├── database/
│   ├── create_tables.sql
│   ├── database_profile.md
│   ├── schema.dbml
│   ├── schema.png
│   ├── schema.reviews.md
│   └── schema_notes.md
│
├── sql/
│   └── 38 SQL analysis files
│
├── report/
│   ├── Investigation reports
│   ├── data_quality_report.md
│   ├── implementation_notes.md
│   └── import_validation.sql
│
├── results/
│   └── Executive analysis results
│
├── images/
│
├── presentation/
│
├── additional_phase/
│   ├── audit.md
│   ├── technology.md
│   ├── project_structure.md
│   ├── how_to_run.md
│   ├── key_findings.md
│   └── project_architecture.md
│
├── .gitignore
├── README.md
└── CHANGELOG.md
```

The `additional_phase/` documents are **supporting portfolio documentation**. They do not represent additional investigations or analytical phases.

---

## 5. Project Completion Architecture

The completed project can therefore be summarised as:

```text
                    DATA
                     │
                     ▼
              DATABASE DESIGN
                     │
                     ▼
              SQL DEVELOPMENT
                     │
                     ▼
             BUSINESS ANALYSIS
                     │
                     ▼
            STRATEGIC ANALYTICS
                     │
                     ▼
           EXECUTIVE COMMUNICATION
                     │
                     ▼
             TECHNICAL REVIEW
                     │
                     ▼
              DOCUMENTATION
                     │
                     ▼
             PORTFOLIO PROJECT
                     │
                     ▼
              PROJECT COMPLETE
```

The architecture demonstrates that the project is not simply a collection of SQL queries. It represents a complete progression from **raw relational data → database implementation → SQL analysis → business insight → executive communication → professional portfolio**.
