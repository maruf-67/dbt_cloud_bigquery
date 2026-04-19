# Mart Contracts

## Purpose
Define downstream-ready contracts for fact and mart models used by BI, analytics, and ML.

## Global rules
- Grain must be explicit per model.
- Primary key candidates must be documented.
- Partition and cluster strategy must be declared for large marts.
- Breaking contract changes require roadmap update + changelog note.

## Fact contracts

### `fct_survey_conversions`
- Grain: one row per `submission_id`.
- Required fields:
	- `submission_id` (not null, unique)
	- `app_event_id` (not null)
	- `user_pseudo_id` (nullable only when source missing)
	- `conversion_timestamp` (not null)
	- `utm_source`, `utm_medium`, `utm_campaign`
	- `overall_score`, `score_range`, `readiness_level`
	- `is_high_quality_lead` (0/1)

### `fct_leads` (planned completion)
- Grain: one row per internal lead id.
- Required fields:
	- `internal_lead_id` (not null, unique)
	- `submission_id` (not null)
	- `hashed_email` (not null)
	- `created_at` (not null)

## Mart contracts

### `mart_funnel_efficiency`
- Grain: one row per `event_date`.
- Required fields:
	- `event_date`
	- `total_sessions`
	- `total_completions`
	- `session_to_completion_rate`

### `mart_lead_attribution`
- Grain: one row per `conversion_date + utm_source + utm_medium + utm_campaign`.
- Required fields:
	- `conversion_date` (not null)
	- `utm_source` (not null)
	- `total_conversions`
	- `total_high_quality_leads`
	- `average_readiness_score`
- Recommended physical design:
	- Partition: `conversion_date`
	- Cluster: `utm_source`, `utm_campaign`

### `mart_readiness_distribution` (planned completion)
- Grain: one row per score bucket per reporting date.
- Required fields:
	- `score_bucket` (accepted values from enum reference)
	- `bucket_count`

### `mart_ai_training_set`
- Grain: one row per `identity_key`.
- Required fields:
	- `identity_key` (not null, unique)
	- feature columns (`feat_*`)
	- `label_converted_hq`

### `mart_lead_propensity_scores`
- Grain: one row per `identity_key` per scoring run.
- Required fields:
	- `identity_key` (not null)
	- `conversion_probability` (0..1)
	- `propensity_segment` (`HIGH`, `MEDIUM`, `LOW`)
	- `scored_at`

## SLA targets
- Staging freshness: <= 2h normal, <= 6h max.
- Daily marts ready by 08:00 project timezone.
- BI query response target: < 3 seconds for executive dashboards.

## Data Contract Change Log

Use this compact log for mart/fact grain updates, required field changes, SLA updates, and model lifecycle changes.

| Version | Date | Scope | Change summary | Migration required | Owner |
| --- | --- | --- | --- | --- | --- |
| 1.0.0 | 2026-04-19 | Initial formalization | Baseline fact and mart contracts documented with grain, required fields, and SLA targets. | No | Data Engineering |

### Entry rules
- Add one row for every contract-impacting model change.
- If `Migration required` is `Yes`, include the dependent dashboard/model impact in the change summary.
- Keep newest entries at the top.
