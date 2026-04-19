/*
    STAGING MODEL: stg_ga4_events
    - Purpose: Flattened, cleaned GA4 event stream.
    - Identity: SHA-256 hashed user_id and email-ready stubs.
    - Freshness: Union of historical shards and intraday tables.
*/

WITH raw_events AS (
    SELECT * FROM {{ source('ga4', 'events') }}
    {% if target.name == 'prod' %}
    UNION ALL
    SELECT * FROM {{ source('ga4', 'events_intraday') }}
    WHERE _TABLE_SUFFIX NOT IN (SELECT DISTINCT _TABLE_SUFFIX FROM {{ source('ga4', 'events') }})
    {% endif %}
),

flattened AS (
    SELECT
        -- Surrogate Key: Internal dbt identifier
        MD5(CONCAT(
            CAST(event_timestamp AS STRING), 
            event_name, 
            user_pseudo_id
        )) AS dbt_event_id,

        -- Transactional Identifiers (From App)
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_id') AS app_event_id,
        
        -- Timing
        TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
        PARSE_DATE('%Y%m%d', event_date) AS event_date,
        
        -- Identity Boundary
        user_pseudo_id,
        SHA256(CAST(user_id AS STRING)) AS hashed_user_id,
        
        -- Core Event Properties
        event_name,
        
        -- Parameter Extraction (Common GA4 Params)
        (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id,
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_location') AS page_location,
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_title') AS page_title,
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_referrer') AS page_referrer,
        
        -- Marketing UTMs
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source') AS utm_source,
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'medium') AS utm_medium,
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'campaign') AS utm_campaign,
        
        -- Governance
        'v1' AS event_version,
        CAST(platform AS STRING) AS device_platform

    FROM raw_events
)

SELECT * FROM flattened
-- Deduplication Logic: Ensuring 1 row per surrogate key
QUALIFY ROW_NUMBER() OVER (PARTITION BY dbt_event_id ORDER BY event_timestamp DESC) = 1
