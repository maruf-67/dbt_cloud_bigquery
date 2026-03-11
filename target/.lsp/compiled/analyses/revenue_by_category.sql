-- Revenue and order volume by product category.
select
    category,
    count(distinct order_id)    as total_orders,
    sum(quantity)               as total_units_sold,
    sum(total_revenue)          as total_revenue,
    round(avg(total_revenue), 2) as avg_order_revenue
from `bigquery-testing-489807`.`dbt_test`.`fct_orders`
group by category
order by total_revenue desc