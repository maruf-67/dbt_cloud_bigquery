# Enum Reference

## Purpose
Canonical enum catalog for event payloads, staged fields, and marts. Use this list when creating tests and validating upstream payloads.

## Event schema version
- `event_version`
	- `v1`
	- `v2`

## Score range bucket
- `score_range` / `score_bucket`
	- `20-35_data_disadvantaged`
	- `36-50_data_aware`
	- `51-70_data_capable`
	- `71-85_data_advantaged`
	- `86-100_data_leadership`

## Readiness level labels
- `readiness_level`
	- `Data Disadvantaged`
	- `Data Aware`
	- `Data Capable`
	- `Data Advantaged`
	- `Data Leadership`

## Consent values
- Consent mode state fields (`analytics_storage`, `ad_storage`, `ad_user_data`, `ad_personalization`)
	- `granted`
	- `denied`

## Propensity segment
- `propensity_segment`
	- `HIGH`
	- `MEDIUM`
	- `LOW`
