# dbt_cloud_bigquery

BigQuery-ready dbt starter project with source definitions, staging and mart models, seeds, tests, macros, snapshots, and analyses.

## Folder Structure

```
.
|-- analyses/
|   `-- campaign_efficiency.sql
|-- macros/
|   `-- safe_divide.sql
|-- models/
|   |-- marts/
|   |   |-- fct_campaign_performance.sql
|   |   `-- fct_campaign_performance.yml
|   `-- staging/
|       |-- src_marketing.yml
|       |-- stg_campaigns.sql
|       `-- stg_campaigns.yml
|-- seeds/
|   |-- schema.yml
|   `-- seed_campaign_targets.csv
|-- snapshots/
|   `-- snap_campaign_budget.sql
|-- tests/
|   `-- assert_non_negative_metrics.sql
|-- dbt_project.yml
`-- README.md
```

## BigQuery Assumptions

- `src_marketing.yml` expects a source table: `{{ target.project }}.{{ var('raw_marketing_schema', 'raw_marketing') }}.campaigns`
- Set `raw_marketing_schema` via vars if your raw schema is different.

Example `campaigns` columns:

- `campaign_id` (string)
- `campaign_name` (string)
- `channel` (string)
- `spend` (numeric)
- `clicks` (int64)
- `impressions` (int64)
- `event_date` (date)

## Run Commands

```bash
dbt deps
dbt seed
dbt run
dbt test
dbt snapshot
```

## What You Have Now

- Source config for raw BigQuery data
- Staging model (`stg_campaigns`) for type-casting and cleanup
- Mart model (`fct_campaign_performance`) with CTR and CPC metrics
- Seed data for campaign targets
- Singular test for non-negative metrics
- Snapshot for change tracking
- Analysis query for channel-level efficiency
