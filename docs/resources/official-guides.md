# 官方指南：送件、評分、規則

本頁把 2026 年官方指南中會讓作品**失格或扣分**的規定整理成可以勾選的清單。指南原文都標 2026-11-13，入口是 https://www.spaceappschallenge.org/resources/ 。

- 查證日期：2026-11-14
- 各指南都有「Download as PDF」按鈕，但 PDF 直接連結由 JS 產生，沒有取得。

## 送件前最後檢查

| # | 項目 | 依據 |
|---|---|---|
| 1 | 全隊（含 Team Owner）都註冊在**台中場**，而且不是 waitlist | Team Formation、Judging |
| 2 | 隊伍 1–6 人；**送件截止後不能加人** | Judging |
| 3 | Demo 是 **≤ 7 頁 slides（含標題與介紹頁）或 ≤ 30 秒影片**，二選一；超過就沒有 Global Judging 資格 | Submission |
| 4 | 全部英文；影片可講其他語言但**必須有英文字幕** | Submission |
| 5 | Demo 與 Final Project 連結**公開、不需登入**；用無痕視窗測過 | Submission |
| 6 | NASA Data 欄位列出使用的 NASA 資料（至少一項才有 Global Award 資格） | Submission |
| 7 | References 欄位列出**所有**外部資料、程式碼、圖片、字型（開源的也要） | Submission |
| 8 | SI 使用如實揭露：程式與資料寫在描述與 metadata，SI 生成的圖片或影片加可見浮水印 | Submission、FAQ |
| 9 | 勾選 Terms and Conditions 與「Confirm All Work is Original」，按 **Submit for Judging**；之後每次修改都要**再按一次 Submit**，只 Save 不算 | Submission、台灣主辦方 |
| 10 | **台灣時間 2026-11-15 23:59 前**送出，建議 23:00 前完成留緩衝 | Submission |
| 11 | 作品中沒有未滿 18 歲者的影像或聲音，沒有商業推銷內容 | Submission、T&C |
| 12 | repo 有 LICENSE（未指定時 NASA 以 Apache 2.0 散布原創內容） | T&C |

---

## Project Submission Guide

- URL：https://www.spaceappschallenge.org/resources/project-submission-guide/
- **時間**：11/14 09:00 開放，**11/15 23:59 截止**，以隊伍 Local Event 的時區為準（台中是 UTC+8）。截止後才儲存或送出的內容不列入評審。
- **入口**：右上頭像 → My Team → Project 分頁 → Edit。記得常按「Save Progress」；有編輯鎖，但其他人可以強制解鎖，內容可能被覆蓋。
- **頁面只能上傳圖片**（JPG/PNG/GIF，每張 ≤ 10 MB），影片與文件要用外部連結。
- **表單欄位**：
  1. Project Name
  2. High-Level Project Summary：做了什麼、如何回應挑戰、為什麼重要
  3. Link to Project Demo：7 頁 slides 或 ≤ 30 秒影片
  4. Link to Final Project：網站或 repo，要公開
  5. Detailed Project Description：怎麼運作、效益、目標、使用的工具與語言
  6. Use of Super Intelligence (SI)
  7. NASA Data：原文「To be eligible for a Global Award, you must use at least one NASA data or resource.」
  8. Space Agency Partner Data and Other References：列出所有用到的資料、程式碼、文字、圖片；有版權的素材要取得授權
- **Slides 必須包含**：隊名、成員名字、所選挑戰，並說明 NASA data 如何讓這個方案成為可能。
- **30 秒影片建議腳本**：0:00 自我介紹 → 0:02 挑戰與動機 → 0:05 專案名稱與 tagline → 0:10 怎麼運作、用了哪些 NASA data → 0:20–0:30 未來願景。
- 截止前可以無限次重送，**評審只看最後一次儲存的版本**。
- 自訂網域建議送 FortiGuard Web Filter 分類：https://www.fortiguard.com/faq/wfratingsubmit （Company Name 填 "N/A"）。

## Judging & Awards Guide

- URL：https://www.spaceappschallenge.org/resources/judging-awards-guide/
- **評分**：五項各 1–5 分，官方沒有公布權重。

| 項目 | 對本題的意義 |
|---|---|
| Impact | 對學生與大眾理解地球系統變化的幫助 |
| Creativity | 引導流程、在地案例、資料偵探的體驗 |
| Validity | 科學依據與技術可行性：統計方法的假設（自相關、季節性）、缺值處理要說清楚；介面要好用 |
| **Relevance** | 完整回應挑戰，NASA data 是 **core component** 而不是點綴；5 分的描述是「NASA data is integral to the project's success」 |
| Presentation | 評審同時看 demo 與完整專案；pitch 與 storytelling 要投入同等心力 |

- **時程**：Global Nominees 2026-12-03；Global Finalists 與 Honorable Mentions 2026-12-17；Global Winners 2027-01-26。
- **10 個 Global Awards** 中最貼近本題的是 **Best Use of Data**（讓太空資料更容易取得，或用在獨特的應用）與 **Local Impact**（在地案例）。
- **China 關聯限制**：與中國或中資實體（含香港、澳門的政府、公司、大學）有所屬關係的團隊會被審查，判斷依據是所屬單位，不是國籍。

## Participant FAQs

- URL：https://www.spaceappschallenge.org/resources/participant-faqs/
- 活動日期 2026-11-14～15，主題「The Next Frontier」，免費參加。
- 每人只能加入一隊，每隊只做一個挑戰。
- 原文「Teams are not allowed to begin working on the challenges prior to the hackathon.」：實作要在 11/14 開始之後；commit 時間會留紀錄。
- 未滿 18 歲：必須由家長或監護人註冊並全程陪同。
- 有問題可以到 Space Apps Connect 問 SME：https://github.com/nasa/spaceapps

## SI（即 AI）使用規定

- 依據：Submission Guide 的「Use of Super Intelligence (SI)」段落與 FAQ。官方依 2026-09-29 美國行政命令，以「Super Intelligence（SI）」取代「AI」一詞。
- 允許使用 ML、chatbot、影像生成、LLM、code generation 等工具。
- 原文「SI should not be used to come up with your idea of how to solve the challenge.」：**解題點子本身不能由 SI 產生**。
- SI 生成的內容**不得使用或修改 NASA branding**（logo、旗幟、任務識別）。
- 揭露方式：圖片與影片加**可見浮水印**；音訊、程式碼、資料在描述文字與 metadata 註明。
- 表單的 SI 欄位只做統計，評審看不到；但評審**看得到**專案裡的浮水印與註記，並據此評估原創性。

本隊做法：

- [ ] 專案 README 加「SI Usage」段落，說明 Claude Code、Copilot 等協助了哪些部分。
- [ ] SI 生成的程式檔加 header 註解。
- [ ] SI 生成的圖、icon、影片片段加「AI-generated」浮水印。
- [ ] 不用 SI 生成任何含 NASA logo 的素材。

## Team Formation Guide

- URL：https://www.spaceappschallenge.org/resources/team-formation-guide/
- Team Owner 的 Local Event 決定全隊的截止時區與第一輪評審場地；所有成員都必須是同一個 Local Event 的 confirmed participants。
- 被列入 waitlist 要聯絡 Local Lead；沒有回應的話，全隊要一起換到有名額的場次。
- Team Owner 要在 About 頁填 Team Contact Information；換挑戰也在 About 頁的 Edit Details。
- 刪除隊伍會清掉 Project 內容。

## Participant Terms & Conditions

- URL：https://www.spaceappschallenge.org/legal/ （2026 版）
- 作品必須直接回應挑戰；不得含商業推銷內容、沒有權利的素材、個資、未成年人的肖像。
- **原創內容視為開源**：沒有指定 OSI 授權時，NASA 會以 Apache 2.0 散布。
- 使用非 NASA 素材時，要確保它可以自由公開使用或採用 OSI 授權。
- NASA 可以使用參賽者的姓名與影像。

## 未讀取或未查證

- 各指南的 PDF 直接連結。
- Space Apps Connect Guide（https://www.spaceappschallenge.org/resources/space-app-connect-guide/），與本題關係不大。
- 評分五項是否等權：官方沒有公布。
