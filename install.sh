#!/usr/bin/env zsh

# +---------------------+
# | install xcode tools |
# +---------------------+

print "📍 checking xcode tools are installed..."

if ! xcode-select --print-path &>/dev/null; then

	print "🏗️ installing xcode command line tools..."
	xcode-select --install &>/dev/null

	# Wait until the XCode Command Line Tools are installed
	until xcode-select --print-path &>/dev/null; do
		sleep 10
	done

	print "✔︎ xcode command line tools installed!"

	print "⚠️ Agree with the xcode command line tools licence:"
	sudo xcodebuild -license
fi

# +-------------------+
# | configure ZDOTDIR |
# +-------------------+

# Set the desired configuration line
zdotdir_line='export ZDOTDIR="$HOME/.config/zsh"'

# Check if /etc/zshenv exists
if [[ -f "/etc/zshenv" ]]; then
	if ! grep -qF "$zdotdir_line" "/etc/zshenv"; then
		print "$zdotdir_line" | sudo tee -a "/etc/zshenv" >/dev/null
		print "✔︎ appended '$zdotdir_line' to '/etc/zshenv/'"
	fi
else
	print "$zdotdir_line" | sudo tee "/etc/zshenv" >/dev/null
	print "✔︎ created '/etc/zshenv' and appended the '$zdotdir_line' line."
fi

# +--------------+
# | install brew |
# +--------------+

print "📍 Checking homebrew is installed..."
local brew_bin
brew_bin=$(which brew) 2>&1 >/dev/null

if [[ $? != 0 ]]; then
	print "🏗️ installing homebrew..."

	# has to run in bash
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	if [[ $? != 0 ]]; then
		print "🚨 unable to install homebrew, script $0 abort!"
		exit 2
	fi

    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# +--------------+
# | set XDG dirs |
# +--------------+

# see https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# +----------------+
# | clone dotfiles |
# +----------------+

if ! [[ -d ~/.config ]]; then
	git clone https://github.com/baggiponte/dotfiles ~/.config
else
	read -r -p "⚠️ '~/.config' already exists. Replace dotfiles? (contents of '~/.config' will not be deleted) [y/N]" response
	if [[ $response =~ (y|yes|Y) ]]; then

		mv ~/.config ~/.config.bak
		print "✔︎ moved old configs to '~/.config.bak'"

		git clone https://github.com/baggiponte/dotfiles ~/.config
	else
		print "⚠️ did not clone dotfiles: this script might fail if a binary is not found"
	fi
fi

ln -s ~/.config/.gitconfig ~/.gitconfig

# +----------------------+
# | install dependencies |
# +----------------------+

read -r -p "❓ install dependencies from Brewfile? [y/N]" response
if [[ $response =~ (y|yes|Y) ]]; then

	brew bundle --file="$HOME/.config/Brewfile"

    if command -v "docker-compose" &> /dev/null; then
        if ! [[ -d "~/.docker/cli-plugins" ]]; then
            mkdir -p ~/.docker/cli-plugins
        fi
        ln -sfn "$(brew --prefix)/opt/docker-compose/bin/docker-compose" "~/.docker/cli-plugins/docker-compose"
    fi

    if command -v "docker-buildx" &> /dev/null; then
        if ! [[ -d "~/.docker/cli-plugins" ]]; then
            mkdir -p ~/.docker/cli-plugins
        fi
        ln -sfn "$(brew --prefix)/opt/docker-compose/bin/docker-buildx" "~/.docker/cli-plugins/docker-buildx"
    fi
else
	print "⚠️ skipped brew package installs"
fi

# +------------------------------+
# | configure languages with rtx |
# +------------------------------+

eval "$(rtx activate zsh)"

for lang in python@3.11 python@3.10 node@latest; do
	rtx install "$lang"
done

rtx global python@3.10 node@latest

# +--------------+
# | install rust |
# +--------------+

export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

for version in stable nightly; do
	rustup install "$version"
	rustup component add rust-analyzer --toolchain="$version"
done

# +--------------+
# | install nvim |
# +--------------+

bob install latest
bob install nightly
bob use nightly

# +---------------------+
# | install python CLIs |
# +---------------------+

for lib in 'pdm[all]' cruft pre-commit virtualenv; do
	pipx install "$lib"
done

mkdir -p "$HOME/Library/Application Support/pdm"
ln -s "$XDG_CONFIG_HOME/pdm/config.toml" "$HOME/Library/Application Support/pdm/config.toml"
