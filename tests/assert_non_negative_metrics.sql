select *
from {{ ref('fct_campaign_performance') }}
where spend < 0
   or clicks < 0
   or impressions < 0
