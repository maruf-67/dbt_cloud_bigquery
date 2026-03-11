-- created_at: 2026-03-11T06:04:32.210636867+00:00
-- finished_at: 2026-03-11T06:04:36.958181832+00:00
-- elapsed: 4.7s
-- outcome: success
-- dialect: bigquery
-- node_id: not available
-- query_id: NRyWo0oJftk8jtqRukwX1h3eM6j
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "default", "target_name": "dev"} */

    select distinct schema_name from `bigquery-testing-489807`.INFORMATION_SCHEMA.SCHEMATA;
  ;
-- created_at: 2026-03-11T06:04:36.960787774+00:00
-- finished_at: 2026-03-11T06:04:38.981280109+00:00
-- elapsed: 2.0s
-- outcome: success
-- dialect: bigquery
-- node_id: not available
-- query_id: 2CvDcvX7lrWi0I3mTUEIg2tIYBh
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "default", "target_name": "dev"} */
create schema if not exists `dbt_test_snapshots`;
-- created_at: 2026-03-11T06:04:39.090176315+00:00
-- finished_at: 2026-03-11T06:04:43.073889656+00:00
-- elapsed: 4.0s
-- outcome: success
-- dialect: bigquery
-- node_id: snapshot.ecommerce_analytics.snap_product_prices
-- query_id: 1rUoRJqNiAm5AsWCgA1cIBwgWMn
-- desc: get_relation > list_relations call
SELECT
    table_catalog,
    table_schema,
    table_name,
    table_type
FROM 
    `bigquery-testing-489807`.`dbt_test_snapshots`.INFORMATION_SCHEMA.TABLES;
-- created_at: 2026-03-11T06:04:43.083182593+00:00
-- finished_at: 2026-03-11T06:04:46.144735802+00:00
-- elapsed: 3.1s
-- outcome: success
-- dialect: bigquery
-- node_id: snapshot.ecommerce_analytics.snap_product_prices
-- query_id: k89hHmwkLKl4nENdNmwlHuDhpoQ
-- desc: get_column_schema_from_query adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.ecommerce_analytics.snap_product_prices", "profile_name": "default", "target_name": "dev"} */
select * from (
        
    

    select *,
        to_hex(md5(concat(coalesce(cast(product_id as string), ''), '|',coalesce(cast(
    current_timestamp()
 as string), '')))) as dbt_scd_id,
        
    current_timestamp()
 as dbt_updated_at,
        
    current_timestamp()
 as dbt_valid_from,
        
  
  coalesce(nullif(
    current_timestamp()
, 
    current_timestamp()
), null)
  as dbt_valid_to
from (
        



select
    product_id,
    product_name,
    category,
    price
from `bigquery-testing-489807`.`dbt_test`.`stg_products`


    ) sbq



    ) as __dbt_sbq
    where false and current_timestamp() = current_timestamp()
    limit 0
;
-- created_at: 2026-03-11T06:04:46.146518528+00:00
-- finished_at: 2026-03-11T06:04:49.433939282+00:00
-- elapsed: 3.3s
-- outcome: success
-- dialect: bigquery
-- node_id: snapshot.ecommerce_analytics.snap_product_prices
-- query_id: bSt38kOHgDIdgwkyhFRuvZIeMjt
-- desc: get_column_schema_from_query adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.ecommerce_analytics.snap_product_prices", "profile_name": "default", "target_name": "dev"} */
select * from (
        select 
    current_timestamp()
 as dbt_snapshot_time
    ) as __dbt_sbq
    where false and current_timestamp() = current_timestamp()
    limit 0
;
-- created_at: 2026-03-11T06:04:49.441016106+00:00
-- finished_at: 2026-03-11T06:04:55.167369846+00:00
-- elapsed: 5.7s
-- outcome: success
-- dialect: bigquery
-- node_id: snapshot.ecommerce_analytics.snap_product_prices
-- query_id: Wgvn4tPLyzx7NTEGhZMXJMD4zTT
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.ecommerce_analytics.snap_product_prices", "profile_name": "default", "target_name": "dev"} */

      
  
    

    create or replace table `bigquery-testing-489807`.`dbt_test_snapshots`.`snap_product_prices`
      
    
    

    
    OPTIONS()
    as (
      
    

    select *,
        to_hex(md5(concat(coalesce(cast(product_id as string), ''), '|',coalesce(cast(
    current_timestamp()
 as string), '')))) as dbt_scd_id,
        
    current_timestamp()
 as dbt_updated_at,
        
    current_timestamp()
 as dbt_valid_from,
        
  
  coalesce(nullif(
    current_timestamp()
, 
    current_timestamp()
), null)
  as dbt_valid_to
from (
        



select
    product_id,
    product_name,
    category,
    price
from `bigquery-testing-489807`.`dbt_test`.`stg_products`


    ) sbq



    );
  
  ;
