/*
    STAGING MODEL: stg_google_ads
    - Status: INCOMPLETE (Awaiting active connector sync)
    - Instructions:
        1. Extract `ad_id`, `ad_group_id`, `campaign_id`.
        2. Standardize spend to standard currency (e.g., USD).
        3. Prefix standard UTM strings based on ad campaign structure.
*/

-- Placeholder to ensure valid compilation
SELECT 
    CAST(NULL AS STRING) AS ad_id,
    CAST(NULL AS STRING) AS utm_source,
    CAST(NULL AS STRING) AS utm_medium,
    CAST(NULL AS STRING) AS utm_campaign,
    CAST(NULL AS FLOAT64) AS spend,
    CAST(NULL AS TIMESTAMP) AS _airbyte_emitted_at
LIMIT 0
