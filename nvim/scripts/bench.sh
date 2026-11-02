#!/usr/bin/env bash
# Startup benchmarks: `nvim -u NONE` vs one or more configs, selected by NVIM_APPNAME.
# Usage: scripts/bench.sh [NVIM_APPNAME...]   (default: nvim)
set -euo pipefail
apps=("${@:-nvim}")
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
# Quit right after the very_lazy() callbacks ran.
VL="-c 'autocmd UIEnter * ++once lua vim.schedule(function() vim.schedule(function() vim.cmd([[qa!]]) end) end)'"

headless=(-n 'clean (-u NONE)' 'timeout 10 nvim --headless -u NONE +qa')
headless_file=()
tui_plain=(-n 'clean (-u NONE)' "$(tui nvim '-u NONE +qa')")
tui_file=()
for app in "${apps[@]}"; do
  headless+=(-n "$app" "timeout 10 env NVIM_APPNAME=$app nvim --headless +qa")
  headless_file+=(-n "$app" "timeout 10 env NVIM_APPNAME=$app nvim --headless $F +qa")
  tui_plain+=(-n "$app" "$(tui "$app" '+qa')")
  tui_file+=(-n "$app" "$(tui "$app" "$F $VL")")
done

hyperfine -N --warmup 5 --min-runs 40 "${headless[@]}"
hyperfine -N --warmup 5 --min-runs 40 "${headless_file[@]}"
hyperfine --warmup 5 --min-runs 40 "${tui_plain[@]}"
hyperfine --warmup 5 --min-runs 40 "${tui_file[@]}"
