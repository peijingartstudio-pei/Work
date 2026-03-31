# Linear ↔ Agency OS（跨國企業預設治理）

> **目標**：讓團隊繼續用 **Linear** 做日常議題與 sprint，同時讓 **`git pull` + AO-RESUME** 在另一台機器仍可靠——不靠口頭轉述。

## 1) 單一真相（SSOT）

| 層級 | 權威來源 | 用途 |
|------|----------|------|
| 續接／收工／綜合狀態 | `TASKS.md`、`WORKLOG.md`、龍蝦 `MASTER_CHECKLIST`、Discovery | `integrated-status`、公司機復工 |
| 排程鏡像（規劃） | `docs/overview/PROGRAM_SCHEDULE.json` | 表／甘特渲染 |
| 執行視圖（協作） | **Linear** | Issue 流、狀態、sprint、跨時區討論 |
| **稽核帳（Linear 發生了什麼）** | `memory/daily/YYYY-MM-DD.md` 內 **`### Linear API sync`** 區塊 | 自動或手動；**不覆寫** `TASKS` 全文 |

**原則**：凡要進 **AO-CLOSE、法遵、客戶承諾** 的事項，最終要能從 **repo 檔** 讀到；Linear 上的完成態**必須**在收工鏈路上以某种形式**落盤**（自動摘要或你手寫一句 + issue key）。

## 2) 預設自動化（模式 A，已內建）

- **腳本**：`scripts/sync-linear-delta-to-daily.ps1`
- **觸發**：`generate-integrated-status-report.ps1` 末尾（與 **AO-CLOSE** 同路徑）——**僅当**環境變數 **`LINEAR_API_KEY`** 已設定時執行。
- **行為**：向 Linear GraphQL 拉取**最近 N 小時內有更新**的 issues（預設 72h，可調），把清單 **append** 到**當日** `memory/daily/YYYY-MM-DD.md`（新小節 `### Linear API sync ...`，採 **append-only** 利於稽核）。
- **不會**：修改 `TASKS.md`、不刪 daily 既有內容、API 失敗時**不讓**收工腳本失敗（只記 log）。

### 2.1 本機／CI 設定金鑰（不入庫）

1. 在 Linear：**Settings → API → Personal API keys** 建立 key（權限最小化：讀取 issues 即可若日後可細分）。
2. Windows（使用者層級示例）：

```powershell
[System.Environment]::SetEnvironmentVariable('LINEAR_API_KEY', 'lin_api_xxxx', 'User')
```

重新開啟 Cursor／終端後，`AO-CLOSE` 產報時會一併寫入當日 Linear 小節。

3. **禁止**把 key 寫進 `TASKS`、`WORKLOG`、`memory`、`.env` 入庫檔。

### 2.2 與 Slack 搭配（建議分層）

| 通道 | 做什麼 | 與本 Playbook 的關係 |
|------|--------|----------------------|
| **Linear 官方 Slack App** | Issue 指派／狀態變更／留言通知到頻道；常在 Slack 用捷徑建立或連結 issue | **即時協作**，給「人現在要看」；在 **Linear 或 Slack** 搜尋官方說明完成綁定（workspace 管理員可能需核准 App） |
| **`sync-linear-delta-to-daily.ps1`** | 收工時把一段時間內更新之 issues **寫進 git** | **稽核與續接**，給「公司機 `pull` + `AO-RESUME`」；**不會**自動發 Slack |
| **既有 Agency OS Slack 告警**（例如 guard／ops webhook） | 閘道 FAIL、排程結果等 | 與 Linear **無直接關聯**；建議 **頻道分離**（例：`#ao-gates` vs `#linear-activity`）避免通知混雜 |

**推薦組合**：**Slack 接 Linear 官方整合**（團隊跟進）**＋** **`LINEAR_API_KEY` + 本腳本**（repo 落盤）——兩者互補，不是二選一。

**何時再加 Webhook**：若你要 **自訂格式**、或要 **同一事件**同時打 Slack 與內網系統，可用 **Linear Webhook → n8n → Slack／其他**；維護成本較官方 App 高，留給非標需求。

### 2.3 會用 n8n 時：Linear「URL」填什麼？

1. 在 n8n 建 workflow，第一個節點用 **Webhook**（通常 **POST**）。
2. **啟用** workflow 後，複製 **Webhook** 節點的 **Production URL**（形如 `https://你的-n8n主機/webhook/...`）——**這就是** Linear 後台 Webhook 表單裡要貼的 **URL**。  
   - n8n 只在內網時，Linear 雲端打不進來，需 **HTTPS 公開入口**（反向代理、Tunnel、或雲上 n8n）。
3. **Signing secret** 放 **n8n Credential 或環境變數**，並依 [Linear Webhooks 文件](https://linear.app/developers/webhooks) **驗簽**；**勿**把 secret 提交進 git。
4. 下游可用 **Switch** → **Slack**／**HTTP Request** 等；與 **Slack 官方 App** 可並存（注意頻道用途分流）。
5. **與 `sync-linear-delta-to-daily.ps1`**：**並存**——n8n＝**即時事件**；PowerShell 腳本＝**收工 git 稽核**（`memory/daily`）。
6. **n8n 主動打 Linear GraphQL**：亦可用 **HTTP Request** + API key 做定時拉取；與本腳本**擇一為主**以免重複寫入。

架構細部：`docs/standards/n8n-workflow-architecture.md`。

### 2.4 Cursor 內用 MCP 操控 Linear（官方，推薦）

若你要在 **Cursor 對話裡**查／建／改 issue，優先用 **Linear 官方 MCP**（**OAuth**，不必把 key 寫進 MCP 設定）：

- **端點**：`https://mcp.linear.app/mcp`（[說明](https://linear.app/docs/mcp)）
- **本 monorepo**：已在 repo 根 **`mcp.json`** 加入 **`linear`** server：`npx -y mcp-remote https://mcp.linear.app/mcp`（與其他 server 一樣走 `cmd /c npx`，**勿**在 JSON 內嵌 API key）。
- **首次使用**：於 Cursor **MCP** 面板啟動 **linear**，依畫面完成 **Linear 登入／授權**（互動流程）。
- **故障**：官方 FAQ 可刪除本機快取後重試：`rm -rf ~/.mcp-auth`（Unix）；Windows 則刪對應使用者目錄下 MCP 認證快取後再連線。
- **與 `LINEAR_API_KEY` 腳本**：**並存**——MCP＝你在 IDE 裡操作；**`sync-linear-delta-to-daily.ps1`**＝收工 **git 稽核帳**。

進階：官方亦支援以 **`Authorization: Bearer`** 帶 OAuth token／API key（無互動時）；細節見 [Linear MCP 文件](https://linear.app/docs/mcp)。

**多機（筆電 ↔ 公司桌機）**：**`git pull` 只會同步 repo 檔**（含別台寫入的 `memory/daily` Linear 稽核小節）。**`LINEAR_API_KEY`** 與 **Linear MCP OAuth** 皆為**每機器各自設定／各登入一次**；無法也不應靠 git 傳憑證。換機清單見 `docs/overview/REMOTE_WORKSTATION_STARTUP.md` §4。

## 3) 模式 B（可選）：repo → Linear（排程 → Issues）

當「計畫已在 repo」要給團隊在 **Linear** 裡看日期／依賴／敘述時：

### 3.1 腳本（v1：單向推送）

- **腳本**：`agency-os/scripts/push-program-schedule-to-linear.ps1`（repo 根亦有 **`scripts/push-program-schedule-to-linear.ps1`** 相容入口，解析規則相同）。
- **來源**：`docs/overview/PROGRAM_SCHEDULE.json`（可用 `-SchedulePath` 覆寫；`-WorkspaceRoot` 指向 `agency-os` 根目錄時最直覺）。
- **認證**：**`LINEAR_API_KEY`**（**正式推送必填**；不入庫）。**`-DryRun` 可不設**（僅本地預覽，**Linear 上完全不會變**）。**`LINEAR_TEAM_ID`** 可省略（多 team 時會警告並用第一個）。**`LINEAR_PROJECT_ID`** 可選，問題會掛到該 **Project**。
- **`LINEAR_PROJECT_ID` 格式**：必須是 **UUID**（例如 `ffe9e2b5-55ee-4cbb-baa6-7479cbf10f49`）。若填錯格式，推送腳本會警告並忽略 project 綁定（不阻塞整批同步）。
- **預設建議**：`LINEAR_PROJECT_ID` 保持未設定（避免一次把整份排程綁進單一 Project）；需要時再臨時設定或只對特定批次指定。
- **分流綁定（推薦）**：可分別設定 `LINEAR_PROJECT_ID_AO`、`LINEAR_PROJECT_ID_LF`、`LINEAR_PROJECT_ID_PJ`（皆 UUID）。腳本會優先用分流值，無分流才回退 `LINEAR_PROJECT_ID`。
- **行為**：依 `streams[].tasks[]` 建立或更新 issue（標題含 `[streamKey taskId]`；描述內含 HTML comment `<!-- agency-os-schedule v1 ... -->` 供穩定對應）；**`dueDate`** 來自 `end`；**`crit`** → Linear **Urgent**（priority 1）。
- **對應表**（create/update）：`reports/linear/linear-schedule-map.json`（**task.id** → issue id / identifier / url）。刪除此檔會在下次執行時**重新建立** issue（可能重複），請保留或手動合併。
- **演練**：`-DryRun` 僅印出將執行之 create/update，**不呼叫** API → **因此在 Linear 裡看不到任何新資料是正常的**。

```powershell
# DryRun（可不設 LINEAR_API_KEY）
powershell -NoProfile -ExecutionPolicy Bypass -File .\agency-os\scripts\push-program-schedule-to-linear.ps1 -WorkspaceRoot .\agency-os -DryRun

# 正式推送（必須有 Personal API key；建議先設使用者環境變數後開新終端）
powershell -NoProfile -ExecutionPolicy Bypass -File .\agency-os\scripts\push-program-schedule-to-linear.ps1 -WorkspaceRoot .\agency-os
# 先只建 1 筆驗證（成功時終端會印綠色 OK create -> ENG-xxx 與 URL）：
powershell -NoProfile -ExecutionPolicy Bypass -File .\agency-os\scripts\push-program-schedule-to-linear.ps1 -WorkspaceRoot .\agency-os -MaxTasks 1
# 或同線設定（避免 $env 在巢狀 powershell 被吃掉時）：
# cmd /c "set LINEAR_API_KEY=lin_api_xxxx&& powershell -NoProfile -ExecutionPolicy Bypass -File .\agency-os\scripts\push-program-schedule-to-linear.ps1 -WorkspaceRoot .\agency-os -MaxTasks 1"

# 一鍵（push + delta）：先設好 LINEAR_API_KEY，再跑
powershell -NoProfile -ExecutionPolicy Bypass -File .\agency-os\scripts\linear-sync-all.ps1 -WorkspaceRoot .\agency-os

# 清理（把 map 內既有 issues 從當前 project 解除綁定，不刪 issue）
powershell -NoProfile -ExecutionPolicy Bypass -File .\agency-os\scripts\linear-unassign-project-from-map.ps1 -WorkspaceRoot .\agency-os
```

### 3.2 若在 Linear 看不到新議題

| 狀況 | 說明 |
|------|------|
| 只用過 **`-DryRun`** | 不會對 Linear 發請求，**UI 一定沒有新單**；拿掉 `-DryRun` 再跑。 |
| **`LINEAR_API_KEY` 沒進到「這個」PowerShell** | MCP／Cursor 的 OAuth **不**等於 API key；請在 **Linear → Settings → API → Personal API keys** 建立 key，並用 **使用者環境變數**或 **`cmd /c set ...&& powershell ...`** 注入後重跑。 |
| **Team／檢視篩選** | 腳本會把 issue 建在 **`LINEAR_TEAM_ID`** 或 API 查到的**第一個 team**（多 team 時請顯式設 `LINEAR_TEAM_ID`）。在 Linear 用 **All teams** 或搜尋標題片段如 **`[AO OP-1]`**。 |
| **終端機有失敗訊息** | 腳本會 `Write-Warning`（create/update GraphQL 錯誤）；修正後再跑。成功後才會寫入 **`reports/linear/linear-schedule-map.json`**。 |
| **沒有 `linear-schedule-map.json`** | 代表尚未成功跑過 **非 DryRun** 的推送（或 31 筆全失敗）。請用 **`-MaxTasks 1`** 重跑並閱讀終端機紅色 JSON／綠色 `OK create` 行。 |

**與 MCP**：在 Cursor 裡用 **Linear MCP** 只影響你在 IDE 裡的操作，**不會**自動執行本推送腳本。

### 3.3 與模式 A、`PROGRAM_TIMELINE` 的關係

- **模式 A**（`sync-linear-delta-to-daily.ps1`）仍是 **Linear → git 稽核**；**模式 B** 是 **JSON → Linear**。**v1 不自動把 Linear 狀態寫回** `PROGRAM_SCHEDULE.json`（避免與甘特渲染源衝突）；排程仍以 JSON 為 planning SSOT，修改 JSON 後**再執行**本推送腳本刷新看板。
- **`AO-CLOSE`**：`generate-integrated-status-report.ps1` 在 **`LINEAR_API_KEY`** 已設定時，會於渲染 **`PROGRAM_TIMELINE`** 之後自動執行 **`push-program-schedule-to-linear.ps1`**（模式 B），再跑 **`sync-linear-delta-to-daily`**。推送若回傳非零結束碼**不會**擋下整輪收工（僅 **Warning**），以免 API 短暫失效時無法 commit/push。若要跳過推送：環境變數 **`AO_SYNC_SCHEDULE_TO_LINEAR=0`**（或 `false`）。
- **雙向即時全表同步**：本 repo **不提供**（衝突成本高）；若未來要做，須另開專案定 **欄位級**誰可寫。

## 4) 跨國企業注意事項（合規與風險）

- **供應商與資料流**：Linear 為美國 SaaS；EU/UK 客戶或內部法遵請自洽 **DPA / 次處理者條款**（以 Linear 官網與你方律師為準）。本 playbook **不**構成法律意見。
- **稽核**：`memory/daily` 與 `WORKLOG` 宜保留下來；Linear 摘要區塊便於對照「線上板 ↔ git 紀錄」。
- **離職與權限**：API key 隨人走時要輪替；企業方案請用 **SSO + 集中帳號治理**。

## 5) 與 `AGENTS.md` 的關係

執行規則與代理行為以 **`AGENTS.md`「Linear」** 為準；本檔為 **操作與合規補充**。

## Related Documents (Auto-Synced)
- `docs/standards/n8n-workflow-architecture.md`

_Last synced: 2026-03-31 10:06:12 UTC_

