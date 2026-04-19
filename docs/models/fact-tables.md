# Fact Tables

## Implemented

### `fct_survey_conversions`
- Grain: one row per survey submission.
- Inputs:
	- `stg_survey_submissions`
	- `stg_ga4_events`
- Outputs:
	- conversion timestamp
	- readiness score and level
	- score bucket
	- acquisition attribution (`utm_source`, `utm_medium`, `utm_campaign`)
	- high-quality lead flag.

## Planned/incomplete facts

### `fct_leads`
- Status: placeholder.
- Target role: lead-centric operational fact with source and lifecycle metadata.

### `fct_survey_events`
- Status: placeholder.
- Target role: event-level survey behavior fact for detailed funnel analysis.

### `fct_campaign_performance`
- Status: placeholder.
- Target role: spend/impressions/clicks/conversions performance fact across channels.

## Readiness criteria
- All facts must declare grain and primary key.
- all keys used in marts must be test-covered (`unique`, `not_null` where required).
- placeholders must not be referenced by production dashboards.
