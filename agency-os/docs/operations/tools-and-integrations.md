# Tools and Integrations

## Integrations
- WordPress
- Supabase
- GitHub
- **Linear**（議題／路線圖／sprint；通常經 **Cursor 外掛** 或官方 OAuth；與 `TASKS.md` 對齊方式見 `AGENTS.md`「Linear」）
- n8n
- Replicate
- DataForSEO
- ~~**Airtable**~~：**已淘汰**（2026-03-30）；**功能須遷到 Supabase**（schema、權限、自動化改接），見 **`docs/operations/airtable-to-supabase-migration-playbook.md`**；MCP 清單對照見 **`docs/operations/cursor-mcp-and-plugin-inventory.md`**。

## Cursor MCP 與外掛分工（完整表）
- **權威索引**：**`docs/operations/cursor-mcp-and-plugin-inventory.md`**（與 repo 根 **`mcp.json`** 的 `mcpServers` 鍵對齊子表；含 LLM 分流、plugin MCP、與龍蝦 [`MCP_TOOL_ROUTING_SPEC`](../../../lobster-factory/docs/MCP_TOOL_ROUTING_SPEC.md) 的對照）。

## Credential Rule
- 憑證不落地在 Markdown、聊天訊息、或版本庫。
- 只用環境變數與密鑰管理工具注入執行環境。

## Expected Environment Variables
- `LINEAR_API_KEY`（**可選**；設後於 `generate-integrated-status-report`／**AO-CLOSE** 自動把 Linear 更新摘要寫入 `memory/daily`；見 `docs/operations/linear-repo-sync-playbook.md`）
- `WP_BASE_URL`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `GITHUB_TOKEN`
- `N8N_BASE_URL`
- `N8N_API_KEY`
- `REPLICATE_API_TOKEN`
- `DATAFORSEO_LOGIN`
- `DATAFORSEO_PASSWORD`

## Operational Notes
- **MCP 清單與分工**：見 **`docs/operations/cursor-mcp-and-plugin-inventory.md`**；連線步驟見 **`docs/operations/mcp-add-server-quickstart.md`**（若日後另有 `mcp/CONNECTORS.md` 可併列入口，非必填）。
- 每次整合異動都需記錄於 `WORKLOG.md`。
- **Linear**：API key／token **不入庫**；以 Cursor 設定或組織核准的 secrets 注入為主；跨機續接以 **`TASKS` + `WORKLOG` + issue key** 對照，避免只靠雲端板。

## Related Documents (Auto-Synced)
- `docs/operations/airtable-to-supabase-migration-playbook.md`
- `docs/operations/cursor-mcp-and-plugin-inventory.md`
- `docs/standards/n8n-workflow-architecture.md`
- `tenants/templates/tenant-template/03_TOOLS_CONFIGURATION_GUIDE.md`

_Last synced: 2026-04-01 02:31:21 UTC_

