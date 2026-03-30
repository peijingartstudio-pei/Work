# Operations and Automation Guide - Company A

## 設定檔
- `OPERATIONS_SCHEDULE.json`
- `OPS_QUEUE.json`

## 常用操作
- 註冊排程：
  - `powershell -ExecutionPolicy Bypass -File .\automation\REGISTER_TENANT_TASKS.ps1 -TenantSlug company-a`
- 加入臨時任務：
  - `powershell -ExecutionPolicy Bypass -File .\automation\ENQUEUE_TENANT_TASK.ps1 -TenantSlug company-a -Title "<task>" -Command "<command>"`
- 手動跑一次：
  - `powershell -ExecutionPolicy Bypass -File .\automation\TENANT_AUTOMATION_RUNNER.ps1 -TenantSlug company-a -Frequency daily`

## 監控
- `reports/automation/company-a/`
- `LAST_SYSTEM_STATUS.md`

## Related Documents (Auto-Synced)
- `tenants/NEW_TENANT_ONBOARDING_SOP.md`
- `tenants/templates/tenant-template/04_OPERATIONS_AUTOMATION_GUIDE.md`

_Last synced: 2026-03-30 05:16:43 UTC_

