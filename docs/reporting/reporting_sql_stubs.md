# Reporting SQL Stubs

## Purpose
Starter SQL templates for BI dashboards. Replace placeholder filters and validate against active marts before publishing.

## 1) Funnel Efficiency (Daily)
```sql
SELECT
  event_date,
  total_sessions,
  total_completions,
  session_to_completion_rate,
  high_quality_conversions,
  lead_quality_rate
FROM {{ ref('mart_funnel_efficiency') }}
WHERE event_date BETWEEN @start_date AND @end_date
ORDER BY event_date DESC;
```

## 2) Lead Attribution by UTM
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
WHERE conversion_date BETWEEN @start_date AND @end_date
ORDER BY conversion_date DESC, total_conversions DESC;
```

## 3) Readiness Distribution
```sql
SELECT
  score_bucket,
  bucket_count,
  ROUND(100 * SAFE_DIVIDE(bucket_count, SUM(bucket_count) OVER()), 2) AS bucket_pct
FROM {{ ref('mart_readiness_distribution') }}
WHERE report_date BETWEEN @start_date AND @end_date
ORDER BY score_bucket;
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
WHERE DATE(conversion_timestamp) = CURRENT_DATE()
ORDER BY conversion_timestamp DESC;
```

## 5) Propensity Score Segments
```sql
SELECT
  propensity_segment,
  COUNT(*) AS users,
  ROUND(AVG(conversion_probability), 4) AS avg_probability
FROM {{ ref('mart_lead_propensity_scores') }}
GROUP BY propensity_segment
ORDER BY avg_probability DESC;
```
