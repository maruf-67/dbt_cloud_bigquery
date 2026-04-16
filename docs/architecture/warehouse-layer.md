# Warehouse Layer: Modeling Strategy

## Overview
The BigQuery warehouse is structured into three distinct layers to ensure data integrity, performance, and clear lineage.

## 1. BASE Layer (Source Alignment)
- **Role**: Raw data exactly as ingested from sources (GA4, LinkedIn, Salesforce, etc.).
- **Access**: Restricted to Data Engineers.
- **Rules**: Minimal transformation. Union heterogeneous table shards (e.g., `events_*`) into unified base views if necessary.

## 2. STAGING Layer (Normalization & Deduplication)
- **Role**: Where broad source-specific logic is applied and PII is handled.
- **Key Operations**:
  - **Deduplication**: Use `QUALIFY row_number() OVER (PARTITION BY event_id ORDER BY ingested_at DESC) = 1`.
  - **Flattening**: UNNESTing GA4 arrays or Salesforce JSON fields.
  - **Hashing**: Enforcing SHA-256 for email/identity fields.
  - **Naming**: Converting source-specific names to project-standard naming conventions.

## 3. MART Layer (Business Logic & Performance)
- **Role**: Highly optimized, denormalized tables for LookerML and AI training.
- **Key Models**:
  - `mart_survey_funnel`: End-to-end journey from start to completion.
  - `mart_lead_summary`: Consolidated view of leads from all platforms.
  - `dim_identity_map`: The source of truth for user recognition.
- **Optimization**:
  - **Partitioning**: Always partition by `event_date` or `created_at`.
  - **Clustering**: Cluster on high-cardinality fields like `campaign_id` or `hashed_email` for performance.
  - **Materialization**: Use `table` or `materialized_view` for performance stabilization on large datasets.

## Data Quality (dbt Tests)
- **Contracts**: Enforce schema constraints on staging models.
- **Freshness**: Continuous source monitoring to ensure the warehouse is never stale.
- **Validity**: Multi-source reconciliation (e.g., checking if GA4 lead counts match Salesforce lead counts).
