/*
    MART MODEL: mart_survey_funnel
    - Purpose: Daily survey funnel view for Looker semantic modeling.
    - Grain: One row per date x attributed channel dimensions.
*/

{{ config(
    materialized='table',
    partition_by={
      "field": "event_date",
      "data_type": "date",
      "granularity": "day"
    },
    cluster_by=["utm_source", "utm_medium", "utm_campaign"]
) }}

WITH ga4_events AS (
    SELECT
        DATE(event_timestamp) AS event_date,
        COALESCE(NULLIF(utm_source, ''), '(direct)') AS utm_source,
        COALESCE(NULLIF(utm_medium, ''), '(none)') AS utm_medium,
        COALESCE(NULLIF(utm_campaign, ''), '(not_set)') AS utm_campaign,
        app_event_id,
        event_name,
        ga_session_id
    FROM {{ ref('stg_ga4_events') }}
    WHERE event_name IN ('survey_started', 'survey_form_submitted', 'survey_completed')
),

started AS (
    SELECT
        event_date,
        utm_source,
        utm_medium,
        utm_campaign,
        COUNT(DISTINCT app_event_id) AS started_submissions,
        COUNT(DISTINCT ga_session_id) AS started_sessions
    FROM ga4_events
    WHERE event_name = 'survey_started'
    GROUP BY 1, 2, 3, 4
),

form_submitted AS (
    SELECT
        event_date,
        utm_source,
        utm_medium,
        utm_campaign,
        COUNT(DISTINCT app_event_id) AS form_submitted_submissions
    FROM ga4_events
    WHERE event_name = 'survey_form_submitted'
    GROUP BY 1, 2, 3, 4
),

completed AS (
    SELECT
        event_date,
        utm_source,
        utm_medium,
        utm_campaign,
        COUNT(DISTINCT app_event_id) AS completed_submissions
    FROM ga4_events
    WHERE event_name = 'survey_completed'
    GROUP BY 1, 2, 3, 4
),

conversions AS (
    SELECT
        DATE(conversion_timestamp) AS event_date,
        COALESCE(NULLIF(utm_source, ''), '(direct)') AS utm_source,
        COALESCE(NULLIF(utm_medium, ''), '(none)') AS utm_medium,
        COALESCE(NULLIF(utm_campaign, ''), '(not_set)') AS utm_campaign,
        COUNT(DISTINCT submission_id) AS converted_submissions,
        SUM(is_high_quality_lead) AS high_quality_converted_submissions
    FROM {{ ref('fct_survey_conversions') }}
    GROUP BY 1, 2, 3, 4
),

all_keys AS (
    SELECT event_date, utm_source, utm_medium, utm_campaign FROM started
    UNION DISTINCT
    SELECT event_date, utm_source, utm_medium, utm_campaign FROM form_submitted
    UNION DISTINCT
    SELECT event_date, utm_source, utm_medium, utm_campaign FROM completed
    UNION DISTINCT
    SELECT event_date, utm_source, utm_medium, utm_campaign FROM conversions
),

final AS (
    SELECT
        k.event_date,
        k.utm_source,
        k.utm_medium,
        k.utm_campaign,

        COALESCE(s.started_sessions, 0) AS started_sessions,
        COALESCE(s.started_submissions, 0) AS started_submissions,
        COALESCE(f.form_submitted_submissions, 0) AS form_submitted_submissions,
        COALESCE(c.completed_submissions, 0) AS completed_submissions,
        COALESCE(v.converted_submissions, 0) AS converted_submissions,
        COALESCE(v.high_quality_converted_submissions, 0) AS high_quality_converted_submissions,

        SAFE_DIVIDE(COALESCE(f.form_submitted_submissions, 0), NULLIF(COALESCE(s.started_submissions, 0), 0)) AS started_to_form_submit_rate,
        SAFE_DIVIDE(COALESCE(c.completed_submissions, 0), NULLIF(COALESCE(s.started_submissions, 0), 0)) AS started_to_completed_rate,
        SAFE_DIVIDE(COALESCE(v.converted_submissions, 0), NULLIF(COALESCE(c.completed_submissions, 0), 0)) AS completed_to_converted_rate,
        SAFE_DIVIDE(COALESCE(v.high_quality_converted_submissions, 0), NULLIF(COALESCE(v.converted_submissions, 0), 0)) AS converted_to_hq_rate

    FROM all_keys AS k
    LEFT JOIN started AS s
        ON k.event_date = s.event_date
       AND k.utm_source = s.utm_source
       AND k.utm_medium = s.utm_medium
       AND k.utm_campaign = s.utm_campaign
    LEFT JOIN form_submitted AS f
        ON k.event_date = f.event_date
       AND k.utm_source = f.utm_source
       AND k.utm_medium = f.utm_medium
       AND k.utm_campaign = f.utm_campaign
    LEFT JOIN completed AS c
        ON k.event_date = c.event_date
       AND k.utm_source = c.utm_source
       AND k.utm_medium = c.utm_medium
       AND k.utm_campaign = c.utm_campaign
    LEFT JOIN conversions AS v
        ON k.event_date = v.event_date
       AND k.utm_source = v.utm_source
       AND k.utm_medium = v.utm_medium
       AND k.utm_campaign = v.utm_campaign
)

SELECT * FROM final
