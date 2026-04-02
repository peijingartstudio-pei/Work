# Platform templates（非租戶範本）

> **勿與** `tenants/templates/` 混淆：本目錄放 **技術堆疊／交付骨架**；租戶（每家公司）的複製起點在 **`tenants/templates/`**。

## 子目錄

| 路徑 | 用途 |
|------|------|
| `woocommerce/manifests/` | WooCommerce 相關 manifest 範例／歷史 JSON（**執行期權威 manifest 以 `lobster-factory/packages/manifests/` 與驗證腳本為準**；此處可作對客說明或本地草案） |
| `woocommerce/scripts/` | 與 playbook 對齊的 shell 入口範例（與 `lobster-factory/templates/woocommerce/scripts/` 可能並存；以龍蝦閘道實際解析路徑為準） |
| `client-base/` | 客戶專案級極簡骨架（非 `company-*` 租戶資料夾） |

## SSOT 對照

- **全庫凡名「templates」之路徑索引**：`docs/overview/repo-template-locations.md`
- **租戶 onboard**：`tenants/README.md`、`tenants/NEW_TENANT_ONBOARDING_SOP.md`
- **龍蝦 factory manifest / install 路徑**：`lobster-factory/README.md`、`lobster-factory/docs/WORDPRESS_FACTORY_EXECUTION_SPEC.md`
- **Formal SSOT 決策**：`docs/architecture/decisions/001-wordpress-manifest-and-shell-ssot.md`
- **電商 playbook**：`docs/operations/ecommerce-project-playbook.md`
