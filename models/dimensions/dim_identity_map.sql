/*
    DIMENSION MODEL: dim_identity_map
    - Purpose: The central "Identity Graph" that stitches anonymous web IDs to CRM identities.
    - JOIN Spine: hashed_email (SHA-256) and app_event_id (UUID).
    - Path 1: Survey → Leads (via submission_id) → GA4 (via app_event_id)
    - Path 2: Direct CRM leads (HubSpot contacts) without a matching survey submission
*/

WITH ga4_conversions AS (
    -- Collect GA4 events that match an app transaction (via app_event_id)
    SELECT
        user_pseudo_id,
        hashed_user_id,
        app_event_id,
        event_timestamp,
        'ga4_conversion' AS detection_method
    FROM {{ ref('stg_ga4_events') }}
    WHERE app_event_id IS NOT NULL 
),

survey_conversions AS (
    -- Collect survey submissions that have both a bridge id and a pseudo_id
    SELECT
        app_event_id,
        user_pseudo_id,
        submission_id,
        created_at AS event_timestamp
    FROM {{ ref('stg_survey_submissions') }}
),

lead_identities AS (
    -- Link the lead identity (email) to the submission
    SELECT
        submission_id,
        hashed_email,
        internal_lead_id,
        company,
        created_at AS event_timestamp
    FROM {{ ref('stg_leads') }}
),

-- Path 1: Stitched via survey submission_id
survey_stitched AS (
    SELECT
        COALESCE(ga4.user_pseudo_id, srv.user_pseudo_id) AS user_pseudo_id,
        leads.hashed_email,
        leads.internal_lead_id,
        LEAST(ga4.event_timestamp, srv.event_timestamp) AS first_seen_at
    FROM survey_conversions AS srv
    INNER JOIN lead_identities AS leads ON srv.submission_id = leads.submission_id
    LEFT JOIN ga4_conversions AS ga4 ON srv.app_event_id = ga4.app_event_id
),

-- Path 2: Direct hashed identity link from GA4 to CRM lead email hash
ga4_hashed_stitched AS (
    SELECT
        ga4.user_pseudo_id,
        leads.hashed_email,
        leads.internal_lead_id,
        LEAST(ga4.event_timestamp, leads.event_timestamp) AS first_seen_at
    FROM ga4_conversions AS ga4
    INNER JOIN lead_identities AS leads ON ga4.hashed_user_id = leads.hashed_email
    WHERE ga4.user_pseudo_id IS NOT NULL
      AND ga4.hashed_user_id IS NOT NULL
),

stitched_emails AS (
    SELECT hashed_email FROM survey_stitched
    UNION DISTINCT
    SELECT hashed_email FROM ga4_hashed_stitched
),

-- Path 3: CRM leads with no matching survey submission or GA4 hashed identity
crm_only_leads AS (
    SELECT
        CAST(NULL AS STRING) AS user_pseudo_id,
        leads.hashed_email,
        leads.internal_lead_id,
        leads.event_timestamp AS first_seen_at
    FROM lead_identities AS leads
    WHERE NOT EXISTS (
        SELECT 1
        FROM stitched_emails AS stitched
        WHERE stitched.hashed_email = leads.hashed_email
    )
),

identity_bridge AS (
    SELECT * FROM survey_stitched
    UNION ALL
    SELECT * FROM ga4_hashed_stitched
    UNION ALL
    SELECT * FROM crm_only_leads
),

final AS (
    SELECT
        -- Primary Identity Key
        MD5(hashed_email) AS identity_key,
        hashed_email,
        
        -- Mapping
        MAX(user_pseudo_id) AS user_pseudo_id,
        MAX(internal_lead_id) AS internal_lead_id,
        
        -- Metadata
        MIN(first_seen_at) AS identified_at

    FROM identity_bridge
    GROUP BY 1, 2
)

SELECT * FROM final
