#!/usr/bin/env bash
# Headless startup benchmarks: `nvim -u NONE` vs one or more configs, selected by NVIM_APPNAME.
# Usage: scripts/bench.sh [NVIM_APPNAME...]   (default: nvim)
set -euo pipefail
apps=("${@:-nvim}")
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
printf 'import os\n\n\ndef f(x):\n    return x\n' >"$tmp/t.py"

startup=(-n 'clean (-u NONE)' 'timeout 10 nvim --headless -u NONE +qa')
open_file=(-n 'clean (-u NONE)' "timeout 10 nvim --headless -u NONE $tmp/t.py +qa")
for app in "${apps[@]}"; do
  startup+=(-n "$app" "timeout 10 env NVIM_APPNAME=$app nvim --headless +qa")
  open_file+=(-n "$app" "timeout 10 env NVIM_APPNAME=$app nvim --headless $tmp/t.py +qa")
done

hyperfine -N --warmup 5 --min-runs 40 "${startup[@]}"
hyperfine -N --warmup 5 --min-runs 40 "${open_file[@]}"
