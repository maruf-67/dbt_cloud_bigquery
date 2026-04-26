/*
    ML MODEL: ml_propensity_model
    - Purpose: Predict the probability of a user converting to a High-Quality Lead.
    - Logic: Managed as a post-hook for BigQuery ML compatibility.
*/

{{ config(
    materialized='view',
    alias='ml_propensity_placeholder',
    pre_hook="DROP VIEW IF EXISTS `{{ this.database }}`.`{{ this.schema }}`.`ml_propensity_model`",
    post_hook="
        CREATE OR REPLACE MODEL `{{ this.database }}`.`{{ this.schema }}`.`ml_propensity_model`
        OPTIONS(
            model_type='logistic_reg',
            input_label_cols=['label_converted_hq'],
            max_iterations=20,
            data_split_method='AUTO_SPLIT'
        ) AS
        SELECT 
            * EXCEPT(identity_key)
        FROM {{ ref('mart_ai_training_set') }}
    "
) }}

-- This view serves as a placeholder for dbt's dependency graph
SELECT 
    'ml_propensity_model' AS model_type,
    CURRENT_TIMESTAMP() AS last_trained_at
