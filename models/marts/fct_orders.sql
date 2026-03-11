select
    o.order_id,
    o.order_date,
    o.quantity,
    c.customer_id,
    c.customer_name,
    c.city,
    p.product_id,
    p.product_name,
    p.category,
    p.price                                     as unit_price,
    {{ calc_revenue('o.quantity', 'p.price') }} as total_revenue
from {{ ref('stg_orders') }}    o
left join {{ ref('stg_customers') }} c using (customer_id)
left join {{ ref('stg_products') }}  p using (product_id)
