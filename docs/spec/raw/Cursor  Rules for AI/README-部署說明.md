# CURSOR RULES — 部署說明（v1.1 · 與 Agency OS 版控對齊）

## 重要：正本已進 repo

**單一真相**在 **`agency-os`**（可 `git pull` 給客戶／同事）：

| 正本（請改這裡） | 用途 |
|---|---|
| **`agency-os/.cursor/rules/63-cursor-core-identity-risk.mdc`** | 身分、風險分級、紅線（與 `AO`／`00/30/40` 衝突時以後者為準） |
| **`agency-os/.cursor/rules/64-architecture-mcp-routing.mdc`** | 架構分層、MCP／工具路由（細節以 inventory + `MCP_TOOL_ROUTING_SPEC` 為準） |
| **`agency-os/.cursor/rules/65-build-standards-data-state.mdc`** | DB／狀態機／結構（**globs** 限定程式與 SQL 路徑） |
| **`agency-os/.cursor/rules/66-skills-observability-protocol.mdc`** | Skill 協議、可觀測性、與 heartbeat 規則搭配 |
| **`agency-os/docs/operations/cursor-enterprise-rules-index.md`** | **索引頁**（連動矩陣 + `change-impact-map.json` 已登記） |

本目錄下之 **`00-CORE.md`、原 `01`–`03` 內容** 為多模型產出之**溯源／草稿參考**；**部署與販售**請以 **`agency-os` 內 `.mdc`** 為準。

## 可選：全域 Cursor Settings

若仍想在 **Cursor → Settings → Rules for AI** 貼一小段：請只貼 **與本專案無關的個人偏好**，或一句「專案規則以 `agency-os` 內 `.cursor/rules` 與 `AGENTS.md` 為準」，避免與版控規則**兩套打架**。

## 本目錄檔案（歷史包）

| 檔案 | 說明 |
|---|---|
| `00-CORE.md` | 原始核心草案（長輸出模板已收斂至「大型任務再啟用」，見 `63`） |
| `01-arch-and-tools.mdc` | 已融入 `64` |
| `02-build-standards.mdc` | 已融入 `65`（並加上 monorepo 適用範圍） |
| `03-skills-and-observability.mdc` | 已融入 `66` |

## 維護後必做（連動）

1. 改任一份 `agency-os` 內上述檔案 → 依 **`docs/operations/new-doc-linkage-checklist.md`**（或 `register-new-governance-doc.ps1`）與 **`doc-sync-automation.ps1` + `system-health-check.ps1`**。

## Related（連回索引）

- `agency-os/docs/operations/cursor-enterprise-rules-index.md`

## Related Documents (Auto-Synced)
- `.cursor/rules/63-cursor-core-identity-risk.mdc`
- `.cursor/rules/64-architecture-mcp-routing.mdc`
- `.cursor/rules/65-build-standards-data-state.mdc`
- `.cursor/rules/66-skills-observability-protocol.mdc`
- `docs/operations/cursor-enterprise-rules-index.md`

_Last synced: 2026-03-30 05:16:43 UTC_

