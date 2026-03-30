# Agency-OS Rules 使用說明

這份說明教你怎麼在日常工作中使用 `.cursor/rules`。

## 一句話版本

- 開工：直接開聊，或打 `AO-RESUME`
- 收工：打 `AO-CLOSE`
- 文件大改後：讓系統跑 `doc-sync + health-check + guard`

## 你現在有的規則（ monorepo 根；與 `agency-os/.cursor/rules` 併用時勿改出兩套敘述）

- `00-session-bootstrap.mdc` — 新對話開場結構。
- `10-memory-maintenance.mdc` — 長短期記憶維護。
- `20-doc-sync-closeout.mdc` — 治理文件改動後 doc-sync / health。
- `30-resume-keyword.mdc` — `AO-RESUME`。
- `40-shutdown-closeout.mdc` — `AO-CLOSE`。
- `50-operator-autopilot.mdc`、`60-beginner-operation-format.mdc`、`62-progress-heartbeat-15min.mdc` — 營運／格式／心跳（見各檔 description）。
- **`63`–`66`（企業級）** — 與 **`agency-os/.cursor/rules` 正本同檔同步複製至此**；索引見 `agency-os/docs/operations/cursor-enterprise-rules-index.md`。更新正本後請覆蓋根目錄這四檔，避免只開 monorepo 根時漏載。

## 每天建議流程

1. 開工時輸入 `AO-RESUME`
2. 完成任務過程中照常對話
3. 有改 `docs/`、`tenants/`、規則或治理檔時，確認有跑 closeout 流程
4. 關機前輸入 `AO-CLOSE`

## 常用關鍵字

- `AO-RESUME`：開工續接（強制先讀記憶與任務檔）
- `AO-CLOSE`：收工總結（今日完成/未完成/連動檢查/明日優先）

## 你會看到的固定輸出

- 開工：
  - `Yesterday Recap`
  - `Today Plan`
  - `Confirm`
- 收工：
  - `今日完成`
  - `今日未完成`
  - `連動檢查`
  - `明日優先`

## 異常時怎麼判斷

- 如果回覆沒先出現開工摘要，請直接重打 `AO-RESUME`
- 如果收工沒跑檢查，請重打 `AO-CLOSE`
- 如果 `連動檢查` 顯示 FAIL，先修復再結束當日工作

## 手動檢查命令（必要時）

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\doc-sync-automation.ps1 -AutoDetect
powershell -ExecutionPolicy Bypass -File .\scripts\system-health-check.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\system-guard.ps1 -Mode manual
```

## 維護規則時的原則

- 一個規則只做一件事（避免互相覆蓋）
- 改規則後要同步檢查：
  - `AGENTS.md`
  - `docs/change-impact-map.json`
  - `docs/CHANGE_IMPACT_MATRIX.md`
