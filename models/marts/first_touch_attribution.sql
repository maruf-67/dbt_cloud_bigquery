/*
    MART MODEL: first_touch_attribution
    - Purpose: Identify the original marketing source for every identified user.
    - Logic: Window function finding the earliest UTM source per identity_key.
*/

WITH identities AS (
    SELECT * FROM {{ ref('dim_identity_map') }}
),

sessions AS (
    -- All GA4 sessions that have UTM data
    SELECT
        user_pseudo_id,
        utm_source,
        utm_medium,
        utm_campaign,
        event_timestamp
    FROM {{ ref('stg_ga4_events') }}
    WHERE utm_source IS NOT NULL 
),

first_touch AS (
    SELECT
        ident.identity_key,
        ident.hashed_email,
        
        -- Window Function: Get the first value in history
        FIRST_VALUE(ses.utm_source) OVER (
            PARTITION BY ident.identity_key 
            ORDER BY ses.event_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS first_utm_source,
        
        FIRST_VALUE(ses.utm_medium) OVER (
            PARTITION BY ident.identity_key 
            ORDER BY ses.event_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS first_utm_medium,
        
        FIRST_VALUE(ses.utm_campaign) OVER (
            PARTITION BY ident.identity_key 
            ORDER BY ses.event_timestamp ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS first_utm_campaign,
        
        MIN(ses.event_timestamp) OVER (PARTITION BY ident.identity_key) AS first_seen_at

    FROM identities AS ident
    LEFT JOIN sessions AS ses ON ident.user_pseudo_id = ses.user_pseudo_id
)

SELECT DISTINCT * FROM first_touch
