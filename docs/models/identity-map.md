# Identity Map (`dim_identity_map`)

## Purpose
`dim_identity_map` is the warehouse identity spine linking behavioral and lead systems with privacy-preserving identifiers.

## Intended grain
One row per unique hashed identity.

## Current mapping strategy
1. Bridge survey submissions to GA4 events via `app_event_id`.
2. Link submission records to leads via `submission_id`.
3. Carry forward `user_pseudo_id` and `hashed_email` as join keys.

## Current output fields
- `identity_key`
- `hashed_email`
- `user_pseudo_id`
- `internal_lead_id`
- `identified_at`

## Known caveats
- `identity_key` currently derives from MD5 of `hashed_email`; this should be reviewed against SHA-256-only governance intent.
- records without bridgeable `app_event_id` may remain partially connected and require orphan monitoring.

## Validation targets
- `identity_key` unique, not null.
- `hashed_email` unique, not null.
- orphan ratio trend tracked in operations review.
