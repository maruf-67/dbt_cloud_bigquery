/*
    STAGING MODEL: stg_hubspot_companies
    - Purpose: Normalize HubSpot companies loaded by cf-bigquery-sync.
*/

WITH src AS (
    SELECT
        CAST(event_id AS STRING) AS event_id,
        CAST(crm_id AS STRING) AS crm_id,
        TRIM(CAST(company_name AS STRING)) AS company_name,
        LOWER(TRIM(CAST(domain AS STRING))) AS domain,
        LOWER(TRIM(CAST(industry AS STRING))) AS industry,
        TIMESTAMP(created_at) AS created_at,
        TIMESTAMP(updated_at) AS updated_at,
        TIMESTAMP(ingested_at) AS ingested_at,
        CAST(archived AS BOOL) AS archived,
        CAST(run_id AS STRING) AS run_id,
        CAST(payload AS JSON) AS payload
    FROM {{ source('hubspot', 'companies') }}
),

final AS (
    SELECT
        event_id,
        crm_id,
        company_name,
        domain,
        industry,
        created_at,
        updated_at,
        ingested_at,
        archived,
        run_id,
        payload
    FROM src
    WHERE crm_id IS NOT NULL
      AND company_name IS NOT NULL
      AND company_name != ''
)

SELECT *
FROM final
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY crm_id
    ORDER BY updated_at DESC, ingested_at DESC
) = 1
