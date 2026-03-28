# E2E / staging drill reports

Markdown drill outputs from `lobster-factory/scripts/emit-staging-drill-report.mjs` land here (C3-2).

Generate from repo root `D:\Work`:

```powershell
cd D:\Work\lobster-factory
node scripts/emit-staging-drill-report.mjs
```

Optional full gate + notes:

```powershell
node scripts/emit-staging-drill-report.mjs --runBootstrap=1 --notes="First dry run on company machine"
```

Template: `lobster-factory/docs/e2e/STAGING_PIPELINE_DRILL_REPORT_TEMPLATE.md`
