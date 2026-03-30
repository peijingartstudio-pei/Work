# Cursor 企業級規則（可賣系統／版控正本）

## 這是什麼？

整合多模型產出的 **IDE 行為規範**（身分、風險、架構面、MCP 路由、資料／狀態機紀律、Skill／可觀測性），**以本 repo 為單一真相**，與 **AO 關鍵字、收工閘道、龍蝦 Routing** 對齊，避免「Settings 貼一大段卻沒進 git」的交付風險。

## 正本在哪裡？

| 位置 | 用途 |
|---|---|
| **`agency-os/.cursor/rules/63-cursor-core-identity-risk.mdc`** | 身分、風險分級、禁則（與 `00/30/40` 衝突時以 **AO 規則與關鍵字**為準） |
| **`agency-os/.cursor/rules/64-architecture-mcp-routing.mdc`** | 架構分層、MCP／工具職責（**細節以下方 SSOT 為準**） |
| **`agency-os/.cursor/rules/65-build-standards-data-state.mdc`** | DB／狀態機／專案結構（**僅在對應 globs 下啟用**） |
| **`agency-os/.cursor/rules/66-skills-observability-protocol.mdc`** | Skill 協議、可觀測性與 Phase 節奏 |
| **`../docs/spec/raw/Cursor  Rules for AI/`**（monorepo 根下 `docs/spec/...`） | 拆檔溯源與歷史包；**部署時以 `agency-os/.mdc` 正本為準**（見該目錄 `README-部署說明.md`） |

## SSOT（權威文件）

- **龍蝦自動化路由（強制）**：`../lobster-factory/docs/MCP_TOOL_ROUTING_SPEC.md`
- **Cursor MCP 鍵名與分工**：`docs/operations/cursor-mcp-and-plugin-inventory.md`
- **憑證／祕鑰政策**：`docs/operations/security-secrets-policy.md`
- **人＋代理總則**：`AGENTS.md`
- **新治理文件連動**：`docs/operations/new-doc-linkage-checklist.md`

## 維護時

1. 改任一份 `.mdc` 或本索引：依 `docs/operations/new-doc-linkage-checklist.md` 更新矩陣／`change-impact-map.json`（或 `register-new-governance-doc.ps1`）。  
2. 改 **monorepo 根** `README.md` 關於開工／雙機／收工／Cursor 規則時：同步核對本索引、`REMOTE_WORKSTATION_STARTUP`、`EXECUTION_DASHBOARD`，避免敘述分叉。  
3. 跑 `doc-sync-automation.ps1 -AutoDetect` 與 `system-health-check.ps1`。

## Related Documents (Auto-Synced)
- `../docs/spec/raw/Cursor  Rules for AI/README-部署說明.md`
- `../lobster-factory/docs/MCP_TOOL_ROUTING_SPEC.md`
- `../README.md`
- `.cursor/rules/63-cursor-core-identity-risk.mdc`
- `.cursor/rules/64-architecture-mcp-routing.mdc`
- `.cursor/rules/65-build-standards-data-state.mdc`
- `.cursor/rules/66-skills-observability-protocol.mdc`
- `AGENTS.md`
- `docs/CHANGE_IMPACT_MATRIX.md`
- `docs/change-impact-map.json`
- `docs/operations/cursor-mcp-and-plugin-inventory.md`
- `docs/operations/new-doc-linkage-checklist.md`
- `docs/operations/security-secrets-policy.md`
- `docs/README.md`

_Last synced: 2026-03-30 05:16:43 UTC_

