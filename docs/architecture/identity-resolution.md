# Identity Resolution & Graph Table

## dim_identity_map
Currently, identity resolution depends on `hashed_email` alone. The `dim_identity_map` table unifies cross-system identities.

**Implementation:**
- Single source of truth for identity resolution across GA4, CRM, and HubSpot.
- **Primary key**: `hashed_email` (immutable).
- **Columns**: `hubspot_contact_id`, `user_pseudo_id`, `first_seen_at`, `last_updated_at`.
- Updated via upsert logic in dbt staging models whenever new contact or pseudo_id is discovered.
- Enables ML-safe joins with full identity context (no dangling keys).

### Idempotency
- **event_id**: Unique UUID associated to each interaction for dedup handling via `QUALIFY row_number()`
- Client-edge PII transit restrictions enforced. `event_id` provides downstream duplication handling without relying on timestamps entirely.
