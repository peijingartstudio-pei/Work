# Resume After Reboot

## 同一台電腦 — 重開機後

請先在 Cursor 開啟工作區：
- **建議 monorepo 根**：`<WORK_ROOT>`（含 `agency-os`、`lobster-factory` 與根 `scripts`）
- 或僅開：`<WORK_ROOT>\agency-os`

**建議**：在 monorepo 根執行 `git fetch origin` 與 **`git pull --ff-only origin main`**（與另一台 **AO-CLOSE** 推送對齊；`AO-RESUME` 關鍵字**不會**自動 pull）。詳 **`agency-os/docs/overview/REMOTE_WORKSTATION_STARTUP.md`** §2。

貼上：**`AO-RESUME`**

先看：
- `LAST_SYSTEM_STATUS.md`（在 `agency-os` 根目錄）
- 若存在 **`ALERT_REQUIRED.txt`**：先修復再繼續交付

## 他處電腦／公司機 — 第一次或換機

請改看：**`docs/overview/REMOTE_WORKSTATION_STARTUP.md`**（`git pull`、`verify-build-gates`、`npm ci`、狀態檔路徑）。

> `<WORK_ROOT>` 例子：筆電可能是 `D:\Work`；公司桌機可能是 `C:\Users\USER\Work`。

## Related Documents (Auto-Synced)
- `docs/operations/system-guard-and-notification.md`

_Last synced: 2026-03-28 11:27:29 UTC_

