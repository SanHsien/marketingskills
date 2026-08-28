English | [中文版](CHANGELOG.md)

# Changelog

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); newest first.
This file records **this fork's maintenance history** only (from 2026-08-27). The product
history of upstream
[`coreyhaines31/marketingskills`](https://github.com/coreyhaines31/marketingskills) lives in
its own history and in the review ledger at [`docs/UPSTREAM.md`](docs/UPSTREAM.md). Per-commit
adopt/skip reasoning is recorded in [`docs/DECISIONS.md`](docs/DECISIONS.md).

---

## 2026-08-27 (review)

### Fixed

- **Windows CI checkout.** Upstream `CLAUDE.md` is a git symlink. With `core.symlinks=false` on Windows, `git add` stored the file body as the symlink target, and the runner failed with `Filename too long`. It is now a regular file, with a test that blocks git symlinks.
- **Relative links escaping the worktree.** `check_links.py` now rejects paths that resolve outside the repository root.
- **Issue/PR routing.** `ISSUE_TEMPLATE/config.yml` now links this fork's `CONTRIBUTING.md` and keeps a separate upstream product-contribution link. Skill-request and product-skill PR templates say not to open those against this fork.
- **Upstream validate-skill workflow.** `validate-skill.yml` now has the same official-repo gate as `sync-skills.yml` and `release.yml`.

### Added

- **`REVIEW.md`.** First project-review snapshot.

## 2026-08-27

### Added

- **Windows-first maintenance overlay.** `AGENTS.md`, `CLAUDE.md`, `FORK.md`, `NOTICE.md`,
  `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `docs/`, maintenance scripts under
  `tools/`, `tests/`, and GitHub workflows for CI, CodeQL, Dependabot, upstream review, and
  dependency freshness. CI runs Ubuntu 3.9–3.14 plus Windows Python 3.14: pytest, ruff (E9+F),
  `validate_skills.py`, `node --check`, and relative-link checks.
- **Public entry in Traditional Chinese and English only.** `README.md` is the Chinese
  primary file; `README.en.md` is the English mirror. Source and license credit stay;
  author promotion and sponsorship CTAs do not.

### Changed

- `sync-skills.yml` and `release.yml` now run only on the upstream official repository, so
  this fork cannot overwrite the Traditional Chinese README or auto-publish product releases.
