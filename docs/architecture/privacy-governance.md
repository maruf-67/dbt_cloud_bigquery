# Data Governance & Privacy Framework

## 1. PII & Identity Protection
This framework ensures that minimal Personally Identifiable Information (PII) enters the data warehouse, adhering to GDPR, CCPA, and Google’s data protection policies.

### Hashing Standard
- **Algorithm**: SHA-256 (Salted when stored in specific CRM lookup tables).
- **Point of Entry**: Client-side (Edge) before transmission.
- **Forbidden**: MD5 and Base64 (reversible) are strictly prohibited for identity hashing.

### Data Anonymization Logic
- **Email (Analytics Path)**: Never sent as plain text to GTM, GA4, or BigQuery analytics logs.
- **Email (CRM Path)**: Real email may be transmitted only from backend API routes to HubSpot Contacts API (Private App token).
- **Lead Storage**: Plain email is stored only in `public.leads` (Supabase) for outreach operations and never pushed to analytics payloads.
- **IP Address**: Anonymized via sGTM (GTM Server-Side) before being sent to GA4 or Meta Ads.
- **User ID**: All `user_id` fields in GA4 must be the SHA-256 hashed version of the authenticated identifier.

## 2. Retention & Purging
To minimize risk, data retention is strictly governed:
- **Raw Landing Zone (Cloudflare / BigQuery Raw)**: 30 days retention.
- **Staging Data**: 13 months (Standard GA4 retention).
- **Curated Marts (Aggregated)**: 3 years.
- **Right to be Forgotten**: Requests received via HubSpot must trigger a dbt `run` that excludes the specific `hashed_email` from the next materialized view refresh.
