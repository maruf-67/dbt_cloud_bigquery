/*
    STAGING MODEL: stg_linkedin_leads
    - Source: analytics_526441677.linkedin_ads_campaigns
    - Purpose: Normalize LinkedIn campaign performance for attribution joins.
*/

WITH raw_campaigns AS (
    SELECT *
    FROM {{ source('linkedin_ads', 'campaign_performance') }}
),

final AS (
    SELECT
        CAST(event_date AS DATE) AS event_date,
        CAST(platform AS STRING) AS platform,
        CAST(campaign_id AS STRING) AS campaign_id,
        CAST(campaign_name AS STRING) AS campaign_name,
        CAST(ad_group_id AS STRING) AS ad_group_id,
        CAST(ad_group_name AS STRING) AS ad_group_name,
        CAST(ad_id AS STRING) AS ad_id,
        CAST(ad_name AS STRING) AS ad_name,
        CAST(utm_source AS STRING) AS utm_source,
        CAST(utm_medium AS STRING) AS utm_medium,
        CAST(utm_campaign AS STRING) AS utm_campaign,
        CAST(impressions AS INT64) AS impressions,
        CAST(clicks AS INT64) AS clicks,
        CAST(ctr AS FLOAT64) AS ctr,
        CAST(spend AS FLOAT64) AS spend,
        CAST(leads AS INT64) AS leads,
        CAST(conversions AS INT64) AS conversions,
        CAST(cost_per_conversion AS FLOAT64) AS cost_per_conversion,
        CAST(conversion_rate AS FLOAT64) AS conversion_rate,
        'linkedin_ads' AS source_platform
    FROM raw_campaigns
)

SELECT *
FROM final
