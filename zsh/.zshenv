# +-------------------+
# | DEFAULT VARIABLES |
# +-------------------+

# see https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# in case it's not compatible with XDG dirs
export CACHE="${XDG_CACHE_HOME:-"$HOME/.cache"}"
export CONFIG="${XDG_CONFIG_HOME:-"$HOME/.config"}"
export CONFIG_HOME="$CONFIG"

# +------+
# | PATH |
# +------+

export PATH="$HOME/.local/bin:$PATH"

# MUST be before any "hash" call!
if [ "$(sysctl -n machdep.cpu.brand_string)" = "Apple M1" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/Brewfile.M1"
else
	eval "$(/usr/local/bin/brew shellenv)"
	export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/Brewfile.Intel"
fi

# +----------------+
# | CUSTOM CONFIGS |
# +----------------+

if hash nvim 2>/dev/null; then
	# NOTE: exporting EDITOR=nvim will automatically run bindkey -v
	# e.g. zsh will use vim keybindings!
	export EDITOR="nvim"
	export MANPAGER="nvim +Man!"
	export MYVIMRC="$CONFIG/nvim/init.lua"
fi

if hash npm 2>/dev/null; then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/.npmrc"
	export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
fi

export ZIM_HOME="$XDG_CACHE_HOME/zim"

if hash pipx 2>/dev/null; then
	export PIPX_HOME="$HOME/.local/pipx"
	export PIPX_BIN_DIR="$HOME/.local/bin"
fi

if hash pyenv 2>/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
fi

# conda - but please don't use this
# CONDA_ROOT is the path for your `base` conda install.
# CONDA_PREFIX is the path to the current active environment.
# https://anaconda-project.readthedocs.io/en/latest/user-guide/tasks/work-with-variables.html
if hash conda 2>/dev/null; then
	export CONDA_ROOT
	CONDA_ROOT="$(brew --caskroom)/miniconda/base"
	export CONDA_PKGS_DIR="$CONDA_ROOT/pkgs"
	export CONDA_ENVS_PATH="$CONDA_ROOT/envs"
fi

if hash cookiecutter 2>/dev/null; then
	export COOKIECUTTER_CONFIG="$CONFIG/cookiecutter.yaml"
fi

if hash psql 2>/dev/null; then
	export PGDATA="/usr/local/var/postgres@14"
	export PGDATABASE="postgres"
fi

export MPLCONFIGDIR="$CONFIG/matplotlib"
export MATPLOTLIBRC="$MPLCONFIGDIR/matplotlibrc"

