# System Guard and Notification

## 目的
- 在重要時點主動檢查資料連動完整性並留下狀態告知。

## 守護內容
- 自動跑 `scripts/doc-sync-automation.ps1 -AutoDetect`
- 自動跑 `scripts/system-health-check.ps1`
- 顯示桌面彈窗：PASS/FAIL（可視化提醒）
- 產生狀態報告與告警檔：
  - `reports/guard/guard-*.md`
  - `LAST_SYSTEM_STATUS.md`
  - `ALERT_REQUIRED.txt`（僅失敗時產生）

## 執行模式
- `manual`：手動觸發
- `daily`：每日固定時段
- `pre_shutdown`：登出前（接近關機前）
- `startup`：開機後立即檢查

## 註冊排程
- `powershell -ExecutionPolicy Bypass -File .\automation\REGISTER_SYSTEM_GUARD_TASKS.ps1 -DailyTime 22:30`
- 預設會在開機守護後開啟 `LAST_SYSTEM_STATUS.md`
- 若不想開啟：加 `-NoOpenStatusOnStartup`

## 手動立即執行
- `powershell -ExecutionPolicy Bypass -File .\scripts\system-guard.ps1 -Mode manual`

## 判定標準
- 健康分數 >= 95% 視為 PASS
- Health Critical Gate 必須 PASS（map 連動缺漏或 tenant 必要檔缺漏會直接 FAIL）
- 低於門檻時建立 `ALERT_REQUIRED.txt` 並要求先修復再發布

## Related Documents (Auto-Synced)
- `AGENTS.md`
- `automation/REGISTER_SYSTEM_GUARD_TASKS.ps1`
- `README.md`
- `RESUME_AFTER_REBOOT.md`
- `scripts/system-guard.ps1`

_Last synced: 2026-03-20 04:57:15 UTC_

