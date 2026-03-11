

-- Grain: one row per customer. Aggregates lifetime order metrics.
select
    c.customer_id,
    c.customer_name,
    c.city,
    count(distinct o.order_id)  as total_orders,
    sum(o.total_revenue)        as lifetime_revenue,
    min(o.order_date)           as first_order_date,
    max(o.order_date)           as last_order_date
from `bigquery-testing-489807`.`dbt_test`.`dim_customers` c
left join `bigquery-testing-489807`.`dbt_test`.`fct_orders` o using (customer_id)
group by c.customer_id, c.customer_name, c.city