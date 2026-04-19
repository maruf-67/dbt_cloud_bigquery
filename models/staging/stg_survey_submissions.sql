/*
    STAGING MODEL: stg_survey_submissions
    - Source: GA4 staged events (`stg_ga4_events`) as current warehouse fallback.
    - Identity: Bridges attribution using `app_event_id` and `user_pseudo_id`.
*/

WITH ga4_submissions AS (
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
    FROM ga4_submissions
)

SELECT * FROM final
QUALIFY ROW_NUMBER() OVER (PARTITION BY submission_id ORDER BY created_at DESC) = 1
