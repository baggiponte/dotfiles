#!/usr/bin/env bash
# Startup benchmarks: lazy.nvim config (NVIM_APPNAME=nvim) vs vim.pack (NVIM_APPNAME=nvim-pack).
# Usage: scripts/bench.sh [tui]   (pass `tui` to skip the headless runs)
set -euo pipefail
tmp=$(mktemp -d)
trap 'tmux -L bench kill-server 2>/dev/null || true; rm -rf "$tmp"' EXIT
printf 'import os\n\n\ndef f(x):\n    return x\n' >"$tmp/t.py"
: >"$tmp/tmux.conf" # empty tmux config: no plugins (e.g. session restore) on server start
F=$tmp/t.py

# Run nvim inside a detached tmux session: a real terminal that answers the
# TUI's startup queries. `timeout --foreground` so a hung nvim gets killed.
tui() {
  echo "tmux -L bench -f $tmp/tmux.conf new-session -d -x 200 -y 50 \"timeout --foreground 10 env NVIM_APPNAME=$1 nvim $2; tmux -L bench wait-for -S done\" \; wait-for done"
}
# Quit right after lazy.nvim's VeryLazy / our very_lazy() callbacks ran.
VL="-c 'autocmd UIEnter * ++once lua vim.schedule(function() vim.schedule(function() vim.cmd([[qa!]]) end) end)'"

if [[ "${1:-}" != tui ]]; then
  hyperfine -N --warmup 5 --min-runs 40 \
    -n 'clean (-u NONE)' 'timeout 10 nvim --headless -u NONE +qa' \
    -n 'lazy.nvim' 'timeout 10 env NVIM_APPNAME=nvim nvim --headless +qa' \
    -n 'vim.pack' 'timeout 10 env NVIM_APPNAME=nvim-pack nvim --headless +qa'
  hyperfine -N --warmup 5 --min-runs 40 \
    -n 'lazy.nvim' "timeout 10 env NVIM_APPNAME=nvim nvim --headless $F +qa" \
    -n 'vim.pack' "timeout 10 env NVIM_APPNAME=nvim-pack nvim --headless $F +qa"
fi
hyperfine --warmup 5 --min-runs 40 \
  -n 'clean (-u NONE)' "$(tui nvim '-u NONE +qa')" \
  -n 'lazy.nvim' "$(tui nvim '+qa')" \
  -n 'vim.pack' "$(tui nvim-pack '+qa')"
hyperfine --warmup 5 --min-runs 40 \
  -n 'lazy.nvim' "$(tui nvim "$F $VL")" \
  -n 'vim.pack' "$(tui nvim-pack "$F $VL")"
