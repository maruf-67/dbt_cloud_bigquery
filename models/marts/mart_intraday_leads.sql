/*
    MART MODEL: mart_intraday_leads
    - Purpose: Real-time monitoring of lead flow.
    - Refresh: This model should be queried with High Freshness.
*/

{{ config(
    materialized='view'
) }}

WITH historical_conversions AS (
    SELECT
        submission_id,
        utm_source,
        utm_medium,
        utm_campaign,
        conversion_timestamp,
        readiness_level,
        is_high_quality_lead,
        'historical' AS data_stream
    FROM {{ ref('fct_survey_conversions') }}
),

intraday_conversions AS (
    -- This CTE extracts conversions that haven't been processed by the daily dbt run yet
    -- We assume the presence of the intraday source tables registered in schema.yml
    SELECT
        app_event_id AS submission_id,
        utm_source,
        utm_medium,
        utm_campaign,
        event_timestamp AS conversion_timestamp,
        'N/A' AS readiness_level, -- Readiness level may not be available in intraday raw stream
        0 AS is_high_quality_lead,
        'real_time' AS data_stream
    FROM {{ ref('stg_ga4_events') }}
    WHERE event_name = 'survey_completed' -- Filter for conversion event
      AND event_date = CURRENT_DATE()
      AND app_event_id NOT IN (SELECT submission_id FROM historical_conversions)
),

final AS (
    SELECT * FROM historical_conversions
    UNION ALL
    SELECT * FROM intraday_conversions
)

SELECT * FROM final
ORDER BY conversion_timestamp DESC
