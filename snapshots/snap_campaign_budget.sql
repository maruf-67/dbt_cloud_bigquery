{% snapshot snap_campaign_budget %}

{{
    config(
        target_database=target.project,
        target_schema=target.schema ~ '_snapshots',
        unique_key="concat(campaign_id, '-', cast(event_date as string))",
        strategy='check',
        check_cols=['spend', 'clicks', 'impressions'],
        invalidate_hard_deletes=true
    )
}}

select
    campaign_id,
    spend,
    clicks,
    impressions,
    event_date
from {{ ref('stg_campaigns') }}

{% endsnapshot %}
