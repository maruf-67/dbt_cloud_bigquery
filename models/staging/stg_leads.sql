/*
    STAGING MODEL: stg_leads
    - Source: Supabase raw leads (primary) + HubSpot contacts and GA4 events as fallback.
    - Privacy: Uses email_sha256 from HubSpot; hashed_user_id from GA4. No plain PII.
*/

{% set supabase_leads_source = source('supabase_raw', 'leads') %}
{% set has_supabase_leads_source = execute and load_relation(supabase_leads_source) is not none %}

WITH supabase_leads AS (
    {% if has_supabase_leads_source %}
    SELECT
        TO_HEX(SHA256(CONCAT(record_id, ':supabase'))) AS internal_lead_id,
        CAST(submission_id AS STRING) AS submission_id,
        LOWER(TRIM(CAST(hashed_email AS STRING))) AS hashed_email,
        company,
        'supabase' AS source_platform,
        TIMESTAMP(created_at) AS created_at
    FROM {{ supabase_leads_source }}
    WHERE hashed_email IS NOT NULL
        AND hashed_email != ''
    {% else %}
    SELECT
        CAST(NULL AS STRING) AS internal_lead_id,
        CAST(NULL AS STRING) AS submission_id,
        CAST(NULL AS STRING) AS hashed_email,
        CAST(NULL AS STRING) AS company,
        CAST(NULL AS STRING) AS source_platform,
        CAST(NULL AS TIMESTAMP) AS created_at
    WHERE 1 = 0
    {% endif %}
),

hubspot_contacts AS (
    SELECT
        TO_HEX(SHA256(CONCAT(crm_id, ':hubspot'))) AS internal_lead_id,
        CAST(NULL AS STRING) AS submission_id,
        LOWER(TRIM(CAST(email_sha256 AS STRING))) AS hashed_email,
        company,
        'hubspot' AS source_platform,
        TIMESTAMP(created_at) AS created_at
    FROM {{ source('hubspot', 'contacts') }}
    WHERE email_sha256 IS NOT NULL
        AND email_sha256 != ''
),

ga4_identities AS (
    SELECT
        TO_HEX(SHA256(CONCAT(CAST(app_event_id AS STRING), ':', LOWER(TRIM(CAST(hashed_user_id AS STRING)))))) AS internal_lead_id,
        CAST(app_event_id AS STRING) AS submission_id,
        LOWER(TRIM(CAST(hashed_user_id AS STRING))) AS hashed_email,
        CAST(NULL AS STRING) AS company,
        'ga4_fallback' AS source_platform,
        event_timestamp AS created_at
    FROM {{ ref('stg_ga4_events') }}
    WHERE app_event_id IS NOT NULL
        AND hashed_user_id IS NOT NULL
),

unioned AS (
    SELECT * FROM supabase_leads

    UNION ALL

    SELECT *
    FROM hubspot_contacts
    WHERE NOT EXISTS (
        SELECT 1
        FROM supabase_leads AS supabase
        WHERE supabase.hashed_email = hubspot_contacts.hashed_email
    )

    UNION ALL

    SELECT *
    FROM ga4_identities
    WHERE NOT EXISTS (
        SELECT 1
        FROM supabase_leads AS supabase
        WHERE supabase.hashed_email = ga4_identities.hashed_email
    )
),

final AS (
    SELECT
        internal_lead_id,
        submission_id,
        hashed_email,
        company,
        source_platform,
        created_at
    FROM unioned
)

SELECT * FROM final
QUALIFY ROW_NUMBER() OVER (PARTITION BY internal_lead_id ORDER BY created_at DESC) = 1
