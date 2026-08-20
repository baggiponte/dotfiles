# Migration Audit — homegrown `install.sh` → `mise bootstrap`

**Date:** 2026-08-20
**Machine:** macOS arm64, zsh, Homebrew
**Scope:** Full mapping of the existing setup (`install.sh`, `install/*.zsh`, `Brewfile`, dotfiles, uv) onto declarative `mise bootstrap` config.
**Source of truth:** `mise --version` → 2026.8.9; official docs read 2026-08-20.

---

## 0. Verdict (TL;DR)

Migration is **highly feasible and worth doing**, but **not 1:1**. Roughly:

| Area | Verdict |
|---|---|
| Homebrew formulae | Migrate to `[bootstrap.packages]` (100% covered, incl. `@17`-style pins) |
| Homebrew casks incl. fonts | Migrate to `[bootstrap.packages]` as `brew-cask:` (covered; macOS only) |
| Taps, `trusted:`, VS Code ext, `uv` tools, npm deps in Brewfile | **Not covered by `[bootstrap.packages]`** — keep `brew bundle` as one fallback hook, or use package plugins/`[tools]` for the subsets you want |
| Dotfiles symlinks (`~/.gitconfig`, `~/icloud`, `~/.local/bin` script farm) | Migrate to `[dotfiles]` (incl. `symlink-each`, the perfect fit for the script farm) |
| macOS defaults | Migrate to `[bootstrap.macos.*]`, mostly 1:1; **3 entries can't** (see §5) |
| `prerequisites` (xcode, `/etc/zshenv`) | Split: **`/etc/zshenv` → `[bootstrap.files]`** (it elevates with sudo and converges — see §4.6); xcode-select + license stays a guarded hook/task |
| Python (`python.zsh`) | **Stays 100% uv-owned. mise never touches it.** See §2 — this is your explicit constraint |
| Docker Compose/Buildx plugin wiring | Keep as a `post-packages` hook |

**Net:** roughly 60–70% of the pipeline becomes declarative and converging; the rest stays as a small, idempotent `[tasks.bootstrap]` + a handful of hooks.

---

## 1. Why this is the right idea for this repo

`install.sh` + `install/*.zsh` today is the classic hand-rolled bootstrap with all its failure modes:

- **Not idempotent.** `apply-macos-defaults.zsh` re-writes every default and `killall`s Dock/Finder/SystemUIServer on every run — even when nothing changed.
- **No preview, no audit.** You can't answer "what would this change on a fresh box?" without running it.
- **One brittle chain.** A failing `source` in the middle aborts the rest.
- **No cross-machine story.** Same scripts, by hand, on every box.

`mise bootstrap` converts most of that into declarative TOML that **converges** — already-set defaults, already-installed packages, already-matching dotfiles are skipped. You get `--dry-run`, `plan`, `status --missing`, `--skip`/`--only`, and optionally `mise bootstrap remote` for SSH'd boxes.

---

## 2. 🐍 Python: uv owns it. mise coordinates, uv computes.

Your constraint: **mise must not manage Python.** Confirmed viable — and I checked the "can mise 100% leverage uv?" question honestly:

### Can mise fully delegate Python to uv? **No** — for interpreter installation.

Verified against current docs/source (`docs/lang/python.md`, current Python backend):

- mise's `python` backend installs interpreters **into its own store** (`~/.local/share/mise/installs/python/...`) using python-build-standalone binaries or python-build. There is **no uv install backend** — mise does not hand the install to `uv python install`.
- uv installs its managed interpreters into **`~/.local/share/uv/python/`** — a separate pool.
- The only mise/uv integration that exists is about **venvs, not interpreters**: `python.uv_venv_auto` (source a uv-created `.venv`) and `_.python.venv` with `uv_create_args`. You don't need either, and both assume mise-managed Python.

So "mise with uv backend" **does not exist for Python installs**. If mise also installed Python, you'd end up with **two parallel interpreter pools**, and then exactly the ambiguity you're trying to avoid: *"which `python` is on PATH right now?"* `UV_PYTHON` can force uv to *use* a mise-installed interpreter, but that reverses ownership (mise owns, uv obeys) — the opposite of what you want.

### What I recommend: **mise never declares `python`, never runs a python tool backend, never manages venvs for you.**

- No `python = ...` anywhere in `[tools]`.
- No `python.uv_venv_auto`, no `_.python.venv` in `[env]`.
- Your existing `python.zsh` logic moves into a **bootstrap task/hook** as plain `uv` invocations:

```sh
uv python install 3.13 3.12 3.11 3.10 || true
```

`uv python install` is idempotent and fast when already present, so it's safe to run on every `mise bootstrap`. This is consistent with your `uv.toml` → `python-preference = "only-managed"` (uv only ever resolves its own managed interpreters).

- Keep `uv` itself a brew package (`brew:uv`) — already in your Brewfile.
- Keep the `uv "..."` entries of your Brewfile (`argcomplete`, `azure-cli`, `google-colab-cli`, `huggingface-hub`, `llmfit`, `maturin`, `prek`, `wandb`) **in uv land** — they're `uv tool install`s and belong to uv. If/where you leave the Brewfile, they ride along via `brew bundle`; if you drop the Brewfile, fold them into the same bootstrap task (`uv tool install --name ... <pkg>`).

**Rule to enforce in review:** grep the final config for `python` — it must only appear in comments, hook *commands* (`uv ...`), and never as a `[tools]` backend.

---

## 3. Pipeline inventory

| File | What it does | Maps to |
|---|---|---|
| `install.sh` | sudo loop, clone/pull dotfiles repo, source 5 steps in order | Replaced wholesale by `mise bootstrap`; clone is a documented first-run step (not `[bootstrap.repos]` — circular, since the config lives in the repo) |
| `prerequisites.zsh` | xcode-select install + license; append `ZDOTDIR` to `/etc/zshenv` via sudo | **Split** (see §4.6): `/etc/zshenv` → `[bootstrap.files]` (declarative); xcode → guarded hook/task (interactive) |
| `packages.zsh` | Install Homebrew; `brew bundle --file=~/.config/Brewfile`; docker plugin wiring | `[bootstrap.packages]` for formulae/casks; tail remains a hook |
| `config.zsh` | `~/.gitconfig`, `~/icloud` symlinks; `~/.local/bin` script farm | `[dotfiles]` |
| `python.zsh` | `uv python install` 3.10–3.13 | uv task (see §2) |
| `apply-macos-defaults.zsh` | All `defaults write` + `killall` | `[bootstrap.macos.*]` + `post-defaults` hook |
| `Brewfile` | taps, formulae, casks, fonts, vscode/uv/npm deps | Split: formulae→`brew:`, casks→`brew-cask:`, rest→fallback `brew bundle` hook |

---

## 4. Migration mapping (line by line)

### 4.1 Homebrew formulae → `[bootstrap.packages]`

Every `brew "x"` in your Brewfile becomes `"brew:x" = "latest"`. The `brew` manager doesn't even require Homebrew to be present (mise's built-in installer handles it; one `sudo` to create `/opt/homebrew`). Version pins like `postgresql@17` map to `"brew:postgresql@17"`.

> ⏱️ Note: since you already have Homebrew and use `brew bundle` for the residue, simplest is keeping Homebrew installed and letting the `brew:` / `brew-cask:` managers use the real CLI.

### 4.2 Casks, taps, and the messy Brewfile residue

- **Plain casks** (`arc`, `alt-tab`, `discord`, …) → `"brew-cask:arc" = "latest"` etc.
- **Font casks** (`font-hack-nerd-font`, …) → `"brew-cask:font-hack-nerd-font" = "latest"` (also works on Linux for fonts).
- **Tap-tap formulae** (`agavra/tap/tuicr`, `anomalyco/tap/opencode`, `databricks/tap/databricks`, …) → `brew:`/`brew-cask:` gourmet handling is uncertain for third-party taps + `trusted:`. **Decision point** below.
- **`vscode "..."`**, **`uv "..."`**, **`npm "..."`** entries → **not** `[bootstrap.packages]`. They're VS Code extension installs, `uv tool` installs, and npm global installs respectively. mise has a `npm` backend for `[tools]` (`"npm:agent-browser"`), package-manager plugins for VS Code, and uv is *your* tool.

**Decision (recommended for v1):** keep the `Brewfile` and run `brew bundle --file=...` once in a `post-packages` hook that tolerates already-applied bundles (`brew bundle check` or just rely on bundle idempotence). Migrate formulae + core casks into mise declarativity at your own pace; leave the taps/vscode/uv/npm entries in the Brewfile. This gives you convergence for the bulk and keeps the messy tail working without re-implementing it.

### 4.3 `config.zsh` → `[dotfiles]`

| Current | Proposed `[dotfiles]` |
|---|---|
| `ln -sf ~/.config/.gitconfig ~/.gitconfig` | `"~/.gitconfig" = { mode = "symlink" }` (source resolved under `dotfiles.root`, or point at `~/.config/.gitconfig`) |
| `ln -sf "<CloudDocs>" ~/icloud` | `"~/icloud" = "<path to com~apple~CloudDocs dir>"` with `mode = "symlink"` (source outside the repo — fine, must be explicit) |
| script farm → `~/.local/bin` | `"~/.local/bin" = { source = "~/.config/scripts", mode = "symlink-each" }` — **the exact feature for this**: symlinks each script individually, dir can hold other stuff, tracks managed links in `$MISE_STATE_DIR/dotfiles` |
| `mkdir -p ~/.local/bin` | No longer needed (mise creates targets) |
| XDG exports | Not install concern — already in `~/.config/zsh/.zshenv` |

Everything under `~/.config` is **already** your dotfiles repo, so `[dotfiles]` only needs the *out-of-tree* links. Your `~/.config` tree itself stays as-is (git repo + zsh + nvim + …); you don't need to turn it into a `.dotfiles` bundle.

### 4.4 `apply-macos-defaults.zsh` → `[bootstrap.macos.*]`

Mostly a faithful translation. Probably 40 of your entries are covered by curated sections:

| Your default(s) | Friendly section |
|---|---|
| `com.apple.dock` autohide/tilesize/magnification/largesize/orientation | `[bootstrap.macos.dock]` → `autohide, tilesize, magnification, largesize, orientation` |
| `com.apple.finder` FXPreferredViewStyle=**Nlsv** (list) | `[bootstrap.macos.finder] preferred_view_style = "list"` |
| `NSGlobalDomain` KeyRepeat/InitialKeyRepeat/ApplePressAndHoldEnabled/keyboard.fnState | `[bootstrap.macos.keyboard] key_repeat, initial_key_repeat, press_and_hold, fn_state` |
| `com.apple.AppleMultitouchTrackpad`/Bluetooth trackpad Clicking → `true` | `[bootstrap.macos.trackpad] tap_to_click = true` |

Everything else (FlatFinder, WindowManager, screencapture, Magic Mouse, all other NSGlobalDomain, text-substitution array) goes into raw `[bootstrap.macos.defaults]` domain blocks. Value types map 1:1: TOML bool→`-bool`, int→`-int`, float→`-float`, string→`-string`.

### 4.5 The `bootstrap` task + hooks for the imperative tail

```toml
[tasks.bootstrap]          # runs LAST, after tools; runs EVERY time → keep idempotent
run = [
  # xcode — irreducible part of prerequisites (see §4.6-B)
  "test -d \"$(xcode-select -p 2>/dev/null || echo /no)\" || xcode-select --install",
  # /etc/zshenv ZDOTDIR now lives in [bootstrap.files] (see §4.6-A) — no task needed
  "uv python install 3.13 3.12 3.11 3.10 || true",          # ← THE PYTHON RULE (see §2)
  "brew bundle --file=~/.config/Brewfile || true",           # ← residue (see §4.2)
  "gh auth status || gh auth login",
]

[bootstrap.hooks.post-packages]
run = [
  "mkdir -p ~/.docker/cli-plugins && ln -sfn \"$(brew --prefix)/opt/docker-compose/bin/docker-compose\" ~/.docker/cli-plugins/docker-compose",
  "ln -sfn \"$(brew --prefix)/opt/docker-buildx/bin/docker-buildx\" ~/.docker/cli-plugins/docker-buildx || true",
]

[bootstrap.hooks.post-dotfiles]      # recreate their script-farm side effects that aren't dotfiles
run = "command -v bat && bat cache --build || true"

[bootstrap.hooks.post-defaults]
run = "killall Dock Finder WindowManager SystemUIServer 2>/dev/null || true"
```

> The `killall`s: mise **deliberately never kills apps**; it prints a "restart these apps" follow-up reminder. Your script does the killall — keep that as a `post-defaults` hook if you want the immediate effect, or drop it and rely on mise's reminder.

### 4.6 The `prerequisites` step — the queer one — split in two

`prerequisites.zsh` does two unrelated things. They get different fates:

**A) `/etc/zshenv` + `ZDOTDIR` — ✅ actually declarative now.**

Key discovery: `[bootstrap.files]` is **not** Linux-only and **does elevate**. It manages absolute paths "that may require root privileges": changes are attempted as the current user first, and on a permission error mise retries in **one privileged batch** (sudo). It compares content/type/mode/owner/group before applying, converges, and never touches the file when it already matches.

So the whole "append `export ZDOTDIR=...` to `/etc/zshenv`" hack becomes a declared, idempotent managed file:

```toml
[bootstrap.files."/etc/zshenv"]
content = '''
export ZDOTDIR="$HOME/.config/zsh"
'''
mode = "0644"          # explicit ownership is optional on macOS; defaults to current user
```

`mise bootstrap files apply --dry-run` shows you exactly what it would do, and `mise bootstrap files status` reports `set`/`differs`/`missing` like the other sections.

> ⚠️ **Honest caveat:** this is **whole-file ownership**. `content` replaces the file. `/etc/zshenv` is normally absent/empty on macOS (your script already treats it as "create or append"), so whole-file is safe *for you*. If you ever expect other software to write to `/etc/zshenv`, the conservative fallback is the classic guarded hook (grep-then-append) below instead.

**B) `xcode-select --install` + `xcodebuild -license accept` — ⚠️ irreducible.**

This genuinely cannot be declarative: it's a GUI popup + click-through, needs physical presence, takes minutes, and blocks. No mise section covers it. It stays a **guarded task/hook** (idempotent — only acts when `xcode-select -p` fails):

```sh
command -v git >/dev/null || xcode-select --install   # note: needs interaction anyway
test -d "$(xcode-select -p 2>/dev/null)" || xcode-select --install
sudo xcodebuild -license accept 2>/dev/null || true
```

Related bonus: since you're touching shell plumbing, `[bootstrap.user].login_shell = "/bin/zsh"` covers the `/etc/shells` + `chsh` side (it even appends the shell to `/etc/shells` when missing, with the same sudo path). Your machine already runs zsh, so it's a no-op — nice to declare anyway.

**Verdict for `prerequisites.zsh`:** one of its two jobs finally has a declarative home; the other stays automation-semi-queer forever because macOS makes it so.

---

## 5. Gap analysis — what does *not* map cleanly

| Thing | Why | Handling |
|---|---|---|
| `/etc/zshenv` ZDOTDIR | `[dotfiles]` has no sudo, but **`[bootstrap.files]` elevates** (whole-file) → see §4.6 | `[bootstrap.files."/etc/zshenv"]` with inline `content`; fallback = guarded `grep`-then-append hook |
| `xcode-select --install`, license | Interactive GUI popup + sudo; not declarable | Guarded hook/task (only runs when `xcode-select -p` fails) |
| `NSUserDictionaryReplacementItems` (text substitutions) | `[bootstrap.macos.defaults]` supports **only** bool/int/float/string — no arrays | Keep in a hook or bootstrap task as a raw `defaults write ... -array '...'` |
| `vscode ...`, `uv ...`, `npm ...` Brewfile entries | Not package-manager entries | Stay in Brewfile fallback (or `[tools] npm:...`, uv-tool task) |
| Third-party `tap`/`trusted:` formulae | mise `brew:`/`brew-cask:` support for non-core taps is unverified | Stay in Brewfile fallback for now |
| Docker Compose/Buildx plugin dir wiring | Imperative, condititional on install | `post-packages` hook |
| `~/icloud` symlink | Source is outside the dotfiles repo | Works, but must be explicit source; consider a hook if flaky |
| `killall`s | mise won't do it | `post-defaults` hook or ignore reminders |

---

## 6. Proposed target config (draft)

```toml
# ~/.config/mise/config.toml
[settings]
experimental = true
npm.package_manager = "bun"
# Your dotfiles LIVE in this repo (~/.config). You do NOT need a dotfiles.root
# bundle — [dotfiles] entries below use explicit `source = "~/.config/..."` so
# your layout stays exactly as-is. `[bootstrap.repos]` is only relevant for the
# "relocate to ~/.dotfiles + clone on fresh box" shape, which you don't want.

[tools]
bun = "latest"
"npm:@opencode-ai/cli" = { version = "beta", bun_args = "--trust" }
pnpm = "latest"
# 👇 deliberately NO python. uv owns Python. See §2.

[bootstrap.packages]
# ---- formulae (translated from Brewfile) ----
"brew:gettext" = "latest"
"brew:readline" = "latest"
"brew:bash" = "latest"
"brew:openssl@3" = "latest"
"brew:bat" = "latest"
"brew:colima" = "latest"
"brew:coreutils" = "latest"
"brew:curl" = "latest"
"brew:git" = "latest"
# ... (translate the rest of the Brewfile formulae) ...
"brew:uv" = "latest"

# ---- casks / fonts (translated from Brewfile) ----
"brew-cask:alt-tab" = "latest"
"brew-cask:arc" = "latest"
"brew-cask:font-hack-nerd-font" = "latest"
# ... rest ...

# ---- fresh-box clone of this repo (see §4.6-B; only needed once) ----
# Git clone the dotfiles repo before enclosing scratch; keep as a documented
# first-run step or a guarded pre- hook — do NOT declare it as [bootstrap.repos]
# since the config you are running IS inside that repo (circular).

# ---- the queer step, declarative half: /etc/zshenv (whole-file; see §4.6-A) ----
[bootstrap.files."/etc/zshenv"]
content = '''
export ZDOTDIR="$HOME/.config/zsh"
'''
mode = "0644"

[dotfiles]
"~/.gitconfig" = { source = "~/.config/.gitconfig", mode = "symlink" }
"~/icloud" = { source = "~/Library/Mobile Documents/com~apple~CloudDocs", mode = "symlink" }
"~/.local/bin" = { source = "~/.config/scripts", mode = "symlink-each" }

[bootstrap.macos.dock]
autohide = true
tilesize = 50
magnification = true
largesize = 70
orientation = "left"

[bootstrap.macos.finder]
preferred_view_style = "list"

[bootstrap.macos.keyboard]
key_repeat = 2
initial_key_repeat = 15
press_and_hold = false
fn_state = true

[bootstrap.macos.trackpad]
tap_to_click = true

[bootstrap.macos.defaults]
"com.apple.dock" = { "wvous-br-corner" = 14, "wvous-br-modifier" = 0 }
"NSGlobalDomain" = {
  AppleInterfaceStyle = "Dark",
  AppleKeyboardUIMode = 1,
  AppleMiniaturizeOnDoubleClick = false,
  _HIHideMenuBar = true,
  "com.apple.mouse.doubleClickThreshold" = 0.15,
  "com.apple.mouse.linear" = false,
  "com.apple.mouse.scaling" = 3,
  "com.apple.springing.delay" = 0.0,
  "com.apple.springing.enabled" = true,
  "com.apple.trackpad.forceClick" = true,
  "com.apple.trackpad.scaling" = 3,
  "com.apple.trackpad.scrolling" = true,
  # ... rest of the AppleMultitouchTrackpad / Magic Mouse / Finder entries ...
}
"com.apple.WindowManager" = {
  GloballyEnabled = true, AutoHide = true, ShowDesktopEnabled = false,
  StageManagerWidgetGrouping = 0, StandardShowDesktopMode = 0,
}
"com.apple.screencapture" = { location = "$HOME/Desktop", "disable-shadow" = true }

# --- imperative tail (see §4.5 / §5) ---
[bootstrap.hooks.post-packages]
run = ["…docker plugin wiring…"]

[bootstrap.hooks.post-dotfiles]
run = "command -v bat && bat cache --build || true"

[bootstrap.hooks.post-defaults]
run = "killall Dock Finder WindowManager SystemUIServer 2>/dev/null || true"

[tasks.bootstrap]
run = [
  # xcode — the irreducible part of prerequisites (see §4.6-B)
  "test -d \"$(xcode-select -p 2>/dev/null || echo /no)\" || xcode-select --install",
  "uv python install 3.13 3.12 3.11 3.10 || true",   # uv-owned, per your constraint
  "brew bundle --file=~/.config/Brewfile || true",     # residue (taps/vscode/uv/npm)
  "gh auth status || gh auth login",
]
```

---

## 7. Suggested adoption sequence (incremental, low-risk)

1. **Phase 0 — nothing moves.** `mise trust` the repo; run `mise bootstrap --dry-run` (should be near-no-op on your config today) and play with `status`/`plan`. Learn the verbs.
2. **Phase 1 — dotfiles.** Add the three `[dotfiles]` entries only. `mise bootstrap dotfiles apply --dry-run`, then apply. Lowest risk, immediately reversible with `unapply`.
3. **Phase 2 — macOS defaults.** Add `[bootstrap.macos.*]` sections. `mise bootstrap macos defaults status --missing` to see drift before applying. Skip the 2–3 unmappable entries (keep them in a `post-defaults` hook).
4. **Phase 3 — packages.** Add `[bootstrap.packages]` for formulae + core casks; keep `brew bundle` fallback for the rest. Use `mise bootstrap packages import --manager brew` to seed the list from your installed formulae, then curate.
5. **Phase 4 — collapse the pipeline.** Replace `install.sh` + `install/*.zsh` with the hooks/task above; retire the files; run full `mise bootstrap --yes` on a scratch/user to verify.

**Guardrail at every phase:** `mise bootstrap --dry-run` and `status --missing`. Nothing is ever written without a confirmation/`--yes`.

---

## 8. Risks & footguns already spotted

- **Feature is new** (bulk landed mid-2026; you're on 2026.8.9). Expect minor CLI churn — the top-level `mise dotfiles` command is already deprecated in favor of `mise bootstrap dotfiles`.
- **Destructive by design** — `--force-dotfiles` overwrites conflicting whole-file targets; read diffs before using it. Default is refuse, not replace.
- **Curated macOS sections ≤ raw defaults**: friendly keys compile to raw `(domain, key)`; you can still write raw for the rest.
- **No array/dict values** in `[bootstrap.macos.defaults]` — your text-substitution array is the notable casualty.
- **`[dotfiles]` has no sudo** — that's why `/etc/zshenv` uses `[bootstrap.files]` instead (which does elevate). But `[bootstrap.files]` is whole-file: declaring `/etc/zshenv` content means mise owns that file and would overwrite anything else in it.
- **`brew:`/`brew-cask:` third-party tap support unverified** — keep those in `brew bundle` until proven.
- **Python rule is a hard constraint:** mise must never declare `python` in `[tools]`. If anyone adds it later, `UV_PYTHON`-style confusion returns.

---

## Appendix — macOS defaults translation cheat-sheet

| Curated section | Maps to |
|---|---|
| `dock.autohide` | `com.apple.dock.autohide` |
| `dock.orientation` (= bottom/left/right) | `com.apple.dock.orientation` |
| `dock.tilesize` / `magnification` / `largesize` | `com.apple.dock.*` |
| `finder.preferred_view_style` (= icon/list/column/gallery) | `com.apple.finder.FXPreferredViewStyle` (note: your **Nlsv → `list`**) |
| `keyboard.key_repeat` / `initial_key_repeat` | `NSGlobalDomain.KeyRepeat` / `InitialKeyRepeat` |
| `keyboard.press_and_hold` / `fn_state` | `NSGlobalDomain.ApplePressAndHoldEnabled` / `com.apple.keyboard.fnState` |
| `trackpad.tap_to_click` | both trackpad `Clicking` keys |
| `trackpad.three_finger_drag` | both trackpad `TrackpadThreeFingerDrag` keys |
| Raw | `defaults write` `-bool/-int/-float/-string` only |