# 他處電腦／公司機 — 開機與首次接線須知

> **目的**：在家 push 後，到**另一台電腦**（公司機、筆電、新機）能**最快安全續接**，並知道與 `agency-os/reports/status`、根目錄 `reports/status` 的差異。

## 0) 你應該從哪裡開 repo？

- **Monorepo 根目錄**（含 `agency-os\`、`lobster-factory\`、根目錄 `scripts\`）：與本機慣例一致時為 **`D:\Work`**（他處可自訂路徑，但請整包 clone，勿只拷 `agency-os` 子資料夾）。
- **Cursor / IDE**：可開 **`D:\Work`**（整倉）或 **`D:\Work\agency-os`**；若規則/連動檢查找不到 `.cursor`，請參考 `memory/CONVERSATION_MEMORY.md` 與 health 對 `agency-os/.cursor` junction 的說明，必要時在**新機**建立 junction 指向上層 `.cursor`。

## 1) 第一次或換電腦：取得程式碼

```powershell
git clone https://github.com/peijingartstudio-pei/Work.git
cd Work
git checkout main
git pull
```

已 clone 過則在 repo 根：

```powershell
cd D:\Work   # 或你的路徑
git pull origin main
```

## 2) 開機後必做三件事（約 5–15 分鐘）

1. **依賴（若你用 MCP 本機 wrappers）**  
   ```powershell
   cd mcp-local-wrappers
   npm ci
   ```
   `node_modules` **不在** Git 裡，一定要在本機還原。

2. **一次跑滿「工程 + 治理」閘道（強烈建議）**  
   在 **monorepo 根**：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\verify-build-gates.ps1
   ```
   須已安裝 **Node.js**（給 `lobster-factory` 的檢驗腳本用）。**Critical Gate 必須 PASS** 再開始改大範圍。

3. **看狀態三件套**  
   - `agency-os\LAST_SYSTEM_STATUS.md`  
   - `agency-os\TASKS.md`  
   - `agency-os\reports\status\integrated-status-LATEST.md`  

   在 Cursor 對 AI 輸入 **`AO-RESUME`**，請它依記憶檔回報「已完成／目前進度／下一步」。

## 3) 兩份「綜合狀態」路徑別搞混

| 路徑 | 說明 |
|------|------|
| **`agency-os/reports/status/`** | **主要**：`generate-integrated-status-report.ps1` 與 **AO-CLOSE** 會更新這裡（內容較完整）。 |
| **`Work/reports/status/`**（repo 根下） | 若曾從根目錄跑過產報，可能另有**較短**副本；**以 `agency-os/reports/status` 為準**。 |

## 4) 憑證與不可進庫的檔案

- **勿**把 `.env`、API key、Claude OAuth 等放進 Git（見 `docs/operations/security-secrets-policy.md`）。
- `.claude\`、`node_modules\` 已被 `.gitignore`；新機要**各自重新登入** Claude / MCP / GitHub（本機憑證管理員）。

## 5) 與「重開機續接」的關係

- 同一台電腦重開：見 repo 根的 **`RESUME_AFTER_REBOOT.md`**（貼 **`AO-RESUME`**）。
- **換電腦**：以**本文件**為準，做完 §2 再在 Cursor 用 **`AO-RESUME`**。

## Related Documents (Auto-Synced)

- `docs/overview/EXECUTION_DASHBOARD.md`
- `RESUME_AFTER_REBOOT.md`
- `docs/operations/end-of-day-checklist.md`
- `AGENTS.md`
