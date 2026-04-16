# Orchestration Layer: Automation & Workflow

## Overview
The orchestration layer ensures that data flows reliably from ingestion to visualization. For this project, dbt Cloud serves as the primary engine for transformation scheduling and testing.

## Orchestration Controls

### 1. Unified Job Scheduling
- **Hourly Staging Refresh**: Ensuring latest GA4 and CRM data is staging-ready.
- **Daily Mart Refresh**: Rebuilding heavy materialized views for executive reporting and data science datasets.
- **Trigger-Based Runs**: Exploring sGTM or Cloud Function triggers to run dbt jobs upon successful file intake.

### 2. Failure Recovery & Alerts
- **Source Freshness Alerts**: Notifying the team if Meta Ads or LinkedIn data is >6 hours stale.
- **Model Failure Notifications**: Integrated alerts to Slack/Email upon any dbt test failure.
- **Retry Logic**: Attempting reruns for transient BigQuery failures.

### 3. CI/CD Pipeline
- **Slim CI**: Running `dbt build --select state:modified+` on Pull Requests to ensure new changes don't break downstream marts.
- **PR Code Reviews**: Mandatory review for any changes to identity mapping or PII handling logic.

## Future Scope: feedback Loops
The orchestration layer will eventually handle "Reverse ETL" tasks—pushing lead scoring data or audience segments back to LinkedIn and Meta Ads via their respective APIs to optimize campaign performance based on warehouse-verified insights.
