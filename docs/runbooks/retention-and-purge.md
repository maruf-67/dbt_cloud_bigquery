# Runbook: Retention and Purge

## Retention policy
- Raw landing and transient ingest: 30 days.
- Staging: 13 months.
- Curated marts: 36 months.

## Right-to-be-forgotten workflow
1. Receive deletion request with auditable ticket id.
2. Locate identity via deterministic key (`hashed_email`).
3. Remove/obfuscate eligible records from operational source where policy requires.
4. Trigger rebuild of affected downstream models.
5. Record completion audit log.

## Safety controls
- Never expose plain email in analytics marts.
- Validate deletion impact does not break model contracts.

## Verification
1. Confirm identity no longer appears in downstream marts.
2. Confirm BI reports remain query-safe after refresh.
