/*
    MART MODEL: mart_lead_attribution
    - Purpose: High-level dashboard-ready view of lead acquisition performance.
    - Materialization: TABLE (for performance in Looker Studio)
*/

{{ config(
    materialized='table',
    partition_by={
      "field": "conversion_date",
      "data_type": "date",
      "granularity": "day"
    },
    cluster_by=["utm_source", "utm_campaign"]
) }}

WITH conversions AS (
    SELECT * FROM {{ ref('fct_survey_conversions') }}
),

final AS (
    SELECT
        EXTRACT(DATE FROM conversion_timestamp) AS conversion_date,
        utm_source,
        utm_medium,
        utm_campaign,
        
        -- Success Metrics
        COUNT(submission_id) AS total_conversions,
        SUM(is_high_quality_lead) AS total_high_quality_leads,
        
        -- Score Metrics
        AVG(overall_score) AS average_readiness_score

    FROM conversions
    GROUP BY 1, 2, 3, 4
)

SELECT * FROM final
