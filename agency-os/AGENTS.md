# AGENTS.md - Agency Operating Rules

## 語言與輸出
- 預設使用繁體中文
- 先給結論，再給執行步驟
- 回覆需包含下一步

## Session 啟動順序（每次都做）
1. 讀 `README.md`
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
- 使用者輸入 `AO-RESUME` 時，必須先讀取記憶與進度檔後再回覆。
- 回覆格式固定為：`已完成`、`目前進度`、`下一步`。
- `目前進度` 必須包含龍蝦工廠欄位：`目前 Milestone`、`今日 DoD`、`阻塞/風險`。
- 使用者輸入 **`AO-CLOSE`**（關鍵字不變）或明確表達要關機/收工時，必須先執行 **closeout**，再輸出：`今日完成`、`今日未完成`、`連動檢查`、`明日優先`。
  - **建議一鍵**（更新 `TASKS` / `WORKLOG` / `memory/**` 後）：`.\scripts\ao-close.ps1`（repo 根）或 `.\agency-os\scripts\ao-close.ps1`（fallback；**同邏輯雙複本**，請保持內容一致）  
    → 預設依序：`verify-build-gates`（龍蝦 + 治理 health）→ `system-guard`（內含 doc-sync + health + guard）→ `generate-integrated-status-report` → **PASS 後** `git commit`／`git push`（公司機 `pull` 即完整）。不推：`-SkipPush`；略過龍蝦閘（不建議）：`-SkipVerify`。
  - **或分部手動**（與一鍵擇一）：`doc-sync-automation -AutoDetect` → `system-health-check` → `system-guard -Mode manual` → 再自行 `git push`（見 `docs/operations/end-of-day-checklist.md`）。

## First Run
- 若有 `BOOTSTRAP.md`，先照檔案完成初始化再開始任務。

## 記憶制度
- 日記型記憶：`memory/daily/YYYY-MM-DD.md`（原始過程）
- 長期記憶：`memory/CONVERSATION_MEMORY.md`（濃縮版本）
- 任一對話很長（約 8000+ 中文字）時，必須濃縮回寫長期記憶
- 禁止寫入敏感資訊原文（API keys、密碼、個資）

## 文件同步規範
- 決策更新：`WORKLOG.md`
- 任務狀態更新：`TASKS.md`
- 里程碑與脈絡更新：`memory/CONVERSATION_MEMORY.md`
- 當日原始脈絡更新：`memory/daily/YYYY-MM-DD.md`
- 文件關聯同步：修改治理文件時，必查 `docs/CHANGE_IMPACT_MATRIX.md`

## 文件治理規則
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
- `docs/operations/system-guard-and-notification.md`
- `docs/operations/system-operation-sop.md`

_Last synced: 2026-03-26 07:43:44 UTC_

