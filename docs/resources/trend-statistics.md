# 趨勢統計：方法、套件與陷阱

題目第四個元素要求「變化率加顯著性檢定」，並點名 t-test、Mann-Kendall、confidence intervals。本頁給出可以在 1.5 天內做完、又經得起評審 Validity 項目檢驗的做法。

- 查證日期：2026-11-14
- 方法 baseline 來自題目 Resources 上的 Acker et al. 2009（見 [nasa-data.md](./nasa-data.md#方法參考acker-et-al-2009-seawifs-葉綠素時間序列論文)）
- 套件說明取自官方文件；下方引用的論文 DOI 未逐一開啟核對

## 套件

| 用途 | 套件 / 函式 | 重點 |
|---|---|---|
| OLS 線性趨勢 + t 檢定 | `scipy.stats.linregress` | 回傳 `slope, intercept, rvalue, pvalue, stderr`；pvalue 檢定 H0: slope = 0；95% CI = `slope ± t.ppf(0.975, n-2) * stderr` |
| 穩健斜率 + CI | `scipy.stats.theilslopes(y, x, alpha=0.95)` | 回傳斜率與上下界；**alpha 是信賴水準**；不回傳 p 值 |
| Mann-Kendall 家族 | [`pymannkendall`](https://github.com/mmhs013/pyMannKendall) 1.4.3 | `original_test`、`hamed_rao_modification_test`（自相關修正）、`seasonal_test(x, period=12)`、`sens_slope`、`seasonal_sens_slope`；每個檢定回傳 `trend, h, p, z, Tau, slope…` |
| 去季節 | `statsmodels.tsa.seasonal.STL(endog, period=12, robust=True)` | 有 NaN 時要先插補 |
| 多重檢定 | `scipy.stats.false_discovery_control(ps, method="bh")` | 逐格點掃描或比較很多變數時使用 |

## 五個陷阱

1. **自相關會讓顯著性灌水。** 月距平通常有 lag-1 自相關，OLS 和原始 Mann-Kendall 都假設獨立，算出的 p 值會太小。
   - OLS：用有效樣本數 `n_eff = n·(1−r1)/(1+r1)` 重算標準誤（Santer et al. 2000, JGR, doi:10.1029/1999JD901105）。
   - Mann-Kendall：用 Hamed-Rao 修正（Hamed & Rao 1998, J. Hydrol. 204:182–196）。
2. **季節循環。** 月資料直接回歸，季節振幅會讓殘差變大；起訖月份不對稱時還會讓斜率偏差。最簡單也最好向學生解釋的做法是**月距平**（每月減該月份的多年平均），和 Acker 論文一致。另一個選擇是 Seasonal Mann-Kendall。
3. **紀錄長度。** 可偵測的趨勢大小與年數有關（Weatherhead et al. 1998, JGR, doi:10.1029/98JD00995）。實務建議：**少於 10 年就顯示警告**。MODIS（2000～）、OMI（2004～）約 20 年可用；SWOT（2023～）不行。
4. **多重檢定。** 逐格點畫顯著性地圖時，α = 0.05 下約 5% 的格點會假顯著，要用 BH-FDR（Wilks 2016, BAMS, doi:10.1175/BAMS-D-15-00267.1）。
5. **顯著不等於重要。** 同時呈現斜率、95% CI 與每 10 年的變化量。另外，感測器換代（例如 MODIS C6 → C6.1）可能造成假趨勢，缺值超過約 20% 的序列也不宜分析。

## 最小 pipeline（後端 Python）

```python
import numpy as np, pandas as pd, pymannkendall as mk
from scipy import stats

def analyze(series: pd.Series, period=12, alpha=0.05):
    """series：月平均、DatetimeIndex、已做區域平均"""
    s = series.asfreq("MS")
    warn = []
    if len(s) / period < 10:
        warn.append("紀錄少於 10 年，趨勢不可靠")
    if s.isna().mean() > 0.2:
        warn.append("缺值超過 20%")

    # 1) 去季節：月距平
    anom = (s - s.groupby(s.index.month).transform("mean")).dropna()
    t = (anom.index - anom.index[0]).days / 365.25          # 單位：年

    # 2) OLS + t 檢定 + CI，用 lag-1 自相關修正有效樣本數
    r = stats.linregress(t, anom.values)
    resid = anom.values - (r.intercept + r.slope * t)
    r1 = np.corrcoef(resid[:-1], resid[1:])[0, 1]
    n = len(anom)
    n_eff = max(3, n * (1 - r1) / (1 + r1))
    se_adj = r.stderr * np.sqrt((n - 2) / (n_eff - 2))
    tcrit = stats.t.ppf(1 - alpha / 2, n_eff - 2)
    p_adj = 2 * stats.t.sf(abs(r.slope / se_adj), n_eff - 2)

    # 3) 非參數：Hamed-Rao MK（距平）、Seasonal MK（原始月值）、Sen's slope 與 CI
    hr = mk.hamed_rao_modification_test(anom.values, alpha=alpha)
    smk = mk.seasonal_test(s.values, period=period, alpha=alpha)
    ts = stats.theilslopes(anom.values, t, alpha=1 - alpha)

    return dict(
        ols_slope_per_decade=10 * r.slope,
        ols_ci=(10 * (r.slope - tcrit * se_adj), 10 * (r.slope + tcrit * se_adj)),
        ols_p_raw=r.pvalue, ols_p_ar1=p_adj, lag1_r=r1, n_eff=n_eff,
        mk_hamed_rao_p=hr.p, mk_trend=hr.trend, seasonal_mk_p=smk.p,
        sen_slope_per_decade=10 * ts.slope,
        sen_ci=(10 * ts.low_slope, 10 * ts.high_slope),
        warnings=warn)
```

`seasonal_test` 遇到 NaN 的行為未查證，保險做法是先確認每個月份都有足夠資料。這段程式尚未實跑，進專案前要寫測試（例如用已知斜率加雜訊的合成序列驗證）。

## 給學生的呈現方式

- 原始序列與距平序列各一張圖，畫出趨勢線與 95% CI 帶。
- 一句話結論，例如：「每 10 年上升 0.21 °C（95% CI 0.12–0.30），考慮自相關後仍顯著（p = 0.003），兩種方法結論一致。」
- OLS 和 Mann-Kendall 結論不一致時，提示可能有離群值或非線性變化。
- 「什麼是顯著？」說明卡：p < 0.05 不代表趨勢很大；不顯著也不代表沒有變化，可能只是資料期不夠長（題目原文也這樣說）。素材可取自 Statsig 文章。

## 驗證結果的方法

- 用 GSOD 清泉崗站月均溫（1952–2025）和衛星或再分析序列比對斜率量級。
- 同一區域、同一期間，在 KNMI Climate Explorer 算一次趨勢，比對我們的結果。
