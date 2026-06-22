#!/usr/bin/env zsh

set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"

# +----------------+
# | clone dotfiles |
# +----------------+
# This must run first so the install/ modules are available.

if ! [[ -d "$HOME/.config" ]]; then
	git clone "https://github.com/baggiponte/dotfiles" "$HOME/.config"
else
	read -r -p "⚠️ '$HOME/.config' already exists. Replace dotfiles? [y/N] " response
	if [[ "$response" =~ ^[Yy](es)?$ ]]; then

		if [[ "$script_dir" == "$HOME/.config"* ]]; then
			print "🚨 Cannot replace dotfiles while running from \$HOME/.config."
			print "   Run this script from outside \$HOME/.config first."
			exit 1
		fi

		mv "$HOME/.config" "$HOME/.config.bak"
		print "✔︎ moved old configs to '$HOME/.config.bak'"

		git clone "https://github.com/baggiponte/dotfiles" "$HOME/.config"
	else
		print "⚠️ did not clone dotfiles: this script might fail if a binary is not found"
	fi
fi

# +------------------+
# | source install/  |
# +------------------+

install_dir="$HOME/.config/install"

modules=(
	xcode
	zdotdir
	brew
	xdg
	symlinks
	dependencies
	python
	apply-ui-defaults
)

for m in "${modules[@]}"; do
	source "$install_dir/${m}.zsh"
done
