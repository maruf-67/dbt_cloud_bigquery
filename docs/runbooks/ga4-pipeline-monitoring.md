# Runbook: GA4 Pipeline Monitoring

## Purpose
Monitor ingestion quality and freshness for GA4 exports used by staging and conversion facts.

## Daily checks
1. Freshness window for `ga4.events_*` and intraday tables.
2. Event volume sanity for:
	- `survey_started`
	- `survey_form_submitted`
	- `survey_completed`
3. Null-rate checks for `event_id`, `user_pseudo_id`, `event_version`.

## Alert thresholds
- Warning: no new GA4 partitions in 2 hours.
- Critical: no new GA4 partitions in 6 hours.

## Triage steps
1. Confirm GTM events still firing in preview/debug.
2. Confirm GA4 export dataset permissions and quotas.
3. Validate `stg_ga4_events` query compiles and scans expected partitions.
4. Re-run staging job and compare row deltas.

## Recovery action
- Backfill missed day/hour using targeted run on staging + dependent facts.
