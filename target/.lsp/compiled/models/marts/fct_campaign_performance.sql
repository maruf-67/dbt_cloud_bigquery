select
    campaign_id,
    campaign_name,
    channel,
    event_date,
    spend,
    clicks,
    impressions,
    
    safe_divide(cast(clicks as numeric), nullif(cast(impressions as numeric), 0))
 as ctr,
    
    safe_divide(cast(spend as numeric), nullif(cast(clicks as numeric), 0))
 as cpc
from `bigquery-testing-489807`.`dbt_test`.`stg_campaigns`