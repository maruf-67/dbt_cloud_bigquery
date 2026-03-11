with source_data as (
    select *
    from `bigquery-testing-489807`.`raw_marketing`.`campaigns`
)

select
    cast(campaign_id as string) as campaign_id,
    trim(campaign_name) as campaign_name,
    lower(channel) as channel,
    cast(spend as numeric) as spend,
    cast(clicks as int64) as clicks,
    cast(impressions as int64) as impressions,
    cast(event_date as date) as event_date
from source_data