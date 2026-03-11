-- Top-performing customers ranked by lifetime revenue.
select
    customer_id,
    customer_name,
    city,
    total_orders,
    lifetime_revenue,
    rank() over (order by lifetime_revenue desc) as revenue_rank
from {{ ref('fct_customer_orders') }}
order by revenue_rank
