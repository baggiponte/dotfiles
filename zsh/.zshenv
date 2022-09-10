# +-------------------+
# | DEFAULT VARIABLES |
# +-------------------+

# see https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# in case it's not compatible with XDG dirs
export CACHE="${XDG_CACHE_HOME:-'$HOME/.cache'}"
export CONFIG="${XDG_CONFIG_HOME:-'$HOME/.config'}"
export CONFIG_HOME="$CONFIG"

export LOCAL_BIN="$HOME/.local/bin"
export MYBINS="$HOME/.local/scripts"

# brew & brewfiles
export HOMEBREW_BUNDLE_FILE="$CONFIG/Brewfile"
eval "$(/usr/local/bin/brew shellenv)"

# zsh plugin manager: https://github.com/zimfw/zimfw
export ZIM_HOME="$XDG_CACHE_HOME/zim"

# hash is like command -v

if hash nvim 2>/dev/null; then
	export EDITOR="/usr/local/bin/nvim"
	export MANPAGER="nvim +Man!"
	export MYVIMRC="$CONFIG/nvim/init.lua"
fi

# +-------------+
# | CONFIG DIRS |
# +-------------+

# bat
if hash bat 2>/dev/null; then
	export BAT_CONFIG_PATH=$CONFIG/bat
	export BAT_THEME="gruvbox-dark"
	export PAGER="/usr/local/bin/bat --plain"
fi

# pipx is a python CLIs manager
if hash pipx 2>/dev/null; then
	export PIPX_HOME="$HOME/.local/pipx"
	export PIPX_BIN_DIR="$LOCAL_BIN"
fi

# pyenv is a python version manager
if hash pyenv 2>/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
fi

# conda - but please don't use this
# CONDA_ROOT is the path for your `base` conda install.
# CONDA_PREFIX is the path to the current active environment.
# https://anaconda-project.readthedocs.io/en/latest/user-guide/tasks/work-with-variables.html
if hash conda 2>/dev/null; then
	export CONDA_ROOT="$(brew --caskroom)/miniconda/base"
	export CONDA_PKGS_DIR="$CONDA_ROOT/pkgs"
	export CONDA_ENVS_PATH="$CONDA_ROOT/envs"
fi

# cookiecutter: python CLI to create project templates
if hash cookiecutter 2>/dev/null; then
	export COOKIECUTTER_CONFIG="$CONFIG/cookiecutter.yaml"
fi

# jupyter
# JUPYTER_CONFIG_DIR for config file location
# JUPYTER_CONFIG_PATH for config file locations
# JUPYTER_PATH for datafile directory locations
# JUPYTER_DATA_DIR for data file location
# JUPYTER_RUNTIME_DIR for runtime file location
if hash jupyter 2>/dev/null; then
	export JUPYTER_ROOT="$PIPX_HOME/.jupyter"
	export JUPYTER_CONFIG_DIR="$JUPYTER_ROOT/"
	export JUPYTER_CONFIG_DIR="$PIPX_HOME/.jupyter/etc/jupyter"
	export JUPYTER_DATA_DIR="$PIPX_HOME/.jupyter/share/jupyter"
	export JUPYTER_KERNEL_DIR="$JUPYTER_DATA_DIR/kernels" # user defined kernels
fi

# matplotlib
export MPLCONFIGDIR="$CONFIG/matplotlib"
export MATPLOTLIBRC="$MPLCONFIGDIR/matplotlibrc"

# kaggle
if hash kaggle 2>/dev/null; then
	export KAGGLE_CONFIG_DIR="$CONFIG/kaggle"
	source "$HOME/.secrets/kaggle.txt" # username and key
fi

# zoxide (autojump)
if hash zoxide 2>/dev/null; then
	export _ZO_DATA_DIR="$XDG_DATA_HOME"
fi

# postgres
if hash psql 2>/dev/null; then
	export PGDATA="/usr/local/var/postgres@14"
	export PGDATABASE="postgres"
fi

# +------+
# | PATH |
# +------+

export PATH="$MYBINS:$LOCAL_BIN:$PATH:$HOME/.local/jetbrains"
