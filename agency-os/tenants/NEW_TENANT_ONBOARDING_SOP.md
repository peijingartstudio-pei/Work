# New Tenant Onboarding SOP

## 目的
- 用固定流程建立新客戶公司（tenant），確保資料隔離、權限安全、可立即開案

## 命名規範
- 公司資料夾：`company-<slug>`
- 站點資料夾：`<brand-or-domain-slug>`
- 專案資料夾：`<YYYY-NNN>-<project-slug>`

## Step 1：建立公司骨架
1. 複製 `tenants/templates/tenant-template/`
2. 重新命名為 `tenants/company-<slug>/`
3. 確認以下檔案存在：
   - `PROFILE.md`
   - `SERVICE_CATALOG.md`
   - `SITES_INDEX.md`
   - `FINANCIAL_LEDGER.md`
   - `ACCESS_REGISTER.md`
   - `01_COMMANDER_SYSTEM_GUIDE.md`
   - `02_CLIENT_WORKSPACE_GUIDE.md`
   - `03_TOOLS_CONFIGURATION_GUIDE.md`
   - `04_OPERATIONS_AUTOMATION_GUIDE.md`

## Step 2：填寫公司主檔
1. 更新 `PROFILE.md`：公司名稱、窗口、狀態、合作起始日
2. 更新 `SERVICE_CATALOG.md`：已購服務與不含項目
3. 更新 `SITES_INDEX.md`：至少新增 1 個站點規劃
4. 初始化 `FINANCIAL_LEDGER.md`：付款節點與條件
5. 初始化 `ACCESS_REGISTER.md`：系統/環境/權限 Owner
6. 建立 `OPERATIONS_SCHEDULE.json` 與 `OPS_QUEUE.json`
7. 填寫 1-4 使用指南，對齊該客戶的角色、流程、工具與排程

## Step 3：建立第一個站點
1. 於 `tenants/company-<slug>/sites/` 建立 `<site-slug>/`
2. 從 `tenants/templates/site-template/` 複製：
   - `SITE_PROFILE.md`
   - `SYSTEM_REQUIREMENTS.md`
   - `OPS_GROWTH_PLAN.md`
3. 在 `SITES_INDEX.md` 記錄 site 名稱、類型、階段、Owner

## Step 4：建立第一個專案
1. 建立 `tenants/company-<slug>/projects/<YYYY-NNN>-<project-slug>/`
2. 建立或複製以下文件：
   - `00_PROJECT_BRIEF.md`
   - `01_SCOPE_AND_CR.md`
   - `02_EXECUTION_PLAN.md`
   - `03_HANDOVER_CRITERIA.md`
   - `10_DISCOVERY.md`
3. 填入初版目標、角色、里程碑日期

## Step 5：權限與安全
1. 依 `docs/operations/tools-and-integrations.md` 確認所需整合與環境變數名稱
2. 憑證管理遵守 `docs/operations/security-secrets-policy.md`
3. 每客戶獨立憑證、最小權限、可輪替
4. 如發現明文外洩，立即依事件流程處理

## Step 6：營運同步
1. 在 `TASKS.md` 新增該客戶導入任務
2. 在 `WORKLOG.md` 記錄 tenant 建立完成
3. 在 `memory/daily/YYYY-MM-DD.md` 記錄當日導入脈絡
4. 若為重大里程碑，更新 `memory/CONVERSATION_MEMORY.md`
5. 註冊自動排程：
   - `powershell -ExecutionPolicy Bypass -File .\automation\REGISTER_TENANT_TASKS.ps1 -TenantSlug <company-slug>`
6. 跑系統健康檢查：
   - `powershell -ExecutionPolicy Bypass -File .\scripts\system-health-check.ps1`

## 完成檢查清單（Go/No-Go）
- [ ] 公司骨架與核心檔案（含 1-4 使用指南）齊備
- [ ] 至少 1 個 site 建立完成且可維護
- [ ] 第 1 個專案已開立並有 Discovery 初版
- [ ] 權限與憑證已分離且可輪替
- [ ] 任務板、工作日誌、記憶文件已同步
- [ ] 每日/每週/每月/不定時任務排程已啟用
- [ ] 最新健康檢查分數 >= 95%

## Related Documents (Auto-Synced)
- `docs/operations/tenant-scheduling.md`
- `README.md`
- `TASKS.md`
- `tenants/company-a/01_COMMANDER_SYSTEM_GUIDE.md`
- `tenants/company-a/02_CLIENT_WORKSPACE_GUIDE.md`
- `tenants/company-a/03_TOOLS_CONFIGURATION_GUIDE.md`
- `tenants/company-a/04_OPERATIONS_AUTOMATION_GUIDE.md`
- `tenants/README.md`
- `tenants/templates/tenant-template/01_COMMANDER_SYSTEM_GUIDE.md`
- `tenants/templates/tenant-template/02_CLIENT_WORKSPACE_GUIDE.md`
- `tenants/templates/tenant-template/03_TOOLS_CONFIGURATION_GUIDE.md`
- `tenants/templates/tenant-template/04_OPERATIONS_AUTOMATION_GUIDE.md`
- `WORKLOG.md`

_Last synced: 2026-03-20 04:57:16 UTC_

