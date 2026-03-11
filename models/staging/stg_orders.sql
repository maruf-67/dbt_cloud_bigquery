with source_data as (
    select * from {{ source('ecommerce', 'orders') }}
)

select
    cast(order_id    as string) as order_id,
    cast(customer_id as string) as customer_id,
    cast(product_id  as string) as product_id,
    cast(quantity    as int64)  as quantity,
    cast(order_date  as date)   as order_date
from source_data
