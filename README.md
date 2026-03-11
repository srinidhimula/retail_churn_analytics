# Retail Customer Churn & Revenue Analysis (dbt + BigQuery + Looker Studio)
![dbt](https://img.shields.io/badge/dbt-data--build--tool-orange)
![BigQuery](https://img.shields.io/badge/BigQuery-data--warehouse-blue)
![Looker](https://img.shields.io/badge/LookerStudio-dashboard-green)
![SQL](https://img.shields.io/badge/SQL-analytics-lightgrey)

This project analyzes transactional data from a UK-based online retail company selling all-occasion gifts (many customers are wholesalers).

Objective:
- Understand revenue trends
- Identify churn patterns
- Diagnose drivers of customer drop-off
- Build foundation for ML-based churn prediction

## Data Architecture
![Architecture](dashboard/data_architecture.png)

## Data Modeling Approach
Layered dbt architecture:
- staging → cleaned transactional data
- intermediate → customer-level metrics
- marts → business KPIs & churn flags
![DBT Lineage](dashboard/dbt_lineage.png)

## Dashboard Overview
### Page 1 — Churn Overview
- Overall churn rate
- Churn by country
- Customer type segmentation
![Dashboard1](dashboard/dashboard_page1.png)

### Page 2 — Revenue Diagnostics
Monthly revenue trend
- Active customers
- Average order value (AOV)
- Orders per active customer
![Dashboard2](dashboard/dashboard_page2.png)

## Key Insights
- Customer churn rate of 20% resulting in revenue risk of 5% amounting to £384K.
- High churn concentration observed in UK, France and Germany.
- Large portion of customers are one-time buyers, impacting retention stability.
- Revenue decomposition analysis to identify shifting Q4 growth drivers identified a high-margin surge in Sept/Oct (driven by Average Order Value) against a high-volume spike in November (driven by order volume).



