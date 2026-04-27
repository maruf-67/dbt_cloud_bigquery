/*
    MART MODEL: mart_semantic_overview
    - Purpose: Unified Looker-ready semantic mart combining funnel, conversion, and
               readiness distribution metrics into a single wide, consistent row.
    - Grain: One row per event_date × utm_source × utm_medium × utm_campaign.
    - Readiness buckets: pivoted as columns to avoid fan-out in Looker Explore.
    - Upstream: fct_survey_conversions, stg_ga4_events (no mart-on-mart dependencies).
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

-- ── Funnel events from GA4 ─────────────────────────────────────────────────
WITH ga4_funnel AS (
    SELECT
        DATE(event_timestamp) AS event_date,
        COALESCE(NULLIF(utm_source, ''), '(direct)') AS utm_source,
        COALESCE(NULLIF(utm_medium, ''), '(none)') AS utm_medium,
        COALESCE(NULLIF(utm_campaign, ''), '(not_set)') AS utm_campaign,
        event_name,
        app_event_id,
        ga_session_id
    FROM {{ ref('stg_ga4_events') }}
    WHERE event_name IN ('survey_started', 'survey_form_submitted', 'survey_completed')
),

funnel_agg AS (
    SELECT
        event_date,
        utm_source,
        utm_medium,
        utm_campaign,
        COUNT(DISTINCT CASE WHEN event_name = 'survey_started'        THEN ga_session_id END) AS started_sessions,
        COUNT(DISTINCT CASE WHEN event_name = 'survey_started'        THEN app_event_id  END) AS started_count,
        COUNT(DISTINCT CASE WHEN event_name = 'survey_form_submitted' THEN app_event_id  END) AS form_submitted_count,
        COUNT(DISTINCT CASE WHEN event_name = 'survey_completed'      THEN app_event_id  END) AS completed_count
    FROM ga4_funnel
    GROUP BY 1, 2, 3, 4
),

-- ── Conversions + readiness from the fact layer ───────────────────────────
conv_agg AS (
    SELECT
        DATE(conversion_timestamp) AS event_date,
        COALESCE(NULLIF(utm_source, ''), '(direct)') AS utm_source,
        COALESCE(NULLIF(utm_medium, ''), '(none)') AS utm_medium,
        COALESCE(NULLIF(utm_campaign, ''), '(not_set)') AS utm_campaign,

        COUNT(DISTINCT submission_id)                             AS converted_count,
        SUM(is_high_quality_lead)                                 AS hq_converted_count,
        AVG(overall_score)                                        AS avg_readiness_score,

        -- Readiness buckets pivoted
        COUNTIF(score_range = '20-35_data_disadvantaged')        AS bucket_data_disadvantaged,
        COUNTIF(score_range = '36-50_data_aware')                AS bucket_data_aware,
        COUNTIF(score_range = '51-70_data_capable')              AS bucket_data_capable,
        COUNTIF(score_range = '71-85_data_advantaged')           AS bucket_data_advantaged,
        COUNTIF(score_range = '86-100_data_leadership')          AS bucket_data_leadership
    FROM {{ ref('fct_survey_conversions') }}
    GROUP BY 1, 2, 3, 4
),

-- ── Spine: union all date×utm keys from both sources ─────────────────────
spine AS (
    SELECT event_date, utm_source, utm_medium, utm_campaign FROM funnel_agg
    UNION DISTINCT
    SELECT event_date, utm_source, utm_medium, utm_campaign FROM conv_agg
),

-- ── Final wide join ───────────────────────────────────────────────────────
final AS (
    SELECT
        s.event_date,
        s.utm_source,
        s.utm_medium,
        s.utm_campaign,

        -- Funnel counts
        COALESCE(f.started_sessions,       0) AS started_sessions,
        COALESCE(f.started_count,          0) AS started_count,
        COALESCE(f.form_submitted_count,   0) AS form_submitted_count,
        COALESCE(f.completed_count,        0) AS completed_count,

        -- Conversion counts
        COALESCE(c.converted_count,        0) AS converted_count,
        COALESCE(c.hq_converted_count,     0) AS hq_converted_count,

        -- Readiness score
        ROUND(c.avg_readiness_score, 2)       AS avg_readiness_score,

        -- Readiness bucket columns
        COALESCE(c.bucket_data_disadvantaged, 0) AS bucket_data_disadvantaged,
        COALESCE(c.bucket_data_aware,         0) AS bucket_data_aware,
        COALESCE(c.bucket_data_capable,       0) AS bucket_data_capable,
        COALESCE(c.bucket_data_advantaged,    0) AS bucket_data_advantaged,
        COALESCE(c.bucket_data_leadership,    0) AS bucket_data_leadership,

        -- Derived rates (SAFE_DIVIDE avoids division by zero)
        ROUND(SAFE_DIVIDE(f.form_submitted_count, f.started_count) * 100, 2) AS form_submit_rate_pct,
        ROUND(SAFE_DIVIDE(f.completed_count,      f.started_count) * 100, 2) AS completion_rate_pct,
        ROUND(SAFE_DIVIDE(c.converted_count,      f.started_count) * 100, 2) AS conversion_rate_pct,
        ROUND(SAFE_DIVIDE(c.hq_converted_count,   c.converted_count) * 100, 2) AS hq_rate_pct

    FROM spine s
    LEFT JOIN funnel_agg f USING (event_date, utm_source, utm_medium, utm_campaign)
    LEFT JOIN conv_agg   c USING (event_date, utm_source, utm_medium, utm_campaign)
)

SELECT * FROM final
