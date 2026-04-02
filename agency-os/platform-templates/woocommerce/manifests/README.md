# 示例 manifest（非 SSOT）

此目錄內 `*.json` 為 **範例或歷史快照**，方便：

- 對客簡報、團隊 onboarding
- 對照 schema 欄位長相

**若要改「會被龍蝦執行／閘道驗證」的內容**，請編輯：

`lobster-factory/packages/manifests/` 下同檔名或新增檔，並跑 monorepo 根 **`verify-build-gates.ps1`**。

**勿**只在這裡改 JSON 就以為 staging／production 行為已更新。
