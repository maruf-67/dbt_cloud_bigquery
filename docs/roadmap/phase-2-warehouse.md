# Roadmap: Phase 2 - Data Warehouse & Multi-Source Integration

## Objectives
Establish a robust, standardized warehouse layer that consumes data from Meta, LinkedIn, and Salesforce, normalizing them into unified staging and mart layers.

## Key Milestones

### 1. Unified Staging (Normalization)
- [ ] Implement `stg_meta_ads` mapping Meta fields to unified reporting keys.
- [ ] Implement `stg_linkedin_ads` mapping LinkedIn fields to unified reporting keys.
- [ ] Implement `stg_salesforce_leads` with `hashed_email` identity resolution.
- [ ] Implement `stg_ga4_events` with strict data contracts.

### 2. Multi-Source Lead Orchestration
- [ ] Develop `dim_identity_map` incorporating identifiers from all new sources.
- [ ] Create `fct_leads` unioning lead data from Salesforce, LinkedIn, and Supabase.
- [ ] Establish `fct_opportunity_pipeline` for Salesforce-driven sales metrics.

### 3. Data Integrity & Contracts
- [ ] Apply `dbt-utils` or `dbt-expectations` for cross-source uniqueness checks.
- [ ] Enforce SHA-256 hashing at the staging boundary for Salesforce/LinkedIn PII.
- [ ] Define LookerML-compatible materialized views for executive reporting.

## Acceptance Criteria
- Zero duplicate lead records across sources (via identity graph).
- Unified "Marketing Efficiency" dashboard showing spend vs. opportunity value across all platforms.
- Sanitized, typed datasets ready for Data Science and ML extraction.
