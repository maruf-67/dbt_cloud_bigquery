# Marts

## Purpose
Marts provide denormalized, query-efficient datasets for BI and ML consumers.

## Implemented marts

### `mart_funnel_efficiency`
- Daily session-to-conversion metrics.

### `mart_lead_attribution`
- Daily conversion performance by UTM dimensions.
- Includes partitioning and clustering config.

### `mart_ai_training_set`
- Feature set for lead propensity modeling.

### `mart_intraday_leads`
- Near-real-time monitoring view combining historical and same-day events.

### `mart_lead_propensity_scores`
- ML predictions and segmentation output.

## Incomplete marts (placeholders)
- `mart_campaign_attribution`
- `mart_lead_summary`
- `mart_readiness_distribution`
- `mart_survey_funnel`

## BI usage policy
- only non-placeholder marts should feed production dashboards.
- all dashboard queries must include date filtering aligned with table partitioning.
- any KPI from placeholder marts is considered non-production.

## KPI lineage map
| KPI | Primary mart | Upstream dependencies | Refresh target |
| --- | --- | --- | --- |
| Survey session-to-completion rate | `mart_funnel_efficiency` | `stg_ga4_events`, `fct_survey_conversions` | Daily |
| Lead conversions by channel/campaign | `mart_lead_attribution` | `fct_survey_conversions` | Daily |
| Intraday lead flow | `mart_intraday_leads` | `fct_survey_conversions`, `stg_ga4_events` | Hourly or near-real-time |
| Propensity segment counts | `mart_lead_propensity_scores` | `mart_ai_training_set`, `ml_propensity_model`, `dim_identity_map` | Daily |

## Freshness and QA expectations
1. Every production KPI must map to a non-placeholder mart.
2. Every mapped mart must have documented tests in `models/schema.yml`.
3. Dashboards must fail closed for missing refreshes (show stale-data warning instead of silent success).
