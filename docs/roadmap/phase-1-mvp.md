# Roadmap: Phase 1 - Foundation & MVP

## Objectives
Establish the core infrastructure, secure the production data connection, and build the first high-accuracy staging model.

## Key Milestones

### 1. Project Infrastructure
- [x] Clear boilerplate code and resolve dbt configuration conflicts.
- [x] Configure connection to production dataset (`analytics_526441677`).
- [x] Define multi-source directory structure (`base`, `staging`, `marts`).

### 2. Privacy-First Governance
- [x] Document SHA-256 PII policies in `DATA_GOVERNANCE.md`.
- [x] Initialize Identity Resolution strategy.
- [x] Create initial Data Contracts for core events.

### 3. First Model: GA4 Staging
- [ ] Implement `stg_ga4_events.sql` to flatten and clean raw GA4 production data.
- [ ] Verify `event_id` uniqueness via dbt tests.
- [ ] Audit `hashed_email` coverage across `survey_form_submitted` events.

## Current Status: READY
The baseline environment is configured. Execution of the first GA4 staging model is the next priority.
