# Marketing Data Orchestration (dbt + BigQuery)

A centralized, privacy-first marketing and CRM data orchestration pipeline built with dbt on Google BigQuery. 
This project ingests multi-source data (GA4, Supabase, LinkedIn, etc.), normalizes it, enforces strict privacy hashing, resolves identities, and feeds directly into performance dashboards and BigQuery ML predictive models.

---

## 🏗 Data Architecture & DAG

The pipeline follows a modern layered architecture:

```text
sources (analytics_526441677)
  ga4_events      ──► stg_ga4_events       ─────────┐
  supabase_RPCs   ──► stg_survey_submissions ───────┤
  linkedin_leads  ──► stg_linkedin_leads   ─────────┼──► dim_identity_map
                                                    │
                                                    ▼
                                            fct_survey_conversions
                                                    │
             ┌──────────────────────────────────────┴──────────────────────────────────────┐
             ▼                                      ▼                                      ▼
    mart_funnel_efficiency               first_touch_attribution                 mart_ai_training_set
             │                                      │                                      │
             ▼                                      ▼                                      ▼
 (Looker Studio Dashboards)             (Looker Studio / Reports)             ml_propensity_model (BQML)
                                                                                           │
                                                                                           ▼
                                                                             mart_lead_propensity_scores
```

---

## 🗂 Folder Structure

```text
.
├── models/
│   ├── staging/        # Source normalization, flattening (UNNEST), and PII hashing (SHA-256)
│   ├── dimensions/     # Identity stitching (e.g., dim_identity_map stitching GA4 id to CRM email)
│   ├── marts/          # Denormalized, clustered tables for BI & AI feature sets
│   ├── ml/             # BigQuery ML models configured as dbt post-hooks
│   ├── schema.yml      # Source definitions and expectation tests (dbt_expectations)
│   └── data_contracts.yml # Enforced schema constraints
├── docs/               # Technical runbooks, roadmaps, and Looker Studio SQL stubs
├── .github/
│   └── copilot-instructions.md # AI pairing guidelines
├── packages.yml        # dbt packages (dbt_utils, dbt_expectations)
├── dbt_project.yml
└── README.md
```

---

## 🚀 Key Features

1. **Identity Spine:** Deterministic matching using `app_event_id` to stitch anonymous web traffic (`user_pseudo_id`) to CRM records (`hashed_email`).
2. **Privacy First:** Raw PII is hashed immediately at the staging boundary using SHA-256. Modeled tables contain NO raw emails or names.
3. **Advanced Attribution:** Implements "First-Touch" attribution using window functions to trace the *original* marketing source of a customer's journey.
4. **Intraday Monitoring:** Unions processed historical data with real-time intraday GA4 streaming data for live dashboarding.
5. **AI/ML Engine:** Flattens user behavioral data into `mart_ai_training_set` and trains a BigQuery ML Logistic Regression model (`ml_propensity_model`) to predict conversion probabilities for every user.
6. **Data Quality Automation:** Relies on `dbt_expectations` and `dbt_utils` to enforce data drift anomaly detection, schema contracts, and uniqueness guarantees.

---

## 💻 Developer Commands

Make sure to be authenticated to GCP before running dbt.

```bash
dbt deps                          # Install required packages (dbt_utils, dbt_expectations)
dbt parse                         # Parse and validate the DAG
dbt run                           # Build all models in DAG order (including the BQML model)
dbt test                          # Run schema + expectation tests
dbt build                         # Run and test all resources
```

---

## ⚙️ Environment Source Overrides

Source database and schema routing can be overridden per run without editing project files.

Example: run against alternate GA4 and LinkedIn source schemas.

```bash
dbt run --select stg_ga4_events stg_linkedin_leads --vars '{"ga4_schema":"analytics_526441677","linkedin_ads_schema":"dbt_linkedin_ads"}'
dbt test --fail-fast --vars '{"ga4_schema":"analytics_526441677","linkedin_ads_schema":"dbt_linkedin_ads"}'
```

Available override vars (defaults are defined in `dbt_project.yml`):
- `source_database`
- `ga4_database`, `ga4_schema`
- `supabase_schema`, `hubspot_schema`, `meta_ads_schema`, `linkedin_ads_schema`, `salesforce_schema`

Use these overrides to point dev/staging/prod runs to environment-specific datasets while keeping contracts unchanged.

Model output schema is controlled by the active target in `~/.dbt/profiles.yml`.

---

## 📊 BI & Reporting Integration

All reporting marts are materialized as performance-optimized Tables or Views. Ready-to-use SQL snippets for Looker Studio can be found in:
**`docs/reporting/reporting_sql_stubs.md`** (these stubs should be adapted with production date filters and dashboard-level parameters).

## Current Maturity Note

- Foundation and core models are in place.
- Several facts/marts are still placeholders and require completion before full production BI rollout.
- Operational runbooks now exist under `docs/runbooks/` and should be used as the release baseline.
