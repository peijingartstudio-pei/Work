# Lobster Factory Master Checklist

> 用途：集中追蹤「一人跨國公司底座」的完整建置流程、目前進度、未完成項目，避免遺漏與重工。  
> 單一真實來源：本檔 + `D:\Work\agency-os\TASKS.md`（跨系統任務板）。

## A) 全流程總覽（由上到下）
- [x] A1. 定義 Phase 1 範圍（先安全可驗證，再逐步開啟真寫入）
- [x] A2. 建立多租戶 DB migration 基礎（core/factory/governance/RLS/seeds/catalog）
- [x] A3. 建立 manifest 規格與 `wc-core` 範本
- [x] A4. 建立 durable workflow 骨架（`create-wp-site`、`apply-manifest`）
- [x] A5. 建立結構驗證與 fail-fast gate（bootstrap/manifests/governance/dryrun validate）
- [ ] A6. 串接 hosting provider adapter（建立 staging site 的實作層）
- [ ] A7. 串接 WordPress 真正 provision/shell execution（仍須 guardrails）
- [ ] A8. 打通 DB 真寫入完整流程（workflow_runs -> package_install_runs lifecycle）
- [ ] A9. 補齊 artifacts/log ref、rollback 路徑、錯誤回復策略
- [ ] A10. 建立最小可運營 E2E（新客戶從建立到驗收）與回歸測試

## B) 目前已完成（依現況勾選）
### B1. DB / Catalog
- [x] `packages/db/migrations/0001_core.sql`
- [x] `packages/db/migrations/0002_factory.sql`
- [x] `packages/db/migrations/0003_agents_approvals_observability.sql`
- [x] `packages/db/migrations/0004_rls_helpers.sql`
- [x] `packages/db/migrations/0005_seed_minimum.sql`
- [x] `packages/db/migrations/0006_seed_catalog.sql`（固定 catalog IDs）

### B2. Manifest / API Types / Service
- [x] `packages/manifests/wc-core.json`（Phase 1: staging-only）
- [x] `apps/api/src/types/manifest.ts`
- [x] `apps/api/src/services/wp/wpFactory.ts`

### B3. Workflows / DB Adapter
- [x] `packages/workflows/src/trigger/create-wp-site.ts`
- [x] `packages/workflows/src/trigger/apply-manifest.ts`
- [x] `packages/workflows/src/db/catalogIds.ts`
- [x] `packages/workflows/src/db/sql/workflowRunsSql.ts`
- [x] `packages/workflows/src/db/sql/packageInstallRunsSql.ts`
- [x] `packages/workflows/src/db/supabase/supabaseRestInsert.ts`（預設安全，不自動寫入）

### B4. Governance / Agent / Policy
- [x] `packages/agents/src/configs/repair-agent.json`
- [x] `packages/agents/src/validators/repairAgentConfigValidator.ts`
- [x] `packages/agents/src/loaders/loadRepairAgentConfig.ts`
- [x] `packages/policies/approval/production-deploy-policy.json`
- [x] `packages/policies/tool/repair-agent-policy.json`
- [x] `packages/policies/src/validators/policiesValidator.ts`
- [x] `packages/policies/src/loaders/loadPoliciesFromFiles.ts`

### B5. Validation / Acceptance Gates
- [x] `scripts/bootstrap-validate.mjs`
- [x] `scripts/validate-manifests.mjs`
- [x] `scripts/validate-governance-configs.mjs`
- [x] `scripts/dryrun-apply-manifest.mjs`
- [x] `scripts/validate-dryrun-apply-manifest.mjs`（`--mode=strict|fast`）

## C) 尚未完成（下一步主線，避免重工）
### C1. 寫入鏈路（先小後大）
- [ ] C1-1. 先只開 `LOBSTER_ENABLE_DB_WRITES=true` 驗證 `workflow_runs` 寫入（已新增 `scripts/validate-workflow-runs-write.mjs`，待實際 env 執行）
- [ ] C1-2. 再接 `package_install_runs` 寫入與狀態流（pending/running/completed/failed/rolled_back；已新增 `scripts/validate-package-install-runs-flow.mjs`，待實際 env 執行）
- [ ] C1-3. 補齊 DB 寫入錯誤處理（重試、補償、可觀測；已新增 `scripts/validate-db-write-resilience.mjs` + `supabaseRestInsert` retry/trace）

### C2. 執行鏈路（staging-only）
- [ ] C2-1. hosting adapter（site/env 建立）
- [ ] C2-2. WP 實際安裝步驟執行器（對應 manifest steps）
- [ ] C2-3. rollback 實作（最少可回復到 snapshot）

### C3. 驗收與可運營
- [ ] C3-1. 建立一套標準 E2E 測試 payload（真實欄位）
- [ ] C3-2. 完成一次端到端演練並留存報告
- [ ] C3-3. 設計 release gate（禁止未過 gate 的變更進主幹）

### C4. 規格差距補齊（raw spec 對齊）
- [x] C4-1. 建立 `templates/woocommerce/scripts/install-from-manifest.sh`
- [x] C4-2. 建立 `templates/woocommerce/scripts/smoke-test.sh`
- [x] C4-3. 建立 `infra/github/workflows/validate-manifest.yml`
- [x] C4-4. 建立 `infra/n8n/exports/client-onboarding-flow.json`
- [x] C4-5. 建立 `docs/ROUTING_MATRIX.md`（或 `002_ROUTING_MATRIX.md`）

### C5. Enterprise 補強（工具層）
- [ ] C5-1. Observability：Sentry（錯誤追蹤）+ PostHog（產品分析）
- [ ] C5-2. Edge/Security：Cloudflare（WAF/CDN/Rate limit）
- [ ] C5-3. Secrets：1Password Secrets Automation（或同級）
- [ ] C5-4. Identity/Org：Clerk/WorkOS/Auth0（三選一）
- [ ] C5-5. Cost/Decision：成本與決策引擎可觀測化（budget/ROI guardrails）
- [ ] C5-6. 後續建議：Langfuse / Upstash / Stripe / Object Storage / Search

## D) 每次開工/收工要看什麼
### 開工（AO-RESUME 後）
- [ ] 先看本檔 C 區（尚未完成）只挑 1 條主線
- [ ] 對照 `agency-os/TASKS.md` 是否已有相同任務，避免重開重做
- [ ] 執行前先決定今天跑 `strict` 或 `fast` 驗收模式

### 收工（AO-CLOSE 前）
- [ ] 今日改動是否更新到本檔（B/C 區勾選）
- [ ] 今日證據是否回寫到 `agency-os/WORKLOG.md` 與 `memory/daily/YYYY-MM-DD.md`
- [ ] 今日是否已跑對應 gate（至少 `dryrun + validate`）

### C1 專用流程
- [ ] 需要執行 C1 時，先照 `docs/C1_EXECUTION_RUNBOOK.md` 跑完整順序（dryrun -> execute -> acceptance）

## E) 驗收命令（直接可跑）
```powershell
node D:\Work\lobster-factory\scripts\bootstrap-validate.mjs
node D:\Work\lobster-factory\scripts\validate-manifests.mjs
node D:\Work\lobster-factory\scripts\validate-governance-configs.mjs
node D:\Work\lobster-factory\scripts\validate-workflow-runs-write.mjs --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --projectId=33333333-3333-3333-3333-333333333333 --siteId=44444444-4444-4444-4444-444444444444
node D:\Work\lobster-factory\scripts\validate-package-install-runs-flow.mjs --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --siteId=44444444-4444-4444-4444-444444444444 --environmentId=55555555-5555-5555-5555-555555555555 --workflowRunId=66666666-6666-6666-6666-666666666666
node D:\Work\lobster-factory\scripts\validate-db-write-resilience.mjs
node D:\Work\lobster-factory\scripts\dryrun-apply-manifest.mjs --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --projectId=33333333-3333-3333-3333-333333333333 --siteId=44444444-4444-4444-4444-444444444444 --environmentId=55555555-5555-5555-5555-555555555555 --wpRootPath="D:\Work\dummy" --environmentType=staging
node D:\Work\lobster-factory\scripts\validate-dryrun-apply-manifest.mjs --mode=strict --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --projectId=33333333-3333-3333-3333-333333333333 --siteId=44444444-4444-4444-4444-444444444444 --environmentId=55555555-5555-5555-5555-555555555555 --wpRootPath="D:\Work\dummy" --environmentType=staging
```

## F) 本次重讀結論（2026-03-25）
- 已重讀：
  - `docs/spec/raw/Lobster Factory Master Spec v1 .md`
  - `docs/spec/raw/接貼給 Cursor 用的「Cursor Pack v1」.md`
  - `docs/spec/raw/「再加 AI」，而是把你現在這套補成 企業級底座。.md`
- 已確認現況缺口（repo 尚未存在）：
  - （已完成）C4-1~C4-5 raw spec 差距第一輪補齊

