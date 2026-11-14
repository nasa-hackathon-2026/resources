# Challenge 資源：Be An Earth System Trend Detective!

本頁整理題目原文的要求，以及 Resources 分頁上每一項資源**實際上對本題有多少用處**。台灣主辦方提醒過，評審會看「NASA 數據與資源的整合深度」，Resources 分頁的資源最好全部用上（見 [taichung-local.md](./taichung-local.md)），所以每一項都標了建議的用法，包括「只在簡報引用」這種最低限度的用法。

- 來源：https://www.spaceappschallenge.org/2026/challenges/earth-system-trend-detective/ （Details 與 Resources 分頁）
- 查證日期：2026-11-14，以 Claude in Chrome 讀取頁面原文

## 題目要什麼

難度 Advanced，主題 Earth Science、Software。任務是做一個工具：選擇衛星任務量測或地球科學模式產出的變數，視覺化它隨時間的變化，並回答**什麼在變、在哪裡變、變多少、變化是否顯著**。

### 四個必要元素（Objectives）

| # | 元素 | 我們要做到的 |
|---|---|---|
| 1 | 找出可能有趨勢的變數 | 變數選單加上給學生的簡單定義 |
| 2 | 取得特定區域的資料（多數趨勢不是全球性的） | 點位與區域（台灣、縣市）兩種模式 |
| 3 | 產生並視覺化夠長的時間序列 | 至少 10 年，最好 20 年以上的月資料 |
| 4 | 基本統計：變化率加顯著性檢定（t-test、Mann-Kendall、confidence intervals） | 斜率、95% CI、p 值，兩種方法並陳 |

原文明說：**「A response that does both the visualization and the analysis meets the full scope of this challenge.」** 視覺化和統計缺一就不算完整。

### 題目點名的資料

- 衛星儀器：MODIS、OMI、AIRS、GPM
- 模式：MERRA-2、GLDAS

這六個的取得方式與台灣可用期間見 [nasa-data.md](./nasa-data.md)。

### 加分方向（Potential Considerations，非必要）

- **對象**：高中生、大學生、有科學背景的大眾；提供變數的簡單定義；讓使用者當「資料偵探」。
- **引導流程**：用一串問題問使用者想調查什麼、在哪裡，再據此搜尋相關變數；提供幾個可以觀看的 demo 範例。
- **SI**：原文是「SI could be useful here」，用來從新聞、論文或區域特徵（沙漠、雨林、潮汐河口、大城市上空的大氣）找出可能有趨勢的資料。官方因美國行政命令把 AI 改稱 Super Intelligence（SI），所以這裡指的就是 AI。注意：官方規定**點子本身不能由 SI 產生**，但把 SI 當作工具的功能是允許的（見 [official-guides.md](./official-guides.md)）。
- **資料處理**：資料有 hourly、3-hourly、daily、monthly，daily 和 monthly 最容易處理；沒達到顯著也值得呈現，有時只是資料期不夠長；可以參考 CUAHSI 的水文繪圖工具。
- **方法範圍**：趨勢可能是非線性的，或要先移除季節循環才看得出來；更複雜的分析超出題目預期，**偵測與分析線性趨勢就是很好的起點**。

---

## Resources 分頁逐項評估

頁面聲明：NASA 不背書非美國政府實體；使用非美國政府網站的資料時，要遵守該網站的資料使用規範。

### NASA Data & Resources

| 資源 | 是什麼 | 對本題的實際用處 | 建議用法 | 優先度 |
|---|---|---|---|---|
| [Giovanni](https://giovanni.gsfc.nasa.gov/) | GES DISC 的網頁分析工具，另有雲端 API | **最核心。** 雲端 API 涵蓋 IMERG、GLDAS、MERRA-2、AIRS、OMI 共 867 個變數，單點序列同步回 CSV | 後端主幹：`/timeseries` 加 Harmony 區域平均 | 高 |
| [Hydrology Time Series](https://disc.gsfc.nasa.gov/information/tools?title=Hydrology%20Time%20Series) | 舊名 Data Rods，單點水文時間序列網頁 | 程式化存取就是 Giovanni `/timeseries`，不必另外串 | 簡報說明對應關係；可做颱風事件放大 | 中 |
| [AppEEARS](https://appeears.earthdatacloud.nasa.gov/) | LP DAAC 的陸地產品抽取工具，有 REST API | 補上 Giovanni API 沒有的 **MODIS**（NDVI、LST、ET），area task 附區域統計 CSV | 今晚先送 task，結果存成靜態檔 | 高 |
| [Climate Data Online (CDO)](https://www.ncei.noaa.gov/cdo-web/) | NOAA 測站氣候資料 | 台灣覆蓋很零碎（見下方說明），只適合當地面驗證 | 改用同屬 NCEI 的 GHCNh（AWS Open Data）台中、台北站驗證衛星序列 | 中 |
| [SeaWiFS 葉綠素時間序列論文](https://ntrs.nasa.gov/api/citations/20090042747/downloads/20090042747.pdf) | Acker et al. 2009，用 Giovanni 做趨勢偵測的示範 | **方法論依據**：月平均、OLS 加 F-test、月距平、robust regression | 當統計模組的 baseline；Pearl River 外海案例可做在地化故事 | 高 |

CDO 的台灣測站實況 [實測]：

- GHCN-Daily 裡**台灣 0 站**，所以 CDO 的 GHCND 與 GSOM 查不到台灣。
- GSOD **已正式停更**（BigQuery 公開資料集說明寫「officially discontinued」），台灣站都停在 **2025-08-24**，AWS 上的 `noaa-gsod-pds` 也沒有 2026 年。單位是 °F、inch，`units=metric` 不會換算。
  - 台中清泉崗 `46770099999`：**2001–2013 年完全沒有資料**（2014 年才恢復），不能做 2000 年起的趨勢 [實測]。
  - 台北松山 `46696099999`：2000–2025-08 完整。
- **建議改用 GHCNh**（ISD 的後繼資料集），放在 AWS Open Data 的 `noaa-ghcnh-pds`，免帳號、匿名 HTTPS 下載，授權 **CC0-1.0**（NOAA 要求標示出處）[實測]：
  - 台中 `CHM00059158`（中央氣象署台中站，WMO 59158，24.15N 120.68E）：1946 → 2026-11-10
  - 台北 `CHM00058968`（中央氣象署台北站）：1957 → 2026-11-10
  - 2025 年台中月均溫和 GSOD `59158099999` 相差 ≤ 0.1 °C [實測]；**只有氣溫可用**，降水欄位幾乎是空的。
  - 下載：`https://noaa-ghcnh-pds.s3.amazonaws.com/hourly/access/by-year/<YYYY>/psv/GHCNh_CHM00059158_<YYYY>.psv`
- 授權注意：NCEI 的 GSOD 說明依 WMO Resolution 40，非美國站的資料或衍生產品「shall not be provided to other users」；AWS 上的 NODD 標示 CC0。兩者說法不一致，保守做法是只公開月平均並註明教育、非商業用途（法律解讀未查證）。
- CDO v2 API 要申請 token、每秒 5 次、每天 1 萬次；查 GSOD 可以用免 token 的 Access Data Service，例如：

```
https://www.ncei.noaa.gov/access/services/data/v1?dataset=global-summary-of-the-day&stations=46696099999&startDate=2000-01-01&endDate=2025-08-24&dataTypes=TEMP,PRCP,MAX,MIN&format=csv
```

台灣測站的權威來源是中央氣象署的 CODiS 與開放資料平台，不在題目資源內，也還沒查證 API 細節。

### Space Agency Partner Resources

| 資源 | 是什麼 | 對本題的實際用處 | 建議用法 | 優先度 |
|---|---|---|---|---|
| [KNMI Climate Explorer](https://climexp.knmi.nl/) | KNMI 的網頁氣候分析工具，可做時間序列、距平、趨勢與顯著性 | 沒有 API，2025-02 起有人機驗證，不能當後端；但是很好的**交叉驗證參照** | 同區域同期間比對我們的斜率，答辯時引用 | 中 |
| [Statistical test methods to detect trends](https://medium.com/@snp.kriss/statistical-test-methods-to-detect-trends-in-time-series-data-b361a0ec530b) | Medium 部落格文章 | 自動抓取被擋（403），內容未查證；二手來源不宜引用 | 組員入門閱讀 | 低 |
| [A Comprehensive Guide to Statistical Significance](https://www.statsig.com/perspectives/a-comprehensive-guide-to-statistical-significance) | Statsig 的顯著性科普，A/B testing 取向 | 講 p 值、CI、統計顯著與實務顯著的差別，沒談自相關與季節性 | 改寫成工具內的「什麼是顯著？」說明卡 | 低–中 |
| [RADARSAT Constellation Mission data](https://donnees-data.asc-csa.gc.ca/en/dataset/rcm) | 加拿大 C-band SAR 衛星影像 | 覆蓋以加拿大為主，SAR 前處理 1.5 天做不完，也不是變數時間序列 | 只在簡報背景提及 | 低 |
| [Geo.ca](https://geo.ca/) | 加拿大開放地理空間資料平台 | 沒有台灣資料 | 不使用 | 低 |
| [SWOT Mission](https://www.asc-csa.gc.ca/eng/satellites/swot/) | NASA 與 CNES 主導的地表水測高任務 | PO.DAAC 的 Hydrocron API 確實可用、免認證 [實測]，但資料 2023 年才開始，**不足以做長期趨勢** | 有餘力才做「新世代衛星水文」展示 | 低 |
| [Monitoring and protecting our ecosystems from space](https://www.asc-csa.gc.ca/eng/satellites/everyday-lives/monitoring-and-protecting-our-ecosystems-from-space.asp) | CSA 科普頁 | 本次連線失敗，未查證 | 只在簡報背景提及 | 低 |
| [SAR Python Tutorial](https://github.com/asc-csa/Synthetic_Aperture_Radar_Tutorial) | CSA 的 SAR 影像繪圖教學（GDAL、cartopy） | 只有繪圖，沒有時間序列或趨勢分析 | 不使用 | 低 |

SWOT Hydrocron 範例（Version 2.0 的 reach ID 要加 `collection_name`，預設是 Version D）[實測]：

```
https://soto.podaac.earthdatacloud.nasa.gov/hydrocron/v1/timeseries?feature=Reach&feature_id=71224100223&start_time=2024-01-01T00:00:00Z&end_time=2024-03-01T00:00:00Z&output=csv&fields=reach_id,time_str,wse&collection_name=SWOT_L2_HR_RiverSP_2.0
```

台灣河段與水庫的 reach_id 或 lake_id 要另外從 SWORD 或 PLD 資料庫查，還沒查。

### 題目文字提到、但不在 Resources 分頁的資源

| 資源 | 說明 | 建議 |
|---|---|---|
| [CUAHSI HydroClient](https://data.cuahsi.org/)、[HydroShare](https://www.hydroshare.org/) | 水文時間序列探索與分享平台 | 資料以美國為主，台灣幾乎沒有；只在簡報引用「選變數、選區域、拿時間序列」的流程概念 |

---

## 整合建議

依「全部用上、用得有深度」的原則，建議的對應如下：

| 資源 | 整合深度 |
|---|---|
| Giovanni | 程式核心：後端資料來源 |
| Hydrology Time Series | 同一個 API；UI 提供「在 Hydrology Time Series 開啟」連結 |
| AppEEARS | 程式核心：MODIS 區域序列來源 |
| SeaWiFS 論文 | 統計方法依據，UI 可有「Paper mode」重現論文流程 |
| CDO | 地面測站驗證層 |
| KNMI Climate Explorer | 結果交叉驗證，寫進方法說明 |
| 兩篇統計文章 | 學生說明卡的素材 |
| CSA 資源、SWOT | 簡報中說明評估過、為什麼不適用於台灣長期趨勢 |
