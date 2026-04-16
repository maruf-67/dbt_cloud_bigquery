# Reporting Layer: Visualization & Insights

## Overview
The reporting layer provides the business interface to the warehouse data. It is primarily powered by **Looker Studio** and **LookerML** for semantic consistency.

## Dashboard Architecture

### 1. Executive Dashboards (L1)
- **Objective**: High-level KPIs (Spend, ROAS, Lead Volume, Conversion Rates).
- **Source**: Directly connected to `MART` tables.
- **Performance**: Uses **Scheduled Extracts** to ensure sub-second report loading times.

### 2. Operational In-Depth (L2)
- **Objective**: Campaign-level optimization and journey analysis.
- **Functionality**: Dynamic filtering by campaign, UTM source, and date range.
- **Optimization**: All queries are date-partitioned to minimize BigQuery compute costs.

### 3. Data Science & AI Export (L3)
- **Objective**: Clean, wide tables for ML training and statistical analysis.
- **Source**: Specialized marts with longitudinal data (e.g., journey sequences).
- **Security**: Strict enforcement of hashed PII only.

## LookerML Transition
As the project grows, we will implement **LookerML** to define a centralized semantic layer. This ensures that "Conversion Rate" and "Lifetime Value" have exactly one definition across all reports, regardless of which dashboard or analyst accesses the data.
