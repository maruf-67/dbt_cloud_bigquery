-- Fails if any order has a non-positive quantity (data quality guard).
select *
from {{ ref('stg_orders') }}
where quantity <= 0
