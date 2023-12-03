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

export PATH="$PATH:/usr/local/bin:$HOME/.local/bin"

# +------+
# | NVIM |
# +------+

# NOTE: exporting EDITOR=nvim will automatically run bindkey -v (vim mode)
export PATH="$PATH:$XDG_DATA_HOME/bob/nvim-bin/"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export MYVIMRC="$XDG_CONFIG_HOME/nvim/init.lua"

# +------+
# | RUST |
# +------+

if [[ -f $XDG_DATA_HOME/cargo/bin/rustup ]]; then
	export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
	export CARGO_HOME="$XDG_DATA_HOME"/cargo
	source "$CARGO_HOME"/env
fi

# +--------+
# | DOCKER |
# +--------+

if command -v colima >/dev/null && command -v docker >/dev/null; then
	export DOCKER_HOST="unix:///${HOME}/.colima/default/docker.sock"
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

export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter/cookiecutter.yaml"

# +-------+
# | OTHER |
# +-------+

if hash tldr 2>/dev/null; then
	export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"
fi

if hash R 2>/dev/null; then
	export R_ENVIRON_USER=$XDG_CONFIG_HOME/R/.Renviron
	export R_PROFILE_USER=$XDG_CONFIG_HOME/R/.Rprofile
fi

if hash npm 2>/dev/null; then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/.npmrc"
	export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
fi


# +-----------+
# | JETBRAINS |
# +-----------+

export PATH="$PATH:$HOME/.local/share/jetbrains/bin"
