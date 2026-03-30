# Global Task Board

## In Progress
- [x] 建立多租戶案場資料夾結構（company -> site -> project）
- [x] 設計標準報價包（建置/維運/行銷/客製）
- [x] 定義變更單（CR）流程與核價規則
- [x] 套入第一個真實客戶到 `tenants/company-a/`
- [x] 完成 `2026-001` Discovery 需求盤點（初版）
- [x] 補齊 `2026-001` 時程與里程碑日期（初版）
- [x] 建立 `lobster-factory` Phase 1 底座骨架（Supabase migrations + wc-core manifest + workflow 安全骨架）

## Next
- [ ] **（2026-03-31 提醒）** 整理 `docs/spec/raw/` **四份原文**內容（`LOBSTER_FACTORY_MASTER_V3.md`、`LOBSTER_FACTORY_MASTER_SPEC_V1.md`、`ENTERPRISE_BASE_STACK.md`、`CURSOR_PACK_V1.md`）：目錄／摘要／與 [`docs/overview/company-os-four-sources-integration.md`](docs/overview/company-os-four-sources-integration.md) 對齊；避免與 `agency-os`／`lobster-factory` 已落地文件重複維護兩套敘述。
- [x] 定義 WordPress 客製系統開發準則（plugin/mu-plugin/資料表策略）
- [x] 建立 n8n 工作流分層（共用流程 vs 客戶專屬流程）
- [x] 建立 KPI + 毛利雙儀表板（規格）
- [x] 建立文件分類與連動更新機制（`docs/CHANGE_IMPACT_MATRIX.md`）
- [x] 建立結案自動檢查清單與文件自動同步（`scripts/doc-sync-automation.ps1`）
- [x] 建立每公司自動排程系統（Daily/Weekly/Monthly/Adhoc）
- [x] 建立國際化交付/合規/多幣別政策（global delivery/compliance/commercial）
- [x] 建立系統健康檢查機制（`scripts/system-health-check.ps1`）
- [x] 建立主動守護與告警機制（`scripts/system-guard.ps1` + 排程）
- [x] 建立桌面彈窗提醒（PASS/FAIL）與 ALERT/LAST_STATUS 主動提示
- [x] 建立可販售產品化藍圖與交接清單（`docs/product/*`）
- [x] 建立對外販售打包腳本（`scripts/build-product-bundle.ps1`）
- [x] 建立總控中心架構與多平台（WordPress-first）連動設計
- [x] AO-CLOSE 預設 100% health 閘道已落地（規則/文件/腳本三層）
- [ ] 用 1 個新客戶實跑 `tenants/NEW_TENANT_ONBOARDING_SOP.md`
- [x] 完成今日 AO-CLOSE 三步收工檢查（doc-sync / health / guard 全 PASS）
- [x] 完成今日 AO-CLOSE 一鍵閘道與同步推送（verify-build-gates + guard + integrated-status + git push；**2026-03-28 晚** 再跑一輪以收斂 A10／SOP／presign 等本機變更）
- [x] 報表單一路徑收斂（canonical=`agency-os/reports`，root `reports/` 退役為相容用途）
- [x] 建立標準 MSA/SOW/CR 文件模板
- [x] 修復 `AgencyOS-*` 排程路徑到 `D:\Work\agency-os` 並補齊命令引號防呆
- [x] 建立 reports 歸檔腳本（`scripts/archive-old-reports.ps1`）與 README 操作入口
- [x] 他處／公司機開機須知（`docs/overview/REMOTE_WORKSTATION_STARTUP.md` + `RESUME_AFTER_REBOOT.md` 分機情境）
- [x] Enterprise 工具層選型/安裝完成（Sentry/PostHog/Cloudflare/Clerk；Secrets 先採 env/mcp；輔助：Supabase/Slack）
- [x] 啟用 Operator Autopilot 規則與 Phase1 自動化腳本（startup preflight / alert auto-repair / closeout optional push / Slack notify）
- [ ] Enterprise 工具層 Phase 1 正式串接（Clerk auth、env/mcp secrets 治理、Cloudflare WAF/rate-limit、Sentry error ingest、PostHog core events、Slack alerts）
- [x] 整合 `LOBSTER_FACTORY_MASTER_V3` 至系統建置路線（gap map + skeleton sprint + gate 追蹤，H1~H6 baseline 完成）
- [x] `lobster-factory` H3 第一批 skeleton sprint（Sales/Marketing/Partner/Media/Decision Engine/Merchandising）
- [x] `lobster-factory` H4 Decision Engine baseline（recommendations schema + contract）
- [x] `lobster-factory` H5 CX retention/upsell baseline（workflow_runs 串接骨架）
- [x] `lobster-factory` C3-3 release gate baseline（PR gate + prod deploy gate）
- [x] `lobster-factory` Trigger deploy CI 修復完成（project ref 對齊 + 缺失 `uid` 補齊 + Actions 綠燈）
- [x] 修復 Cursor `user-trigger` MCP 啟動錯誤（移除錯誤 `--api-key` 參數，改 vault 啟動腳本）
- [x] 落地強制版 MCP routing 規格與風險矩陣（`MCP_TOOL_ROUTING_SPEC.md` + `workflow-risk-matrix.json`）
- [x] 落地 WordPress Factory 細部執行規格（`WORDPRESS_FACTORY_EXECUTION_SPEC.md`：step-by-step + failure matrix + approval payload）
- [x] 將 WordPress Factory 規範轉成可執行 gate（`wordpress-factory-execution-policy.json` + `validate-workflow-routing-policy.mjs` + bootstrap 整合）
- [x] `lobster-factory` C3-1 標準 E2E payload + staging 管線回歸腳本（`docs/e2e/STAGING_PIPELINE_E2E_PAYLOAD.md`、`run-staging-pipeline-regression.mjs`）
- [x] `lobster-factory` C2-1 mock hosting adapter（`hosting/mockStagingAdapter.ts` + `create-wp-site` 整合 + `MOCK_HOSTING_ADAPTER.md`）
- [x] `lobster-factory` C3-2 演練報告產生器（`emit-staging-drill-report.mjs` → `agency-os/reports/e2e/`）
- [x] `lobster-factory` hosting 合約（`resolveStagingProvisioning`、`provider_stub` 阻擋、`HOSTING_ADAPTER_CONTRACT.md`）
- [x] `lobster-factory` A9 本機 artifacts（`localArtifactSink`、`LOBSTER_ARTIFACTS_MODE=local`、`logs_ref` PATCH）
- [x] `lobster-factory` hosting `providers/` 合約骨架 + `print-create-wp-site-payload` CLI
- [x] `lobster-factory` 營運套裝：`operator:sanity`、`payload:apply-manifest`、`LOBSTER_FACTORY_OPERATOR_RUNBOOK.md`
- [x] `lobster-factory` hosting：`http_json` 適配器 + 合約文件（`resolveStagingProvisioning` async）
- [x] `lobster-factory` A9：`remote_put` artifact 上傳（presigned PUT + presign broker 合約）
- [x] Monorepo 根 `README.md` + `EXECUTION_DASHBOARD` 現況對齊 + 雙邊 README／`AGENTS` 導覽連動
- [x] `lobster-factory` A10-1：`OPERABLE_E2E_PLAYBOOK.md` + `validate-operable-e2e-skeleton.mjs`（納入 bootstrap）；A9 政策 `ARTIFACTS_LIFECYCLE_POLICY.md`
- [x] A10-2 前置：`NEW_TENANT_ONBOARDING_SOP` Step 7（Lobster 銜接）+ `PRESIGN_BROKER_MINIMAL` + presign JSON 範例；operable gate 驗證 monorepo SOP 橋接
- [x] `lobster-factory` C1-2 execute 驗證（`package_install_runs` lifecycle：pending -> running -> completed）
- [x] `lobster-factory` C1-3 execute 驗證（DB 寫入韌性：retry/compensation/trace）
- [x] 建立零成本本機 Secrets Vault（Windows DPAPI，`scripts/secrets-vault.ps1`）
- [x] 完成 Secrets Vault 一鍵匯入（`mcp.json` + Lobster/Slack 關鍵值）
- [x] `PROGRAM_SCHEDULE.json` → Linear：`push-program-schedule-to-linear.ps1` + playbook §3（單向；稽核仍靠 `sync-linear-delta-to-daily`）

## Backlog
- [x] 客戶分級與風險評分模型
- [x] 外包交付評分卡
- [x] 合規檢查清單（抓取與 leads）
- [ ] 建立跨國稅務與法遵顧問審核流程（法律文件外部審核）
- [x] 建立英文化客戶輸出模板（Proposal/SOW/Monthly Report）
- [x] 建立 release notes + upgrade path + migration checklist
- [x] `lobster-factory` 補齊 raw spec 差距檔案（C4-1~C4-5 完成）
- [ ] `lobster-factory` Enterprise 必備工具補強路線：Sentry/PostHog/Cloudflare/Secrets/Identity（已選型：Identity=Clerk；Secrets 暫採 env/mcp，待升級 secrets manager）

## Related Documents (Auto-Synced)
- `.cursor/rules/00-session-bootstrap.mdc`
- `.cursor/rules/20-doc-sync-closeout.mdc`
- `.cursor/rules/30-resume-keyword.mdc`
- `.cursor/rules/40-shutdown-closeout.mdc`
- `docs/architecture/agency-command-center-v1.md`
- `docs/compliance/leads-and-scraping-checklist.md`
- `docs/metrics/kpi-margin-dashboard-spec.md`
- `docs/operations/client-risk-scoring-model.md`
- `docs/operations/outsourcing-vendor-scorecard.md`
- `docs/operations/system-operation-sop.md`
- `tenants/NEW_TENANT_ONBOARDING_SOP.md`

_Last synced: 2026-03-30 05:16:43 UTC_

