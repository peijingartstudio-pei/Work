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
- **Cursor / IDE**：可開 repo 根或 `agency-os`；若規則/連動檢查找不到 `.cursor`，請先確認開啟位置與 `.cursor` 實際存在。

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

   在 Cursor 對 AI 輸入 **`AO-RESUME`**，請它依記憶檔回報「已完成／目前進度／下一步」。

## 2.1 失敗處置（不要硬做）

- `git pull --ff-only` 失敗：先 `git status`，整理本機變更後再 pull，避免強制覆蓋。
- `npm ci` 失敗：刪除 `mcp-local-wrappers\node_modules` 後重試；仍失敗就檢查 Node 版本。
- `verify-build-gates` 失敗：先修 gate，不要進行大範圍變更或收工 push。

## 3) 兩份「綜合狀態」路徑別搞混

| 路徑 | 說明 |
|------|------|
| **`agency-os/reports/status/`** | **主要**：`generate-integrated-status-report.ps1` 與 **AO-CLOSE** 會更新這裡（內容較完整）。 |
| **`Work/reports/status/`**（repo 根下） | 若曾從根目錄跑過產報，可能另有**較短**副本；**以 `agency-os/reports/status` 為準**。 |

## 4) 憑證與不可進庫的檔案

- **勿**把 `.env`、API key、Claude OAuth 等放進 Git（見 `docs/operations/security-secrets-policy.md`）。
- `.claude\`、`node_modules\` 已被 `.gitignore`；新機要**各自重新登入** Claude / MCP / GitHub（本機憑證管理員）。
- MCP 若因換機路徑失效，請只改本機設定（例如 `C:\Users\USER\.cursor\mcp.json`），不要把秘密值提交到 repo。

## 5) 與「重開機續接」的關係

- 同一台電腦重開：見 repo 根的 **`RESUME_AFTER_REBOOT.md`**（貼 **`AO-RESUME`**）。
- **換電腦**：以**本文件**為準，做完 §2 再在 Cursor 用 **`AO-RESUME`**。

## 6) 開工完成判定（Definition of Ready）

符合以下 5 項才算「可安全開工」：
1. `git pull --ff-only` 成功，且在正確分支。  
2. 依賴還原完成（若有 wrappers）。  
3. `verify-build-gates.ps1` Critical Gate = PASS。  
4. 已讀 `LAST_SYSTEM_STATUS.md` / `TASKS.md` / `integrated-status-LATEST.md`。  
5. `AO-RESUME` 回覆可清楚列出「已完成／目前進度／下一步」。

## Related Documents (Auto-Synced)

- `docs/overview/EXECUTION_DASHBOARD.md`
- `RESUME_AFTER_REBOOT.md`
- `docs/operations/end-of-day-checklist.md`
- `AGENTS.md`
