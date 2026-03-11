with source_data as (
    select * from `bigquery-testing-489807`.`dbt_test`.`customers`
)

select
    cast(customer_id as string) as customer_id,
    trim(name)                  as customer_name,
    trim(city)                  as city
from source_data