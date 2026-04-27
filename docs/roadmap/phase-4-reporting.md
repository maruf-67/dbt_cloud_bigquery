# Roadmap: Phase 4 - Reporting & Business Intelligence

## Objectives
Connect the standardized dbt warehouse to external BI tools (Looker Studio) to provide actionable analytics for the marketing and sales teams.

## Key Milestones

### 1. Dashboard Foundations
- [x] Create connection stubs and query optimization guides (`docs/reporting/reporting_sql_stubs.md`).
- [x] Protect BigQuery query costs by enforcing `@DS_START_DATE` and `@DS_END_DATE` partition filters in all production dashboard queries.

### 2. Marketing Analytics
- [x] Provide standard SQL for "Marketing ROI & Lead Attribution".
- [x] Provide standard SQL for "Funnel Conversion Efficiency".

### 3. High-Velocity Operations
- [x] Integrate `mart_intraday_leads` to enable "Real-Time / Today's Performance" dashboards.
- [ ] Provide "Predictive Lead Scoring" lists leveraging the `mart_lead_propensity_scores` ML output in live BI.

## Acceptance Criteria
- [ ] Business stakeholders have immediate, actionable visibility into standard KPIs without needing ad-hoc engineering support.
- [ ] Dashboards leverage clustered and partitioned marts for rapid loading (sub-3 seconds).

**Current Status:** IN PROGRESS. Production-safe SQL stubs now enforce date-partition filters and the semantic mart contract is documented, but live dashboard wiring and SLA validation remain open.
