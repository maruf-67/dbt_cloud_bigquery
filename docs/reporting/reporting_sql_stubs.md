# Reporting SQL Stubs

## Purpose
Production-safe SQL templates for BI dashboards. Use partition-aligned date filters in every published query and prefer curated marts over raw/staging models.

## Mandatory filter policy
- Production dashboard queries must filter partition columns with `@DS_START_DATE` and `@DS_END_DATE`.
- Do not publish unbounded queries against BigQuery marts.
- Prefer `mart_semantic_overview` for executive funnel + conversion reporting to keep KPI definitions centralized.

## 1) Executive Funnel + Conversion Overview
```sql
SELECT
  event_date,
  utm_source,
  utm_medium,
  utm_campaign,
  started_sessions,
  started_count,
  form_submitted_count,
  completed_count,
  converted_count,
  hq_converted_count,
  avg_readiness_score,
  form_submit_rate_pct,
  completion_rate_pct,
  conversion_rate_pct,
  hq_rate_pct
FROM {{ ref('mart_semantic_overview') }}
WHERE event_date BETWEEN @DS_START_DATE AND @DS_END_DATE
ORDER BY event_date DESC, converted_count DESC;
```

## 2) Readiness Bucket Mix by Channel
```sql
SELECT
  event_date,
  utm_source,
  utm_medium,
  utm_campaign,
  bucket_data_disadvantaged,
  bucket_data_aware,
  bucket_data_capable,
  bucket_data_advantaged,
  bucket_data_leadership
FROM {{ ref('mart_semantic_overview') }}
WHERE event_date BETWEEN @DS_START_DATE AND @DS_END_DATE
ORDER BY event_date DESC;
```

## 3) Lead Attribution by UTM
```sql
SELECT
  conversion_date,
  utm_source,
  utm_medium,
  utm_campaign,
  total_conversions,
  total_high_quality_leads,
  average_readiness_score
FROM {{ ref('mart_lead_attribution') }}
WHERE conversion_date BETWEEN @DS_START_DATE AND @DS_END_DATE
ORDER BY conversion_date DESC, total_conversions DESC;
```

## 4) Intraday Lead Monitoring
```sql
SELECT
  conversion_timestamp,
  data_stream,
  utm_source,
  utm_medium,
  utm_campaign,
  readiness_level,
  is_high_quality_lead
FROM {{ ref('mart_intraday_leads') }}
WHERE DATE(conversion_timestamp) BETWEEN @DS_START_DATE AND @DS_END_DATE
ORDER BY conversion_timestamp DESC;
```

## 5) Propensity Score Segments
```sql
SELECT
  scored_at,
  propensity_segment,
  COUNT(*) AS users,
  ROUND(AVG(conversion_probability), 4) AS avg_probability
FROM {{ ref('mart_lead_propensity_scores') }}
WHERE DATE(scored_at) BETWEEN @DS_START_DATE AND @DS_END_DATE
GROUP BY scored_at, propensity_segment
ORDER BY scored_at DESC, avg_probability DESC;
```
