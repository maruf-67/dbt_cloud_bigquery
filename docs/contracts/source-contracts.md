# Source Contracts

## Purpose
This document defines source-level contracts for upstream systems feeding the warehouse. These contracts are the minimum required to keep staging, identity stitching, and reporting stable.

## Contract Policy
- Contract failures are release blockers for production jobs.
- Additive fields are allowed.
- Renames/removals require a versioned migration note.
- Timestamps must be UTC-compatible.

## GA4 Export (`ga4.events_*`, `ga4.events_intraday_*`)

### Required fields
- `event_timestamp` (INT64 micros)
- `event_date` (STRING, `YYYYMMDD`)
- `event_name` (STRING)
- `user_pseudo_id` (STRING)
- `event_params` (REPEATED RECORD)

### Required `event_params` keys for survey events
- `event_id` (STRING UUID v4)
- `session_id` (STRING)
- `event_version` (STRING enum: `v1`, `v2`)

### Freshness target
- Warning: data delayed > 2 hours
- Error: data delayed > 6 hours

## Supabase (`supabase_raw.survey_submissions`)

### Required fields
- `id` (submission id)
- `event_id` (STRING UUID v4)
- `user_pseudo_id` (STRING)
- `session_id` (STRING)
- `level` (STRING)
- `overall_score` (NUMERIC/FLOAT)
- `score_range` (STRING)
- `created_at` (TIMESTAMP)

### Contract notes
- `event_id` must be unique per submission.
- `score_range` must match enum reference.

## Supabase (`supabase_raw.leads`)

### Required fields
- `id` (lead id)
- `p_submission_id` (STRING/INT reference to submission)
- `p_hashed_email` (STRING 64-char lowercase hex)
- `p_company` (STRING nullable)
- `created_at` (TIMESTAMP)

### Privacy constraint
- Plain email must never be surfaced in staging/marts.

## HubSpot (`hubspot.contacts`)

### Required fields
- `id`
- `email`
- `firstname`
- `company`
- `readiness_level` (custom)
- `readiness_score` (custom)
- `createdate`
- `lastmodifieddate`

### Contract notes
- `email` is used for deterministic contact upsert in app route.
- Custom properties must be provisioned before sync jobs run.

## Meta Ads (`meta_ads.ads_performance`)

### Required fields
- `campaign_id`
- `campaign_name`
- `date`
- `spend`
- `impressions`
- `clicks`

## LinkedIn Ads (`linkedin_ads.campaign_performance`)

### Required fields
- `campaign_id`
- `campaign_name`
- `date`
- `cost`
- `impressions`
- `clicks`

## Enforcement map
- Source freshness checks: `models/schema.yml`
- Column tests (`unique`, `not_null`, `accepted_values`): `models/schema.yml`
- Extended assertions (optional): `dbt_expectations`

## Data Contract Change Log

Use this compact log for any source contract addition, rename, type change, or deprecation.

| Version | Date | Scope | Change summary | Migration required | Owner |
| --- | --- | --- | --- | --- | --- |
| 1.0.0 | 2026-04-19 | Initial formalization | Baseline source contracts documented for GA4, Supabase, HubSpot, Meta Ads, LinkedIn Ads. | No | Data Engineering |

### Entry rules
- Add one row for every breaking or additive contract change.
- If `Migration required` is `Yes`, reference the runbook/PR in the change summary.
- Keep newest entries at the top.
