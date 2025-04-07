# +--------------------+
# | ADD TO $PATH FIRST |
# +--------------------+

# override PATH because path_helper screws it up
paths=(
    "${HOME}/.local/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
    "/opt/homebrew/opt/postgresql@17/bin"
)

# reference:
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion-Flags
# can use any pair of delimiters
export PATH="${(j.:.)paths}"

# MUST be before any "hash" call!
eval "$(/opt/homebrew/bin/brew shellenv)"

# +------+
# | NVIM |
# +------+

# NOTE: exporting EDITOR=nvim will automatically run bindkey -v (vim mode)
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export MYVIMRC="${XDG_CONFIG_HOME}/nvim/init.lua"

# +------+
# | RUST |
# +------+

if [[ -x "${HOME}/.cargo/bin/rustup" ]]; then
	source "${HOME}/.cargo/env"
fi

# +--------+
# | DOCKER |
# +--------+

if command -v colima >/dev/null && command -v docker >/dev/null; then
	export DOCKER_HOST="unix://${XDG_CONFIG_HOME}/colima/default/docker.sock"
fi

# +--------+
# | PYTHON |
# +--------+

# TODO: remove once uv takes over :)
if command -v poetry >/dev/null; then
    export POETRY_CONFIG_DIR="${XDG_CONFIG_HOME}/pypoetry"
    export POETRY_DATA_DIR="${XDG_DATA_HOME}/pypoetry"
    export POETRY_HOME="${XDG_DATA_HOME}/pypoetry"
fi

if command -v pipx >/dev/null; then
	export PIPX_HOME="${XDG_DATA_HOME}/pipx"
	export PIPX_BIN_DIR="${PIPX_HOME}/bin"
	export PATH="${PIPX_BIN_DIR}:${PATH}"
fi


if command -v rye >/dev/null; then
    export RYE_HOME="${XDG_DATA_HOME}/rye"
    source "${RYE_HOME}/env"
fi

export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"

# https://docs.jupyter.org/en/latest/use/jupyter-directories.html
export JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}/jupyter"
export JUPYTER_DATA_DIR="${XDG_DATA_HOME}/jupyter"
export JUPYTER_RUNTIME_DIR="${JUPYTER_DATA_DIR}/runtime"

export COOKIECUTTER_CONFIG="${XDG_CONFIG_HOME}/cookiecutter/cookiecutter.yaml"

# +-------+
# | OTHER |
# +-------+

if hash tldr 2>/dev/null; then
	export TEALDEER_CONFIG_DIR="${XDG_CONFIG_HOME}/tealdeer"
fi

if hash R 2>/dev/null; then
	export R_ENVIRON_USER=${XDG_CONFIG_HOME}/R/.Renviron
	export R_PROFILE_USER=${XDG_CONFIG_HOME}/R/.Rprofile
fi

if hash npm 2>/dev/null; then
	export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/.npmrc"
	export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
fi
