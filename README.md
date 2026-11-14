# resources

NASA Space Apps Challenge 2026 台中場、題目「[Be An Earth System Trend Detective!](https://www.spaceappschallenge.org/2026/challenges/earth-system-trend-detective/)」的資源彙整。隊伍與 agent 要找資料、API、規則時，從這裡查。作品本身在 [earth-system-trend-detective](https://github.com/nasa-hackathon-2026/earth-system-trend-detective)。

這裡不只是連結清單：每項資源都實際讀過或打過 API，並判斷**它對本題的實際用處**。

**限制**

- 查證日期都是 **2026-11-14**。官方頁面之後可能更新，送件前請再看一次原頁。
- 需要 Earthdata Login 的 API 只驗證到「不帶 token 會被拒」，帶 token 的流程還沒有人實跑。
- 各頁內文用 **[實測]**、**[官方]**、**未查證** 標示可信度。
- 主辦方發給報名者的 Slack、Drive、表單、會議連結刻意不放，原因見 [taichung-local.md](docs/resources/taichung-local.md)。

## 先看這三件事

1. **NASA 資料怎麼拿**：主幹是 Giovanni Cloud API（IMERG、GLDAS、MERRA-2、AIRS、OMI），MODIS 改從 Planetary Computer 或 AppEEARS 取得，因為 Giovanni API 沒有 MODIS。全隊今天就要註冊 Earthdata Login。見 [nasa-data.md](docs/resources/nasa-data.md)。
2. **會失格的規則**：Demo 是 7 頁 slides 或 30 秒影片，全英文；台灣時間 11/15 23:59 截止，修改後要再按 Submit；全隊註冊台中場；SI（AI）使用要揭露。見 [official-guides.md](docs/resources/official-guides.md) 開頭的檢查表。
3. **評分重點**：NASA data 必須是核心而不是點綴，台灣主辦方也建議 Resources 分頁的資源全部用上。每項資源的建議用法見 [challenge-resources.md](docs/resources/challenge-resources.md#整合建議)。

## 文件

| 檔案 | 內容 |
|---|---|
| [challenge-resources.md](docs/resources/challenge-resources.md) | 題目要求拆解；Resources 分頁 13 項資源逐項評估 |
| [nasa-data.md](docs/resources/nasa-data.md) | 可直接使用的資料集與 API、範例程式、建議的資料架構 |
| [trend-statistics.md](docs/resources/trend-statistics.md) | 趨勢與顯著性檢定的套件、陷阱、最小 pipeline |
| [global-offers.md](docs/resources/global-offers.md) | 13 項 Global Offers 依對本題的用處排序 |
| [official-guides.md](docs/resources/official-guides.md) | 送件、評分、FAQ、SI 規定、組隊、條款 |
| [taichung-local.md](docs/resources/taichung-local.md) | 台灣主辦方公告重點 |

## 索引

「本題」欄：★ = 本隊直接使用的資料集或 API，○ = 輔助（驗證、說明、工具），－ = 評估後不使用。

### Challenge 資源（Resources 分頁）

| 本題 | 名稱 | 來源網址 | 取得方式 | 使用條件 |
|---|---|---|---|---|
| ★ | Giovanni（含 Cloud API） | https://giovanni.gsfc.nasa.gov/ | 網頁；API `api.giovanni.earthdata.nasa.gov` | 免費 Earthdata Login；每月 quota |
| ★ | Hydrology Time Series（舊名 Data Rods） | https://disc.gsfc.nasa.gov/information/tools?title=Hydrology%20Time%20Series | 網頁免登入；API 同 Giovanni `/timeseries` | API 需 Earthdata Login |
| ★ | AppEEARS | https://appeears.earthdatacloud.nasa.gov/ | 網頁；REST API | 免費 Earthdata Login；非同步，可能排隊 |
| ○ | Climate Data Online (CDO) | https://www.ncei.noaa.gov/cdo-web/ | 網頁；v2 API；Access Data Service | v2 需 token；台灣測站零碎；GSOD 已停更 |
| ○ | NOAA GHCNh（CDO 測站的後繼取得管道） | https://registry.opendata.aws/noaa-ghcnh/ | AWS Open Data 匿名 HTTPS | CC0，需標出處；台中、台北氣溫到 2026-11 |
| ★ | Acker et al. 2009 SeaWiFS 時間序列論文 | https://ntrs.nasa.gov/api/citations/20090042747/downloads/20090042747.pdf | PDF | 公開 |
| ○ | KNMI Climate Explorer | https://climexp.knmi.nl/ | 網頁 | 匿名可用，有人機驗證；無 API |
| ○ | Statistical test methods to detect trends | https://medium.com/@snp.kriss/statistical-test-methods-to-detect-trends-in-time-series-data-b361a0ec530b | 網頁 | Medium 可能要求登入 |
| ○ | A Comprehensive Guide to Statistical Significance | https://www.statsig.com/perspectives/a-comprehensive-guide-to-statistical-significance | 網頁 | 公開 |
| － | RADARSAT Constellation Mission data | https://donnees-data.asc-csa.gc.ca/en/dataset/rcm | CSA 開放資料 | 依加拿大開放資料授權（未查證） |
| － | Geo.ca | https://geo.ca/ | 網頁 | 加拿大開放資料 |
| ○ | SWOT Mission | https://www.asc-csa.gc.ca/eng/satellites/swot/ | 資料經 PO.DAAC Hydrocron API | Hydrocron 免認證；資料 2023 年起 |
| － | Monitoring and protecting our ecosystems from space | https://www.asc-csa.gc.ca/eng/satellites/everyday-lives/monitoring-and-protecting-our-ecosystems-from-space.asp | 網頁 | 公開 |
| － | SAR Python Tutorial | https://github.com/asc-csa/Synthetic_Aperture_Radar_Tutorial | GitHub | 修改版 MIT |

### NASA 開放資料與 API

| 本題 | 名稱 | 來源網址 | 取得方式 | 使用條件 |
|---|---|---|---|---|
| ★ | GPM IMERG 月降水 `GPM_3IMERGM` | https://disc.gsfc.nasa.gov/ | Giovanni API；earthaccess | Earthdata Login；V07 Final 到 2025-09 |
| ★ | GLDAS Noah 月 `GLDAS_NOAH025_M` 2.1 | https://disc.gsfc.nasa.gov/ | Giovanni API；earthaccess | Earthdata Login；只有陸地 |
| ★ | MERRA-2 月 `M2IMNXASM`、`M2TMNX*` | https://disc.gsfc.nasa.gov/ | Giovanni API（瞬時）；earthaccess（月平均） | Earthdata Login |
| ★ | AIRS 月 `AIRS3STM` 7.0 | https://disc.gsfc.nasa.gov/ | Giovanni API；earthaccess | Earthdata Login |
| ★ | OMI 日 `OMNO2d`、`OMTO3d` 等 | https://disc.gsfc.nasa.gov/ | Giovanni API；earthaccess | Earthdata Login；要自己轉月 |
| ★ | MODIS NDVI、LST、ET、GPP | https://planetarycomputer.microsoft.com/catalog | AppEEARS；Earth Engine；Planetary Computer STAC | AppEEARS 需 Earthdata Login；EE 需非商用註冊；PC 免帳號（需 SAS token） |
| ★ | Google Earth Engine（GCP） | https://developers.google.com/earth-engine/datasets | Python API `ee`，伺服器端區域平均 | 非商用 Community Tier 免費、不用綁卡；無 AIRS、OMI NO₂ |
| ○ | NASA POWER | https://power.larc.nasa.gov/ | REST API；AWS `nasa-power` bucket | 免認證；MERRA-2 氣溫交叉驗證 |
| ○ | earthaccess + Cloud OPeNDAP | https://github.com/nsidc/earthaccess | Python 套件 | Earthdata Login；地端 OPeNDAP 已關閉 |
| ○ | SWOT Hydrocron | https://podaac.github.io/hydrocron/ | REST API | 免認證 |
| ○ | NASA NEX-GDDP-CMIP6 | https://planetarycomputer.microsoft.com/dataset/nasa-nex-gddp-cmip6 | Planetary Computer | 免帳號；未來情境延伸用 |

### Global Offers

| 本題 | 名稱 | 來源網址 | 取得方式 | 使用條件 |
|---|---|---|---|---|
| ★ | Microsoft Planetary Computer | https://planetarycomputer.microsoft.com/ | STAC API、Data API | 免帳號；SAS token 約 1 小時過期 |
| ○ | Meteomatics Weather API | https://www.meteomatics.com/en/meteomatics-and-nasa-space-apps-challenge/ | 表單申請帳密 | 每天 1,000 次；黑客松後失效；非 NASA data |
| ○ | 免費網域與 hosting（GoDaddy Registry × Porkbun） | https://www.spaceapps.earth/ | 網頁申請 | 一年；只限 non-premium 網域 |
| ○ | GitHub Copilot Free | https://github.com/features/copilot | GitHub 帳號 | 免卡；使用要揭露 |
| ○ | Google Cloud | https://cloud.google.com/free/docs/free-cloud-features | 申請試用 | US$300／90 天；需信用卡驗證 |
| ○ | Miro Education／Hackathon 模板 | https://miro.com/templates/profile/nasa-space-apps-challenge/ | Miro 帳號 | 學生免費兩年 |
| － | Microsoft Azure | https://azure.microsoft.com/en-us/free/ | 申請試用 | US$200／30 天；需非預付卡 |
| － | Microsoft Copilot | https://www.microsoft.com/en-us/microsoft-copilot | Microsoft 帳號 | 使用要揭露 |
| － | Microsoft Teams Free | https://www.microsoft.com/en-us/microsoft-teams/teams-free | Microsoft 帳號 | 會議 60 分鐘、100 人 |
| － | Miro Business 試用 | https://miro.com/pricing/ | 填付款資訊 | 14 天，期限前取消 |

### 官方指南

| 本題 | 名稱 | 來源網址 | 取得方式 | 使用條件 |
|---|---|---|---|---|
| ★ | Project Submission Guide | https://www.spaceappschallenge.org/resources/project-submission-guide/ | 網頁（可下載 PDF） | 2026-11-13 版 |
| ★ | Judging & Awards Guide | https://www.spaceappschallenge.org/resources/judging-awards-guide/ | 網頁 | 2026-11-13 版 |
| ★ | Participant FAQs | https://www.spaceappschallenge.org/resources/participant-faqs/ | 網頁 | 2026-11-13 版 |
| ○ | Team Formation Guide | https://www.spaceappschallenge.org/resources/team-formation-guide/ | 網頁 | 2026-11-13 版 |
| ○ | Participant Terms & Conditions | https://www.spaceappschallenge.org/legal/ | 網頁 | 2026 版 |
| ○ | 官方注意事項影片（英文原版） | https://www.youtube.com/watch?v=CV7AYfMRyMM | YouTube | 公開 |

### 台中場

| 本題 | 名稱 | 來源網址 | 取得方式 | 使用條件 |
|---|---|---|---|---|
| ★ | 主辦方 2026-11-14 公告彙整 | 主辦方寄給報名者的 email | 隊員信箱 | 分享連結不公開；重點見 [taichung-local.md](docs/resources/taichung-local.md) |
| ○ | Space Apps Taiwan Facebook | https://www.facebook.com/SpaceAppsTaiwan | Facebook | 公開 |

## 更新這個 repo

- 新增或修改資源時，同時更新上方索引與對應的 `docs/resources/*.md`，並寫上查證日期。
- 來源以官方頁面為準；二手來源要標明。
- 送 PR 前跑 `scripts/check-links.sh` 檢查連結。

Agent 設定（`AGENTS.md`、`.claude/`、`.codex/`、`docs/agents/`）來自 [org-standards](https://github.com/nasa-hackathon-2026/org-standards) 模板。
