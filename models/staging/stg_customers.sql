with source_data as (
    select * from {{ source('ecommerce', 'customers') }}
)

select
    cast(customer_id as string) as customer_id,
    trim(name)                  as customer_name,
    trim(city)                  as city
from source_data
