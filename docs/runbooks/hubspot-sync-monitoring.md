# Runbook: HubSpot Sync Monitoring

## Purpose
Monitor lead/contact sync integrity between application route processing and warehouse source ingestion.

## Health checks
1. HubSpot API response success rate from route metrics.
2. Daily row delta in `hubspot.contacts` source.
3. Null checks on `email`, `readiness_level`, `readiness_score`.

## Common failure modes
- Invalid/missing custom properties.
- Token scope issues.
- Rate limiting or transient 5xx from HubSpot.

## Triage steps
1. Verify token configured and not expired.
2. Verify custom properties exist in HubSpot account.
3. Inspect route retry counters and failed events.
4. Confirm source connector sync schedule executed.

## Recovery
1. Fix property/token issues.
2. Replay failed submissions from durable source if available.
3. Re-run dbt staging and affected marts.
