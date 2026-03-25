# Integrated status report (assembled)

- Generated: 2026-03-26 01:55:01
- agency-os root: `D:\Work`

> Assembled from canonical sources only; edit those files to change truth. Chinese legend: `docs/overview/INTEGRATED_STATUS_REPORT.md`
>
> Regenerate: `powershell -ExecutionPolicy Bypass -File .\scripts\generate-integrated-status-report.ps1`

## Source index
- `TASKS.md`
- `../lobster-factory/docs/LOBSTER_FACTORY_MASTER_CHECKLIST.md`
- `memory/CONVERSATION_MEMORY.md`
- `memory/daily/YYYY-MM-DD.md`
- `LAST_SYSTEM_STATUS.md`, `WORKLOG.md`

## 1)-2) TASKS.md
_missing_

## 3) Lobster Factory Master Checklist - open items (sections A-C, before section D)
- [ ] A6. 串接 hosting provider adapter（建立 staging site 的實作層） - [ ] A7. 串接 WordPress 真正 provision/shell execution（仍須 guardrails） - [ ] A8. 打通 DB 真寫入完整流程（workflow_runs -> package_install_runs lifecycle） - [ ] A9. 補齊 artifacts/log ref、rollback 路徑、錯誤回復策略 - [ ] A10. 建立最小可運營 E2E（新客戶從建立到驗收）與回歸測試 - [ ] C1-1. 先只開 `LOBSTER_ENABLE_DB_WRITES=true` 驗證 `workflow_runs` 寫入（已新增 `scripts/validate-workflow-runs-write.mjs`，待實際 env 執行） - [ ] C1-2. 再接 `package_install_runs` 寫入與狀態流（pending/running/completed/failed/rolled_back；已新增 `scripts/validate-package-install-runs-flow.mjs`，待實際 env 執行） - [ ] C1-3. 補齊 DB 寫入錯誤處理（重試、補償、可觀測；已新增 `scripts/validate-db-write-resilience.mjs` + `supabaseRestInsert` retry/trace） - [ ] C2-1. hosting adapter（site/env 建立） - [ ] C2-2. WP 實際安裝步驟執行器（對應 manifest steps） - [ ] C2-3. rollback 實作（最少可回復到 snapshot） - [ ] C3-1. 建立一套標準 E2E 測試 payload（真實欄位） - [ ] C3-2. 完成一次端到端演練並留存報告 - [ ] C3-3. 設計 release gate（禁止未過 gate 的變更進主幹） - [ ] C5-1. Observability：Sentry（錯誤追蹤）+ PostHog（產品分析） - [ ] C5-2. Edge/Security：Cloudflare（WAF/CDN/Rate limit） - [ ] C5-3. Secrets：1Password Secrets Automation（或同級） - [ ] C5-4. Identity/Org：Clerk/WorkOS/Auth0（三選一） - [ ] C5-5. Cost/Decision：成本與決策引擎可觀測化（budget/ROI guardrails） - [ ] C5-6. 後續建議：Langfuse / Upstash / Stripe / Object Storage / Search

*Checklist path:* `D:\Work\lobster-factory\docs\LOBSTER_FACTORY_MASTER_CHECKLIST.md`

## 4) CONVERSATION_MEMORY
_missing_

## 5) memory/daily/2026-03-26.md
_no file for today yet._

## 6) LAST_SYSTEM_STATUS.md (appendix)
_none_

## 7) WORKLOG.md tail (~60 lines)
_none_

