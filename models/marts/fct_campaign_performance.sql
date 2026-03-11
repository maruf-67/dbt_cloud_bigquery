select
    campaign_id,
    campaign_name,
    channel,
    event_date,
    spend,
    clicks,
    impressions,
    {{ safe_divide('clicks', 'impressions') }} as ctr,
    {{ safe_divide('spend', 'clicks') }} as cpc
from {{ ref('stg_campaigns') }}
