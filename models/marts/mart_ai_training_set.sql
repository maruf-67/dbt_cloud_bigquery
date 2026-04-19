/*
    MART MODEL: mart_ai_training_set
    - Purpose: Unified user feature store for AI/ML training (e.g., Propensity Modeling).
    - Grain: One row per identity_key.
*/

{{ config(
    materialized='table'
) }}

WITH identity_map AS (
    SELECT * FROM {{ ref('dim_identity_map') }}
),

behavioral_sessions AS (
    -- Aggregate session-level behavior
    SELECT
        user_pseudo_id,
        count(DISTINCT ga_session_id) AS total_sessions,
        count(DISTINCT event_date) AS active_days,
        sum(CASE WHEN event_name = 'page_view' THEN 1 ELSE 0 END) AS total_page_views,
        min(event_timestamp) AS first_engagement_at,
        max(event_timestamp) AS last_engagement_at
    FROM {{ ref('stg_ga4_events') }}
    GROUP BY 1
),

survey_performance AS (
    -- Aggregate survey results
    SELECT
        user_pseudo_id,
        count(submission_id) AS total_submissions,
        max(overall_score) AS max_readiness_score,
        avg(overall_score) AS avg_readiness_score,
        max(is_high_quality_lead) AS has_hq_lead_converted
    FROM {{ ref('fct_survey_conversions') }}
    GROUP BY 1
),

final AS (
    SELECT
        ident.identity_key,
        
        -- BEHAVIORAL FEATURES
        coalesce(beh.total_sessions, 0) AS feat_total_sessions,
        coalesce(beh.active_days, 0) AS feat_active_days,
        coalesce(beh.total_page_views, 0) AS feat_total_page_views,
        timestamp_diff(beh.last_engagement_at, beh.first_engagement_at, DAY) AS feat_days_since_first_touch,
        
        -- SURVEY FEATURES
        coalesce(srv.total_submissions, 0) AS feat_total_survey_submissions,
        coalesce(srv.max_readiness_score, 0) AS feat_max_readiness_score,
        coalesce(srv.avg_readiness_score, 0) AS feat_avg_readiness_score,
        
        -- TARGET LABEL (For ML training)
        coalesce(srv.has_hq_lead_converted, 0) AS label_converted_hq

    FROM identity_map AS ident
    LEFT JOIN behavioral_sessions AS beh ON ident.user_pseudo_id = beh.user_pseudo_id
    LEFT JOIN survey_performance AS srv ON ident.user_pseudo_id = srv.user_pseudo_id
)

SELECT * FROM final
