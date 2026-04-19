# Roadmap: Phase 3 - Orchestration & Advanced Analytics

## Objectives
Automating the feedback loop between CRM, Ads, and Analytics to optimize marketing spend and prepare for AI training.

## Key Milestones

### 1. Automated Orchestration
- [ ] Set up dbt Cloud jobs for hourly staging and daily mart refreshes.
- [ ] Implement source freshness monitoring with alerts for LinkedIn/Meta lag.
- [ ] Configure sGTM event enrichment using BigQuery/CRM lookups.

### 2. Lead Scoring & Feedback Loops
- [x] Develop simplified and predictive lead scoring models (`ml_propensity_model`).
- [ ] (Future) Integrate conversion feedback back into Google/Meta Ads via CAPI.
- [x] Implement "First-Touch" vs "Last-Touch" attribution marts.

### 3. AI & Data Science Foundation
- [x] Create specialized marts for AI training sets (`mart_ai_training_set`).
- [x] Ensure point-in-time correctness for longitudinal studies (DS readiness).
- [x] Integrate LookerML definitions for "Semantic Layer" consistency (Completed via SQL Dashboard Stubs).

## Success Metrics
- [ ] 99% pipeline uptime (Pending dbt Cloud job scheduling).
- [ ] Metadata traceability from Looker dashboard back to raw source event, validated on production dashboard lineage.
- [ ] Training-ready datasets refreshed on a 24-hour cycle via scheduled jobs.

**Current Status:** PARTIAL. Modeling foundations exist, but production orchestration, freshness alerting, and reliability metrics are not yet operational.
