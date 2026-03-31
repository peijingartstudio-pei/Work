# 他處電腦／公司機 — 開機與首次接線須知

> **目的**：在家 push 後，到**另一台電腦**（公司機、筆電、新機）能**最快、安全、可驗證**地續接，並把流程收斂為「可重複、可回復、可追蹤」。
>
> **硬性原則**：
> 1. 以 `origin/main` 為單一真相。  
> 2. **Critical Gate 未 PASS 不開工大改**。  
> 3. 不可進庫資料（憑證、快取）必須機器本地化管理。

## 0) 你應該從哪裡開 repo？

- **Monorepo 根目錄**（含 `agency-os\`、`lobster-factory\`、根目錄 `scripts\`）：請整包 clone，不要只拷子資料夾。
- **路徑可不同**（例如筆電 `D:\Work`、公司機 `C:\Users\USER\Work`），流程都用**相對路徑**執行，不綁磁碟代號。
- **Cursor / IDE**：可開 repo 根或 `agency-os`；若規則/連動檢查找不到 `.cursor`，請先確認開啟位置與 `.cursor` 實際存在。**IDE 行為與 MCP 職責（版控正本）** 見 `docs/operations/cursor-enterprise-rules-index.md`（與本頁 **先 pull 再 AO-RESUME** 無衝突：`AO` 關鍵字流程仍優先）。

### 0.1 快速確認你在正確根目錄

```powershell
git rev-parse --show-toplevel
git branch --show-current
```

預期：
- 在 `Work` repo 根（或其子目錄）
- 分支為 `main`（如非 `main`，請先確認你是否刻意在 feature branch）

## 1) 第一次或換電腦：取得程式碼

```powershell
git clone https://github.com/peijingartstudio-pei/Work.git
cd Work
git checkout main
git pull
```

已 clone 過則在 repo 根：

```powershell
cd <你的 Work 路徑>
git pull origin main
```

## 2) 開機後必做四件事（約 5–15 分鐘）

1. **同步主線（先收斂到遠端真相）**  
   ```powershell
   git fetch origin
   git checkout main
   git pull --ff-only
   ```
   若失敗，先處理本機未提交或衝突，再往下走。

2. **依賴（若你用 MCP 本機 wrappers）**  
   ```powershell
   cd mcp-local-wrappers
   npm ci
   ```
   `node_modules` **不在** Git 裡，一定要在本機還原。

3. **一次跑滿「工程 + 治理」閘道（強烈建議）**  
   在 **monorepo 根**：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\verify-build-gates.ps1
   ```
   須已安裝 **Node.js**（給 `lobster-factory` 的檢驗腳本用）。**Critical Gate 必須 PASS** 再開始改大範圍。

4. **看狀態三件套 + 對話續接**  
   - `agency-os\LAST_SYSTEM_STATUS.md`  
   - `agency-os\TASKS.md`  
   - `agency-os\reports\status\integrated-status-LATEST.md`  

   **至此已完成 Git 同步**後，在 Cursor 對 AI 輸入 **`AO-RESUME`**。  
   > **重要**：`AO-RESUME` 會先檢查並嘗試 `git pull --ff-only`；但若你本機已有未提交變更/衝突，pull 仍可能失敗。為了穩定，建議先手動完成 §2 第 1 步，再打 `AO-RESUME`。

## 2.1 失敗處置（不要硬做）

- `git pull --ff-only` 失敗：先 `git status`，整理本機變更後再 pull，避免強制覆蓋。
- `npm ci` 失敗：刪除 `mcp-local-wrappers\node_modules` 後重試；仍失敗就檢查 Node 版本。
- `verify-build-gates` 失敗：先修 gate，不要進行大範圍變更或收工 push。

## 2.3 AO-RESUME 後 30 秒自檢（預防 dirty 與邏輯漂移）

在 monorepo 根執行：

```powershell
git status -sb
git rev-list --left-right --count HEAD...origin/main
powershell -ExecutionPolicy Bypass -File .\scripts\verify-build-gates.ps1
```

判讀重點：
- `git status -sb` 只看到 `## main...origin/main` 才是乾淨工作樹（有 `M`/`??` 就是 dirty）。
- `HEAD...origin/main` 應為 `0 0`（非 `0 0` 代表尚未完全對齊）。
- `verify-build-gates` 要 PASS（避免「版本對齊但行為錯」的邏輯 bug 持續擴散）。

## 2.2 臨時離席／可能斷網（吃飯前 30 秒版）

1. 在 **monorepo 根** `<WORK_ROOT>` 開終端機（例：`C:\Users\USER\Work` 或 `D:\Work`）
2. 貼上：`git status --short`
3. 若只想暫停、不收工：可直接離開；（**回來後**建議先 `git pull --ff-only origin main` 再打 `AO-RESUME`，與 §2 第 1 步一致）
4. 若希望離開前做完整安全收工：`powershell -ExecutionPolicy Bypass -File .\scripts\ao-close.ps1 -SkipPush`
5. 回來後在 **同一 repo 根**：可選 `powershell -ExecutionPolicy Bypass -File .\scripts\ao-resume.ps1 -AllowUnexpectedDirty`（Autopilot preflight）；**仍須**自行確認已 `pull` 對齊遠端後再當真開工

你會看到什麼（成功判斷）：
- `ao-close`：會產生 closeout/health/guard 報告
- `ao-resume.ps1`：顯示 preflight completed（**不**取代 `git pull`）

## 3) 兩份「綜合狀態」路徑別搞混

| 路徑 | 說明 |
|------|------|
| **`agency-os/reports/status/`** | **主要**：`generate-integrated-status-report.ps1` 與 **AO-CLOSE** 會更新這裡（內容較完整）。 |
| **`Work/reports/status/`**（repo 根下） | **已退役**（僅相容保留，不再作為輸出路徑）；請只看 `agency-os/reports/status`。 |

## 4) 憑證與不可進庫的檔案

- **勿**把 `.env`、API key、Claude OAuth 等放進 Git（見 `docs/operations/security-secrets-policy.md`）。
- **可選**：換機後若要用 **Linear → `memory/daily` 自動稽核帳**，請在使用者環境重設 **`LINEAR_API_KEY`**（見 `docs/operations/linear-repo-sync-playbook.md`）；不入庫。
- **Linear MCP（Cursor）**：`mcp.json` 裡的 **linear** 走 **OAuth**，授權存在**該台電腦**的本機快取；**公司桌機 `pull` 不會帶過去**。到公司機後：`pull` 完 → Cursor **啟動 linear MCP** → 再 **登入 Linear 一次**（與筆電各登各的）。
- `.claude\`、`node_modules\` 已被 `.gitignore`；新機要**各自重新登入** Claude / MCP / GitHub（本機憑證管理員）。
- MCP 若因換機路徑失效，請只改本機設定（例如 `C:\Users\USER\.cursor\mcp.json`），不要把秘密值提交到 repo。
- 密鑰庫建置與復原手冊：`docs/operations/local-secrets-vault-dpapi.md`（換機時先照手冊重建 vault）
- MCP 常用新增流程：`docs/operations/mcp-add-server-quickstart.md`

## 5) 與「重開機續接」的關係

- 同一台電腦重開：見 repo 根的 **`RESUME_AFTER_REBOOT.md`**（貼 **`AO-RESUME`**）。
- **換電腦**：以**本文件**為準，做完 §2 再在 Cursor 用 **`AO-RESUME`**。

## 6) 開工完成判定（Definition of Ready）

符合以下 5 項才算「可安全開工」：
1. `git pull --ff-only`（或等價對齊 `origin/main`）成功，且在正確分支。  
2. 依賴還原完成（若有 wrappers）。  
3. `verify-build-gates.ps1` Critical Gate = PASS。  
4. 已讀 `LAST_SYSTEM_STATUS.md` / `TASKS.md` / `integrated-status-LATEST.md`。  
5. **`AO-RESUME` 在 §2 第 1 步之後執行**，回覆可清楚列出「已完成／目前進度／下一步」（含龍蝦 Milestone/DoD/風險，見 `AGENTS.md`）。

## Related Documents (Auto-Synced)
- `../README.md`

_Last synced: 2026-03-31 12:06:18 UTC_

