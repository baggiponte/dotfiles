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
| Homebrew formulae (core) | Migrate to `[bootstrap.packages]` as `brew:` (incl. `@17`-style pins) — **validated working** |
| Homebrew casks incl. fonts | **Do NOT migrate for v1.** Validated: casks already owned by Homebrew are *refused* by `brew-cask:` (adoption fails on 2026.8.9), and cask-fonts-tap fonts error out. **All casks/fonts stay in `brew bundle`** |
| Taps, `trusted:`, VS Code ext, `uv` tools, npm deps in Brewfile | **Not covered by `[bootstrap.packages]`** — keep `brew bundle` as one fallback hook, or use package plugins/`[tools]` for the subsets you want |
| Dotfiles symlinks (`~/.gitconfig`, `~/icloud`, `~/.local/bin` script farm) | Migrate to `[dotfiles]` (incl. `symlink-each`, the perfect fit for the script farm) — **validated: all already applied** |
| macOS defaults | Migrate to `[bootstrap.macos.*]`, ~1:1 for scalars; **strictly typed** (ints vs floats!) and **no `$HOME` expansion, no arrays** (see §5) — **validated: 33/33 converge after float fixes** |
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

### 4.2 Casks, taps, and the messy Brewfile residue — **validated constraints**

**⚠️ 2026-08-20 validation changed this section.** On mise 2026.8.9, dry-runs against this machine (transcripts in `mise-bootstrap-validation.log` §7) show:

- **Casks owned by real Homebrew cannot be migrated.** `brew-cask:alt-tab`/`arc` fail with *"Homebrew owns this cask; remove it with Homebrew before installing it with mise"* — even with the documented `{ version = "latest", adopt = true }` table form. Adoption is **not functional** for Homebrew-owned casks in this version.
- **Font casks from `homebrew/cask-fonts` are unusable.** `brew-cask:font-hack-nerd-font` fails with *"Tapped casks must publish API metadata at api/cask/<token>.json"* plus a JSON parse error.

**Consequence:** all casks and fonts **stay in `brew bundle`** for v1. Don't put them in `[bootstrap.packages]`.

Remaining entries and their fates:

- **Tap-tapped formulae** (`agavra/tap/tuicr`, `anomalyco/tap/opencode`, `databricks/tap/databricks`, …) → `brew:` handling of third-party taps is unverified; keep in `brew bundle`.
- **`vscode "..."`**, **`uv "..."`**, **`npm "..."`** entries → **not** `[bootstrap.packages]`. They're VS Code extension installs, `uv tool` installs, and npm global installs respectively. mise has an `npm` backend for `[tools]` (`"npm:agent-browser"`), package plugins for VS Code, and uv is *your* tool (see §2).

**Decision (validated for v1):** keep the `Brewfile` and run `brew bundle --file=...` in a `post-packages` hook. Migrate **only core formulae** into mise declarativity (`mise bootstrap packages import --manager brew` seeds the list). The fallback hook must *surface* failures rather than swallow them (`|| true` discouraged — see §5).

### 4.3 `config.zsh` → `[dotfiles]`

| Current | Proposed `[dotfiles]` |
|---|---|
| `ln -sf ~/.config/.gitconfig ~/.gitconfig` | `"~/.gitconfig" = { source = "~/.config/.gitconfig", mode = "symlink" }` — explicit source, no `dotfiles.root` needed |
| `ln -sf "<CloudDocs>" ~/icloud` | `"~/icloud" = "<path to com~apple~CloudDocs dir>"` with `mode = "symlink"` (source outside the repo — fine, must be explicit) |
| script farm → `~/.local/bin` | `"~/.local/bin" = { source = "~/.config/scripts", mode = "symlink-each" }` — **the exact feature for this**: symlinks each script individually, dir can hold other stuff, tracks managed links in `$MISE_STATE_DIR/dotfiles` |
| `mkdir -p ~/.local/bin` | No longer needed (mise creates targets) |
| XDG exports | Not install concern — already in `~/.config/zsh/.zshenv` |

Everything under `~/.config` is **already** your dotfiles repo, so `[dotfiles]` only needs the *out-of-tree* links. Your `~/.config` tree itself stays as-is (git repo + zsh + nvim + …); you don't need to turn it into a `.dotfiles` bundle.

### 4.4 `apply-macos-defaults.zsh` → `[bootstrap.macos.*]`

Mostly a faithful translation, with three traps found in validation (§5): values are **strictly typed** (float stays float), strings are written **literally** (no `$HOME` expansion), and **arrays are unsupported**. Curated sections cover a chunk:

| Your default(s) | Friendly section |
|---|---|
| `com.apple.dock` autohide/tilesize/magnification/largesize/orientation | `[bootstrap.macos.dock]` → `autohide, tilesize, magnification, largesize, orientation` |
| `com.apple.finder` FXPreferredViewStyle=**Nlsv** (list) | `[bootstrap.macos.finder] preferred_view_style = "list"` |
| `NSGlobalDomain` KeyRepeat/InitialKeyRepeat/ApplePressAndHoldEnabled/keyboard.fnState | `[bootstrap.macos.keyboard] key_repeat, initial_key_repeat, press_and_hold, fn_state` |
| `com.apple.AppleMultitouchTrackpad`/Bluetooth trackpad Clicking → `true` | `[bootstrap.macos.trackpad] tap_to_click = true` |

Everything else goes into raw `[bootstrap.macos.defaults]` — **one block per domain** (this matters: don't stuff trackpad/mouse/finder keys into `NSGlobalDomain`). Value types map 1:1: TOML bool→`-bool`, int→`-int`, float→`-float`, string→`-string`.

**Completion checklist — every line in `apply-macos-defaults.zsh`, classified:**

| Source line(s) | Domain / keys | Fate |
|---|---|---|
| `com.apple.dock` autohide, tilesize, magnification, largesize, orientation | `[bootstrap.macos.dock]` | curated |
| `com.apple.dock` wvous-br-corner/-modifier | `[bootstrap.macos.defaults]` `"com.apple.dock"` | raw ints |
| `NSGlobalDomain` AppleInterfaceStyle, AppleKeyboardUIMode, Miniaturize, PressAndHold (curated), _HIHideMenuBar, InitialKeyRepeat & KeyRepeat (curated), keyboard.fnState (curated) | `[bootstrap.macos.keyboard]` + `[bootstrap.macos.defaults]` `"NSGlobalDomain"` | curated + raw |
| `NSGlobalDomain` mouse.doubleClickThreshold (float), mouse.linear, mouse.scaling (**float**), springing.delay (**float**), springing.enabled, trackpad.forceClick, trackpad.scaling (**float**), trackpad.scrolling | `[bootstrap.macos.defaults]` `"NSGlobalDomain"` | raw — **use `3.0`, not `3`** |
| `com.apple.AppleMultitouchTrackpad` all keys (Clicking curated; ActuateDetents, thresholds, gestures…) | `[bootstrap.macos.defaults]` `"com.apple.AppleMultitouchTrackpad"` | raw |
| `com.apple.driver.AppleBluetoothMultitouch.mouse` all keys (Magic Mouse) | `[bootstrap.macos.defaults]` `"com.apple.driver.AppleBluetoothMultitouch.mouse"` | raw |
| `com.apple.finder` FXPreferredViewStyle (curated) + external/hard/removable drives, sidebar keys, SidebarWidth | `[bootstrap.macos.finder]` + `[bootstrap.macos.defaults]` `"com.apple.finder"` | curated + raw |
| `NSGlobalDomain` NSAutomaticCapitalizationEnabled, NSAutomaticPeriodSubstitutionEnabled | `[bootstrap.macos.defaults]` `"NSGlobalDomain"` | raw |
| `NSUserDictionaryReplacementItems` (array of dicts) | **not representable** | keep as raw `defaults write ... -array '…'` in `post-defaults` hook |
| `com.apple.WindowManager` 5 keys (Stage Manager) | `[bootstrap.macos.defaults]` `"com.apple.WindowManager"` | raw |
| `com.apple.screencapture` location (**resolved path**, not `$HOME`), disable-shadow | `[bootstrap.macos.defaults]` `"com.apple.screencapture"` | raw — **no `$HOME` expansion** |

### 4.5 The `bootstrap` task + hooks for the imperative tail

```toml
[tasks.bootstrap]          # runs LAST, after tools; runs EVERY time → keep idempotent
run = [
  # Xcode — faithful to prerequisites.zsh: wait for CLT to finish, then accept
  # license. Blocks (GUI) on a fresh machine — irreducible, see §4.6-B.
  "if ! xcode-select -p >/dev/null 2>&1; then xcode-select --install; until xcode-select -p >/dev/null 2>&1; do sleep 10; done; sudo xcodebuild -license accept; fi",
  # /etc/zshenv ZDOTDIR now lives in [bootstrap.files] (see §4.6-A) — no task needed
  "uv python install 3.13 3.12 3.11 3.10 || true",          # ← THE PYTHON RULE (see §2)
  # Fallback for the Brewfile residue (taps/casks/fonts/vscode/uv/npm). Surface
  # failures — write a log and warn instead of `|| true` (see §5).
  "brew bundle --file=~/.config/Brewfile >/tmp/brew-bundle.log 2>&1 || { echo '⚠️ brew bundle failed — see /tmp/brew-bundle.log'; false; }",
  # NOTE: `gh auth` was NOT in the original pipeline; opt in as a manual step,
  # don't bake it into bootstrap (see §5).
]

[bootstrap.hooks.post-packages]
run = [
  # Docker CLI plugin wiring (+ the ~/.docker/config.json from packages.zsh)
  "mkdir -p ~/.docker/cli-plugins",
  "ln -sfn \"$(brew --prefix)/opt/docker-compose/bin/docker-compose\" ~/.docker/cli-plugins/docker-compose",
  # FIX (from review): source script points buildx at docker-compose's bin
  # (likely a typo). Use docker-buildx's own keg.
  "ln -sfn \"$(brew --prefix)/opt/docker-buildx/bin/docker-buildx\" ~/.docker/cli-plugins/docker-buildx",
  "printf '{\\n  \"cliPluginsExtraDirs\": [\\n    \"'\"$(brew --prefix)\"'/lib/docker/cli-plugins\"\\n  ]\\n}\\n' > ~/.docker/config.json",
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
mode = "0644"          # owner/group intentionally unmanaged: file is root:wheel 0644
                       # and `mise bootstrap files status` reports it unchanged (no chown/write)
```

`mise bootstrap files apply --dry-run` shows you exactly what it would do, and `mise bootstrap files status` reports `set`/`differs`/`missing` like the other sections.

> ⚠️ **Honest caveat:** this is **whole-file ownership**. `content` replaces the file. `/etc/zshenv` is normally absent/empty on macOS (your script already treats it as "create or append"), so whole-file is safe *for you*. If you ever expect other software to write to `/etc/zshenv`, the conservative fallback is the classic guarded hook (grep-then-append) below instead.

**B) `xcode-select --install` + `xcodebuild -license accept` — ⚠️ irreducible.**

This genuinely cannot be declarative: it's a GUI popup + click-through, needs physical presence, takes minutes, and blocks. No mise section covers it. Keep it **faithful to `prerequisites.zsh`** — including the wait loop and license (reviewer fix: a bare `xcode-select --install` without waiting lets later steps race CLT install and skips licensing):

```sh
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install                  # GUI popup, needs human
  until xcode-select -p >/dev/null 2>&1; do
    sleep 10
  done
  sudo xcodebuild -license accept
fi
```

Related bonus: since you're touching shell plumbing, `[bootstrap.user].login_shell = "/bin/zsh"` covers the `/etc/shells` + `chsh` side (it even appends the shell to `/etc/shells` when missing, with the same sudo path). Your machine already runs zsh, so it's a no-op — nice to declare anyway.

**Verdict for `prerequisites.zsh`:** one of its two jobs finally has a declarative home; the other stays automation-semi-queer forever because macOS makes it so.

---

## 5. Gap analysis — what does *not* map cleanly

| Thing | Why | Handling |
|---|---|---|
| `/etc/zshenv` ZDOTDIR | `[dotfiles]` has no sudo, but **`[bootstrap.files]` elevates** (whole-file) → see §4.6 | `[bootstrap.files."/etc/zshenv"]` with inline `content`; fallback = guarded `grep`-then-append hook |
| `xcode-select --install`, license | Interactive GUI popup + sudo; not declarable | Guarded task with wait loop + `xcodebuild -license accept` (faithful to `prerequisites.zsh`) |
| **Homebrew-owned casks** | `brew-cask:` *refuses* them on 2026.8.9 — "Homebrew owns this cask" even with `{ version, adopt = true }` (**validated**) | Stay in `brew bundle`; migration would require `brew uninstall --cask …` first |
| **cask-fonts-tap fonts** | `brew-cask:` can't fetch tap API metadata + JSON parse error (**validated**) | Stay in `brew bundle` |
| `NSUserDictionaryReplacementItems` (text substitutions) | `[bootstrap.macos.defaults]` supports **only** bool/int/float/string — no arrays | Keep in a `post-defaults` hook as raw `defaults write ... -array '...'` |
| `vscode ...`, `uv ...`, `npm ...` Brewfile entries | Not package-manager entries | Stay in Brewfile fallback (or `[tools] npm:...`, uv-tool task) |
| Third-party `tap`/`trusted:` formulae | mise `brew:` support for non-core taps is unverified | Stay in Brewfile fallback for now |
| `brew bundle` failures | Silently ignoring (`|| true`) hides a partially bootstrapped machine | Log to `/tmp/brew-bundle.log` and fail loudly in the task |
| `gh auth` | **Was not in the original pipeline** — do not invent interactive steps | Optional manual post-bootstrap step only |
| Docker Compose/Buildx plugins + `~/.docker/config.json` | Imperative, conditional on install | `post-packages` hook; also **fix** the buildx symlink path (source script points it at docker-compose's bin — likely a typo) |
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
# ---- formulae ONLY (translated from Brewfile). ----
# Validated: casks/fonts/taps CANNOT migrate (see §4.2) — they stay in Brewfile,
# handled by the `brew bundle` step in [tasks.bootstrap].
"brew:gettext" = "latest"
"brew:readline" = "latest"
"brew:bash" = "latest"
"brew:openssl@3" = "latest"
"brew:bat" = "latest"
"brew:colima" = "latest"
"brew:coreutils" = "latest"
"brew:curl" = "latest"
"brew:git" = "latest"
# ... (translate the rest of the Brewfile formulae; seed via `mise bootstrap
# packages import --manager brew`) ...
"brew:uv" = "latest"

# ---- fresh-box clone of this repo (see §4.6-B; only needed once) ----
# Git clone the dotfiles repo before running bootstrap; keep as a documented
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

# One block per domain — nothing stuffed into NSGlobalDomain that isn't global.
[bootstrap.macos.defaults]
"com.apple.dock" = { "wvous-br-corner" = 14, "wvous-br-modifier" = 0 }
"NSGlobalDomain" = {
  AppleInterfaceStyle = "Dark",
  AppleKeyboardUIMode = 1,
  AppleMiniaturizeOnDoubleClick = false,
  _HIHideMenuBar = true,
  "com.apple.mouse.doubleClickThreshold" = 0.15,
  "com.apple.mouse.linear" = false,
  "com.apple.mouse.scaling" = 3.0,        # float! `3` would drift forever
  "com.apple.springing.delay" = 0.0,
  "com.apple.springing.enabled" = true,
  "com.apple.trackpad.forceClick" = true,
  "com.apple.trackpad.scaling" = 3.0,     # float!
  "com.apple.trackpad.scrolling" = true,
  NSAutomaticCapitalizationEnabled = true,
  NSAutomaticPeriodSubstitutionEnabled = true,
}
"com.apple.AppleMultitouchTrackpad" = {
  ActuateDetents = true, Clicking = true, DragLock = false, Dragging = false,
  FirstClickThreshold = 1, ForceSuppressed = false, SecondClickThreshold = 1,
  TrackpadCornerSecondaryClick = 0, TrackpadFiveFingerPinchGesture = 2,
  TrackpadFourFingerHorizSwipeGesture = 2, TrackpadFourFingerPinchGesture = 2,
  TrackpadFourFingerVertSwipeGesture = 2, TrackpadHandResting = true,
  TrackpadHorizScroll = true, TrackpadMomentumScroll = true, TrackpadPinch = true,
  TrackpadRightClick = true, TrackpadRotate = true, TrackpadScroll = true,
  TrackpadThreeFingerDrag = false, TrackpadThreeFingerHorizSwipeGesture = 2,
  TrackpadThreeFingerTapGesture = 0, TrackpadThreeFingerVertSwipeGesture = 2,
  TrackpadTwoFingerDoubleTapGesture = 1, TrackpadTwoFingerFromRightEdgeSwipeGesture = 3,
  USBMouseStopsTrackpad = false, UserPreferences = true,
}
"com.apple.driver.AppleBluetoothMultitouch.mouse" = {
  MouseButtonDivision = 55, MouseButtonMode = "OneButton", MouseHorizontalScroll = true,
  MouseMomentumScroll = true, MouseOneFingerDoubleTapGesture = 0,
  MouseTwoFingerDoubleTapGesture = 3, MouseTwoFingerHorizSwipeGesture = 2,
  MouseVerticalScroll = true, UserPreferences = true,
}
"com.apple.finder" = {
  ShowExternalHardDrivesOnDesktop = true, ShowHardDrivesOnDesktop = false,
  ShowRemovableMediaOnDesktop = true, ShowSidebar = true,
  SidebarDevicesSectionDisclosedState = true, SidebarPlacesSectionDisclosedState = true,
  SidebarShowingiCloudDesktop = false, SidebariCloudDriveSectionDisclosedState = true,
  SidebarWidth = 148,
}
"com.apple.WindowManager" = {
  GloballyEnabled = true, AutoHide = true, ShowDesktopEnabled = false,
  StageManagerWidgetGrouping = 0, StandardShowDesktopMode = 0,
}
# No $HOME expansion in defaults strings — use the resolved path (see §5).
"com.apple.screencapture" = { location = "/Users/baggiponte/Desktop", "disable-shadow" = true }

# --- imperative tail (see §4.5 / §5) ---
[bootstrap.hooks.post-packages]
run = [
  "mkdir -p ~/.docker/cli-plugins",
  "ln -sfn \"$(brew --prefix)/opt/docker-compose/bin/docker-compose\" ~/.docker/cli-plugins/docker-compose",
  "ln -sfn \"$(brew --prefix)/opt/docker-buildx/bin/docker-buildx\" ~/.docker/cli-plugins/docker-buildx",
  "printf '{\\n  \"cliPluginsExtraDirs\": [\\n    \"'\"$(brew --prefix)\"'/lib/docker/cli-plugins\"\\n  ]\\n}\\n' > ~/.docker/config.json",
]

[bootstrap.hooks.post-dotfiles]
run = "command -v bat && bat cache --build || true"

[bootstrap.hooks.post-defaults]
run = "killall Dock Finder WindowManager SystemUIServer 2>/dev/null || true"

[tasks.bootstrap]
run = [
  # xcode — faithful wait-loop + license (see §4.6-B)
  "if ! xcode-select -p >/dev/null 2>&1; then xcode-select --install; until xcode-select -p >/dev/null 2>&1; do sleep 10; done; sudo xcodebuild -license accept; fi",
  "uv python install 3.13 3.12 3.11 3.10 || true",   # uv-owned, per your constraint
  # residue: taps/casks/fonts/vscode/uv/npm — log + fail loudly, don't hide
  "brew bundle --file=~/.config/Brewfile >/tmp/brew-bundle.log 2>&1 || { echo '⚠️ brew bundle failed — see /tmp/brew-bundle.log'; false; }",
  # NOTE: no `gh auth` — not part of the original pipeline (optional, manual)
]
```

---

## 7. Suggested adoption sequence (incremental, low-risk)

1. **Phase 0 — nothing moves.** `mise trust` the repo; run `mise bootstrap --dry-run` (should be near-no-op on your config today) and play with `status`/`plan`. Learn the verbs.
2. **Phase 1 — dotfiles.** Add the three `[dotfiles]` entries only. `mise bootstrap dotfiles apply --dry-run`, then apply. Lowest risk, immediately reversible with `unapply`. ✅ already validated.
3. **Phase 2 — macOS defaults.** Add `[bootstrap.macos.*]` per the §4.4 checklist (one TOML block per domain). `status --missing` before applying. Only the text-substitution **array** is unmappable — keep it in a `post-defaults` hook. Watch the strictly-typed floats and the resolved screencapture path.
4. **Phase 3 — packages.** Add `[bootstrap.packages]` **for core formulae only**; casks/taps/fonts/vscode/uv/npm stay in `brew bundle`. Seed with `mise bootstrap packages import --manager brew`, then curate.
5. **Phase 4 — collapse the pipeline.** Replace `install.sh` + `install/*.zsh` with the hooks/task above (incl. the faithful xcode wait-loop); retire the files; run full `mise bootstrap --yes` on a scratch/user to verify.

**Guardrail at every phase:** `mise bootstrap --dry-run` and `status --missing`. Nothing is ever written without a confirmation/`--yes`.

---

## 8. Risks & footguns already spotted

- **Feature is new** (bulk landed mid-2026; you're on 2026.8.9). Expect minor CLI churn — the top-level `mise dotfiles` command is already deprecated in favor of `mise bootstrap dotfiles`.
- **Destructive by design** — `--force-dotfiles` overwrites conflicting whole-file targets; read diffs before using it. Default is refuse, not replace.
- **Curated macOS sections ≤ raw defaults**: friendly keys compile to raw `(domain, key)`; you can still write raw for the rest.
- **`brew-cask:` on 2026.8.9 is a dead end for this machine** — Homebrew-owned casks are refused (adopt not honored) and tap-fonts fail. Migrating casks later = `brew uninstall --cask` first, or wait for a fixed release.
- **No array/dict values** in `[bootstrap.macos.defaults]` — your text-substitution array is the notable casualty (stays a hook).
- **Strictly typed + no `$HOME` expansion** in defaults — `3` ≠ `3.0`, `$HOME/Desktop` ≠ `/Users/<you>/Desktop`.
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