/*
    STAGING MODEL: stg_survey_submissions
    - Source: Supabase raw submissions when available, else GA4 staged events as fallback.
    - Identity: Bridges attribution using `app_event_id` and `user_pseudo_id`.
*/

{% set supabase_submission_source = source('supabase_raw', 'survey_submissions') %}
{% set has_supabase_submission_source = execute and load_relation(supabase_submission_source) is not none %}

WITH supabase_submissions AS (
    {% if has_supabase_submission_source %}
    SELECT
        CAST(record_id AS STRING) AS submission_id,
        CAST(event_id AS STRING) AS app_event_id,
        CAST(user_pseudo_id AS STRING) AS user_pseudo_id,
        CAST(session_id AS STRING) AS ga_session_id,
        CAST(readiness_level AS STRING) AS readiness_level,
        CAST(readiness_score AS FLOAT64) AS overall_score,
        CAST(score_range AS STRING) AS score_range,
        COALESCE(
            SAFE_CAST(submitted_at AS TIMESTAMP),
            SAFE_CAST(created_at AS TIMESTAMP),
            SAFE_CAST(updated_at AS TIMESTAMP)
        ) AS created_at
    FROM {{ supabase_submission_source }}
    WHERE record_id IS NOT NULL
    {% else %}
    SELECT
        CAST(NULL AS STRING) AS submission_id,
        CAST(NULL AS STRING) AS app_event_id,
        CAST(NULL AS STRING) AS user_pseudo_id,
        CAST(NULL AS STRING) AS ga_session_id,
        CAST(NULL AS STRING) AS readiness_level,
        CAST(NULL AS FLOAT64) AS overall_score,
        CAST(NULL AS STRING) AS score_range,
        CAST(NULL AS TIMESTAMP) AS created_at
    WHERE 1 = 0
    {% endif %}
),

ga4_submissions AS (
    SELECT
        CAST(app_event_id AS STRING) AS submission_id,
        CAST(app_event_id AS STRING) AS app_event_id,
        CAST(user_pseudo_id AS STRING) AS user_pseudo_id,
        CAST(ga_session_id AS STRING) AS ga_session_id,
        CAST(NULL AS STRING) AS readiness_level,
        CAST(NULL AS FLOAT64) AS overall_score,
        CAST(NULL AS STRING) AS score_range,
        event_timestamp AS created_at
    FROM {{ ref('stg_ga4_events') }}
    WHERE app_event_id IS NOT NULL
),

final AS (
    SELECT *
    FROM supabase_submissions

    UNION ALL

    SELECT ga4.*
    FROM ga4_submissions AS ga4
    WHERE NOT EXISTS (
        SELECT 1
        FROM supabase_submissions AS supabase
        WHERE supabase.app_event_id = ga4.app_event_id
    )
)

SELECT * FROM final
QUALIFY ROW_NUMBER() OVER (PARTITION BY submission_id ORDER BY created_at DESC) = 1
