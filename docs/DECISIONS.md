# 維護決策

## 2026-08-27：建立 Windows-first 維護型 fork

**決定**：fork `coreyhaines31/marketingskills`，保留 MIT 與完整歷史，預設分支維持 `main` 以降低與上游同步摩擦。本線聚焦繁中公開入口、Windows 開發 gate、Windows CI，以及逐筆審查的上游追蹤。

**理由**：上游已有 50 個可安裝的行銷 Agent Skills 與零依賴 Node CLI，符合維護者讓 AI 助手處理轉化、文案、SEO 與增長的需求。缺的是 Windows 11 上可重現的開發／驗收骨架，以及繁中入口。直接用上游 repo 難以長期記錄 fork 取捨。授權是 MIT，fork 修改同樣走 MIT。

**限制**：

- 不把 fork 包裝成原創專案，不移除原作者與 MIT 標示。
- `skills/*/SKILL.md` 保持產品規格，不用維護索引覆寫。
- 不把產品 skill 翻譯成繁體；產品語言跟隨上游。
- 上游更新必須逐筆審查。
- 不回貢，除非維護者在當次對話明確同意。

## 2026-08-27：維護線直接推 main

**決定**：fork 維護不再開功能分支。改完在本機跑 gate，通過後直接推 `origin/main`。遠端只留 `main`；`upstream/main` 只追蹤。

**理由**：這是單人維護 fork，分支與 PR 沒有第二審查者，只增加同步成本。

**限制**：

- Dependabot 與外部 fork 仍可能開 PR，讀 diff 後再合併，不自動合併。
- 不推 `upstream`，不 force-push `main`。
- 不刪 `upstream` remote。

## 2026-08-27：不啟用 Dependabot 自動合併

**決定**：Dependabot 只開 PR；CI 與人工讀 diff 通過後才合併。

**理由**：開發依賴只有 pytest / ruff，體積小，但自動合併仍會跳過「讀 diff」這一步。

## 2026-08-27：閘住上游的自動同步與自動發版

**決定**：`.github/workflows/sync-skills.yml` 與 `.github/workflows/release.yml` 加上 `if: github.repository == 'coreyhaines31/marketingskills'`。本 fork 不讓 Coreybot 覆寫繁中 README，也不在版本號變動時自動發 GitHub Release。

**理由**：`sync-skills.yml` 會把技能表寫回 `README.md`，與本 fork 的繁中公開入口衝突。`release.yml` 在 `plugin.json` 版本變動時發 release，本線不代發上游產品版本。

**限制**：上游若重寫這兩支 workflow，merge 時要保留閘門。

## 2026-08-27：閘住上游 validate-skill.yml

**決定**：`.github/workflows/validate-skill.yml` 加上 `if: github.repository == 'coreyhaines31/marketingskills'`。本 fork 的 skill 驗證只走 `tools/validate_skills.py`。

**理由**：該 workflow 用 `ubuntu-slim` 與第三方 `Flash-Brew-Digital/validate-skill@v1`，且沒有 repo 閘門。有人改 `SKILL.md` 時會在本 fork 跑。本線不改寫產品 skill，也不把第三方 action 當 CI 契約。

**限制**：merge 上游時若這支 workflow 被重寫，必須把閘門加回去。

## 2026-08-27：GitHub 貢獻入口改指本 fork，產品 skill 仍導向上游

**決定**：`ISSUE_TEMPLATE/config.yml` 的貢獻連結改為本 fork 的 `CONTRIBUTING.md`，另留一條上游產品貢獻連結。skill request 與產品 skill PR 模板加上「不要開到這個 fork」的說明。

**理由**：訪客在 GitHub 點 Contributing 會進到上游英文指南，誤以為本線收產品 skill PR。本 fork 的貢獻契約已經寫在 `CONTRIBUTING.md`。

**限制**：不改 `.claude-plugin/plugin.json` 的 homepage／repository，不把 `FUNDING.yml` 改掛到維護者。

## 2026-08-27：公開文件只留繁中與英文；README 只留 credit

**決定**：GitHub About 與公開入口只用繁體中文與英文。README 不轉載作者個人頁、機構、課程、贊助 CTA 或官網行銷。來源與授權 credit 留在 README 短段與 `NOTICE.md`。

**理由**：這是維護型 fork，不是原作者的宣傳頁。相關 credit 放 README 短段與 `NOTICE.md` 即可滿足 MIT 標示。

**限制**：上游若把宣傳段落一併推進來，merge 後刪掉／不要合進公開入口。技能目錄表與工具登錄連結可同步。

## 2026-08-27：CLAUDE.md 改存一般檔，不跟上游 symlink

**決定**：本 fork 的 `CLAUDE.md` 以一般檔（mode `100644`）存放 fork 薄入口，不保留上游「symlink → AGENTS.md」。

**理由**：上游 `CLAUDE.md` 是 git symlink。Windows 上 `core.symlinks=false` 時，`git add` 會把檔案正文寫進 symlink blob；GitHub Windows runner checkout 就變成 `unable to create symlink CLAUDE.md: Filename too long`，整個 Windows job 在 checkout 失敗。Ubuntu 不受影響，所以 overlay 推送後只紅 Windows。

**限制**：同步上游時若 `CLAUDE.md` 又變回 symlink，必須再改成一般檔。`tests/test_docs.py::test_tracked_files_are_not_git_symlinks` 會擋住。
