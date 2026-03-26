# Conversation Memory

## Current Operating Context
- 你正在建立多客戶網站與系統代營運模式
- 核心平台：WordPress、Supabase、GitHub、n8n、Replicate、DataForSEO
- 服務線：建置、維運、行銷、自動化、WordPress 客製系統

## Confirmed Priorities
1. 先建完整可複製框架，不做精簡版
2. 補齊財務、人力外包、SOP、資安事件應變、客戶邊界管理
3. 需要「每接一案從零到完成」模板套裝
4. 需要跨會話記憶，避免每次重講

## Progress Snapshot
- 已建立 Agency OS v1 基礎文件與政策模板
- 已建立 project-kit 接案模板骨架
- 已建立 Cursor 規則，要求會話先讀記憶與進度文件
- 已整合同事制度中的啟動順序與日記型記憶模式
- 已新增安全政策，禁止文件保存明文憑證
- 已建立 tenants v2 骨架（tenant-template + site-template + company-a sample）
- 多租戶骨架已收斂為 `company-a` 單一實際 tenant（其餘示範 tenant 不保留）
- 已開立第一個專案：`company-a/projects/2026-001-website-system`
- 已完成 `2026-001` Discovery 初版與里程碑日期初版
- 已完成系統級操作文件（System SOP、New Tenant Onboarding SOP、Service Packages、CR Pricing）
- 已建立 MSA/SOW/CR 模板，補齊售前到變更文件鏈
- 已建立 WordPress / n8n / KPI&毛利規範文件，補齊交付與營運標準
- 已建立 docs 分類與文件連動矩陣，修正「改一份不會同步」問題
- 已建立自動同步與結案自檢流程（AutoDetect + Watch + closeout report）
- 已補上每公司排程自動化（schedule/queue/runner/register）
- 已補上國際化治理模組（global delivery/compliance/multi-currency/QA gate）
- 已建立系統健康檢查腳本，最新檢查分數 100%
- 已建立 System Guard（關機前/每日/開機後）與狀態告警檔
- 已加上桌面彈窗 PASS/FAIL 與亂碼防線（自動檢測 + 阻擋同步覆寫）
- 已建立可販售產品化藍圖、買方交接清單與打包腳本
- 已建立英文化對客模板（Proposal/SOW/Monthly Report）
- 已建立客戶風險評分模型、外包評分卡、leads/scraping 合規清單
- 已建立 release notes/upgrade path/migration checklist，補齊升級治理
- 已建立 Agency Command Center 與多平台架構，並保持 WordPress-first 策略
- 已完成一輪本機安全檢查（未見常見遠控軟體活動）
- 已確認 RDP 關閉，Lenovo Now 移除
- 已完成結構收斂：政策文件位於 `docs/operations/`，核心腳本位於 `scripts/`
- 已建立 `company-a` 客戶 package 1-4 使用指南（總司令/客戶/工具/自動化）
- 已將 `.cursor/rules` 納入 watch 與連動矩陣，規則更新可自動進入 closeout 檢查
- 已新增 health `Critical Gate` 與 guard gate 條件（關聯缺漏與缺檔不可帶過）
- 已新增完整系統介紹文件：`docs/overview/agency-os-complete-system-introduction.md`
- 已新增續接關鍵字規則 `AO-RESUME`（下次開啟可快速回到進度）
- 已新增收工關鍵字規則 `AO-CLOSE`，並固定開工摘要格式（Yesterday/Today/Confirm）
- 已新增 `.cursor/rules/README.md` 作為 rules 使用手冊
- 已修復 `AgencyOS-*` 排程路徑漂移（舊路徑 -> `D:\Work\agency-os`）與命令引號問題
- 已在健康檢查加入排程路徑存在性檢查，避免路徑失效未被偵測
- 已針對架構期停用 `company-a` adhoc 輪詢（保留可隨時重啟）
- 已完成 workspace 降載（移除高噪音根目錄 + watcher/search exclude）以降低 Cursor OOM
- 已新增 `scripts/archive-old-reports.ps1`，建立 reports 保留與歸檔機制
- 已修正 `RESUME_AFTER_REBOOT.md` 路徑與續接流程（統一 `AO-RESUME`）

## Next Step
- 與客戶確認 `2026-001` Discovery 阻塞項（決策者/窗口、品牌定位、CR 估價基準、權限交付）
- 以新客戶實跑一次 `NEW_TENANT_ONBOARDING_SOP` 並微調
- 盤點並輪替曾出現在文本中的 API keys/token
- 先選 1 家公司完成真實資料填寫與第一案啟動
- 將 Defender 排程固定到夜間，避免白天高噪音
- 以系統管理員身分套用 Defender 排程變更（目前權限不足）
- `company-a` 真實資料填寫與流程實跑（CR/排程/報告/守護）
- 在 `README.md` 首頁加入 `AO-RESUME` / `AO-CLOSE` 快速操作卡
- 進行一次完整「開工 -> 收工」演練並回寫 WORKLOG

## Today (2026-03-25) - 重點進度
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

## Remaining - 需要接下來做完的事（依序）
1. 為 `lobster-factory` 接上「只寫 `workflow_runs`」的真寫入流程（預設關閉寫入，需你提供 Supabase 相關 env）
2. 接上 `package_install_runs` 的狀態更新（pending -> running -> completed/failed -> rolled_back）與 artifacts/logs ref
3. 把 `apply-manifest` 的 shell 執行器真正串上（仍需維持 `staging-only` + guardrails），並確保 rollback 可用
4. 接回 `create-wp-site` 的 staging 環境建立流程（需要後續 hosting provider adapter）

## Tomorrow (2026-03-26) - 建議第一優先
- 先跑一個 end-to-end「乾跑」payload（不寫 DB），確認回傳的 SQL template + row payload 完整且欄位對齊
- 再開啟真寫入一次（建議只開 `LOBSTER_ENABLE_DB_WRITES=true` 並先寫 `workflow_runs`），用你手上的 Supabase UI 查表插入是否正確
- 把所有「驚險步驟」都留在人機核可/approval 設計裡，不允許 production 自動執行

## Runbook Commands (明天照跑)
你有兩種模式：`Strict`（安全最大）與 `Fast`（速度優先但仍有門檻）。
以下命令中的 `<WORK_ROOT>` 請替換為本機實際路徑（例如 `D:\Work` 或 `C:\Users\USER\Work`）。

### Strict Mode（推薦，確保今天/明天不出問題）
1. Phase 1 基線健檢
```
node <WORK_ROOT>\lobster-factory\scripts\bootstrap-validate.mjs
```
2. manifest 顯式驗證（只驗 JSON 結構與 guardrail）
```
node <WORK_ROOT>\lobster-factory\scripts\validate-manifests.mjs
```
3. governance 顯式驗證（驗 agent/policy JSON）
```
node <WORK_ROOT>\lobster-factory\scripts\validate-governance-configs.mjs
```
4. apply-manifest 乾跑（不寫 DB，只輸出 payload + SQL template）
```
node <WORK_ROOT>\lobster-factory\scripts\dryrun-apply-manifest.mjs --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --projectId=33333333-3333-3333-3333-333333333333 --siteId=44444444-4444-4444-4444-444444444444 --environmentId=55555555-5555-5555-5555-555555555555 --wpRootPath="<WORK_ROOT>\dummy" --environmentType=staging
```
5. apply-manifest 乾跑驗收（失敗即停，`--mode=strict`）
```
node <WORK_ROOT>\lobster-factory\scripts\validate-dryrun-apply-manifest.mjs --mode=strict --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --projectId=33333333-3333-3333-3333-333333333333 --siteId=44444444-4444-4444-4444-444444444444 --environmentId=55555555-5555-5555-5555-555555555555 --wpRootPath="<WORK_ROOT>\dummy" --environmentType=staging
```

### Fast Mode（快、但仍有關鍵門檻）
1. manifest 顯式驗證
```
node <WORK_ROOT>\lobster-factory\scripts\validate-manifests.mjs
```
2. governance 顯式驗證
```
node <WORK_ROOT>\lobster-factory\scripts\validate-governance-configs.mjs
```
3. apply-manifest 乾跑（不寫 DB）
```
node <WORK_ROOT>\lobster-factory\scripts\dryrun-apply-manifest.mjs --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --projectId=33333333-3333-3333-3333-333333333333 --siteId=44444444-4444-4444-4444-444444444444 --environmentId=55555555-5555-5555-5555-555555555555 --wpRootPath="<WORK_ROOT>\dummy" --environmentType=staging
```
4. apply-manifest 乾跑驗收（`--mode=fast`，失敗即停）
```
node <WORK_ROOT>\lobster-factory\scripts\validate-dryrun-apply-manifest.mjs --mode=fast --organizationId=11111111-1111-1111-1111-111111111111 --workspaceId=22222222-2222-2222-2222-222222222222 --projectId=33333333-3333-3333-3333-333333333333 --siteId=44444444-4444-4444-4444-444444444444 --environmentId=55555555-5555-5555-5555-555555555555 --wpRootPath="<WORK_ROOT>\dummy" --environmentType=staging
```

## Memory Update Protocol
- 每完成一個里程碑就新增一段摘要
- 對話內容很長時，用以下格式壓縮：
  - 背景
  - 已完成
  - 未完成
  - 風險
  - 下一步

## Today (2026-03-26) - AO-CLOSE
- **`AO-CLOSE` 關鍵字與四段收工回覆格式不變**；**`ao-close.ps1`**（雙路徑同內容）預設：`verify-build-gates` → `system-guard`（doc-sync+health+guard）→ `generate-integrated-status-report` → **PASS 後** `git commit`／`git push`，讓公司機 **`pull` 即完整**；`-SkipPush`／`-SkipVerify` 為選用。
- **他處電腦開機**：固定閱讀 **`docs/overview/REMOTE_WORKSTATION_STARTUP.md`**（與 `RESUME_AFTER_REBOOT.md` 分機情境）；綜合報告以 **`agency-os/reports/status/integrated-status-LATEST.md`** 為準。
- **2026-03-27**：使用者授權代理於不在現場時執行完整 AO-CLOSE（含 push），並落地上述須知文件。
- `AGENTS.md`、`.cursor/rules/40-shutdown-closeout.mdc`、`end-of-day-checklist.md`、`EXECUTION_DASHBOARD` 已對齊（一鍵與分部手動擇一）。
- 先前晚間收工：doc-sync（無新差異／沿用 `closeout-20260326-015712.md`）、health、`system-guard` PASS；當時約定 Git 次日處理。
- MCP：`mcp.json` 為伺服器設定；整庫同步以本機 **git** 為主。

## Related Documents (Auto-Synced)
- `.cursor/rules/00-session-bootstrap.mdc`
- `.cursor/rules/10-memory-maintenance.mdc`
- `.cursor/rules/30-resume-keyword.mdc`
- `.cursor/rules/40-shutdown-closeout.mdc`
- `docs/overview/EXECUTION_DASHBOARD.md`

_Last synced: 2026-03-26 07:43:44 UTC_

