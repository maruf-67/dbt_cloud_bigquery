# Runbook: dbt Deployment

## Purpose
Operational checklist for promoting dbt changes safely from development to production.

## Pre-deployment checks
1. Confirm `dbt parse` succeeds with zero errors.
2. Confirm package compatibility for active dbt runtime (Fusion/Core).
3. Confirm source datasets exist in target project/location.
4. Confirm model contracts and tests in `models/schema.yml` reflect latest fields.
5. Confirm roadmap/docs were updated for any contract-breaking changes.

## Deployment sequence
1. `dbt deps`
2. `dbt parse`
3. `dbt build --select state:modified+`
4. `dbt test`
5. `dbt run --select marts+`

## Production schedule baseline
- Hourly: staging + critical dimensions.
- Daily: facts + marts + ML scoring.

## Post-deployment verification
1. Validate row counts for `stg_ga4_events`, `fct_survey_conversions`, `mart_lead_attribution`.
2. Validate no duplicate keys in identity and conversion models.
3. Validate dashboard critical KPIs load successfully.

## Rollback
1. Re-run prior known-good job version.
2. Disable failing scheduled job.
3. Open incident note with failing models and last-success timestamp.
