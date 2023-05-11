# +---------------------+
# |  ADD TO $PATH FIRST |
# +---------------------+

# MUST be before any "hash" call!
if [ "$(sysctl -n machdep.cpu.brand_string)" = "Apple M1" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/Brewfile.M1"
else
	eval "$(/usr/local/bin/brew shellenv)"
	export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/Brewfile.Intel"
fi

# +------------------+
# | ENV VARS CONFIGS |
# +------------------+

if hash rustup-init 2>/dev/null; then
	. "$HOME/.cargo/env"
fi

# +------+
# | NVIM |
# +------+

if hash nvim 2>/dev/null; then
	# NOTE: exporting EDITOR=nvim will automatically run bindkey -v (vim mode)
	export EDITOR="nvim"
	export MANPAGER="nvim +Man!"
	export MYVIMRC="$XDG_CONFIG_HOME/nvim/init.lua"
fi

# +--------+
# | PYTHON |
# +--------+

export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
# https://docs.jupyter.org/en/latest/use/jupyter-directories.html
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_DATA_DIR="$XDG_DATA_HOME/jupyter"
export JUPYTER_RUNTIME_DIR="$JUPYTER_DATA_DIR/runtime"

export PIPX_HOME="$XDG_DATA_HOME/pipx"
export PIPX_BIN_DIR="$PIPX_HOME/bin"
export PATH="$PIPX_BIN_DIR:$PATH"

export POETRY_CONFIG_DIR="$XDG_CONFIG_HOME/pypoetry"
export POETRY_DATA_DIR="$XDG_DATA_HOME/pypoetry"
export POETRY_HOME="$XDG_DATA_HOME/pypoetry"

if hash cookiecutter 2>/dev/null; then
	export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter/cookiecutter.yaml"
fi

# +-------+
# | OTHER |
# +-------+

if hash tldr 2>/dev/null; then
	export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"
fi

# +---+
# | R |
# +---+

if [ -d "/Library/Frameworks/R.framework/Resources" ]; then
	export R_ENVIRON_USER=$XDG_CONFIG_HOME/R/.Renviron
	export R_PROFILE_USER=$XDG_CONFIG_HOME/R/.Rprofile
fi

# if ! hash R 2>/dev/null; then
# 	export PATH="$PATH:/usr/local/bin"
# fi

# +-----+
# | NPM |
# +-----+

if hash npm 2>/dev/null; then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/.npmrc"
	export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
fi

# +----------+
# | POSTGRES |
# +----------+

if hash psql 2>/dev/null; then
	export PGDATA="/usr/local/var/postgres@14"
	export PGDATABASE="postgres"
fi

# +---------+
# | ARDUINO |
# +---------+

if hash arduino-cli 2>/dev/null; then
	export ARDUINO_DIRECTORIES_DATA="$XDG_DATA_HOME/arduino"
	export ARDUINO_DIRECTORIES_DOWNLOADS="$ARDUINO_DIRECTORIES_DATA/staging"
	export ARDUINO_DIRECTORIES_USER="$HOME/dev/arduino"

	if ! [ -f "$ARDUINO_DIRECTORIES_DATA/arduino-cli.yaml" ]; then
		ln -s "$XDG_CONFIG_HOME/arduino/arduino-cli.yaml" "$ARDUINO_DIRECTORIES_DATA/arduino-cli.yaml"
	fi
fi
