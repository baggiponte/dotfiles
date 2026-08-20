# Recommendation — adopt `mise bootstrap`

**Status:** 🚧 WIP — branch kept open. Review at the 2-month checkpoint below.
**Branch:** `feat/mise-bootstrap-audit`
**Date:** 2026-08-20 · mise **2026.8.9** · macOS arm64
**Validation method:** live `status` / `--dry-run` / `plan` against the local machine via `MISE_CONFIG_FILE` merge. **Nothing was applied.**

Details that expand on this: `mise-bootstrap-audit.md` (full mapping), `mise/bootstrap-audit-test.toml` (validated config), `mise-bootstrap-validation.log` (transcripts).

---

## Decision

**Migrate to declarative `mise bootstrap`:**
- `[bootstrap.packages]` — **formulae only** (`brew:…`, e.g. `brew:git`)
- `[dotfiles]` — `~/.gitconfig` + `~/icloud` symlinks, `~/.local/bin` script farm (`symlink-each`)
- `[bootstrap.files."/etc/zshenv"]` — ZDOTDIR (whole-file; already converged on this machine)
- `[bootstrap.macos.*]` — defaults, one TOML block per real domain
- `[bootstrap.user]` — `login_shell = "/bin/zsh"`

**Keep in `brew bundle` (do not migrate):**
- all casks, fonts (incl. `homebrew/cask-fonts`), third-party taps, and the `vscode` / `uv` / `npm` Brewfile lines

**Python stays 100% uv-owned.** mise must never declare `python` in `[tools]` — its python backend has no uv install path and would create a second interpreter pool.

---

## Validated facts (this machine, 2026.8.9)

- Full declarative surface **already converges with zero drift**: 3 dotfiles applied, 33 defaults set, `/etc/zshenv` unchanged, 3 formulae installed, login shell set. Green full-pipeline `--dry-run`.
- **Blockers until fixed:**
  - `brew-cask:` refuses Homebrew-owned casks even with `adopt = true` → *"Homebrew owns this cask; remove it with Homebrew"*
  - cask-fonts-tap fonts fail to fetch → *"Tapped casks must publish API metadata"* + JSON parse error
- **Gotchas when writing config:**
  - defaults are strictly typed: `3` ≠ `3.0` (dock/trackpad scaling keys)
  - no `$HOME` expansion in defaults values → screencapture uses the resolved path
  - arrays unsupported in `[bootstrap.macos.defaults]` → text substitutions stay in a `post-defaults` hook
  - `[dotfiles]` has no sudo → `/etc/zshenv` uses `[bootstrap.files]`, not `[dotfiles]`
  - keep the xcode **wait-loop + `xcodebuild -license accept`**; don't strip it to a bare `--install`
  - `~/.docker/config.json` wiring must be ported; `install/packages.zsh` has a buildx-symlink typo (points at docker-compose's keg) — fix on port

---

## Upstream watch (can change the decision)

- **PR #11910** — *feat(brew): share Homebrew formula and cask ownership* — **open draft, updated 2026-08-20**. Would allow adopting Homebrew-owned casks without uninstalling. Prime candidate to unblock casks.
- **Adoption (#12074)** shipped in 2026.8.9 but does not yet cover Homebrew-owned casks — the exact case we hit.
- **Homebrew upstream churn:** casks are migrating to `command_wrapper` / structured flight steps, breaking previously-working mise casks (discussion #11462 → fix #11472). Recurring risk; another reason casks stay in `brew bundle`.
- **cask-fonts tap** doesn't publish `api/cask/<token>.json`; no mise-side fix in sight. Fonts stay in `brew bundle`.

---

## Checkpoint — 2026-10-20

```sh
brew upgrade mise
mise bootstrap packages apply --dry-run brew-cask:alt-tab   # still refused?
gh pr view 11910 -R jdx/mise --json state,mergedAt           # landed?
```

- If the refusal clears → uncomment the `brew-cask:` entries (with `adopt = true`) from the audit test config and migrate casks.
- If not → keep casks in `brew bundle`; re-check next quarter.