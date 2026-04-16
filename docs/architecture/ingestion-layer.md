# Ingestion Layer: Multi-Source Orchestration

## Overview
The ingestion layer is responsible for extracting raw data from disparate 3rd party services and landing them into the BigQuery `BASE` layer. To support unified lead reporting and AI training, data from all sources must be reformatted into a consistent schema.

## Primary Sources

### 1. Google Analytics (GA4)
- **Method**: BigQuery Export (Native)
- **Scope**: Behavioral events, session data, user pseudo identifiers.
- **Privacy**: No plain PII (only hashed identifiers).

### 2. Meta Ads
- **Method**: API Extraction (via Cloud Functions/Nitro Workers)
- **Standardized Fields**: `campaign_id`, `ad_id`, `spend`, `impressions`, `clicks`.
- **Conversion Tracking**: Pushing standardized events back to Meta via Conversions API (CAPI) if required.

### 3. LinkedIn Ads
- **Method**: API Extraction
- **Scope**: Campaign performance and Lead Gen Form submissions.
- **Normalization**: Mapping LinkedIn campaign IDs to our unified attribution models.

### 4. Salesforce (CRM)
- **Method**: Salesforce Connector / API extraction.
- **Key Objects**: `Lead`, `Opportunity`, `Account`, `Contact`.
- **Formatting**: Mapping Salesforce identity fields to our `dim_identity_map` via `hashed_email`.

### 5. Supabase (Backend)
- **Method**: Postgres Sync (Direct or via CDC)
- **Scope**: `survey_submissions`, `leads`.
- **Role**: Secure storage for plain-text PII (isolated from analytics logs).

## Standardized Formatting Rules
As per the project vision, data from Meta, LinkedIn, and Salesforce must be reformatted into a common schema BEFORE or DURING the staging layer to facilitate:
1. **Unified Lead Generation Tracking**: Consolidated funnel from ad click to signed opportunity.
2. **Cross-Service Attribution**: Understanding the touchpoints across LinkedIn vs Meta.
3. **Data Science Preparedness**: Ensuring consistent data types and non-null constraints for ML model inputs.
