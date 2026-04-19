# Cross-Repo Release Checklist

## Purpose
Single checklist to coordinate release readiness between the survey app and warehouse/reporting stack.

## A. Next.js release gates
- [ ] `pnpm lint` passes.
- [ ] `pnpm build` passes.
- [ ] GTM preview checklist fully signed off.
- [ ] No plain email in GTM/GA4 payloads.
- [ ] HubSpot contact properties verified.
- [ ] API diagnostics endpoint blocked in production.

## B. Data ingestion and warehouse gates
- [ ] `dbt parse` passes without errors.
- [ ] `dbt test` passes for release selectors.
- [ ] Source freshness within SLA (< 2h target, < 6h max).
- [ ] Scheduled jobs configured (hourly staging, daily marts).
- [ ] Placeholder models excluded from production dependencies.

## C. Contract and governance gates
- [ ] Event contract fields validated (`event_id`, `user_pseudo_id`, `session_id`, `event_version`).
- [ ] Enum values validated for score buckets and version fields.
- [ ] PII boundary confirmed (plain email only in operational lead store).
- [ ] Retention/deletion process verified in runbook.

## D. BI and analytics gates
- [ ] Dashboard SQL uses approved marts only.
- [ ] Date-partition filters applied in all production dashboards.
- [ ] KPI parity check complete (started/completed/drop-off).
- [ ] Dashboard load-time and freshness checks signed off.

## E. Sign-off matrix
- [ ] Frontend owner sign-off
- [ ] Backend/API owner sign-off
- [ ] Data engineering sign-off
- [ ] Analytics/BI sign-off
- [ ] Product/operations sign-off

## F. Ownership matrix
| Area | Primary owner | Backup owner | Evidence required |
| --- | --- | --- | --- |
| Next.js tracking and GTM | Frontend Engineer | Product Engineer | GTM preview screenshots + payload sample |
| HubSpot API and lead sync | Backend Engineer | Frontend Engineer | Valid test submission + HubSpot contact record |
| dbt jobs and model quality | Data Engineer | Analytics Engineer | `dbt parse` and `dbt test` artifacts |
| Dashboard correctness | Analytics Engineer | Data Engineer | KPI parity workbook + dashboard QA checklist |
| Privacy and governance | Product/Ops | Backend Engineer | PII boundary verification + retention runbook check |

## G. Final go/no-go rules
1. No critical checklist item can remain open.
2. Any open high-risk item must have explicit written risk acceptance.
3. Release can proceed only after all five owner sign-offs are recorded.
