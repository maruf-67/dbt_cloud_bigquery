/*
    FACT MODEL: fct_survey_conversions
    - Purpose: Every survey submission linked to its acquiring marketing source.
    - Grain: One row per unique survey submission.
*/

{{ config(materialized='table') }}

WITH submissions AS (
    SELECT * FROM {{ ref('stg_survey_submissions') }}
),

sessions AS (
    -- Get the session-level UTM data for the conversion event
    SELECT
        app_event_id,
        user_pseudo_id,
        ga_session_id,
        utm_source,
        utm_medium,
        utm_campaign,
        page_location,
        event_timestamp
    FROM {{ ref('stg_ga4_events') }}
    WHERE app_event_id IS NOT NULL
),

final AS (
    SELECT
        -- Primary Key
        srv.submission_id,
        
        -- Identity
        srv.app_event_id,
        srv.user_pseudo_id,
        srv.ga_session_id,
        
        -- Conversion Data
        srv.readiness_level,
        srv.overall_score,
        srv.score_range,
        
        -- Attribute to Marketing Source (Bridge via app_event_id)
        COALESCE(ses.utm_source, '(direct)') AS utm_source,
        COALESCE(ses.utm_medium, '(none)') AS utm_medium,
        COALESCE(ses.utm_campaign, '(not set)') AS utm_campaign,
        
        -- Timing
        srv.created_at AS conversion_timestamp,
        
        -- Flag: High Quality Lead (Threshold: 80)
        CASE WHEN srv.overall_score >= 80 THEN 1 ELSE 0 END AS is_high_quality_lead

    FROM submissions AS srv
    LEFT JOIN sessions AS ses ON srv.app_event_id = ses.app_event_id
)

SELECT * FROM final
