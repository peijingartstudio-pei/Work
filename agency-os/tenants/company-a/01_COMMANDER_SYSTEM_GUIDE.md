# Commander System Guide - Company A

## 每日巡檢
1. `PROFILE.md`
2. `SITES_INDEX.md`
3. `FINANCIAL_LEDGER.md`
4. `ACCESS_REGISTER.md`
5. `LAST_SYSTEM_STATUS.md`

## 每週管理
- 檢查 `projects/2026-001-website-system/02_EXECUTION_PLAN.md`
- 檢查需求是否超出 `SERVICE_CATALOG.md` 邊界
- 高風險項目轉 CR 管控

## 一鍵操作
- `powershell -ExecutionPolicy Bypass -File .\automation\REGISTER_TENANT_TASKS.ps1 -TenantSlug company-a`
- `powershell -ExecutionPolicy Bypass -File .\automation\TENANT_AUTOMATION_RUNNER.ps1 -TenantSlug company-a -Frequency daily`
- `powershell -ExecutionPolicy Bypass -File .\scripts\system-guard.ps1 -Mode manual`

## Related Documents (Auto-Synced)
- `docs/overview/agency-os-complete-system-introduction.md`
- `tenants/NEW_TENANT_ONBOARDING_SOP.md`
- `tenants/templates/tenant-template/01_COMMANDER_SYSTEM_GUIDE.md`

_Last synced: 2026-03-28 11:56:51 UTC_

