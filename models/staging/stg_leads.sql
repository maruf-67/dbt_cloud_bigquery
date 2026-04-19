/*
    STAGING MODEL: stg_leads
    - Source: GA4 staged events (`stg_ga4_events`) as current warehouse fallback.
    - Privacy: Uses already-hashed identifiers only.
*/

WITH ga4_identities AS (
    SELECT
        CAST(app_event_id AS STRING) AS submission_id,
                LOWER(TRIM(CAST(hashed_user_id AS STRING))) AS hashed_email,
        event_timestamp AS created_at
    FROM {{ ref('stg_ga4_events') }}
    WHERE app_event_id IS NOT NULL
            AND hashed_user_id IS NOT NULL
),

final AS (
    SELECT
        TO_HEX(SHA256(CONCAT(submission_id, ':', hashed_email))) AS internal_lead_id,
        submission_id,
        hashed_email,
        CAST(NULL AS STRING) AS company,
        'ga4_fallback' AS source_platform,
        created_at
    FROM ga4_identities
)

SELECT * FROM final
QUALIFY ROW_NUMBER() OVER (PARTITION BY internal_lead_id ORDER BY created_at DESC) = 1
