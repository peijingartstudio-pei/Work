# A10-2 Evidence (Business Loop)

## Checklist
- [ ] Staging flow executed
- [ ] Acceptance evidence captured
- [ ] Production trigger prepared/executed (as approved)
- [ ] Artifacts/logs_ref recorded
- [ ] WORKLOG + memory synced

## Execution plan (next run)
1. Run readiness check:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\preflight-onboarding-a10-2-readiness.ps1`
2. Generate payloads:
   - `cd D:\Work\lobster-factory`
   - `npm run payload:create-wp-site -- --siteName=pilot-main`
   - `npm run payload:apply-manifest -- --wpRootPath="D:\Work\dummy"`
3. Execute staging baseline:
   - `npm run regression:staging-pipeline`
4. Capture report:
   - `npm run drill:staging-report`
5. Fill run IDs and logs_ref back to this file and `03-run-id-map.md`.

## Evidence
- workflow_run_id: pending next A10-2 run
- package_install_run_id: pending next A10-2 run
- logs_ref: pending next A10-2 run (from artifact sink / DB)
- e2e_report_path: pending next A10-2 run (`agency-os/reports/e2e/staging-pipeline-drill-*.md`)
- rollback_path (if any): `lobster-factory/scripts/rollback-apply-manifest-staging.mjs`
- notes: P1 complete. This file is prefilled to speed up first A10-2 execution.
