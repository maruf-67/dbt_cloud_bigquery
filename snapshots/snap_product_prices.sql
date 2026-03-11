{% snapshot snap_product_prices %}

{{
    config(
        target_database=target.project,
        target_schema=target.schema ~ '_snapshots',
        unique_key='product_id',
        strategy='check',
        check_cols=['price'],
        invalidate_hard_deletes=true
    )
}}

select
    product_id,
    product_name,
    category,
    price
from {{ ref('stg_products') }}

{% endsnapshot %}
