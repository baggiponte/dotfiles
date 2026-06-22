#!/usr/bin/env zsh

set -euo pipefail

print "📍 requesting admin privileges..."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

script_dir="$(cd "$(dirname "$0")" && pwd)"

# +----------------+
# | clone dotfiles |
# +----------------+
# This must run first so the install/ modules are available.

if ! [[ -d "$HOME/.config" ]]; then
	git clone "https://github.com/baggiponte/dotfiles" "$HOME/.config"
elif ! [[ -d "$HOME/.config/.git" ]]; then
	print "⚠️ '$HOME/.config' exists but is not a git repository."
	print "   Remove it manually and re-run."
	exit 1
elif [[ "$script_dir" != "$HOME/.config"* ]]; then
	print "📍 pulling latest dotfiles..."
	git -C "$HOME/.config" pull --ff-only
fi

# +------------------+
# | source install/  |
# +------------------+

install_dir="$HOME/.config/install"

steps=(
	prerequisites
	packages
	config
	python
	apply-macos-defaults
)

for step in "${steps[@]}"; do
	source "$install_dir/${step}.zsh"
done
