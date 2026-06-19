Data Warehouse & Business Analytics Portfolio Project:

Welcome! This repository showcases an end-to-end data warehousing and business intelligence solution. The project covers everything from building a structured data warehouse to extracting actionable insights that drive business decisions. I designed this specifically as a portfolio piece to highlight modern, industry-standard practices in data engineering and analytics.

🚀 Project Overview & Requirements

🛠 Building the Data Warehouse (Data Engineering)

Objective
The goal here was to build a modern data warehouse using SQL Server. By consolidating scattered sales data into a centralized repository, the system provides a clean, reliable foundation for analytical reporting and strategic planning.

Technical Specifications
Data Sources: Merged and ingested data from two distinct source systems (ERP and CRM) provided via CSV files.

Data Quality: Implemented robust data cleansing workflows to detect and resolve data anomalies, missing values, and formatting issues before running any analysis.

Data Integration: Unified both sources into a single, highly optimized, and user-friendly data model tailored specifically for fast analytical queries.

Project Scope: Focused entirely on the latest current state of the dataset (data historization/SCDs were omitted based on requirements).

Documentation: Built comprehensive documentation of the final data model to ensure clear communication with both business stakeholders and technical team members.

📊 BI: Analytics & Reporting (Data Analytics)

Objective
With the data warehouse running smoothly, I built SQL-based analytics to uncover deep, data-driven insights into core business domains:

Customer Behavior: Tracking engagement, purchasing habits, and lifecycle trends.

Product Performance: Identifying top performers, seasonal demand, and inventory opportunities.

Sales Trends: Mapping revenue patterns over time to forecast future growth.

These insights deliver critical business metrics directly to stakeholders, transforming raw data into a powerful tool for strategic decision-making.

------------------------------------------------------------------------------------------------------------------------------------------------


🚀 Project Requirements

Building the Data Warehouse (Data Engineering)

Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

Specifications**

* Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.
* Data Quality: Cleanse and resolve data quality issues prior to analysis.
* Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.
* Scope: Focus on the latest dataset only; historization of data is not required.
* Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

------------------------------------------------------------------------------------------------------------------------------------------------

Repository Structure

data-warehouse-project/
├── datasets/                   # Raw datasets used for the project (ERP and CRM data)
│   ├── CRM_dataset/
│   ├── ERP_dataset/
│   └── placeholder
├── docs/                       # Project documentation and architecture details
│   ├── data_catalog.md         # Catalog of datasets, including field descriptions and metadata
│   └── placeholder
├── scripts/                    # SQL scripts for ETL and transformations
│   ├── bronze/                 # Scripts for extracting and loading raw data
│   ├── gold/                   # Scripts for creating analytical models
│   ├── silver/                 # Scripts for cleaning and transforming data
│   ├── init_database.sql       # Script to initialize the database structure
│   └── placeholder
├── tests/                      # Test scripts and quality files
│   ├── placeholder
│   ├── quality_check_silver.sql
│   └── quality_checks_gold.sql
├── LICENSE                     # License information for the repository
└── README.md                   # Project overview and instructions

------------------------------------------------------------------------------------------------------------------------------------------------

📜 License
This project is open-source and licensed under the MIT License. Feel free to explore, modify, fork, or use this code for your own projects with proper attribution.

🌟 About Me
Hey there! I'm Pragadesh K, a passionate Data Engineer who loves building clean pipelines, optimizing databases, and turning messy data into structured, meaningful insights. I enjoy working on end-to-end data architectures and solving complex analytical challenges.

Feel free to explore the repository, and let me know if you have any questions or feedback!
