-- created_at: 2026-03-11T04:41:47.387586801+00:00
-- finished_at: 2026-03-11T04:41:48.565315371+00:00
-- elapsed: 1.2s
-- outcome: error
-- error vendor code: -2147483648
-- error message: Unknown: [BigQuery] googleapi: Error 403: Access Denied: Project bigquery-testing-489807: User does not have bigquery.jobs.create permission in project bigquery-testing-489807., accessDenied
-- dialect: bigquery
-- node_id: not available
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "default", "target_name": "dev"} */

    select distinct schema_name from `bigquery-testing-489807`.INFORMATION_SCHEMA.SCHEMATA;
  ;
-- created_at: 2026-03-11T04:41:49.571757155+00:00
-- finished_at: 2026-03-11T04:41:50.072809556+00:00
-- elapsed: 501ms
-- outcome: error
-- error vendor code: -2147483648
-- error message: Unknown: [BigQuery] googleapi: Error 403: Access Denied: Project bigquery-testing-489807: User does not have bigquery.jobs.create permission in project bigquery-testing-489807., accessDenied
-- dialect: bigquery
-- node_id: not available
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "default", "target_name": "dev"} */
create schema if not exists `dbt_test`;
-- created_at: 2026-03-11T04:41:51.188017494+00:00
-- finished_at: 2026-03-11T04:41:52.170282921+00:00
-- elapsed: 982ms
-- outcome: error
-- error vendor code: -2147483648
-- error message: Unknown: [BigQuery] googleapi: Error 403: Access Denied: Project bigquery-testing-489807: User does not have bigquery.jobs.create permission in project bigquery-testing-489807., accessDenied
-- dialect: bigquery
-- node_id: seed.ecommerce_analytics.seed_product_price_tiers
-- query_id: not available
-- desc: get_relation > list_relations call
SELECT
    table_catalog,
    table_schema,
    table_name,
    table_type
FROM 
    `bigquery-testing-489807`.`dbt_test`.INFORMATION_SCHEMA.TABLES;
-- created_at: 2026-03-11T04:41:52.175155115+00:00
-- finished_at: 2026-03-11T04:41:52.556785334+00:00
-- elapsed: 381ms
-- outcome: error
-- error vendor code: -2147483648
-- error message: Unknown: [BigQuery] googleapi: Error 403: Access Denied: Project bigquery-testing-489807: User does not have bigquery.jobs.create permission in project bigquery-testing-489807., accessDenied
-- dialect: bigquery
-- node_id: seed.ecommerce_analytics.seed_product_price_tiers
-- query_id: not available
-- desc: get_relation adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "seed.ecommerce_analytics.seed_product_price_tiers", "profile_name": "default", "target_name": "dev"} */
SELECT table_catalog,
                    table_schema,
                    table_name,
                    table_type
                FROM `bigquery-testing-489807`.`dbt_test`.INFORMATION_SCHEMA.TABLES
                WHERE table_name = 'seed_product_price_tiers';
