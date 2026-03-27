# Integrated status report (assembled)

- Generated: 2026-03-28 01:25:55
- agency-os root: `D:\Work\agency-os`

> Assembled from canonical sources only; edit those files to change truth. Chinese legend: `docs/overview/INTEGRATED_STATUS_REPORT.md`
>
> Regenerate: `powershell -ExecutionPolicy Bypass -File .\scripts\generate-integrated-status-report.ps1`

## Source index
- `TASKS.md`
- `../lobster-factory/docs/LOBSTER_FACTORY_MASTER_CHECKLIST.md`
- `memory/CONVERSATION_MEMORY.md`
- `memory/daily/YYYY-MM-DD.md`
- `LAST_SYSTEM_STATUS.md`, `WORKLOG.md`

## 1) TASKS.md - Next (unchecked)
- [ ] 用 1 個新客戶實跑 `tenants/NEW_TENANT_ONBOARDING_SOP.md` - [ ] Enterprise 工具層 Phase 1 正式串接（Clerk auth、env/mcp secrets 治理、Cloudflare WAF/rate-limit、Sentry error ingest、PostHog core events、Slack alerts）

## 2) TASKS.md - Backlog (unchecked)
- [ ] 建立跨國稅務與法遵顧問審核流程（法律文件外部審核） - [ ] `lobster-factory` Enterprise 必備工具補強路線：Sentry/PostHog/Cloudflare/Secrets/Identity（已選型：Identity=Clerk；Secrets 暫採 env/mcp，待升級 secrets manager）

## 3) Lobster Factory Master Checklist - open items (sections A-C, before section D)
- [ ] A6. 串接 hosting provider adapter（建立 staging site 的實作層） - [ ] A7. 串接 WordPress 真正 provision/shell execution（仍須 guardrails） - [ ] A8. 打通 DB 真寫入完整流程（workflow_runs -> package_install_runs lifecycle） - [ ] A9. 補齊 artifacts/log ref、rollback 路徑、錯誤回復策略 - [ ] A10. 建立最小可運營 E2E（新客戶從建立到驗收）與回歸測試 - [ ] C2-1. hosting adapter（site/env 建立） - [ ] C2-2. WP 實際安裝步驟執行器（對應 manifest steps） - [ ] C2-3. rollback 實作（最少可回復到 snapshot） - [ ] C3-1. 建立一套標準 E2E 測試 payload（真實欄位） - [ ] C3-2. 完成一次端到端演練並留存報告 - [ ] C5-1. Observability：Sentry（錯誤追蹤）+ PostHog（產品分析） - [ ] C5-2. Edge/Security：Cloudflare（WAF/CDN/Rate limit） - [ ] C5-3. Secrets：1Password Secrets Automation（或同級） - [ ] C5-4. Identity/Org：Clerk/WorkOS/Auth0（三選一） - [ ] C5-5. Cost/Decision：成本與決策引擎可觀測化（budget/ROI guardrails） - [ ] C5-6. 後續建議：Langfuse / Upstash / Stripe / Object Storage / Search

*Checklist path:* `D:\Work\lobster-factory\docs\LOBSTER_FACTORY_MASTER_CHECKLIST.md`

## 4) memory/CONVERSATION_MEMORY.md (excerpts)

### Next Step
- 與客戶確認 `2026-001` Discovery 阻塞項（決策者/窗口、品牌定位、CR 估價基準、權限交付）
- 以新客戶實跑一次 `NEW_TENANT_ONBOARDING_SOP` 並微調
- 盤點並輪替曾出現在文本中的 API keys/token
- 先選 1 家公司完成真實資料填寫與第一案啟動
- 將 Defender 排程固定到夜間，避免白天高噪音
- 以系統管理員身分套用 Defender 排程變更（目前權限不足）
- `company-a` 真實資料填寫與流程實跑（CR/排程/報告/守護）
- 在 `README.md` 首頁加入 `AO-RESUME` / `AO-CLOSE` 快速操作卡
- 進行一次完整「開工 -> 收工」演練並回寫 WORKLOG

### Today (2026-03-25) - 重點進度
- 已修復會話記憶檔案遺失：恢復 `agency-os/memory/CONVERSATION_MEMORY.md`（確保 `AO-RESUME/AO-CLOSE` 快速操作卡仍可用）
- 已建立 `lobster-factory` 的 Phase 1 工程骨架（先安全、可驗證、可逐步接上真寫入）
  - Supabase migrations：`packages/db/migrations/0001_core.sql` ~ `0006_seed_catalog.sql`
  - Manifest：`packages/manifests/wc-core.json`（Phase 1 目前只支援 `wc-core`）
  - Durable workflows（Trigger.dev 風格骨架）：
    - `packages/workflows/src/trigger/create-wp-site.ts`
    - `packages/workflows/src/trigger/apply-manifest.ts`
  - 安全與治理：
    - `scripts/validate-manifests.mjs`、`scripts/validate-governance-configs.mjs`
    - `scripts/bootstrap-validate.mjs`（整體健檢基線）
- 已修復 `agency-os` 的 Critical Gate FAIL：在 `agency-os/.cursor` 建 junction 指向 `D:\Work\.cursor`
- 已完成跨電腦 pull 相容修正：`system-health-check.ps1` 新增 `.cursor` 規則路徑 fallback（`agency-os/.cursor` 缺失時可改由 `../.cursor` 驗證）
- 已完成 AO-CLOSE 收工檢查三步：doc-sync / health / guard 全 PASS（最新 health score 100%，Critical Gate PASS）
- 已重讀 `docs/spec/raw` 三份 master 規格並完成差距盤點；已把缺口回寫到 `lobster-factory/docs/LOBSTER_FACTORY_MASTER_CHECKLIST.md`
- 已完成 raw spec 差距第一批落地（C4-1~C4-3）：
  - `templates/woocommerce/scripts/install-from-manifest.sh`
  - `templates/woocommerce/scripts/smoke-test.sh`
  - `infra/github/workflows/validate-manifest.yml`
- 已完成 raw spec 差距第二批落地（C4-4~C4-5）：
  - `infra/n8n/exports/client-onboarding-flow.json`
  - `docs/ROUTING_MATRIX.md`
- 已新增 C1-1 寫入驗證腳本：`lobster-factory/scripts/validate-workflow-runs-write.mjs`
  - 預設 dryrun（安全）
  - `--execute=1` + Supabase env 時可執行 `workflow_runs` 真寫入驗證
- 已新增 C1-2 狀態流驗證腳本：`lobster-factory/scripts/validate-package-install-runs-flow.mjs`
  - 預設 dryrun（安全）
  - `--execute=1` + Supabase env 時可執行 `package_install_runs` 的 pending -> running -> completed 流程
- 已完成 C1-3 第一版：DB 寫入韌性（重試/補償/可觀測）
  - `supabaseRestInsert` 已加入 retry/backoff + traceId header（`x-lobster-trace-id`）
  - 新增 `lobster-factory/scripts/validate-db-write-resilience.mjs`（dryrun/execute）
- 已新增 C1 一次性實戰流程文件：`lobster-factory/docs/C1_EXECUTION_RUNBOOK.md`
  - 固定順序：dryrun -> execute -> acceptance -> rollback-safe handling
- 目前已確認缺口（尚未實作）：
  - Enterprise 工具層（Sentry/PostHog/Cloudflare/Secrets/Identity）

### Remaining - 需要接下來做完的事（依序）
1. 為 `lobster-factory` 接上「只寫 `workflow_runs`」的真寫入流程（預設關閉寫入，需你提供 Supabase 相關 env）
2. 接上 `package_install_runs` 的狀態更新（pending -> running -> completed/failed -> rolled_back）與 artifacts/logs ref
3. 把 `apply-manifest` 的 shell 執行器真正串上（仍需維持 `staging-only` + guardrails），並確保 rollback 可用
4. 接回 `create-wp-site` 的 staging 環境建立流程（需要後續 hosting provider adapter）

### Tomorrow (2026-03-26) - 建議第一優先
- 先跑一個 end-to-end「乾跑」payload（不寫 DB），確認回傳的 SQL template + row payload 完整且欄位對齊
- 再開啟真寫入一次（建議只開 `LOBSTER_ENABLE_DB_WRITES=true` 並先寫 `workflow_runs`），用你手上的 Supabase UI 查表插入是否正確
- 把所有「驚險步驟」都留在人機核可/approval 設計裡，不允許 production 自動執行

### Today (2026-03-26) - AO-CLOSE
- **`AO-CLOSE` 關鍵字與四段收工回覆格式不變**；**`ao-close.ps1`**（雙路徑同內容）預設：`verify-build-gates` → `system-guard`（doc-sync+health+guard）→ `generate-integrated-status-report` → **PASS 後** `git commit`／`git push`，讓公司機 **`pull` 即完整**；`-SkipPush`／`-SkipVerify` 為選用。
- AO-CLOSE 預設新增硬門檻：`system-health-check` 分數需為 **100%**，未達 100% 直接視為收工未完成（需修復或經使用者明確授權才可放寬）。
- **他處電腦開機**：固定閱讀 **`docs/overview/REMOTE_WORKSTATION_STARTUP.md`**（與 `RESUME_AFTER_REBOOT.md` 分機情境）；綜合報告以 **`agency-os/reports/status/integrated-status-LATEST.md`** 為準。
- **報表路徑收斂**：腳本已加 monorepo guardrail，從 repo 根執行也會強制寫入 `agency-os/reports/*`；root `reports/*` 已退役為相容用途。
- **2026-03-27**：使用者授權代理於不在現場時執行完整 AO-CLOSE（含 push），並落地上述須知文件。
- **Enterprise 工具層（C5）決策**：`Identity = Clerk`；`Secrets` 先採 `env/mcp`（1Password 因付費方案暫不採用）。
- **工具連通現況**：`Cloudflare`、`Sentry`、`PostHog`、`Slack`、`Clerk` 可用；`Supabase` plugin OAuth 回傳 `Unrecognized client_id`，暫以既有 `mcp.json` 連線運行。
- **Operator Autopilot**：已新增 `50-operator-autopilot` 規則與 Phase1 自動化（startup preflight / alert auto-repair / closeout optional push / Slack notify）。
- **Autopilot 佈署策略**：排程註冊若受限則用 Startup fallback（本機已安裝啟動項），確保無管理員權限也可運作。
- `AGENTS.md`、`.cursor/rules/40-shutdown-closeout.mdc`、`end-of-day-checklist.md`、`EXECUTION_DASHBOARD` 已對齊（一鍵與分部手動擇一）。
- 先前晚間收工：doc-sync（無新差異／沿用 `closeout-20260326-015712.md`）、health、`system-guard` PASS；當時約定 Git 次日處理。
- MCP：`mcp.json` 為伺服器設定；整庫同步以本機 **git** 為主。

### Today (2026-03-27) - V3 規格整合
- 已匯入新文件：`D:\Work\docs\spec\raw\LOBSTER_FACTORY_MASTER_V3.md`。
- 已建立可執行整合計畫：`D:\Work\lobster-factory\docs\LOBSTER_FACTORY_MASTER_V3_INTEGRATION_PLAN.md`（20 OS 模組映射、P0/P1/P2 優先順序、驗收訊號）。
- 已在 `lobster-factory/docs/LOBSTER_FACTORY_MASTER_CHECKLIST.md` 新增 `H) MASTER V3 整合追蹤`，作為後續落地與完成證據掛點。
- 目前執行策略：先不打斷 `C1-2`，維持 `C1-2 -> C1-3 -> V3 skeleton sprint` 順序。

### Today (2026-03-27) - C1-2 execute 完成
- `validate-package-install-runs-flow.mjs --execute=1` 已實跑成功（目標專案 URL 已切至可連通專案）。
- 結果：`installRunId=206bd6ee-f5e0-4b6a-810c-bbb9914844f4`，狀態流 `pending -> running -> completed`。
- 阻塞修復：補齊 `environments` fixture（`environment_id=555...`），並改用已存在 `workflow_runs.id` 作為 `workflowRunId`。
- C1 目前狀態：`C1-1 ✅`、`C1-2 ✅`、`C1-3 ⏳`（下一步）。

### Today (2026-03-27) - C1-3 execute 完成
- `validate-db-write-resilience.mjs --execute=1` 已實跑成功（以 vault 自動注入 Supabase env）。
- 結果：`ok: true`、`traceId=resilience-4c1b0ea6-84a3-4a8a-8c01-5ce648dd6099`、`insertedWorkflowRunId=77f43da0-6fc6-4ce6-bc3b-f3d139fc783c`。
- C1 目前狀態：`C1-1 ✅`、`C1-2 ✅`、`C1-3 ✅`，可進入下一主線（V3 skeleton sprint / C2）。

### Today (2026-03-27) - H3 skeleton sprint Batch 1
- 已完成 V3 缺口模組第一批骨架（Sales/Marketing/Partner/Media/Decision Engine/Merchandising）。
- 落地檔案：`0007_v3_skeleton_modules.sql`、`v3-skeleton.ts`、`v3-module-skeleton-workflows.ts`、`V3_MODULE_SKELETONS.md`。
- `LOBSTER_FACTORY_MASTER_CHECKLIST`：`H3` 已勾選完成。

### Today (2026-03-27) - H4 Decision baseline 完成
- 已完成 Decision Engine recommendations baseline：
  - migration：`0008_decision_engine_recommendations.sql`
  - contract：`decision-engine-baseline.ts`
- `LOBSTER_FACTORY_MASTER_CHECKLIST`：`H4` 已勾選完成。

### Today (2026-03-27) - H5 CX baseline 完成
- 已完成 CX retention/upsell baseline（與 `workflow_runs` 串接）：
  - migration：`0009_cx_retention_upsell_baseline.sql`
  - contract：`cx-retention-upsell-baseline.ts`
- `LOBSTER_FACTORY_MASTER_CHECKLIST`：`H5` 已勾選完成。

### Today (2026-03-27) - Zero-cost Secrets Vault
- 已落地免費本機祕密庫：`scripts/secrets-vault.ps1`（Windows DPAPI）。
- 預設儲存位置：`%LOCALAPPDATA%\AgencyOS\secrets\vault.json`（不入庫）。
- 操作方式已文件化：`docs/operations/local-secrets-vault-dpapi.md`。
- 既有政策與 runbook 已對齊（`security-secrets-policy`、`mcp-secrets-hardening-runbook`、`README`）。
- 已完成實際匯入：`mcp.json` 主要機密 + `LOBSTER_SUPABASE_*` + `AGENCY_OS_SLACK_WEBHOOK_URL`。
- 已新增復原手冊與揭示入口：`local-secrets-vault-dpapi.md` + `EXECUTION_DASHBOARD` + `REMOTE_WORKSTATION_STARTUP`。
- 已新增高頻「MCP 新增快速手冊」：`mcp-add-server-quickstart.md`，並掛到 README / Dashboard / Startup。
- 已加入長期溝通規則：後續操作一律用「去哪裡 / 做什麼 / 看到什麼」新手格式。
- 文件層也已對齊：`quickstart`、`修復`、`重灌` 都改為同格式步驟句。
- 已補 Autopilot 可見性：新增 `AUTOPILOT_PROGRESS.md` + dashboard/README 入口 + visibility 規則。
- 已追加長任務防呆規則：3 層防呆 + 每 15 分鐘心跳回報 + `進度?` 即時回覆。
- 已完成 `H6` baseline：V3 合規/治理要求已轉為可執行 gate（policy + runner + bootstrap 整合 + 文件）。
- 已完成 `C3-3` baseline：新增 PR release gate + prod deploy 前 gate（未過 gate 不執行 deploy）。
- 已進入 `AO-CLOSE`：收工前四檔進度同步已完成，下一步執行 `scripts/ao-close.ps1`。
- Trigger 經過多輪修復後已收斂：GitHub Actions deploy 成功、`project ref` 對齊、缺失 `uid` 已補、Cursor `user-trigger` MCP 的 `--api-key` 錯參數已修正為 vault 啟動腳本路徑。
- 已落地工具路由治理：新增 `MCP_TOOL_ROUTING_SPEC.md` 與 `workflow-risk-matrix.json`，固定 Trigger / n8n / GitHub / Supabase / WordPress 的強制分工與風險邊界。
- 已落地 `WORDPRESS_FACTORY_EXECUTION_SPEC.md` 細部規格（固定執行步驟、approval gate、rollback、audit trail）。
- 已將 WordPress Factory 規範轉為可執行 gate：新增 execution policy JSON + routing validation script，並納入 `bootstrap-validate` 與 `npm validate`。

> Full runbook: see `## Runbook Commands` in the source file.

## 5) memory/daily/2026-03-28.md
# 2026-03-28

## 背景
- 使用者要求把 Trigger deploy 與 Cursor `user-trigger` MCP 問題一次修到可用，避免反覆失敗。

## 已完成
- Trigger GitHub Actions deploy 鏈路修復完成：
  - 對齊正確 `project ref`：`proj_rqykzzwujizcxdzgnedn`
  - 補齊缺失檔：`lobster-factory/packages/workflows/src/utils/uid.ts`
  - `release-trigger-prod.yml` 調整後，`Deploy to Trigger.dev (prod)` 成功（`gate`/`deploy` 皆綠燈）
- Cursor `user-trigger` MCP 問題修復：
  - 根因：命令含錯誤參數 `--api-key`
  - 修正：`C:\Users\user1115\.cursor\mcp.json` 的 `trigger` 改為呼叫 `D:\Work\scripts\start-trigger-mcp.ps1`
  - 啟動腳本由 vault 注入 `TRIGGER_ACCESS_TOKEN` 並帶正確 `--project-ref`
- 本機與遠端同步：
  - 已 pull 並對齊遠端 GitHub AI 直接修改內容
  - 後續修復提交已 push 至 `main`

## 未完成
- Enterprise 工具層 Phase 1 正式串接（Clerk auth、Cloudflare WAF/rate-limit、Sentry/PostHog/Slack 全鏈路）尚未完成。
- 新客戶實跑 `tenants/NEW_TENANT_ONBOARDING_SOP.md` 尚未執行。

## 風險/阻塞
- `mcp.json`（workspace 與 Cursor user 層）仍包含多組明文金鑰，需安排輪替與去敏。
- `lobster-factory/packages/workflows/.trigger/` 為本機快取資料夾，會干擾工作樹可讀性（非功能阻塞）。

## 下一步
- 將 Trigger 成功配置沉澱成 runbook（避免下次重踩）。
- 進入 H6 第二階段（擴充可執行治理 checks）或推進 Enterprise 工具層正式串接。
- 安排 secrets 去敏與輪替作業。

## 補充：Tool Routing / Factory 通道固定（同日）

### 已完成
- 新增 `lobster-factory/docs/MCP_TOOL_ROUTING_SPEC.md`（強制版工具分工、權限邊界、WordPress Factory 固定通道）
- 新增 `lobster-factory/workflow-risk-matrix.json`（機器可讀風險路由策略）
- 更新揭示與連動：
  - `lobster-factory/README.md`
  - `lobster-factory/docs/ROUTING_MATRIX.md`

### 驗證
- `validate-doc-integrity.mjs` PASS
- `system-health-check` PASS（100%）

## 補充：WordPress Factory 細部 runbook（同日）

### 已完成
- 新增 `lobster-factory/docs/WORDPRESS_FACTORY_EXECUTION_SPEC.md`
- 規格內容補齊：
  - 固定執行通道（staging-first）
  - failure/rollback handling
  - approval payload template
  - audit trail 必填要求

### 連動
- `lobster-factory/README.md` 已新增入口

## 補充：WordPress Factory 規範可執行化（同日）

### 已完成
- 新增 `lobster-factory/packages/policies/approval/wordpress-factory-execution-policy.json`
- 新增 `lobster-factory/scripts/validate-workflow-routing-policy.mjs`
- 整合到 `lobster-factory/scripts/bootstrap-validate.mjs`
- `lobster-factory/package.json` 新增 `validate:routing`
- 文件同步：
  - `lobster-factory/docs/V3_GOVERNANCE_GATES.md`
  - `lobster-factory/README.md`

### 驗證
- `npm run validate` PASS（含 `Workflow routing policy validation PASSED`）

## 補充：報表單一路徑收斂（同日）

### 已完成
- 修正根因：同一組腳本從 `D:\Work\scripts` 入口執行時，root resolve 可能指向 `D:\Work`，導致報表寫到 `Work/reports`。
- 腳本防呆已加到以下檔案（monorepo guardrail）：
  - `scripts/system-health-check.ps1`
  - `scripts/doc-sync-automation.ps1`
  - `scripts/system-guard.ps1`
  - `scripts/generate-integrated-status-report.ps1`
  - `scripts/archive-old-reports.ps1`
- Git 路徑治理：
  - `.gitignore` 新增 root `reports/*` 產物忽略規則。
  - 移除 root `reports` 的歷史產物（closeout/health/status timestamp），避免主線污染。
- 文件同步：
  - `reports/status/README.md`：標註 root `reports/` 已退役，只作相容。
  - `docs/overview/REMOTE_WORKSTATION_STARTUP.md`：將 `Work/reports/status` 標記為退役路徑。

### 驗證
- 後續以 repo 根腳本入口執行時，報表預期只會寫入 `agency-os/reports/*`。

## 6) LAST_SYSTEM_STATUS.md (appendix)
# System Guard Status

- Mode: `manual`
- Time: `2026-03-28 00:24:02`
- Health score: **100%**
- Threshold: **95%**
- Health gate exit code: **0**
- Closeout report exists: **YES**
- Result: **PASS**

## Latest Reports
- Health: `reports/health/health-20260328-002401.md`
- Closeout: `reports/closeout/closeout-20260328-002356.md`

## Action
- No blocking issue detected.

## 7) WORKLOG.md tail (~60 lines)

### 他處電腦開機須知 + 缺席使用者授權之 AO-CLOSE
- 新增 **`docs/overview/REMOTE_WORKSTATION_STARTUP.md`**（公司機／換機：`git pull`、`verify-build-gates`、`npm ci`、`integrated-status` 路徑說明、與根目錄 `reports/status` 區別）。
- 更新 **`RESUME_AFTER_REBOOT.md`**（區分：同機重開 vs 他處開機）、**`README.md`**、**`EXECUTION_DASHBOARD.md`** 指向該須知。
- 使用者授權代理於不在現場時執行 **`ao-close.ps1`**（含 push）；證據見本日 `memory/daily/2026-03-27.md`。
- **AO-CLOSE 產出（agency-os/reports/）**：`health/health-20260326-084302.md`、`guard/guard-20260326-084306.md`、`closeout/closeout-20260326-084303.md`、`status/integrated-status-20260326-084315.md`；**Git**：主提交 `f726ce9`，補登 daily `70114fc`，TASKS 勾選 `5a7841b`（均已 `push origin main`）。

### Lobster Factory - C1-1 execute 驗證成功
- Supabase `EdD Art-based` 已完成 `0001_core.sql` ~ `0006_seed_catalog.sql` 套用。
- `validate-workflow-runs-write.mjs --execute=1` 實跑成功，回傳：`ok: true`、`insertedId: 1e53ec18-1c01-4547-9593-20feee6bdc2c`。
- 已將 `lobster-factory/docs/LOBSTER_FACTORY_MASTER_CHECKLIST.md` 的 `C1-1` 由未完成改為完成。

### Enterprise 工具層（C5）落地決策與授權驗收
- 已安裝與可用：`Cloudflare`、`Sentry`、`PostHog`、`Slack`、`Clerk`（`Supabase` plugin OAuth 仍有 `Unrecognized client_id`，暫用既有 `mcp.json` 連線）。
- C5 選型定稿：`Identity = Clerk`；`Secrets` 先採 `env/mcp`（`1Password` 因付費方案先不阻塞）。
- 使用順序定稿：`Clerk + Cloudflare`（先安全）-> `Sentry + PostHog`（可觀測）-> `Slack`（通知）-> `Supabase plugin` 待 OAuth 修復切回官方授權流。

### Operator Autopilot（Phase 1）完成
- 新增規則：`.cursor/rules/50-operator-autopilot.mdc`（含 `agency-os/.cursor/rules` 同步副本）。
- 新增腳本：`ao-resume`、`check-three-way-sync`、`autopilot-phase1`、`autopilot-alert-loop`、`notify-ops`、`register-autopilot-phase1`、`install-autopilot-startup-fallback`（root + agency-os 雙路徑）。
- 啟動策略：優先嘗試排程註冊；若系統拒絕註冊（權限/IT 限制），自動改用 Startup fallback（本機已完成安裝）。
- Slack：`AGENCY_OS_SLACK_WEBHOOK_URL` 已設置並測試通知成功（建議後續輪替 webhook）。







































