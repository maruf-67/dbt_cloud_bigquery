/*
    STAGING MODEL: stg_hubspot_contacts
    - Status: INCOMPLETE (Awaiting active Airbyte/Fivetran connector)
    - Instructions: 
        1. Extract email and convert to SHA-256 for the identity graph.
        2. Clean and standardize first_name, last_name, company.
        3. Flatten lifecycle stages.
*/

-- Placeholder to ensure valid compilation
SELECT 
    CAST(NULL AS STRING) AS hashed_email,
    CAST(NULL AS STRING) AS first_name,
    CAST(NULL AS STRING) AS last_name,
    CAST(NULL AS STRING) AS lifecycle_stage,
    CAST(NULL AS TIMESTAMP) AS created_at
LIMIT 0
