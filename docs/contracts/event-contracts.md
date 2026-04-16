# Event Contracts & Orchestration Scope

## Core Events Scope
- `virtual_page_view`
- `survey_started`
- `survey_form_submitted`
- `survey_completed`
- `survey_completion_bucket`
- `generate_lead`

## Required Event Fields (dbt Data Contracts)
All events mapping to `stg_ga4_events` must include the following fields un-nuanced in payload (non-null dbt tests required):
- `event_id`
- `user_pseudo_id`
- `session_id`
- `event_version` ('v1', 'v2')

## Orchestration Requirements
Your orchestration project must manage:
- GA4 event ingestion
- GTM event normalization
- HubSpot contacts and lifecycle stages
- Google Ads spend and campaign data
- Meta Ads spend and campaign data
- Supabase survey submissions
- Supabase leads table
- Identity stitching across hashed_email, hubspot_contact_id, and user_pseudo_id
- Source freshness checks
- Retry and failure recovery rules
- dbt job scheduling and downstream dependency handling
- Looker-ready marts and executive dashboards
