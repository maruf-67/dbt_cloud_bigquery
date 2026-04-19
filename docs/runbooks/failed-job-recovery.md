# Runbook: Failed Job Recovery

## Severity levels
- Sev 1: daily marts not produced before business hours.
- Sev 2: staging delay > 6h.
- Sev 3: non-critical model/test failure with no dashboard impact.

## Severity matrix
| Severity | Business impact | Example trigger | Initial response target | Owner |
| --- | --- | --- | --- | --- |
| Sev 1 | Executive dashboards blocked or materially wrong | Daily mart job failed before reporting window | 15 minutes | Data Engineer |
| Sev 2 | Delayed decisions due to stale data | Critical source freshness breach > 6h | 30 minutes | Data Engineer |
| Sev 3 | Localized data quality issue with workaround | Single non-critical model/test failure | 4 hours | Analytics Engineer |

## First response
1. Identify failed node(s) and failing SQL/test.
2. Classify as infra, source outage, or model regression.
3. Pause downstream jobs if contract-breaking.
4. Open incident record with severity and owner.

## Recovery flow
1. Retry failed job once for transient warehouse errors.
2. If source outage, mark job deferred and backfill after source recovery.
3. If model regression, revert to last known-good selector run.
4. Rebuild affected lineage only (`--select <failed_model>+`).

## Validation before close
1. Tests pass on affected lineage.
2. Dashboard KPI parity check vs prior successful run.
3. Incident log updated with root cause and prevention action.
4. Follow-up task created for permanent fix if temporary mitigation was used.
