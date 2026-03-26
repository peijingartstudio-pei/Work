# Integrated status report (assembled)

- Generated: 2026-03-26 17:32:50
- agency-os root: `C:\Users\USER\Work\agency-os`

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
- [ ] 用 1 個新客戶實跑 `tenants/NEW_TENANT_ONBOARDING_SOP.md`

## 2) TASKS.md - Backlog (unchecked)
- [ ] 建立跨國稅務與法遵顧問審核流程（法律文件外部審核） - [ ] `lobster-factory` Enterprise 必備工具補強路線：Sentry/PostHog/Cloudflare/Secrets/Identity

## 3) Lobster Factory Master Checklist - open items (sections A-C, before section D)
- [ ] A6. 串接 hosting provider adapter（建立 staging site 的實作層） - [ ] A7. 串接 WordPress 真正 provision/shell execution（仍須 guardrails） - [ ] A8. 打通 DB 真寫入完整流程（workflow_runs -> package_install_runs lifecycle） - [ ] A9. 補齊 artifacts/log ref、rollback 路徑、錯誤回復策略 - [ ] A10. 建立最小可運營 E2E（新客戶從建立到驗收）與回歸測試 - [ ] C1-2. 再接 `package_install_runs` 寫入與狀態流（pending/running/completed/failed/rolled_back；已新增 `scripts/validate-package-install-runs-flow.mjs`，待實際 env 執行） - [ ] C1-3. 補齊 DB 寫入錯誤處理（重試、補償、可觀測；已新增 `scripts/validate-db-write-resilience.mjs` + `supabaseRestInsert` retry/trace） - [ ] C2-1. hosting adapter（site/env 建立） - [ ] C2-2. WP 實際安裝步驟執行器（對應 manifest steps） - [ ] C2-3. rollback 實作（最少可回復到 snapshot） - [ ] C3-1. 建立一套標準 E2E 測試 payload（真實欄位） - [ ] C3-2. 完成一次端到端演練並留存報告 - [ ] C3-3. 設計 release gate（禁止未過 gate 的變更進主幹） - [ ] C5-1. Observability：Sentry（錯誤追蹤）+ PostHog（產品分析） - [ ] C5-2. Edge/Security：Cloudflare（WAF/CDN/Rate limit） - [ ] C5-3. Secrets：1Password Secrets Automation（或同級） - [ ] C5-4. Identity/Org：Clerk/WorkOS/Auth0（三選一） - [ ] C5-5. Cost/Decision：成本與決策引擎可觀測化（budget/ROI guardrails） - [ ] C5-6. 後續建議：Langfuse / Upstash / Stripe / Object Storage / Search

*Checklist path:* `C:\Users\USER\Work\lobster-factory\docs\LOBSTER_FACTORY_MASTER_CHECKLIST.md`

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
- **他處電腦開機**：固定閱讀 **`docs/overview/REMOTE_WORKSTATION_STARTUP.md`**（與 `RESUME_AFTER_REBOOT.md` 分機情境）；綜合報告以 **`agency-os/reports/status/integrated-status-LATEST.md`** 為準。
- **2026-03-27**：使用者授權代理於不在現場時執行完整 AO-CLOSE（含 push），並落地上述須知文件。
- `AGENTS.md`、`.cursor/rules/40-shutdown-closeout.mdc`、`end-of-day-checklist.md`、`EXECUTION_DASHBOARD` 已對齊（一鍵與分部手動擇一）。
- 先前晚間收工：doc-sync（無新差異／沿用 `closeout-20260326-015712.md`）、health、`system-guard` PASS；當時約定 Git 次日處理。
- MCP：`mcp.json` 為伺服器設定；整庫同步以本機 **git** 為主。

> Full runbook: see `## Runbook Commands` in the source file.

## 5) memory/daily/2026-03-26.md
# 2026-03-26

## AO-CLOSE（收工）

- `doc-sync-automation.ps1 -AutoDetect`：無新變更；沿用 `reports/closeout/closeout-20260326-015712.md`
- `system-health-check`（monorepo `D:\Work`）：`reports/health/health-20260326-020219.md`（265/265）；system-guard 再跑後另有 `health-20260326-020220.md`，皆 Critical Gate PASS
- `system-guard.ps1 -Mode manual`：`reports/guard/guard-20260326-020220.md`，PASS
- `ALERT_REQUIRED.txt`：無
- **Git**：本人改明日再處理 commit／push（§1b 收工項未於今夜完成）

## 第二次收工（關機前：AO-CLOSE 一鍵 + GitHub）

- 關鍵字 **`AO-CLOSE` 不變**；新增 **`D:\Work\scripts\ao-close.ps1`** 作為關機前可選一鍵（內含原 doc-sync／health／guard，PASS 後 push）。
- 執行 `ao-close.ps1` 後補登此節之報告檔名（guard／health／closeout）與 push 結果。

## 備註

- `LAST_SYSTEM_STATUS.md` 已由 system-guard 更新。

## 6) LAST_SYSTEM_STATUS.md (appendix)
# System Guard Status

- Mode: `manual`
- Time: `2026-03-26 17:32:46`
- Health score: **99.6%**
- Threshold: **95%**
- Health gate exit code: **0**
- Closeout report exists: **YES**
- Result: **PASS**

## Latest Reports
- Health: `reports/health/health-20260326-173246.md`
- Closeout: `reports/closeout/closeout-20260326-172111.md`

## Action
- No blocking issue detected.

## 7) WORKLOG.md tail (~60 lines)
- `system-health-check`：PASS，100%（Critical Gate PASS；`reports/health/health-20260325-223403.md`）
- `system-guard -Mode manual`：PASS（`reports/guard/guard-20260325-223414.md`）

### 二次收工確認（跨電腦 pull 相容後）
- `doc-sync-automation -AutoDetect`：PASS（`reports/closeout/closeout-20260325-231338.md`）
- `system-health-check`：PASS，100%（Critical Gate PASS；`reports/health/health-20260325-231344.md`）
- `system-guard -Mode manual`：PASS（`reports/guard/guard-20260325-231349.md`）



## 2026-03-26

### Periodic system review + 週期總檢基建（合併同日紀錄）
- 01:30–01:35：首次週檢後修復 `generate-integrated-status-report.ps1`（完整實作 + WORKLOG `-Tail 60`）；`integrated-status-LATEST` 已刷新
- 01:36：週檢 `verify-build-gates` PASS；綜合報告已刷新
- **排程**：`REGISTER_WEEKLY_SYSTEM_REVIEW_TASK.ps1` 使用 `Register-ScheduledTask` → 工作 **AgencyOS-WeeklySystemReview**（預設週一 09:00；`-NoInteractive` = S4U）
- **Health §1b**：產報／週檢腳本 script sanity（防 wrapper 覆蓋）；`health-20260326-014630.md` Critical Gate PASS
- 儀表板／學習路徑已掛每週儀式與排程說明

### AO-CLOSE（2026-03-26 晚）
- `doc-sync-automation -AutoDetect`：無新變更偵測；沿用 closeout `reports/closeout/closeout-20260326-015712.md`
- `system-health-check`（`D:\Work`）：PASS，100%（265/265），`reports/health/health-20260326-020219.md`，Critical Gate PASS
- `system-guard -Mode manual`：PASS，`reports/guard/guard-20260326-020220.md`
- **Git**：依本人指示改明天再 commit／push（見 §1b 與對話約定）
- `ALERT_REQUIRED.txt`：無

- **GitHub 同步（公司機用）**：自 `.git` 索引移除 `.claude/`（含 OAuth 憑證檔）與 `mcp-local-wrappers/node_modules`，新增 `.gitignore`；`verify-build-gates` PASS 後已 `git push origin main`（`f6a19e6`）。**舊 commit 歷史仍可能含已外洩憑證，請至 Anthropic／Claude 端撤銷並重新登入。**

### AO-CLOSE 關鍵字不變 + 關機前新增一鍵推遠端（2026-03-26 收工）
- 新增 `D:\Work\scripts\ao-close.ps1`：`system-guard`（內含 doc-sync + health）PASS 後自動 `git commit`／`git push`；**FAIL 不推**；`-SkipPush` 可關推送。
- `system-guard.ps1`：失敗時 `exit 1`，供 `ao-close` 判斷。
- `.cursor/rules/40-shutdown-closeout.mdc`、`AGENTS.md`、`end-of-day-checklist.md`、`EXECUTION_DASHBOARD.md` 已對齊說明（**AO-CLOSE 仍為同一關鍵字與四段回覆格式**）。
- 本回合收工：執行 `ao-close.ps1`（含 push）並記錄報告檔名於 `memory/daily/2026-03-26.md`。
- **修正**：`ao-close.ps1` 改為**單一邏輯**（自動判斷從 `Work\scripts` 或 `agency-os\scripts` 啟動），兩處各保留**同內容**複本，避免 wrapper 誤指 `D:\scripts`；已再驗證雙入口 `-SkipPush` PASS。
- **修正**：`ao-close.ps1` 在 `system-guard` PASS 後補跑 **`generate-integrated-status-report.ps1`**，否則 `reports/status/` 只會在週檢時更新；例：`integrated-status-20260326-083247.md`。
- **強化**：`ao-close.ps1` 預設開頭加跑 **`verify-build-gates`**（龍蝦 bootstrap + Agency health），收工 push 後公司機 `pull` 可對齊「工程 + 治理」完整閘道；`-SkipVerify` 僅供加速、不建議跨機前使用。

## 2026-03-27

### 他處電腦開機須知 + 缺席使用者授權之 AO-CLOSE
- 新增 **`docs/overview/REMOTE_WORKSTATION_STARTUP.md`**（公司機／換機：`git pull`、`verify-build-gates`、`npm ci`、`integrated-status` 路徑說明、與根目錄 `reports/status` 區別）。
- 更新 **`RESUME_AFTER_REBOOT.md`**（區分：同機重開 vs 他處開機）、**`README.md`**、**`EXECUTION_DASHBOARD.md`** 指向該須知。
- 使用者授權代理於不在現場時執行 **`ao-close.ps1`**（含 push）；證據見本日 `memory/daily/2026-03-27.md`。
- **AO-CLOSE 產出（agency-os/reports/）**：`health/health-20260326-084302.md`、`guard/guard-20260326-084306.md`、`closeout/closeout-20260326-084303.md`、`status/integrated-status-20260326-084315.md`；**Git**：主提交 `f726ce9`，補登 daily `70114fc`，TASKS 勾選 `5a7841b`（均已 `push origin main`）。

### Lobster Factory - C1-1 execute 驗證成功
- Supabase `EdD Art-based` 已完成 `0001_core.sql` ~ `0006_seed_catalog.sql` 套用。
- `validate-workflow-runs-write.mjs --execute=1` 實跑成功，回傳：`ok: true`、`insertedId: 1e53ec18-1c01-4547-9593-20feee6bdc2c`。
- 已將 `lobster-factory/docs/LOBSTER_FACTORY_MASTER_CHECKLIST.md` 的 `C1-1` 由未完成改為完成。












