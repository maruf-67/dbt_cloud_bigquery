# Runbook: dbt Deployment

## Purpose
Operational checklist for promoting dbt changes safely from development to production.

## Pre-deployment checks
1. Confirm `dbt parse` succeeds with zero errors.
2. Confirm package compatibility for active dbt runtime (Fusion/Core).
3. Confirm source datasets exist in target project/location (`sigma-sector-488608-g0`, `EU`).
4. Confirm model contracts and tests in `models/schema.yml` reflect latest fields.
5. Confirm roadmap/docs were updated for any contract-breaking changes.
6. Confirm `dbt source freshness --select source:supabase_raw` passes once worker smoke ingest has completed.

## Final pre-deploy checklist (EU cutover)
1. Confirm `dbt debug` resolves:
	- database/project: `sigma-sector-488608-g0`
	- schema: `analytics_staging`
	- location: `EU`
	- method: `service-account`
2. Confirm source routing contract remains:
	- GA4 source: `analytics_526441677` (source-only)
	- HubSpot/Supabase/Salesforce raw: `crm_raw`
	- Ads raw: `analytics_raw`
3. Confirm output routing in `dbt_project.yml`:
	- `staging` -> `analytics_staging`
	- `dimensions`, `facts` -> `analytics_core`
	- `marts`, `ml` -> `analytics_mart`
4. Confirm no model is configured to write into `analytics_526441677`.

## Target profile baseline
- Project: `sigma-sector-488608-g0`
- Location: `EU`
- Default target dataset for build jobs: `analytics_staging`
- Model routing:
	- `staging` -> `analytics_staging`
	- `dimensions`, `facts` -> `analytics_core`
	- `marts`, `ml` -> `analytics_mart`

## Deployment sequence
1. `dbt deps`
2. `dbt parse`
3. `dbt build --select state:modified+`
4. `dbt test`
5. `dbt run --select marts+`

## First safe smoke-run order
1. `dbt parse`
2. targeted run/test for touched staging/core models
3. targeted run/test for touched marts
4. verify dataset placement in `analytics_staging` / `analytics_core` / `analytics_mart`
5. only then run wider selectors
6. run `dbt source freshness --select source:supabase_raw` after worker smoke ingest to validate raw-table observability

## Production schedule baseline
- Hourly: staging + critical dimensions.
- Daily: facts + marts + ML scoring.

## Post-deployment verification
1. Validate row counts for `stg_ga4_events`, `fct_survey_conversions`, `mart_lead_attribution`.
2. Validate no duplicate keys in identity and conversion models.
3. Validate dashboard critical KPIs load successfully.
4. Validate `supabase_raw` freshness is within the 18h warn / 36h error window.

## Rollback
1. Re-run prior known-good job version.
2. Disable failing scheduled job.
3. Open incident note with failing models and last-success timestamp.

## Ultra-short go/no-go card (paste-ready)
- `dbt debug` project/schema/location are correct (YES/NO)
- Source routing contract unchanged and valid (YES/NO)
- Output schema routing per layer is correct (YES/NO)
- `dbt parse` passed (YES/NO)
- Targeted run/test passed for touched models (YES/NO)
- Objects materialized in expected datasets only (YES/NO)
- No model write observed in `analytics_526441677` (YES/NO)
- Worker smoke ingest wrote only to `crm_raw` (YES/NO)
- `supabase_raw` freshness check passed (YES/NO)
- Alerts/monitoring checks are green (YES/NO)
- Decision: **GO** only if all YES, else **NO-GO**
