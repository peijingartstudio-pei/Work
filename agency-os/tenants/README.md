# Tenants v2

此目錄用於管理多家公司（tenant）與其網站/系統資產。

## 結構
- `templates/`: 建立新 tenant 或新 site 時複製的範本
- `company-p1-pilot/`: 目前啟用中的公司資料夾

## 規則
- 每家公司資料、憑證、排程、報表必須隔離
- 每家公司至少維護：
  - `PROFILE.md`
  - `SERVICE_CATALOG.md`
  - `SITES_INDEX.md`
  - `FINANCIAL_LEDGER.md`
  - `ACCESS_REGISTER.md`
  - `01_COMMANDER_SYSTEM_GUIDE.md`
  - `02_CLIENT_WORKSPACE_GUIDE.md`
  - `03_TOOLS_CONFIGURATION_GUIDE.md`
  - `04_OPERATIONS_AUTOMATION_GUIDE.md`
  - `OPERATIONS_SCHEDULE.json`
  - `OPS_QUEUE.json`

## 新增公司流程
1. 複製 `templates/tenant-template/`
2. 重新命名資料夾為 `company-<slug>`
3. 更新 `PROFILE.md` 與 `SITES_INDEX.md`
4. 建立至少一個 `sites/<site-slug>/` 子目錄

## 建議操作
- 完整步驟請依 `tenants/NEW_TENANT_ONBOARDING_SOP.md`
- 自動排程註冊請用 `automation/REGISTER_TENANT_TASKS.ps1`

## Related Documents (Auto-Synced)
- `docs/operations/tenant-scheduling.md`
- `tenants/NEW_TENANT_ONBOARDING_SOP.md`
- `tenants/templates/tenant-template/01_COMMANDER_SYSTEM_GUIDE.md`
- `tenants/templates/tenant-template/02_CLIENT_WORKSPACE_GUIDE.md`
- `tenants/templates/tenant-template/03_TOOLS_CONFIGURATION_GUIDE.md`
- `tenants/templates/tenant-template/04_OPERATIONS_AUTOMATION_GUIDE.md`

_Last synced: 2026-04-01 02:31:21 UTC_

