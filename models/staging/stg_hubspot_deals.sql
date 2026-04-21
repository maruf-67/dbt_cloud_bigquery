/*
    STAGING MODEL: stg_hubspot_deals
    - Purpose: Normalize HubSpot deals loaded by cf-bigquery-sync.
*/

WITH src AS (
    SELECT
        CAST(event_id AS STRING) AS event_id,
        CAST(crm_id AS STRING) AS crm_id,
        TRIM(CAST(deal_name AS STRING)) AS deal_name,
        LOWER(TRIM(CAST(deal_stage AS STRING))) AS deal_stage,
        LOWER(TRIM(CAST(pipeline AS STRING))) AS pipeline,
        SAFE_CAST(amount AS NUMERIC) AS amount,
        TIMESTAMP(close_date) AS close_date,
        TIMESTAMP(created_at) AS created_at,
        TIMESTAMP(updated_at) AS updated_at,
        TIMESTAMP(ingested_at) AS ingested_at,
        CAST(archived AS BOOL) AS archived,
        CAST(run_id AS STRING) AS run_id,
        CAST(payload AS JSON) AS payload
    FROM {{ source('hubspot', 'deals') }}
),

final AS (
    SELECT
        event_id,
        crm_id,
        deal_name,
        deal_stage,
        pipeline,
        amount,
        close_date,
        created_at,
        updated_at,
        ingested_at,
        archived,
        run_id,
        payload
    FROM src
    WHERE crm_id IS NOT NULL
      AND pipeline IS NOT NULL
      AND pipeline != ''
)

SELECT *
FROM final
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY crm_id
    ORDER BY updated_at DESC, ingested_at DESC
) = 1
