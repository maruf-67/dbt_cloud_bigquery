{{ config(materialized='table') }}

-- Grain: one row per customer. Aggregates lifetime order metrics.
select
    c.customer_id,
    c.customer_name,
    c.city,
    count(distinct o.order_id)  as total_orders,
    sum(o.total_revenue)        as lifetime_revenue,
    min(o.order_date)           as first_order_date,
    max(o.order_date)           as last_order_date
from {{ ref('dim_customers') }} c
left join {{ ref('fct_orders') }} o using (customer_id)
group by c.customer_id, c.customer_name, c.city
