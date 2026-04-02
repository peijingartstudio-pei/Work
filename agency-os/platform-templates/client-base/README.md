# Client-base（極簡專案卡，非 Agency OS 租戶台帳）

## 和 Agency OS／龍蝦怎麼搭配？

| 你要做的事 | 正確位置 |
|------------|----------|
| 新公司 onboarding、台帳、排程、合約節奏 | **`tenants/company-*`**（複製自 ` tenants/templates/`），依 **`NEW_TENANT_ONBOARDING_SOP.md`** |
| manifest 驅動建站／staging 驗證 | **`lobster-factory/`**（packages manifests + workflows + executor） |
| 策略、閘道、收工、健康分數 | **`agency-os/docs/`**、`TASKS`、`WORKLOG`、`verify-build-gates` |

`client-base/` 只保留 **最小「專案一頁紙」**：客戶名、目標、環境 URL——方便提案附件或本機草稿。

**不要**把 `client-base` 當成 `tenants/company-*` 的替代品；租戶邊界與醬料仍落在 **`tenants/`**。

## 目錄

- `docs/OPENING.md`：開案時連回 SOP／ADR 的檢查清單

## Related

- [`../README.md`](../README.md)（整個 `platform-templates` 的定位）
- `agency-os/tenants/README.md`
