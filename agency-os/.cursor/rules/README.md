# Agency-OS Rules 使用說明

這份說明教你怎麼在日常工作中使用 `.cursor/rules`。

## 一句話版本

- 開工：直接開聊，或打 `AO-RESUME`
- 收工：打 `AO-CLOSE`
- 文件大改後：讓系統跑 `doc-sync + health-check + guard`

## 你現在有的 5 張規則

- `00-session-bootstrap.mdc`
  - 作用：每次新對話先做「昨日回顧 + 今日計畫 + 優先確認」。
- `10-memory-maintenance.mdc`
  - 作用：在里程碑/長對話時，更新長短期記憶檔。
- `20-doc-sync-closeout.mdc`
  - 作用：改治理文件時強制做連動同步與健康檢查。
- `30-resume-keyword.mdc`
  - 作用：收到 `AO-RESUME` 時，用固定格式快速續接。
- `40-shutdown-closeout.mdc`
  - 作用：收到 `AO-CLOSE` 或收工語句時，輸出日結與明日計畫，並驗證連動。

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
