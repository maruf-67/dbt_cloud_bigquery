# Roadmap: Phase 2 - Data Warehouse & Multi-Source Integration

## Objectives
Establish a robust, standardized warehouse layer that consumes data from Meta, LinkedIn, and Salesforce, normalizing them into unified staging and mart layers.

## Key Milestones

### 1. Unified Staging (Normalization)
- [ ] Implement `stg_meta_ads` mapping Meta fields to unified reporting keys.
- [x] Implement `stg_linkedin_leads` mapping LinkedIn fields to unified reporting keys.
- [ ] Implement `stg_hubspot_contacts` (formerly Salesforce) with `hashed_email` identity resolution.
- [x] Implement `stg_ga4_events` with strict data contracts.

### 2. Multi-Source Lead Orchestration
- [x] Develop `dim_identity_map` incorporating identifiers from all new sources.
- [x] Create `fct_survey_conversions` unioning lead data from Supabase and GA4.
- [ ] Establish `fct_opportunity_pipeline` for CRM-driven sales metrics.

### 3. Data Integrity & Contracts
- [x] Apply `dbt-utils` or `dbt-expectations` for cross-source uniqueness checks.
- [x] Enforce SHA-256 hashing at the staging boundary for PII.
- [x] Define LookerML-compatible materialized views for executive reporting (SQL Stubs).

## Acceptance Criteria
- [ ] Zero duplicate lead records across sources (via identity graph), validated in production datasets.
- [ ] Unified "Marketing Efficiency" dashboard showing spend vs. opportunity value across all platforms.
- [x] Sanitized, typed datasets ready for Data Science and ML extraction (`mart_ai_training_set`).

**Current Status:** Integration is ~70% complete. Waiting on active Airbyte/Fivetran connectors for Meta Ads and Hubspot to finalize the pipeline.
