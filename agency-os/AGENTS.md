# AGENTS.md - Agency Operating Rules

## 語言與輸出
- 預設使用繁體中文
- 先給結論，再給執行步驟
- 回覆需包含下一步
- 使用者與客戶視為新手（小白）時，操作說明必須改成「去哪裡、做什麼動作」格式
- 避免只講概念；每個操作至少要有：路徑/畫面位置 + 點擊/貼上動作 + 預期結果
- 指令能貼就貼完整可執行版本（避免使用者自行補路徑）
- 使用者授權 Autopilot 時，進度以「對話視窗即時回報」為主，不要求持續寫入專用進度檔

## 長任務回報防呆（固定執行）
- 採用「3 層防呆」避免使用者呆等：
  1. 開工先報：開始前先回覆「正在做什麼 + 預估下一次回報時間」
  2. 固定心跳：長任務進行中，按約定頻率回報進度
  3. 事件即時：遇到錯誤/阻塞/需要決策時，不等心跳立即回報
- 目前約定心跳頻率：每 **15 分鐘** 回報一次
- 使用者輸入 `進度?` 時，需立即回覆「目前在做什麼 / 有無阻塞 / 下一步」

## MCP／外掛分工（何時用哪個工具）
- **完整表**（與 repo 根 `mcp.json` 鍵對齊、含 LLM 分流與龍蝦 Routing 對照）：**`docs/operations/cursor-mcp-and-plugin-inventory.md`**。
- **龍蝦自動化強制規格**（誰可 orchestrate、核准、rollback）：`../lobster-factory/docs/MCP_TOOL_ROUTING_SPEC.md`（**不**被 IDE MCP 清單取代）。

## Session 啟動順序（每次都做）
1. 讀 `README.md`（本目錄）；若工作區含整個 monorepo，一併讀 `../README.md`（根目錄導覽：龍蝦工廠 + AO + `verify-build-gates`）
2. 讀 `AGENTS.md`
3. 讀 `memory/CONVERSATION_MEMORY.md`（長期記憶）
4. 讀 `memory/daily/` 的今日與昨日筆記（若存在）
5. 讀 `TASKS.md` 與 `WORKLOG.md`
6. 讀龍蝦工廠主軸文件（若存在）：
   - `../lobster-factory/docs/LOBSTER_FACTORY_MASTER_CHECKLIST.md`
   - `../lobster-factory/docs/LOBSTER_FACTORY_COMPLETION_PLAN_V2.md`
7. 先輸出啟動摘要（固定格式）：
   - `Yesterday Recap`（Completed/Pending/Risks）
   - `Today Plan`（Priority 1/2/3）
   - `Confirm`：「今天先做哪一項？」

## 快速續接關鍵字
- 跨系統運作模型（AO 治理 + 龍蝦執行）：`docs/overview/ao-lobster-operating-model.md`（作為事件節奏與責任分工的總入口）。
- 使用者輸入 `AO-RESUME` 時，必須先讀取記憶與進度檔後再回覆。
- **雙機協作硬性說明**：`AO-RESUME` 會先檢查遠端並**嘗試** `git pull --ff-only`；遇本機未提交變更／衝突仍可能失敗，**實務上建議**先在 monorepo 根手動 **`git fetch origin`** + **`git pull --ff-only origin main`**（必要時 **`git pull --rebase origin main`**），再續接讀檔；否則進度檔可能過期、`git push` 會被拒。完整開工順序、30 秒自檢：`docs/overview/REMOTE_WORKSTATION_STARTUP.md` — **新機 §1.5**、**例行 §2**（含 `lobster-factory\packages\workflows` 之 `npm ci` 與閘道）。
- 若已啟用 Autopilot Phase1，開機會自動執行 `scripts/ao-resume.ps1 -SkipVerify -AllowUnexpectedDirty`（**不**取代上述 `git pull`；Autopilot 只管本機 preflight，不管遠端是否超前）。
- 回覆格式固定為：`已完成`、`目前進度`、`下一步`。
- `目前進度` 必須包含龍蝦工廠欄位：`目前 Milestone`、`今日 DoD`、`阻塞/風險`。
- 使用者輸入 **`AO-CLOSE`**（關鍵字不變）或明確表達要關機/收工時，必須先執行 **closeout**，再輸出：`今日完成`、`今日未完成`、`連動檢查`、`明日優先`。
  - **建議一鍵**（更新 `TASKS` / `WORKLOG` / `memory/**` 後）：`.\scripts\ao-close.ps1`（repo 根）或 `.\agency-os\scripts\ao-close.ps1`（fallback；**同邏輯雙複本**，請保持內容一致）  
    → 預設依序：`verify-build-gates`（龍蝦 + 治理 health）→ `system-guard`（內含 doc-sync + health + guard）→ `generate-integrated-status-report` → **PASS 後** `git commit`／`git push`（公司機 `pull` 即完整）。不推：`-SkipPush`；略過龍蝦閘（不建議）：`-SkipVerify`。
  - 預設收工門檻：`system-health-check` **100%**（未達 100% 先修復再收工；僅在使用者明確允許時可放寬）。
  - **單一真相**：AO-CLOSE 的操作步驟以 `docs/operations/end-of-day-checklist.md` 為準，關鍵字行為以 `.cursor/rules/40-shutdown-closeout.mdc` 為準。
  - **或分部手動**（與一鍵擇一）：`doc-sync-automation -AutoDetect` → `system-health-check` → `system-guard -Mode manual` → 再自行 `git push`（見 `docs/operations/end-of-day-checklist.md`）。

## Git：本機 checkpoint 與收工 push（使用者共識）
- **開工～收工之間**：每完成一個**可敘述、已驗證**的里程碑，代理**應**做**本機** `commit`（**不** `push`），避免整天只有未提交變更。建議：`powershell -ExecutionPolicy Bypass -File .\scripts\commit-checkpoint.ps1 -Message "checkpoint: …"`（無可提交內容時腳本會安靜結束）。
- **不要**在剛跑完 **`AO-RESUME` 前檢**或僅草稿階段為了習慣而空 commit。
- **收工**：**`AO-CLOSE`**（建議 `.\scripts\ao-close.ps1`）為**預設**最終 **`commit`（收斂殘留）+ `push`**；或使用者明確 `-SkipPush` 時僅收斂本機。
- **例外**：使用者**明確一句話**要求立即提交／推送（例如 hotfix、客戶急件）時，可依指示執行。

## First Run
- 若有 `BOOTSTRAP.md`，先照檔案完成初始化再開始任務。

## 記憶制度
- 日記型記憶：`memory/daily/YYYY-MM-DD.md`（原始過程）
- 長期記憶：`memory/CONVERSATION_MEMORY.md`（濃縮版本）
- 任一對話很長（約 8000+ 中文字）時，必須濃縮回寫長期記憶
- 禁止寫入敏感資訊原文（API keys、密碼、個資）

## Linear（Cursor 外掛／團隊議題板）
- **定位**：**工程議題、sprint、狀態流、跨人協作**的視圖與操作介面（與 Slack 通知、GitHub PR 可並存）。
- **不取代**（續接／收工／綜合狀態仍以檔案為準）：
  - **Next / Backlog 真相**：`TASKS.md`
  - **證據與決策紀錄**：`WORKLOG.md`
  - **龍蝦工程勾選**：`lobster-factory/docs/LOBSTER_FACTORY_MASTER_CHECKLIST.md`
  - **客戶 Discovery**：`tenants/**/10_DISCOVERY.md` 等
  - **AO-RESUME / AO-CLOSE / integrated-status**：只讀上述檔案拼裝，**不讀** Linear API。
- **代理行為約定**：
  1. 使用者若只在 **Linear** 改狀態、拆 sub-issue：**收工前**應在 `WORKLOG.md` 或 `TASKS.md` **鏡像一句**（含 **Linear issue key**，例如 `AGN-42`）或勾選對應條目，避免他機 `AO-RESUME` 漏接。
  2. 大項承諾（對公司／對客戶 visible）仍寫進 **`TASKS.md` Next/Backlog**；Linear 適合細拆與 UI 操作，必要時在 Linear 描述欄貼回 repo 相對路徑。
  3. **憑證**：Linear token／OAuth 僅能留在 Cursor／本機設定與核准的 secrets 流程，**不入庫**、不寫進 `memory`／聊天紀錄。
- **預設企業配置（已落地）**：**模式 A 自動化** — `scripts/sync-linear-delta-to-daily.ps1` 於 **`generate-integrated-status-report`／AO-CLOSE** 產報階段執行（**僅当**本機已設 **`LINEAR_API_KEY`**），把最近更新之 issues **append** 至 **`memory/daily/YYYY-MM-DD.md`** 作**稽核帳**；詳 **`docs/operations/linear-repo-sync-playbook.md`**。
- **與 repo「要不要同步」**：**應對齊**，但用 **有裁判的一次向同步** 優於 **雙向即時雙寫**。
  - **預設（維持 AO 閘道可行）**：仍以 **`TASKS.md` / `WORKLOG` / Checklist** 為 **source of truth**；Linear 是 **執行視圖**。團隊天天用 Linear 時，至少要 **人工或工具** 把「完成了什麼」對回 repo（收工前一句 + issue key），或改走下方其中一種自動化。
  - **模式 A｜Linear → repo（稽核帳）**：排程或 webhook 把「本週已關閉 issues」摘要寫進 `WORKLOG` 或 `memory/daily`（**不**直接覆寫 `TASKS` 全文，避免和人工編輯對撞）。適合：大家要線上板，但公司機靠 `git pull` 續接。
  - **模式 B｜repo → Linear（發布計畫）**：從 `TASKS` / `PROGRAM_SCHEDULE.json` **週期性**建立或更新 Linear milestone／issue（單向推送）。適合：計畫在 repo 凍結，線上板給團隊看。
  - **模式 C｜雙向**：僅在定義 **欄位級規則**（例如「狀態只許在 Linear 改、標題只許在 repo 改」「衝突以 repo 為準」）且願意維護 **n8n／自建 sync** 時再做；與其讓兩邊互寫全表，不如 **一邊主表、一邊 mirror 摘要**。
- **何時以 Linear 為準**：僅限「團隊已宣告某專案 **只追 Linear**」時——仍須在 `WORKLOG` 留 **專案↔Workspace** 約定，並且應採 **模式 A**（週期匯入 repo），否則 **AO-RESUME / integrated-status** 仍會漏。

## 文件同步規範
- 決策更新：`WORKLOG.md`
- 任務狀態更新：`TASKS.md`
- 里程碑與脈絡更新：`memory/CONVERSATION_MEMORY.md`
- 當日原始脈絡更新：`memory/daily/YYYY-MM-DD.md`
- 文件關聯同步：修改治理文件時，必查 `docs/CHANGE_IMPACT_MATRIX.md`
- **新增或大幅改版「重要 md」（治理／對外／會給客戶看）**：必讀並依序處理 **`docs/operations/new-doc-linkage-checklist.md`**；寫入 **`change-impact-map.json` + 矩陣** 可半自動：`scripts/register-new-governance-doc.ps1`（仍須指定要連動的 `-Targets`；**README 入口與內文語意**無法替你判斷，請補齊後跑 doc-sync / health）。

## 文件治理規則
- **檔名可讀性規範（強制）**：檔名必須讓人一眼看出用途，建議結構為 `TYPE_SCOPE_PURPOSE[_CLIENT/PROJECT].md`（例：`PRODUCTION_RUNBOOK_PILOT_A_EXISTING_SITE_SOULFUL_EXPRESSION.md`）。禁止 `new.md`、`temp.md`、`v2-final-final.md` 這類不具語意命名。
- **最高原則（除非必要）**：**一份內容只能有一個主人（Owner File）**。
- 非 Owner 檔案只放「一句摘要 + 連結」，不得複製完整內容（尤其流程圖、SOP 指令塊、規格正文）。
- 必要副本（法遵/審計/對外交付）必須在檔頭標註原因與 Owner 路徑，並指定同步責任人。
- **Cursor（可賣／可版控）IDE 規則索引**：`docs/operations/cursor-enterprise-rules-index.md`（匯流 `63`–`66` `.mdc`、MCP inventory、龍蝦 `MCP_TOOL_ROUTING_SPEC`；與 `AO-RESUME`／`AO-CLOSE` 衝突時以本 repo 之 **00／30／40** 規則為準）
- 治理/標準/模板文件優先放 `docs/` 分類目錄
- 新增文件時必須在 `README.md` 增加入口
- 任務結束前必做關聯檢查，避免只改單一文件造成不同步
- 文件更新後，執行：`powershell -ExecutionPolicy Bypass -File .\scripts\doc-sync-automation.ps1 -AutoDetect`
- 重大改版後，執行：`powershell -ExecutionPolicy Bypass -File .\scripts\system-health-check.ps1`
- 會話結束前，執行：`powershell -ExecutionPolicy Bypass -File .\scripts\system-guard.ps1 -Mode manual`
- `system-health-check` 的 Critical Gate 必須 PASS（連動缺漏不允許帶過）
- 所有腳本讀寫檔案必須顯式使用 UTF-8，避免亂碼與編碼漂移
- 每次變更前必須完整閱讀目標檔與直接關聯的 source-of-truth；變更後必做衝突檢查（重複、矛盾、路徑舊值、狀態不一致）

## 執行安全
- 不做不可逆破壞操作
- 生產環境操作前先列風險與回滾方案
- 客戶新增需求先判定是否需走 `docs/operations/scope-change-policy.md`

## Related Documents (Auto-Synced)
- `.cursor/rules/00-session-bootstrap.mdc`
- `.cursor/rules/10-memory-maintenance.mdc`
- `.cursor/rules/20-doc-sync-closeout.mdc`
- `.cursor/rules/30-resume-keyword.mdc`
- `.cursor/rules/40-shutdown-closeout.mdc`
- `.cursor/rules/63-cursor-core-identity-risk.mdc`
- `docs/CHANGE_IMPACT_MATRIX.md`
- `docs/operations/cursor-enterprise-rules-index.md`
- `docs/operations/cursor-mcp-and-plugin-inventory.md`
- `docs/operations/new-doc-linkage-checklist.md`
- `docs/operations/system-guard-and-notification.md`
- `docs/operations/system-operation-sop.md`
- `docs/overview/REMOTE_WORKSTATION_STARTUP.md`
- `README.md`
- `scripts/register-new-governance-doc.ps1`

_Last synced: 2026-04-02 02:01:10 UTC_

