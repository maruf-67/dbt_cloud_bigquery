/*
    MART MODEL: mart_readiness_distribution
    - Purpose: Distribution of survey submissions by readiness bucket.
*/

WITH conversions AS (
    SELECT
        conversion_timestamp,
        overall_score,
        score_range
    FROM {{ ref('fct_survey_conversions') }}
),

bucketed AS (
    SELECT
        DATE(conversion_timestamp) AS conversion_date,
        CASE
            WHEN score_range IN (
                '20-35_data_disadvantaged',
                '36-50_data_aware',
                '51-70_data_capable',
                '71-85_data_advantaged',
                '86-100_data_leadership'
            ) THEN score_range
            WHEN overall_score BETWEEN 20 AND 35 THEN '20-35_data_disadvantaged'
            WHEN overall_score BETWEEN 36 AND 50 THEN '36-50_data_aware'
            WHEN overall_score BETWEEN 51 AND 70 THEN '51-70_data_capable'
            WHEN overall_score BETWEEN 71 AND 85 THEN '71-85_data_advantaged'
            WHEN overall_score BETWEEN 86 AND 100 THEN '86-100_data_leadership'
            ELSE NULL
        END AS score_bucket
    FROM conversions
),

final AS (
    SELECT
        conversion_date,
        score_bucket,
        COUNT(*) AS submission_count
    FROM bucketed
    WHERE score_bucket IS NOT NULL
    GROUP BY 1, 2
)

SELECT * FROM final
