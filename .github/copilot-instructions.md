# Marketing Orchestration (dbt) - Copilot Instructions

## 1) Purpose

Use this file as the single practical instruction source for AI-assisted development in this repository.

### Primary goals

- Fast delivery of standardized dbt models.
- Strict consistency with `marketing_orchestration` project architecture.
- Privacy-first data transformation (Consent-aware & SHA-256).
- High-fidelity data for LookerML, Data Science, and AI training.

---

## 2) Non-Negotiable Rules

1. Never run git mutation commands (`git add`, `git commit`, `git reset`, `git stash`, `git push`, branch deletion).
2. SSOT: Google BigQuery is the centralized data warehouse. All data pipelines must terminate here.
3. Privacy-First: Never ingest or store raw Personally Identifiable Information (PII) in modeled tables. Use SHA-256 for identity hashing at the staging boundary.
4. Idempotency: All operations must be deduplicated using unique keys (e.g., `event_id`).
5. Reuse existing patterns inside `models/` (Base -> Staging -> Marts) before introducing new layers.

---

## 3) Repository Map (Source of Truth)

### Layers and Paths

- **Docs**: `docs/architecture/`, `docs/roadmap/` (Check for architectural directives).
- **Models**:
    - `models/base`: Source unions and raw views.
    - `models/staging`: Normalization, flattening (UNNEST), and PII hashing.
    - `models/marts`: Denormalized, clustered tables for BI/AI.
    - `models/ml`: BigQuery ML predictive models (e.g., Logistic Regression) managed as dbt post-hooks.
- **Config**: `dbt_project.yml`, `models/schema.yml` (Source definitions).
- **Contracts**: `models/data_contracts.yml` (Enforced schema constraints).

---

## 4) AI Workflow (Mandatory)

### Step A — Build context

1. Read documentation in `docs/` before modifying models.
2. Check `marketing_orchestration/models/schema.yml` for existing source/model properties.
3. Compare with `proggya-survey-nextjs` patterns if working on cross-platform identity resolution.

### Step B — Implementation Order

1. Update `schema.yml` (Sources/Models properties).
2. Implement SQL model logic.
3. Add `dbt tests` for uniqueness and non-null constraints.
4. Verify with `dbt parse` and `dbt test`.

---

## 5) SQL Styling Standards

- **Formatting**: Upper-case SQL keywords (SELECT, FROM, JOIN).
- **Structure**: Prefer Common Table Expressions (CTEs) over nested subqueries for readability.
- **Commas**: Use trailing commas.
- **Indentation**: 4 spaces.
- **Naming**: `snake_case` for all aliases and column names. Use descriptive prefixes (e.g., `stg_`, `fct_`, `dim_`).

---

## 6) Data Privacy & Identity Standards

- **Identity Resolution**: Always join against `dim_identity_map` for cross-platform user tracking.
- **Hashing**: Use `SHA256()` on raw email strings at the first possible staging layer.
- **Consent**: Respect GA4 `consent` flags when filtering behavioral data.

---

## 7) Quality Gates Before Handoff

At minimum:

1. `dbt parse` passes with zero errors.
2. `dbt test` passes for the touched models (if in a live environment).
3. Documentation in `docs/` is updated if architectural changes occur.
4. `models/schema.yml` contains descriptions for every new column.

---

When workflow/behavior/setup changes, update this file (`.github/copilot-instructions.md`).
