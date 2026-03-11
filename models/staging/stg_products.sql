with source_data as (
    select * from {{ source('ecommerce', 'products') }}
)

select
    cast(product_id as string)   as product_id,
    trim(product_name)           as product_name,
    trim(category)               as category,
    cast(price as numeric)       as price
from source_data
