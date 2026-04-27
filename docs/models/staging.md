# Staging Models

## Purpose
Staging models normalize source-specific schemas into warehouse-safe fields and apply privacy boundaries (hash-only analytics identity).

## Active models

### `stg_ga4_events`
- Source: `ga4.events_*`, optional intraday union.
- Responsibilities:
	- flatten `event_params`
	- extract `app_event_id`, UTM fields, session identifiers
	- keep `user_pseudo_id`
	- produce deterministic dedup key (`dbt_event_id`)
- Known gap:
	- currently sets `event_version` as constant `v1`; downstream contract evolution plan still open.

### `stg_survey_submissions`
- Source: `supabase_raw.survey_submissions` when present, otherwise GA4 staged fallback.
- Responsibilities:
	- standardize survey submission identity fields
	- bridge app event id to analytics flow
	- dedup by latest `submission_id`.

### `stg_leads`
- Source: `supabase_raw.leads` when present, with HubSpot + GA4 fallback coverage.
- Responsibilities:
	- preserve `hashed_email`
	- drop plain email from modeled path
	- keep submission linkage for lead joins.

## Connector-dependent staging models
- `stg_meta_ads`
- `stg_google_ads`
- `stg_hubspot_contacts`
- `stg_linkedin_leads`

These are scaffolded but require active source sync and contract validation before production usage.

## Data quality expectations
- `not_null` and `unique` tests for key identifiers.
- freshness checks for critical sources.
- enum checks for bucket/version fields where applicable.
