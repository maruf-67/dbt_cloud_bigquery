select
    channel,
    round(avg(ctr), 4) as avg_ctr,
    round(avg(cpc), 2) as avg_cpc,
    sum(spend) as total_spend,
    sum(clicks) as total_clicks
from `bigquery-testing-489807`.`dbt_test`.`fct_campaign_performance`
group by channel
order by total_spend desc