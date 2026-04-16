# Enterprise Marketing Data Architecture: System Overview

## Core Architectural Directives

* **Zero-Ops & Serverless Preference:** Always utilize native Google Cloud serverless tools or edge frameworks (e.g., Cloudflare Workers / Nitro). 
* **Single Source of Truth (SSOT):** Google BigQuery is the centralized data warehouse. All data pipelines must terminate here.
* **Privacy-First Identity Resolution & Consent:** Implement Google Consent Mode v2. Never send raw Personally Identifiable Information (PII) to Google Analytics or BigQuery web logs. All emails must be hashed strictly using **SHA-256** (MD5 is prohibited) on the client side before transmission.
* **First-Party Data Strategy (sGTM):** Use Google Tag Manager Server-Side (sGTM) as a first-party proxy to manage cookies and anonymize IP addresses before they reach third-party platforms.
* **Unified Source Normalization:** Collect similar data from multiple 3rd party services (Meta, LinkedIn, Salesforce, etc.), reformat them into a standardized schema, and ingest into the SSOT for a unified view of the customer journey.
* **Idempotency & Deduplication:** All ELT and warehouse operations must be deduplicated using unique keys (e.g., `event_id` + `timestamp`). Implement server-side idempotency checks (e.g., via Redis/KV) to prevent duplicate CRM submissions.
* **AI & DS Readiness:** Maintain high-fidelity, typed materialized tables to support LookerML reporting, Data Science modeling, and downstream AI agent training.

### ELT Phases
1. **Phase 1: Frontend Collection & Identity (Next.js & sGTM)**: Privacy-first intake.
2. **Phase 3: Multi-Source Ingestion Layer**: Aggregating Meta Ads, LinkedIn Ads, Salesforce, and Supabase data.
3. **Phase 3: Data Warehousing (dbt & BigQuery)**: Normalizing heterogeneous sources into a unified identity map and mart layer.
4. **Phase 4: Visualization & AI Training**: Powering Looker Studio dashboards, LookerML models, and providing sanitized datasets for Machine Learning.
