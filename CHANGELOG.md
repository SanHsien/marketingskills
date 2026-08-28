[English](CHANGELOG.en.md) | 中文版

# 變更紀錄

格式參考 [Keep a Changelog](https://keepachangelog.com/zh-TW/1.1.0/)，新的在上面。
本檔只記錄**本 fork 的維護歷史**（2026-08-27 起）；上游
[`coreyhaines31/marketingskills`](https://github.com/coreyhaines31/marketingskills)
的產品演進見其自身歷史與 [`docs/UPSTREAM.md`](docs/UPSTREAM.md) 的審查清冊。
逐筆採用／略過的理由記在 [`docs/DECISIONS.md`](docs/DECISIONS.md)。

---

## 2026-08-27（覆核）

### 修復

- **Windows CI checkout。** 上游 `CLAUDE.md` 是 git symlink；在 `core.symlinks=false` 的 Windows 上被存成「以檔案正文為 target」的 `120000` blob，runner 回 `Filename too long`。改存一般檔，並加測試擋住再出現 symlink。
- **相對連結逃出工作樹。** `check_links.py` 現在拒絕解析到 repo 根目錄以外的路徑。
- **Issue／PR 導流。** `ISSUE_TEMPLATE/config.yml` 改連本 fork 的 `CONTRIBUTING.md`，並保留上游產品貢獻連結。skill request 與產品 skill PR 模板標明不要開到這個 fork。
- **上游 validate-skill workflow。** `validate-skill.yml` 加上與 `sync-skills.yml`／`release.yml` 相同的官方 repo 閘門。

### 新增

- **`REVIEW.md`。** 第一次專案覆核快照。

## 2026-08-27

### 新增

- **`fork` Windows-first 維護骨架。** `AGENTS.md`、`CLAUDE.md`、`FORK.md`、`NOTICE.md`、
  `CONTRIBUTING.md`、`SECURITY.md`、`CODE_OF_CONDUCT.md`、`docs/`、`tools/` 維護腳本、
  `tests/`、`.github/` 的 CI／CodeQL／Dependabot／上游檢查／相依新鮮度。
  CI 跑 Ubuntu 3.9–3.14 與 Windows 3.14：pytest、ruff（E9+F）、`validate_skills.py`、
  `node --check`、相對連結檢查。
- **公開入口只留繁中與英文。** `README.md` 改繁中主檔、`README.en.md` 為英文鏡像。
  來源與授權 credit 保留，作者宣傳與贊助 CTA 不轉載。

### 變更

- `sync-skills.yml` 與 `release.yml` 加上只在上游官方 repo 執行的閘門，避免覆寫繁中 README
  或在本 fork 自動發產品 release。
