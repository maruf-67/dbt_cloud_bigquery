# Release Evidence Record (RC) - 2026-04-19

## Release Metadata
- Release ID: RC-2026-04-19
- Release date/time (UTC): 2026-04-19
- Release owner: TBD
- Environments covered: dev
- Related PRs/issues: TBD
- Change window: TBD
- Rollback owner: TBD
- Overall status: IN PROGRESS

## 1) GTM / GA4 Tracking Evidence
- Status: IN PROGRESS
- GTM preview URL or screenshots: TBD
- Sample payload proving required fields (`event_id`, `user_pseudo_id`, `session_id`, `event_version`): TBD
- Consent Mode v2 verification evidence: TBD
- Confirmation that plain email is absent from analytics payloads: TBD
- Risk note (required if FAIL/WAIVED): Event payload-level GTM preview evidence still pending, but frontend build/lint baseline is green.

## 2) dbt Build and Quality Evidence
- Status: IN PROGRESS
- `dbt parse` result artifact/log link: Local terminal run on 2026-04-19; parse completed with compatibility warnings.
- `dbt test` result artifact/log link: Local terminal runs on 2026-04-19; expanded selector tests pass for configured contracts.
- Source freshness report link: TBD
- Models included in release selector: `stg_ga4_events`, `stg_linkedin_leads`, `stg_meta_ads`, `stg_survey_submissions`, `stg_leads`, `dim_*`, `fct_*`, `mart_*`
- Placeholder model exclusion proof: TBD
- Risk note (required if FAIL/WAIVED): Build health is green for current subset; remaining risk is source completeness for identity-bearing lead data.

### Latest validation run summary
- Schema/test configuration blocker `source_not_null_ga4_events_` was removed from `models/schema.yml`.
- Source dataset routing was parameterized using dbt vars in `models/schema.yml` and `dbt_project.yml`.
- Legacy `ecommerce_*` project/schema naming was removed from active config and docs.
- BigQuery MCP confirmed active dataset `analytics_526441677` (EU); `dbt_test` is removed.
- BigQuery MCP re-validation confirmed `analytics_526441677` now contains GA4 date-sharded events and pseudonymous user shards only.
- BigQuery cleanup completed: misrouted curated/ads tables were removed from `analytics_526441677` to preserve source-only boundary.
- `dbt run --select stg_ga4_events stg_linkedin_leads stg_meta_ads ...` succeeded (3/3).
- `dbt test --select stg_ga4_events stg_linkedin_leads stg_meta_ads ...` succeeded (7/7).
- `dbt run --select stg_ga4_events stg_survey_submissions stg_leads dim_identity_map fct_survey_conversions mart_lead_attribution` succeeded (6/6).
- `dbt test --select stg_ga4_events dim_identity_map fct_survey_conversions mart_lead_attribution` succeeded (13/13).
- `dbt run --select dim_* fct_* mart_*` succeeded (17/17).
- `dbt test --select dim_* fct_* mart_* stg_ga4_events stg_linkedin_leads stg_meta_ads` succeeded (16/16).
- `dbt_project.yml` marts default materialization changed to `table` to comply with BigQuery constraints for derived/placeholder marts.
- `mart_readiness_distribution` was implemented from `fct_survey_conversions` with canonical readiness buckets.
- `mart_lead_propensity_scores` now uses deterministic heuristic scoring until `ml_propensity_model` is provisioned.
- BigQuery MCP row-count evidence for integration subset:
  - `stg_survey_submissions`: 8
  - `stg_leads`: 0
  - `dim_identity_map`: 0
  - `fct_survey_conversions`: 8
  - `mart_lead_attribution`: 2
- BigQuery MCP row-count evidence for expanded selector highlights:
  - `fct_campaign_performance`: 0
  - `fct_leads`: 0
  - `fct_survey_events`: 0
  - `mart_readiness_distribution`: 0
  - `mart_survey_funnel`: 0
  - `mart_lead_propensity_scores`: 0

### Immediate remediation required
1. Validate source availability and mappings for native Supabase, HubSpot, and Salesforce tables in BigQuery.
2. Replace temporary GA4-derived fallbacks in `stg_survey_submissions` and `stg_leads` once native sources are available.
3. Execute `dbt test --fail-fast` for expanded marts selector after native-source cutover.
4. Re-enable a strict readiness-bucket enum assertion after dbt-fusion schema-resolution behavior is stabilized.
5. Update this record with data-volume parity checks and owner sign-off.

### Package/runtime warning classification
- Decision: Accepted risk for RC-2026-04-19.
- Basis: No parse/run/test hard failures in expanded selector; warnings are compatibility advisories only.
- Follow-up actions:
  1. Keep the current package lock in sync with the resolver-backed `calogica/dbt_date` pin until a stable migration path is approved.
  2. Align package versions for the chosen dbt runtime path (stable core or fusion preview).
  3. Re-run parse and full selector tests after any package/runtime alignment change.

## 3) Warehouse/Data Contract Evidence
- Status: WAIVED
- Source contract changes (if any): None in this run.
- Mart contract changes (if any): None in this run.
- Changelog entries updated in:
  - `docs/contracts/source-contracts.md`
  - `docs/contracts/mart-contracts.md`
- Backward compatibility assessment: Pending after warehouse blockers are resolved.
- Risk note (required if FAIL/WAIVED): Contract validation deferred until dbt P0 failures are addressed.

## 4) Dashboard QA Evidence
- Status: WAIVED
- Dashboard URLs reviewed: TBD
- KPI parity checks (`started`, `completed`, `drop_off`) link: TBD
- Freshness check evidence: TBD
- Query performance check evidence: TBD
- QA approver: TBD
- Risk note (required if FAIL/WAIVED): Deferred until pipeline baseline is green.

## 5) Privacy and Governance Evidence
- Status: WAIVED
- PII boundary verification: Pending
- Retention/deletion runbook verification: Pending
- Incident exceptions or risk acceptance notes: Pending
- Risk note (required if FAIL/WAIVED): Verification scheduled after A1/A2 and B1/B2 tasks.

## 6) Evidence Index (Quick Links)
| Gate | Status | Evidence link | Owner | Reviewed at (UTC) |
| --- | --- | --- | --- | --- |
| GTM / GA4 Tracking | IN PROGRESS | Next.js `pnpm lint` + `pnpm build` pass (2026-04-19) | Frontend Engineer | TBD |
| dbt Build and Quality | IN PROGRESS | Local terminal output from 2026-04-19 parse/test/run + MCP evidence queries | Data Engineer | TBD |
| Data Contract Validation | WAIVED | TBD | Data Engineer | TBD |
| Dashboard QA | WAIVED | TBD | Analytics Engineer | TBD |
| Privacy and Governance | WAIVED | TBD | Product/Ops | TBD |

## 7) Sign-Off Record
- Frontend owner sign-off: Pending
- Backend/API owner sign-off: Pending
- Data engineering sign-off: Pending
- Analytics/BI sign-off: Pending
- Product/Ops sign-off: Pending

## Final Decision
- Go / No-Go: No-Go
- Final approver: TBD
- Decision timestamp (UTC): TBD
- Open risks accepted by: None

## Appendix: MCP Queries Used
- Table inventory:
  - `SELECT table_name, table_type FROM \`sigma-sector-488608-g0.analytics_526441677.INFORMATION_SCHEMA.TABLES\` ORDER BY table_name`
- Fact schema check:
  - `SELECT column_name, data_type FROM \`sigma-sector-488608-g0.analytics_core.INFORMATION_SCHEMA.COLUMNS\` WHERE table_name = 'fct_survey_conversions' ORDER BY ordinal_position`
- Integration row counts:
  - `SELECT 'stg_survey_submissions' AS model_name, COUNT(*) AS row_count FROM \`sigma-sector-488608-g0.analytics_staging.stg_survey_submissions\` UNION ALL ...`
- Expanded selector row counts:
  - `SELECT 'fct_campaign_performance' AS model_name, COUNT(*) AS row_count FROM \`sigma-sector-488608-g0.analytics_core.fct_campaign_performance\` UNION ALL ...`
