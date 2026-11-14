# NASA 資料與 API：本隊可直接使用的路線

本頁回答一個問題：**題目要的變數，台灣範圍、夠長的時間序列，要從哪裡、用什麼 API 拿？** 結論先講，細節在後。

- 查證日期：2026-11-14
- 標記：**[實測]** 這次實際打過 API 或下載確認；**[官方]** 讀官方文件或官方 notebook；**未查證** 只有二手來源或推論
- 範圍限制：需要 Earthdata Login 的呼叫只驗證到「不帶 token 會被拒」，帶 token 的流程還沒有人實跑過

## 結論

| 變數類別 | 推薦來源 | 為什麼 | 期間 |
|---|---|---|---|
| 降水（GPM IMERG） | Giovanni Cloud API | 同步回 CSV，點位查詢秒級 | 月：1998-01 → **2025-09**（V07 Final） |
| 陸面水文（GLDAS：氣溫、土壤水、蒸發、逕流） | Giovanni Cloud API | 同上；0.25° 全球陸地 | 月：2000-01 → 2026-07 |
| 大氣（AIRS：地表氣溫、水氣、臭氧、OLR） | Giovanni Cloud API | 同上 | 月：2002-09 → 今 |
| 空氣品質（OMI：NO₂、O₃、SO₂、HCHO、UV aerosol index） | Giovanni Cloud API | 只有日資料，要自己 resample 成月 | 2004-10 → 今 |
| 再分析（MERRA-2） | Giovanni Cloud API（`M2IMNXASM` 月瞬時）或 earthaccess（`M2TMNX*` 月平均） | Giovanni API 沒有月平均版本 | 1980 → 今 |
| 植生、地表溫度、蒸散、GPP（MODIS） | **Planetary Computer**（免帳號）或 **AppEEARS**（區域統計 CSV） | Giovanni API **沒有 MODIS** [實測] | 2000-02 → 今 |

**所有 Giovanni、AppEEARS、earthaccess 路線都需要免費的 Earthdata Login（EDL）帳號。** Planetary Computer 不需要帳號。

### 今天就要做的前置作業

1. 每位成員到 https://urs.earthdata.nasa.gov/ 註冊 EDL 帳號。
2. 在 EDL 的 Applications → Authorized Apps 授權 **"NASA GESDISC DATA ARCHIVE"**，沒授權的話 GES DISC 資料會被拒絕 [官方]。
3. 產生 token（網頁上產生，或用 `earthaccess.get_edl_token()`），實際打一次 `/timeseries` 與 `/quota`，確認 CSV 格式與剩餘額度。

### 建議的資料架構

1. **主幹：Giovanni Cloud API。** 使用者在地圖上點位置時，即時打 `/timeseries`；預設區域（台灣本島、縣市）的區域平均用 Harmony 先批次跑好、存成靜態檔。
2. **MODIS 補位：Planetary Computer 或 AppEEARS，一律離線預抓。** AppEEARS 是非同步 task，曾有排隊數天的紀錄，demo 現場絕對不要即時送出。
3. **備援：earthaccess 加 Cloud OPeNDAP。** 只在 Giovanni quota 用完、Harmony 太慢、或需要 MERRA-2 月平均時使用。
4. **Hydrology Time Series 不另外寫程式。** 它的程式化存取就是 Giovanni `/timeseries` [官方]，簡報裡說明這個對應關係即可算作有整合。

評審的 Relevance 項目要求 NASA data 是「core component」而不是點綴（見 [official-guides.md](./official-guides.md)），所以趨勢計算的主資料必須是上表的 NASA 產品；ERA5、TerraClimate、Meteomatics 只能當比較層。

---

## Giovanni Cloud API（主幹）

- 經典網頁版：https://giovanni.gsfc.nasa.gov/giovanni/ （v4.40）
- 雲端 API base：`https://api.giovanni.earthdata.nasa.gov`
- 官方教學 notebook：
  - 單點：https://github.com/nasa/gesdisc-tutorials/blob/main/notebooks/How_to_Access_GiC_Time_Series_Service.ipynb
  - 區域平均：https://github.com/nasa/gesdisc-tutorials/blob/main/notebooks/How_To_Access_the_Giovanni_Averaging_Service_Using_Python.ipynb （2026-04 撰寫）
- User Guide：https://giovanni.gsfc.nasa.gov/giovanni/doc/UsersManualworkingdocument.docx.html

### 端點

| 端點 | 認證 | 用途 | 狀態 |
|---|---|---|---|
| `GET /configured-variables/` | 不需要 | 可用變數 ID 清單，可直接做 UI 的變數下拉選單 | [實測] 867 個，含 IMERG、GLDAS、MERRA-2、AIRS、OMI、TRMM、NLDAS；**沒有 MODIS** |
| `GET /timeseries?data=<id>&location=[lat,lon]&time=<start>/<end>` | EDL Bearer token | **單點**時間序列，同步回 CSV（前 13 行是 header，接著是 `Timestamp,value`） | [實測] 不帶 token 回 403；官方 notebook 跑 20 年 3-hourly 約 5.8 秒 |
| `GET /quota` | EDL Bearer token | 本月已用 quota 比例，官方建議 ≥ 0.95 時停止 | [官方] |
| Harmony（`harmony-py`，`average="area"`, `format="text/csv"`） | EDL | **區域平均**時間序列，非同步 job | [官方] 等待時間未實測 |

### 範例：台中的月降水

```python
import earthaccess, requests
earthaccess.login()                                   # 讀 ~/.netrc 或環境變數
token = earthaccess.get_edl_token()["access_token"]
r = requests.get(
    "https://api.giovanni.earthdata.nasa.gov/timeseries",
    params={"data": "GPM_3IMERGM_07_precipitation",
            "location": "[24.15,120.68]",
            "time": "2001-01-01T00:00:00/2025-09-30T23:59:59"},
    headers={"Authorization": f"Bearer {token}"})
# 前 13 行是 metadata（param_name、unit、lat、lon…），之後是 Timestamp,value
```

### 範例：台灣本島的區域平均（Harmony）

```python
from harmony import Client, Collection, Request, BBox   # pip install harmony-py
import earthaccess, datetime as dt
earthaccess.login(); hc = Client()
cid = earthaccess.search_datasets(short_name="GLDAS_NOAH025_M", version="2.1")[0].concept_id()
req = Request(collection=Collection(id=cid),
              temporal={"start": dt.datetime(2000, 1, 1), "stop": dt.datetime(2025, 12, 31)},
              spatial=BBox(120.0, 21.8, 122.1, 25.4),          # W, S, E, N
              variables=["GLDAS_NOAH025_M_2_1_Tair_f_inst"],
              format="text/csv", average="area")
files = [f.result() for f in hc.download_all(hc.submit(req))]
```

同一個 Request 改成 `average="time", format="image/tiff"`，會得到時間平均地圖的 GeoTIFF，可以拿來做地圖面板 [官方]。

### 本題建議的月變數

| 變數 ID（皆已在 `/configured-variables/` 確認存在 [實測]） | 意義 | 給學生的一句話定義 |
|---|---|---|
| `GPM_3IMERGM_07_precipitation` | GPM IMERG 月降水率 | 衛星估計的每小時平均降雨量 |
| `GLDAS_NOAH025_M_2_1_Tair_f_inst` | GLDAS 近地面氣溫 | 地表上方約 2 公尺的空氣溫度 |
| `GLDAS_NOAH025_M_2_1_SoilMoi0_10cm_inst` | 表層 0–10 cm 土壤水 | 土壤最上層含多少水 |
| `GLDAS_NOAH025_M_2_1_Evap_tavg` | 蒸散 | 從地面和植物回到大氣的水 |
| `AIRS3STM_7_0_SurfAirTemp_A` | AIRS 地表氣溫（升軌） | 衛星紅外線量到的近地面氣溫 |
| `AIRS3STM_7_0_TotH2OVap_A` | 大氣總水氣 | 整層大氣柱含多少水氣 |
| `M2IMNXASM_5_12_4_T2M` | MERRA-2 2 m 氣溫（月瞬時） | 模式重建的 1980 年以來氣溫 |
| `OMNO2d_003_ColumnAmountNO2TropCloudScreened` | OMI 對流層 NO₂（日） | 交通與工業排放的指標 |

### 限制

- `/timeseries` 只支援單點；區域平均要走 Harmony 非同步 job。
- 每月有運算 quota，上限沒有公開。
- GLDAS 會遮罩海洋格點，靠海的點位可能查不到資料 [官方]。
- 經典網頁版不登入只能取 4 個時間點，也不能下載，實際上也要登入 [官方]。
- 經典網頁版能疊加 linear regression 線，但**不提供顯著性檢定**，所以統計要自己做。

---

## Hydrology Time Series（舊名 Hydrology Data Rods）

- 網址：https://disc.gsfc.nasa.gov/information/tools?title=Hydrology%20Time%20Series （舊的 Data Rods 連結會 301 轉到這裡 [實測]）
- 是什麼：GES DISC 為「時間序列存取」重新排列的資料服務，網頁 UI 可以點一個位置畫出單點序列、下載 CSV／PNG，**網頁不需要登入** [官方]。
- 程式化存取：官方明說請用 Giovanni Time Series API，也就是上一節的 `/timeseries` [官方]。
- 台灣可用：GLDAS、GPM IMERG 半小時、MERRA-2 小時。**不可用**：NLDAS 與 GRACE CLSM0125US（只涵蓋北美／美國）。
- 對本題：長期趨勢改用月資料集；這個服務可以當「颱風期間 IMERG 半小時降雨」之類的事件放大功能，或讓使用者交叉驗證點位序列。

---

## AppEEARS（MODIS 區域統計）

- UI：https://appeears.earthdatacloud.nasa.gov/
- API 文件：https://appeears.earthdatacloud.nasa.gov/api/
- 流程：`POST /login`（EDL 帳密，HTTP Basic）換 Bearer token（約 48 小時）→ `POST /task` → `GET /status/{id}` → `GET /bundle/{id}` [官方]
- 產品：[實測] 193 個，含 `MOD13A3.061`（月 NDVI/EVI 1 km）、`MOD11A2.061`（8 日 LST 1 km）、`MOD16A2GF`（ET）、`MOD17A2HGF`（GPP）、`VNP13A3`、`SPL4SMGP`（SMAP 土壤水）。**沒有** MERRA-2、GLDAS、IMERG、OMI、AIRS。
- **Area task 會附 Statistics CSV**（逐日期的 mean、SD 等），可以直接當區域平均時間序列 [官方公告，未逐字核對]。
- 限制：非同步，平常約 10 分鐘，論壇有排隊數天的紀錄（二手來源）；單筆請求的點數、面積上限沒有寫在文件中（未查證）；台灣雲多，要用 QA layer 過濾。
- 對本題：今晚先送出台灣本島或各縣市 GeoJSON 的 `MOD13A3.061`、`MOD11A2.061` area task（2001–2025），把 Statistics CSV 存成靜態檔。layer 名稱送出前先用 `GET /product/MOD13A3.061` 確認。

```bash
curl -X POST "https://appeears.earthdatacloud.nasa.gov/api/task" \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"task_type":"point","task_name":"taichung-ndvi",
       "params":{"dates":[{"startDate":"01-01-2001","endDate":"12-31-2025"}],
                 "layers":[{"product":"MOD13A3.061","layer":"_1_km_monthly_NDVI"}],
                 "coordinates":[{"latitude":24.15,"longitude":120.68}]}}'
```

---

## Microsoft Planetary Computer 上的 NASA MODIS（Global Offer，免帳號）

Planetary Computer 是 Global Offer，不在題目 Resources 分頁上，但它放的 MODIS 是 NASA 產品，可以補 Giovanni API 沒有 MODIS 的缺口，而且不需要 EDL。

- STAC API：`https://planetarycomputer.microsoft.com/api/stac/v1`（匿名可用）[實測]
- 讀檔前要簽 SAS token：`planetary_computer.sign_inplace`，或 `GET /api/sas/v1/sign?href=<blob url>`；token 匿名免費，約 1 小時過期 [實測：未簽名讀 blob 回 409，簽名後回 206]
- 點值查詢（不用下載整個 tile）：`GET /api/data/v1/item/point/{lon},{lat}?collection=modis-13Q1-061&item=<id>&assets=250m_16_days_NDVI` [實測]
- 台中落在 MODIS tile **h29v06** [實測]

| collection | 內容 | 期間 |
|---|---|---|
| `modis-13Q1-061` | NDVI/EVI 16 日 250 m | 2000-02 → 今 [實測] |
| `modis-11A2-061` | LST 8 日 1 km | 2000-02 → 今 |
| `modis-16A3GF-061` | ET 年值（gap-filled） | 2001 → 今 |
| `modis-17A2HGF-061` | GPP 8 日 | 2000 → 今 |
| `nasa-nex-gddp-cmip6` | NASA 降尺度 CMIP6 | 1950 → 2100，可做「未來情境」延伸 |

注意：Planetary Computer 上的 `gpm-imerg-hhr` 只到 2021-05、`era5-pds` 最新到 2020-12、`terraclimate` 只到 2021-12，都已停更；OMI、AIRS、MERRA-2、GLDAS 不在上面。Hub（免費 compute）已在 2024-06-06 退役，只剩資料與 API。

---

## 備援：earthaccess 加 Cloud OPeNDAP

- earthaccess：https://github.com/nsidc/earthaccess （0.19.0，需要 Python ≥ 3.12）
- GES DISC OPeNDAP In The Cloud：https://disc.gsfc.nasa.gov/information/tools?title=OPeNDAP%20In%20The%20Cloud
- **重要**：GES DISC 公告在 2026-08-07 到 09-30 之間關閉所有地端 OPeNDAP [實測：公告原文仍在頁面上]。舊教學裡 `goldsmr4.gesdisc...`、`hydro1...` 這類 URL 不要再用，改用 `opendap.earthdata.nasa.gov` 的 Cloud OPeNDAP（DAP4 語法，xarray 中要把 `https://` 換成 `dap4://`）。
- 整檔下載很重（MERRA-2 月檔 2000–2025 約 16 GB），一定要用 OPeNDAP 子集。

| short_name | 內容 | 期間 |
|---|---|---|
| `M2TMNXSLV` 5.12.4 | MERRA-2 月平均 T2M、TQV、TO3… | 1980-01 → 2026-09 |
| `M2TMNXFLX` 5.12.4 | MERRA-2 月平均 PRECTOT… | 1980 → 今 |
| `GLDAS_NOAH025_M` 2.1 | GLDAS 月 | 2000-01 → 2026-07 |
| `GPM_3IMERGM` 07 | IMERG 月 | 1998-01 → 2025-09 |
| `AIRS3STM` 7.0 | AIRS 月 | 2002-09 → 今 |
| `OMNO2d` 004 | OMI NO₂ 日 | 2004-10 → 今 |

（期間取自 CMR 查詢 [實測]）

---

## 方法參考：Acker et al. (2009) SeaWiFS 葉綠素時間序列論文

- PDF：https://ntrs.nasa.gov/api/citations/20090042747/downloads/20090042747.pdf
- 作者是 GES DISC 團隊，發表於 *EARSeL eProceedings* 8(2)。
- 為什麼重要：這篇就是「只用 Giovanni 加試算表做 trend detection」的示範，和本題的精神完全一致，也是 Resources 分頁上唯一的方法論文獻。
- 方法（可直接移植）：
  1. Giovanni 對 0.5°×0.5° 區域取月平均，得到時間序列。
  2. 最小平方線性回歸，以 ANOVA F-test 判定顯著（p < 0.05），並報告 R²。
  3. 去季節：每月減去該月份的多年平均得到距平，取年平均後再回歸。
  4. 用 robust regression 和 OLS 比較，檢查離群值的影響；作者也示範了單一洪水事件會讓結果在「顯著」與「接近顯著」之間切換。
- 在地化切入點：研究區之一 **Pearl River 外海（22.0–22.5N, 117.5–118.0E）就在台灣海峽西南側**，結果是上升、p = 0.068（接近顯著）。
- 對本題：統計模組以論文方法當 baseline，再加 Mann-Kendall、Sen's slope、信賴區間，理由正是論文自己承認 OLS 對離群值敏感。細節見 [trend-statistics.md](./trend-statistics.md)。
