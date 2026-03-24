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

## Memory Update Protocol
- 每完成一個里程碑就新增一段摘要
- 對話內容很長時，用以下格式壓縮：
  - 背景
  - 已完成
  - 未完成
  - 風險
  - 下一步

## Related Documents (Auto-Synced)
- `.cursor/rules/00-session-bootstrap.mdc`
- `.cursor/rules/10-memory-maintenance.mdc`
- `.cursor/rules/30-resume-keyword.mdc`
- `.cursor/rules/40-shutdown-closeout.mdc`

_Last synced: 2026-03-23 14:30:03 UTC_

