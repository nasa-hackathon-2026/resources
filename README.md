# org-standards

NASA Hackathon 2026 org 的 AI agent 設定模板，涵蓋 Claude Code 與 Codex。來源是 `agent-config`，已改成 org 版。

## 結構
| 路徑 | 用途 |
|---|---|
| `AGENTS.md` | 兩邊共用的指令（單一來源） |
| `CLAUDE.md` | 匯入 `AGENTS.md`，加上 Claude 專屬內容 |
| `docs/agents/skill-routing.md` | 情境到 skill 的路由、來源解析、宣告格式 |
| `docs/agents/workflow.md` | 以 Matt skills 為基準的開發流程 |
| `docs/agents/delivery.md` | 追蹤、交接格式、worktree 與 Git、升級規則 |
| `docs/agents/issue-tracker.md`、`triage-labels.md`、`domain.md` | Matt skills 的專案設定（已預先完成） |
| `GLOSSARY.md` | 專案用語表（`grill-with-docs`、`domain-modeling` 維護，格式見 Matt skills 的 GLOSSARY-FORMAT） |
| `docs/adr/` | 架構決策紀錄，檔名 `0001-slug.md`（先放 `.gitkeep`，第一個 ADR 出現後可刪） |
| `.out-of-scope/` | `triage` 記錄被拒絕的需求（先放 `.gitkeep`） |
| `docs/agents/memory.md` | Basic Memory 的位置、時機、格式 |
| `docs/agents/dev-env.md` | Python（uv）、Rust（cargo）的環境與驗證指令 |
| `docs/agents/roles.md` | planner、worker、reviewer 三個標準角色 |
| `.claude/agents/`、`.codex/` | 三個標準 agent 的設定 |
| `.github/` | ticket 表單、PR 範本、標籤清單 |
| `scripts/` | `sync-labels.sh` 同步標籤、`project-status.sh` 設定看板欄位 |

## 建新 repo

```bash
gh repo create nasa-hackathon-2026/<名稱> --template nasa-hackathon-2026/org-standards --private --clone
cd <名稱> && scripts/sync-labels.sh
```

建好後依 `docs/agents/dev-env.md` 初始化語言環境，並在專案 `AGENTS.md` 補上「驗證指令」區塊。

## org 前置設定

模板假設 org 已有 Project「開發看板」（第 1 號），欄位 Status、Priority、Size；沒有的話 `scripts/project-status.sh` 不能用。已於 2026-11-14 建立。

## 相關
- Skills：[mattpocock/skills](https://github.com/mattpocock/skills)，Claude Code 用 plugin 安裝
