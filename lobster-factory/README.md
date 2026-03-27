# Lobster Factory (Phase 1) - Multi-tenant Platform Skeleton

這是一套「可長期擴充、先安全後上線」的多租戶底座，用來支撐你要的跨國電商網站營運自動化。

## Phase 1 目前已落地
- Supabase multi-tenant foundation（僅先提供 migration + catalog seeds）
  - `packages/db/migrations/0001_core.sql` ~ `0006_seed_catalog.sql`
- WP Factory manifest（目前 Phase 1 只支援 `wc-core`）
  - `packages/manifests/wc-core.json`
- Durable workflow（Trigger.dev 風格的 workflow 骨架）
  - `packages/workflows/src/trigger/create-wp-site.ts`
  - `packages/workflows/src/trigger/apply-manifest.ts`
- 安全檢查
  - manifest schema 驗證（staging-only guardrail）
  - governance config（agent/policy JSON）驗證

## 全流程進度看板（建議每天先看）
- `docs/LOBSTER_FACTORY_MASTER_CHECKLIST.md`
- `docs/C1_EXECUTION_RUNBOOK.md`（C1 一次性實戰流程）
- `docs/LOBSTER_FACTORY_COMPLETION_PLAN_V2.md`（M1~M5 路線圖）
- `docs/LOBSTER_FACTORY_MASTER_V3_INTEGRATION_PLAN.md`（MASTER_V3 落地整合）
- `docs/V3_GOVERNANCE_GATES.md`（H6 可執行治理 gate）
- `docs/ARCHITECTURE_CANONICAL_MAP.md`（單一真實來源地圖，避免重複與分散）
- `docs/MCP_TOOL_ROUTING_SPEC.md`（工具分工與強制 routing 規範）
- `docs/WORDPRESS_FACTORY_EXECUTION_SPEC.md`（WordPress Factory 固定執行通道）

## 建立/驗證（本機可直接跑）
0. **一鍵全閘道（推薦，含 Lobster + Agency OS health）** — 在 `D:\Work`：
   - `powershell -ExecutionPolicy Bypass -File .\scripts\verify-build-gates.ps1`
   - 僅工程、略過治理健檢：`.\scripts\verify-build-gates.ps1 -LobsterOnly`
1. 統整健檢（會檢查檔案是否存在 + manifest/governance/**doc 連結**）
   - `npm run validate`（於 `lobster-factory` 目錄，需 Node 18+）
   - 或：`node scripts/bootstrap-validate.mjs`

2. 只驗 manifest
   - `node D:\Work\lobster-factory\scripts\validate-manifests.mjs`

3. 只驗 governance configs
   - `node D:\Work\lobster-factory\scripts\validate-governance-configs.mjs`

4. 只驗 workflow routing policy
   - `node D:\Work\lobster-factory\scripts\validate-workflow-routing-policy.mjs`

5. 跑 V3 治理 gate（H6）
   - `node D:\Work\lobster-factory\scripts\run-v3-governance-gates.mjs`
6. 驗證 `workflow_runs` 寫入（預設 dryrun，不寫 DB）
   - `node D:\Work\lobster-factory\scripts\validate-workflow-runs-write.mjs --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --projectId=33333333-3333-3333-3333-333333333333 --siteId=44444444-4444-4444-4444-444444444444`
   - 真寫入時加 `--execute=1`，並先設好 `LOBSTER_SUPABASE_URL` / `LOBSTER_SUPABASE_SERVICE_ROLE_KEY`

7. 僅 clone `lobster-factory`、沒有同層 `agency-os` 時：doc 檢查可設 `LOBSTER_SKIP_AGENCY_CANONICAL=1` 再跑 `validate-doc-integrity.mjs`（CI 單庫情境）

8. 驗證 `package_install_runs` 狀態流（預設 dryrun，不寫 DB）
   - `node D:\Work\lobster-factory\scripts\validate-package-install-runs-flow.mjs --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --siteId=44444444-4444-4444-4444-444444444444 --environmentId=55555555-5555-5555-5555-555555555555 --workflowRunId=66666666-6666-6666-6666-666666666666`
   - 真寫入時加 `--execute=1`（會執行 pending -> running -> completed）

9. 驗證 DB 寫入韌性（重試/補償/可觀測，預設 dryrun）
   - `node D:\Work\lobster-factory\scripts\validate-db-write-resilience.mjs`
   - 真寫入時加 `--execute=1`（會帶 `x-lobster-trace-id` 並套用 retry policy）

## （可選）開啟 Supabase 真寫入：完全靠環境變數
Phase 1 預設「不會真的寫入 DB」。  
只有在你明確打開開關時，`apply-manifest`（以及 `create-wp-site`）才會透過 Supabase PostgREST insert 寫入。

### 需要設定的環境變數（示例，用你的實值替換）
- `LOBSTER_ENABLE_DB_WRITES=true`
- `LOBSTER_SUPABASE_URL=https://<project-ref>.supabase.co`
- `LOBSTER_SUPABASE_SERVICE_ROLE_KEY=<service-role-key>`

### 寫入行為說明（Phase 1）
- `apply-manifest`
  - 預先 seed/參照：`wc-core` 的固定 catalog IDs
  - insert：`workflow_runs`、`package_install_runs`
- `create-wp-site`
  - insert：`workflow_runs`（Phase 1 staging 的後續環節還未接滿）

> 注意：我沒有把任何金鑰寫死在程式或檔案裡；你只要用環境變數提供即可。

## 下一個最佳步驟（建議）
- 先在不開寫入的狀態下，拿你實際的 payload 跑出「db insert template + row payload」
- 再逐步開啟 DB 寫入（先寫 `workflow_runs`，確認可追蹤，再加 `package_install_runs`）

