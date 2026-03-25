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

## 建立/驗證（本機可直接跑）
1. 統整健檢（會檢查檔案是否存在 + 跑 manifest/governance 驗證）
   - `node D:\Work\lobster-factory\scripts\bootstrap-validate.mjs`

2. 只驗 manifest
   - `node D:\Work\lobster-factory\scripts\validate-manifests.mjs`

3. 只驗 governance configs
   - `node D:\Work\lobster-factory\scripts\validate-governance-configs.mjs`

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

