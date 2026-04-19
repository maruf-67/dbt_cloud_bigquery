/*
    MART MODEL: mart_funnel_efficiency
    - Purpose: Track conversion rates through the acquisition funnel.
*/

{{ config(
    materialized='table'
) }}

WITH sessions AS (
    -- Total unique sessions from GA4
    SELECT
        EXTRACT(DATE FROM event_timestamp) AS event_date,
        COUNT(DISTINCT ga_session_id) AS total_sessions
    FROM {{ ref('stg_ga4_events') }}
    GROUP BY 1
),

conversions AS (
    -- Total survey completions
    SELECT
        EXTRACT(DATE FROM conversion_timestamp) AS event_date,
        COUNT(submission_id) AS total_completions,
        SUM(is_high_quality_lead) AS high_quality_conversions
    FROM {{ ref('fct_survey_conversions') }}
    GROUP BY 1
),

final AS (
    SELECT
        s.event_date,
        s.total_sessions,
        COALESCE(c.total_completions, 0) AS total_completions,
        COALESCE(c.high_quality_conversions, 0) AS high_quality_conversions,
        
        -- Rates
        SAFE_DIVIDE(c.total_completions, s.total_sessions) AS session_to_completion_rate,
        SAFE_DIVIDE(c.high_quality_conversions, c.total_completions) AS lead_quality_rate

    FROM sessions AS s
    LEFT JOIN conversions AS c ON s.event_date = c.event_date
)

SELECT * FROM final
