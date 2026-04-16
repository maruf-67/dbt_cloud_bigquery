# Roadmap: Phase 3 - Orchestration & Advanced Analytics

## Objectives
Automating the feedback loop between CRM, Ads, and Analytics to optimize marketing spend and prepare for AI training.

## Key Milestones

### 1. Automated Orchestration
- [ ] Set up dbt Cloud jobs for hourly staging and daily mart refreshes.
- [ ] Implement source freshness monitoring with alerts for LinkedIn/Meta lag.
- [ ] Configure sGTM event enrichment using BigQuery/CRM lookups.

### 2. Lead Scoring & Feedback Loops
- [ ] Develop simplified lead scoring models in SQL (marts).
- [ ] (Future) Integrate conversion feedback back into Google/Meta Ads via CAPI.
- [ ] Implement "First-Seen" vs "Last-Touch" attribution marts.

### 3. AI & Data Science Foundation
- [ ] Create specialized marts for AI training sets (e.g. `mart_training_lead_propensity`).
- [ ] Ensure point-in-time correctness for longitudinal studies (DS readiness).
- [ ] Integrate LookerML definitions for "Semantic Layer" consistency.

## Success Metrics
- 99% pipeline uptime.
- Metadata traceability from Looker dashboard back to raw source event.
- Training-ready datasets refreshed on a 24-hour cycle.
