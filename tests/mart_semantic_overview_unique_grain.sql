SELECT
    event_date,
    utm_source,
    utm_medium,
    utm_campaign,
    COUNT(*) AS row_count
FROM {{ ref('mart_semantic_overview') }}
GROUP BY 1, 2, 3, 4
HAVING COUNT(*) > 1
