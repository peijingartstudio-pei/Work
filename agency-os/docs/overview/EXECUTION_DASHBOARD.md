# Execution Dashboard (Agency OS + Lobster Factory)

> 目的：用**一頁**掌握「完整建置系統、目前進度、尚未完成、下一步、硬性 Gate」並降低遺漏與重工。

## 0) 你每天只需要看什麼
- **狀態**：`LAST_SYSTEM_STATUS.md`
- **進度板（唯一真實來源）**：`TASKS.md`
- **發生了什麼（證據/日誌）**：`WORKLOG.md`
- **可續接摘要（AO-RESUME/AO-CLOSE）**：`memory/CONVERSATION_MEMORY.md`
- **今日細節**：`memory/daily/YYYY-MM-DD.md`
- **綜合報告（單檔拼裝，建議書籤）**：`reports/status/integrated-status-LATEST.md`  
  - 產生方式見 `docs/overview/INTEGRATED_STATUS_REPORT.md`（`scripts/generate-integrated-status-report.ps1`）
- **邊做邊學／將來自己當家**：`docs/overview/LEARNING_PATH_AI_AND_SYSTEMS.md`（具體問法、四週路線、每日 15 分鐘、**§17 五連問：注意·推演·為什麼·效益差錯·檢查預防**）

## 1) 系統全貌（分層）
### A. Agency OS（治理 + 執行 + 證據）
- **治理文件**：`docs/**`
- **執行腳本**：`scripts/**`
- **排程/自動化**：`automation/**`
- **租戶包**：`tenants/**`
- **證據輸出**：`reports/closeout/**`、`reports/health/**`、`reports/guard/**`

### B. Lobster Factory（「一人跨國公司」底座工程）
- **工程本體**：`D:\Work\lobster-factory\`
- **規格來源**：`D:\Work\docs\spec\raw\`
- **主追蹤清單**：`D:\Work\lobster-factory\docs\LOBSTER_FACTORY_MASTER_CHECKLIST.md`

## 2) 目前進度（你要掌握的結論版）
### 已完成（Phase 1 底座已落地）
- `lobster-factory` Phase 1 scaffold：migrations + manifest + workflow skeleton + validators
- 已建立 dry-run + acceptance gate（失敗即停）
- 已推送 GitHub，跨電腦 `pull` 可取得完整工程內容

### 尚未完成（下一段工程主線）
- 接上 hosting provider adapter + WordPress 真正 provision/shell execution
- 打通 Supabase 真寫入（預設關閉；先寫 `workflow_runs` 再擴到 `package_install_runs`）
- 完整 lifecycle：`package_install_runs` 狀態更新 + artifacts/logs ref + rollback 路徑
- 補齊 raw spec 差距項（installer/smoke test/GitHub workflow/n8n flow/routing matrix）
- Enterprise 必備工具補強（Sentry/PostHog/Cloudflare/Secrets/Identity）

> 詳細項目以 `TASKS.md` 為準（避免在多處重複維護）。

## 3) 硬性 Gate（避免錯誤擴散）
### 工程 Gate（lobster-factory）
- `bootstrap-validate.mjs` / `validate-manifests.mjs` / `validate-governance-configs.mjs`
- `dryrun-apply-manifest.mjs` + `validate-dryrun-apply-manifest.mjs --mode=strict|fast`

### 一鍵跑滿「工程 + 治理」閘道（D:\Work monorepo）
- `powershell -ExecutionPolicy Bypass -File D:\Work\scripts\verify-build-gates.ps1`
  - 先跑 `lobster-factory` 的 `bootstrap-validate.mjs`（含 doc integrity），再跑 `agency-os\scripts\system-health-check.ps1`

### 治理 Gate（agency-os）
- `scripts/doc-sync-automation.ps1 -AutoDetect`（closeout 報告）
- `scripts/system-health-check.ps1`（Critical Gate 必須 PASS）
- `scripts/system-guard.ps1 -Mode manual`（狀態檔與告警）

## 4) 每日 Runbook（最短路徑）
### 開工（AO-RESUME）
1. 先看 `LAST_SYSTEM_STATUS.md`
2. 打開 `TASKS.md`，只做 Next/Backlog 最高優先
3. 需要工程驗收就跑（Strict 或 Fast）：
   - 參考 `memory/CONVERSATION_MEMORY.md` 的 Runbook Commands

### 收工（AO-CLOSE）
- **一鍵（建議）**：先更新 `TASKS.md` / `WORKLOG.md` / `memory/**`，再執行（擇一，**同一份腳本邏輯**，請保持兩路徑檔案內容一致）：  
  - `powershell -ExecutionPolicy Bypass -File D:\Work\scripts\ao-close.ps1`  
  - 或於 `agency-os`：`powershell -ExecutionPolicy Bypass -File .\scripts\ao-close.ps1`  
  → 預設依序：**`verify-build-gates`**（龍蝦 bootstrap + Agency health）→ **`system-guard`**（doc-sync + health + guard）→ **`generate-integrated-status-report`**（`reports/status/integrated-status-LATEST.md`）→ **PASS 後** `git commit` + `git push`（**公司機 `git pull` 即與你收工快照一致**）。**FAIL 不 push。** `-SkipPush`：仍跑閘道與產報，不推遠端。`-SkipVerify`：略過龍蝦閘（收工要跨機完整時**不建議**）。

### 公司機／他處電腦（pull 後）
**完整清單請固定看：`docs/overview/REMOTE_WORKSTATION_STARTUP.md`。** 摘要：
1. monorepo 根 `git pull`
2. `powershell -ExecutionPolicy Bypass -File .\scripts\verify-build-gates.ps1`
3. `mcp-local-wrappers`：`npm ci`
4. 綜合狀態以 **`agency-os/reports/status/integrated-status-LATEST.md`** 為準（勿與根目錄 `reports/status` 混淆）
- 手動核銷：仍可依 `docs/operations/end-of-day-checklist.md` 逐項打勾（與 §1b 對齊）。

### 每週（建議固定一天，例如週一）
- **週期總檢**：`powershell -ExecutionPolicy Bypass -File .\scripts\weekly-system-review.ps1`（於 `agency-os`，或於 `D:\Work` 跑 `.\scripts\weekly-system-review.ps1`）
  - 內容：`verify-build-gates.ps1`（龍蝦 bootstrap + 治理 health）→ 重新產生 `reports/status/integrated-status-LATEST.md` → 在 `WORKLOG.md` 附錄**機器產生**的一小節（英文，方便編碼穩定）。
  - 僅刷新綜合報告、不跑閘道：加 `-ReportOnly`；不重寫 WORKLOG：加 `-SkipWorklog`；**不在閘道失敗時寫告警檔**：加 `-NoAlert`。
  - 若 **verify-build-gates 失敗**（且未 `-ReportOnly`、未 `-NoAlert`），會在 agency-os 根目錄寫入 **`ALERT_REQUIRED.txt`**（與收工清單 §0 對齊）；修復後請手動刪除該檔。
  - 同一天若跑第二次，會再新增一個同日 `## 日期` 區塊；可自行合併或保留完整稽核軌跡。
  - **路徑（junction/symlink）**：若 `agency-os` 以連結掛在磁碟根目錄（顯示路徑的父目錄可能是 `D:\` 而非 monorepo 根），週檢腳本會解析**實體目錄**，並向上尋找**同時**具備 `lobster-factory\scripts\bootstrap-validate.mjs` 與 monorepo `scripts\verify-build-gates.ps1` 的目錄（避免誤把僅含腳本複本的 `agency-os` 當成 monorepo 根，也避免誤找 `D:\scripts\...`）。
- **排程（選用）**：`powershell -ExecutionPolicy Bypass -File .\automation\REGISTER_WEEKLY_SYSTEM_REVIEW_TASK.ps1 -WorkspaceRoot D:\Work\agency-os`  
  - 使用 **`Register-ScheduledTask`**（比 raw `schtasks` 在本機較穩）。預設：**每週一 09:00**、互動使用者 **Interactive** 登入型。需改背景行為：加 **`-NoInteractive`**（**S4U** 主體）。可改：`-DayOfWeek SUN -StartTime 20:00`。移除：`-RemoveOnly`。註冊後會 **Get-ScheduledTask** 立即驗證。
- **防呆**：`system-health-check` 含 **§1b Script sanity**（檢查 `generate-integrated-status-report.ps1` 是否仍為「完整產報器」、非誤覆蓋成 wrapper）。

## 5) 防漏 / 防重工規則（你要我遵守的）
- **單一真實來源**：任務狀態只認 `TASKS.md`
- **事實與狀態分離**：做了什麼寫 `WORKLOG.md`，待辦狀態改 `TASKS.md`
- **Gate 先行**：未通過 gate 不進下一步（避免把錯誤帶到後面）
- **收工必留證據**：closeout/health/guard report 檔名要寫進 `daily note`

## Related Documents (Auto-Synced)
- `automation/REGISTER_WEEKLY_SYSTEM_REVIEW_TASK.ps1`
- `docs/operations/end-of-day-checklist.md`
- `docs/overview/INTEGRATED_STATUS_REPORT.md`
- `docs/overview/LEARNING_PATH_AI_AND_SYSTEMS.md`
- `memory/CONVERSATION_MEMORY.md`

_Last synced: 2026-03-26 00:43:03 UTC_

