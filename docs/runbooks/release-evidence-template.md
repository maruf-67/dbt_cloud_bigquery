# Release Evidence Template

## How to use
1. Fill this template during release candidate validation, not after production deployment.
2. Every `Status` field must be `PASS`, `FAIL`, or `WAIVED`.
3. Any `FAIL` or `WAIVED` entry must include a risk note and approver.

## Release Metadata
- Release ID:
- Release date/time (UTC):
- Release owner:
- Environments covered:
- Related PRs/issues:
- Change window:
- Rollback owner:
- Overall status: PASS / FAIL / WAIVED

## 1) GTM / GA4 Tracking Evidence
- Status: PASS / FAIL / WAIVED
- GTM preview URL or screenshots:
- Sample payload proving required fields (`event_id`, `user_pseudo_id`, `session_id`, `event_version`):
- Consent Mode v2 verification evidence:
- Confirmation that plain email is absent from analytics payloads:
- Risk note (required if FAIL/WAIVED):

## 2) dbt Build and Quality Evidence
- Status: PASS / FAIL / WAIVED
- `dbt parse` result artifact/log link:
- `dbt test` result artifact/log link:
- Source freshness report link:
- Models included in release selector:
- Placeholder model exclusion proof:
- Risk note (required if FAIL/WAIVED):

## 3) Warehouse/Data Contract Evidence
- Status: PASS / FAIL / WAIVED
- Source contract changes (if any):
- Mart contract changes (if any):
- Changelog entries updated in:
  - `docs/contracts/source-contracts.md`
  - `docs/contracts/mart-contracts.md`
- Backward compatibility assessment:
- Risk note (required if FAIL/WAIVED):

## 4) Dashboard QA Evidence
- Status: PASS / FAIL / WAIVED
- Dashboard URLs reviewed:
- KPI parity checks (`started`, `completed`, `drop_off`) link:
- Freshness check evidence:
- Query performance check evidence:
- QA approver:
- Risk note (required if FAIL/WAIVED):

## 5) Privacy and Governance Evidence
- Status: PASS / FAIL / WAIVED
- PII boundary verification:
- Retention/deletion runbook verification:
- Incident exceptions or risk acceptance notes:
- Risk note (required if FAIL/WAIVED):

## 6) Evidence Index (Quick Links)
| Gate | Status | Evidence link | Owner | Reviewed at (UTC) |
| --- | --- | --- | --- | --- |
| GTM / GA4 Tracking |  |  |  |  |
| dbt Build and Quality |  |  |  |  |
| Data Contract Validation |  |  |  |  |
| Dashboard QA |  |  |  |  |
| Privacy and Governance |  |  |  |  |

## 7) Sign-Off Record
- Frontend owner sign-off:
- Backend/API owner sign-off:
- Data engineering sign-off:
- Analytics/BI sign-off:
- Product/Ops sign-off:

## Final Decision
- Go / No-Go:
- Final approver:
- Decision timestamp (UTC):
- Open risks accepted by:
