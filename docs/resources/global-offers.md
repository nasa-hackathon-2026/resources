# Global Offers：哪些值得用

Global Collaborators 提供的免費工具，全部是選用的。本頁依「對本題有沒有用」排序，不是依廠商排序。

- 來源：https://www.spaceappschallenge.org/2026/global-offers/ （頁面先有 NASA 非背書聲明，按「I Understand」後顯示內容）
- 查證日期：2026-11-14
- 頁面聲明：NASA 不背書非美國政府實體，也不保證兌換碼有效；參賽者**不必**使用這些資源。

## 結論

| 優先度 | Offer | 用途 |
|---|---|---|
| 高 | Microsoft Planetary Computer | 免帳號取得 NASA MODIS 時間序列 |
| 中 | 免費網域（spaceapps.earth） | 給 demo 一個好記的網址 |
| 中 | GitHub Copilot Free | 寫程式輔助；用了要在 SI 欄位揭露 |
| 中（需要後端時） | Google Cloud | Cloud Run 跑 Python 統計 API |
| 低–中 | Meteomatics Weather API | 比較層；帳號在黑客松後失效 |
| 低–中 | Miro Education / 模板 | 發想、user flow、簡報草稿 |
| 低 | Azure、Microsoft Copilot、Teams Free、Miro Business 試用 | 要綁卡，或隊伍已有替代工具 |

**Hosting 建議**：前端放 GitHub Pages（免費、不綁卡、評審不用登入就能看），預先算好的時間序列放成靜態 JSON；真的需要即時後端再用 Google Cloud Run。自訂網域指向 GitHub Pages 當加分項，但同時保留 `*.github.io` 連結。

---

## Microsoft Planetary Computer（高）

- 網址：https://planetarycomputer.microsoft.com/ ；資料目錄 https://planetarycomputer.microsoft.com/catalog
- Offer 原文重點：Data Catalog 與 STAC API **免帳號**；多數資料不登入就能下載，但速度或存取可能受限；部分請求需要免費 access token。
- 實測：STAC 查詢匿名可用；讀資料檔一定要 SAS token（匿名免費、約 1 小時過期）；台中在 MODIS tile h29v06。
- 對本題：NASA MODIS 的 NDVI、LST、ET、GPP 都持續更新到 2026-10，補上 Giovanni API 沒有 MODIS 的缺口。API 用法與 collection 清單見 [nasa-data.md](./nasa-data.md#microsoft-planetary-computer-上的-nasa-modisglobal-offer免帳號)。
- 限制：Hub（免費 compute）已在 2024-06-06 退役；GPM IMERG、ERA5、TerraClimate 在這裡都已停更；OMI、AIRS、MERRA-2、GLDAS 不在上面。
- 支援窗口：samfal@microsoft.com

## Meteomatics Weather API（低–中）

- 申請頁：https://www.meteomatics.com/en/meteomatics-and-nasa-space-apps-challenge/ （只能用這頁的表單申請）
- Offer 內容：每天 1,000 次查詢、1,800+ 參數、JSON/CSV/XML/PNG、有 Python connector；**帳號只在黑客松期間有效**。
- URL 格式：`https://api.meteomatics.com/{時間}/{參數}/{lat,lon}/{格式}`，HTTP Basic 認證。
- 歷史資料：官方說 ERA5 可回溯到 1940，但官方新聞也寫免費帳號不含歷史資料；黑客松帳號是否開放**未查證**，要拿到帳號後實測。
- 對本題：不是 NASA data，只能當比較層。評審在 11/16 之後才看作品，那時帳號已失效，所以**一定要在 11/15 前抓好並快取**，不要在 demo 網站即時呼叫。商業資料能否公開再散布未查證，建議只放圖、不放原始資料。
- 支援窗口：support@meteomatics.com

## 免費網域與 hosting（中）

- 網址：https://www.spaceapps.earth/
- 內容：免費網域加一年 hosting 與 SSL，**只限 non-premium 網域**；由 GoDaddy Registry 提供、Porkbun 完成註冊；需要 email 收驗證碼。
- 注意：新註冊的網域常被學校或企業的 web filter 擋掉，Submission Guide 建議送 FortiGuard 分類（https://www.fortiguard.com/faq/wfratingsubmit）。續費價格未查證。
- 支援窗口：support@porkbun.com

## GitHub Copilot Free（中）

- 網址：https://github.com/features/copilot
- 內容：不用信用卡；每月 2,000 次 code completion，加上有限的 chat 與 agent。
- 注意：任何 SI 工具的使用都要在提交表單與專案中揭露（見 [official-guides.md](./official-guides.md#si即-ai使用規定)）。

## Google Cloud（需要後端時才用）

- 網址：https://cloud.google.com/free/docs/free-cloud-features
- 內容：US$300、90 天；要信用卡驗證，但試用結束後不會自動扣款；可用 Firebase、Maps API。
- 對本題：如果統計要即時計算（例如使用者自訂點位），可以把 Python API 放 Cloud Run。Earth Engine 不在這個 offer 裡（未查證）。
- 支援窗口：cloudstartupsupport@google.com

## Miro（低–中）

| 方案 | 內容 | 建議 |
|---|---|---|
| [Education Plan](https://miro.com/education-whiteboard/) | 學生免費兩年、教育者永久免費 | 學生用這個就好 |
| [Business Plan 試用](https://miro.com/pricing/) | 14 天，要填付款資訊，期限前取消才不會扣款 | 避免綁卡 |
| [Hackathon 模板](https://miro.com/templates/profile/nasa-space-apps-challenge/) | Hackathon Template Board、Project Coach Board | 可用於發想與規劃 |

## 其他（低）

| Offer | 內容 | 為什麼低 |
|---|---|---|
| [Microsoft Azure](https://azure.microsoft.com/en-us/free/) | 新客戶 US$200、30 天；可能要電話、非預付卡、Microsoft 或 GitHub 帳號 | 要綁卡；GitHub Pages 已足夠 |
| [Microsoft Copilot](https://www.microsoft.com/en-us/microsoft-copilot) | 通用聊天助理 | 價值低，用了一樣要揭露 |
| [Microsoft Teams Free](https://www.microsoft.com/en-us/microsoft-teams/teams-free) | 會議 100 人、每次 60 分鐘、每人 5 GB | 隊伍已有溝通工具 |
