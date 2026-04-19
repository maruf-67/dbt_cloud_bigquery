/*
    MART MODEL: mart_lead_propensity_scores
    - Purpose: Generate ongoing conversion probability scores for every identified user.
    - Refresh: Daily
*/

{{ config(
    materialized='table'
) }}

WITH latest_features AS (
    SELECT * FROM {{ ref('mart_ai_training_set') }}
),

predictions AS (
    SELECT
        identity_key,
        LEAST(
            1.0,
            GREATEST(
                0.0,
                (
                    0.45 * (feat_avg_readiness_score / 100.0)
                    + 0.30 * LEAST(feat_total_sessions / 10.0, 1.0)
                    + 0.15 * LEAST(feat_total_page_views / 50.0, 1.0)
                    + 0.10 * CAST(label_converted_hq AS FLOAT64)
                )
            )
        ) AS conversion_probability
    FROM latest_features
)

SELECT
    ident.identity_key,
    ident.hashed_email,
    pred.conversion_probability,
    CASE 
        WHEN pred.conversion_probability > 0.8 THEN 'HIGH'
        WHEN pred.conversion_probability > 0.4 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS propensity_segment,
    CURRENT_TIMESTAMP() AS scored_at
FROM {{ ref('dim_identity_map') }} AS ident
JOIN predictions AS pred ON ident.identity_key = pred.identity_key
