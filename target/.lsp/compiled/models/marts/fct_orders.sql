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
    
    cast(o.quantity as numeric) * cast(p.price as numeric)
 as total_revenue
from `bigquery-testing-489807`.`dbt_test`.`stg_orders`    o
left join `bigquery-testing-489807`.`dbt_test`.`stg_customers` c using (customer_id)
left join `bigquery-testing-489807`.`dbt_test`.`stg_products`  p using (product_id)