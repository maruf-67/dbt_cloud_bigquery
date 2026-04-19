# Runbook: Source Freshness Monitoring

## Purpose
Define freshness SLAs and response actions for upstream source delays.

## Freshness SLA
- Target: < 2 hours lag for critical sources.
- Max tolerated: 6 hours lag.

## Critical sources
- GA4 events
- Supabase survey submissions
- Supabase leads
- HubSpot contacts

## Monitoring cadence
- Hourly checks for source lag.
- Daily review of trendline and incident recurrence.

## Incident response
1. Identify delayed source and lag duration.
2. Confirm connector/source health externally.
3. Pause dependent marts if source lag invalidates KPIs.
4. Backfill once source resumes.
5. Capture incident notes and preventive action.
