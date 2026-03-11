# dbt_cloud_bigquery — E-commerce Analytics

dbt project targeting **BigQuery dataset `dbt_test`** with customers, products, and orders.

---

## Data Model DAG

```
sources (dbt_test)
  customers ──► stg_customers ──► dim_customers ──┐
  products  ──► stg_products  ──► dim_products  ──┤──► fct_orders ──► fct_customer_orders
  orders    ──► stg_orders    ────────────────────┘
```

---

## Folder Structure

```
.
├── analyses/
│   ├── customer_ltv_ranking.sql
│   └── revenue_by_category.sql
├── macros/
│   └── safe_divide.sql         (safe_divide + calc_revenue helpers)
├── models/
│   ├── marts/
│   │   ├── dim_customers.sql
│   │   ├── dim_products.sql
│   │   ├── fct_orders.sql
│   │   ├── fct_customer_orders.sql
│   │   └── schema.yml
│   └── staging/
│       ├── src_ecommerce.yml   (source declarations)
│       ├── stg_customers.sql / stg_customers.yml
│       ├── stg_products.sql  / stg_products.yml
│       └── stg_orders.sql    / stg_orders.yml
├── seeds/
│   ├── schema.yml
│   └── seed_product_price_tiers.csv
├── snapshots/
│   └── snap_product_prices.sql
├── tests/
│   └── assert_positive_quantity.sql
├── dbt_project.yml
└── README.md
```

---

## Source Tables (BigQuery dataset: `dbt_test`)

| Table       | Key columns                                             |
| ----------- | ------------------------------------------------------- |
| `customers` | customer_id, name, city                                 |
| `products`  | product_id, product_name, category, price               |
| `orders`    | order_id, customer_id, product_id, quantity, order_date |

---

## Models

| Layer   | Model                 | Materialization   | Description                                |
| ------- | --------------------- | ----------------- | ------------------------------------------ |
| Staging | `stg_customers`       | view              | Type-cast + trimmed customers              |
| Staging | `stg_products`        | view              | Type-cast + trimmed products               |
| Staging | `stg_orders`          | view              | Type-cast orders with FK tests             |
| Marts   | `dim_customers`       | materialized_view | Customer dimension (1 row/customer)        |
| Marts   | `dim_products`        | materialized_view | Product dimension (1 row/product)          |
| Marts   | `fct_orders`          | materialized_view | Order fact with revenue = quantity × price |
| Marts   | `fct_customer_orders` | table             | Lifetime metrics per customer              |

---

## Run Commands

```bash
dbt deps                          # install packages
dbt seed                          # load seed_product_price_tiers into BigQuery
dbt run                           # build all models in DAG order
dbt test                          # run schema + singular tests
dbt snapshot                      # track product price history
dbt run -s stg_customers          # run a single model
dbt run -s +fct_orders            # run fct_orders + all its ancestors
```

---

## Overriding the Source Schema

The source schema defaults to `dbt_test` (set in `dbt_project.yml`).  
Override at runtime if needed:

```bash
dbt run --vars '{"ecommerce_schema": "your_dataset"}'
```
