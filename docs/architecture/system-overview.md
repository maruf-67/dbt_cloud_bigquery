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

## Architecture Alignment Addendum (Contributor Clarity)

Use this section as the canonical implementation snapshot when planning new work.

| Layer | Scope | Status | Notes for contributors |
| --- | --- | --- | --- |
| Frontend collection and consent | Next.js survey flow, Consent Mode v2, GTM event emission | Partial | Core flow and events exist; validate release checklist before adding new tracking fields. |
| API and CRM edge | HubSpot upsert/search route, submission ingestion, idempotent `event_id` flow | Implemented | Keep payload keys stable and preserve hash-only analytics boundary. |
| Source ingestion connectors | GA4 export, Supabase raw, HubSpot, ads connectors | Partial | GA4 and app-origin sources are active; external connector completeness varies by source and schedule. |
| Warehouse staging | Source normalization, enum alignment, privacy-safe transforms | Partial | Staging patterns are defined; enforce tests and freshness for each newly onboarded source. |
| Identity resolution | `dim_identity_map` and cross-source stitching strategy | Planned | Design is documented, but full production-grade stitching and QA gates are not complete. |
| Fact and mart models | Funnel, attribution, readiness marts for BI | Partial | Core marts are documented; some models remain planned or placeholder-gated. |
| BI and dashboard delivery | KPI dashboards and QA parity checks | Partial | Reporting contracts exist; release evidence must include parity proof and freshness validation. |
| ML and AI training datasets | Propensity/training marts and feature governance | Planned | Contracts exist for readiness, but operational model lifecycle is pending full implementation. |
