# +-------------------+
# | DEFAULT VARIABLES |
# +-------------------+

export EDITOR="/usr/local/bin/nvim"
export PAGER="/usr/local/bin/bat --plain"

export CACHE="$HOME/.cache"
export CONFIG="$HOME/.config"
export LOCAL_BIN="$HOME/.local/bin"
export MYBINS="$HOME/.local/scripts"

# +-------------+
# | CONFIG DIRS |
# +-------------+

# nvim https://manpages.debian.org/testing/neovim-runtime/nvim.1.en.html
export MYVIMRC="$CONFIG/nvim/init.vim"

# zsh plugin manager zim: https://github.com/zimfw/zimfw
export ZIM_HOME="$CONFIG/.zim"

# cookiecutter
export COOKIECUTTER_CONFIG="$CONFIG/cookiecutter.yaml"

# jupyter
export JUPYTER_CONFIG_DIR="$CONFIG/jupyter"
export JUPYTER_WORKSPACES_DIR="$JUPYTER_CONFIG_DIR/lab/workspaces"
export JUPYTER_DATA_DIR="$HOME/Library/Jupyter"
export JUPYTER_KERNEL_DIR="$JUPYTER_DATA_DIR/kernels" # user defined kernels

# matplotlib
export MPLCONFIGDIR="$CONFIG/matplotlib"
export MATPLOTLIBRC="$MPLCONFIGDIR/matplotlibrc"

# bat
export BAT_CONFIG_PATH=$CONFIG/bat
export BAT_THEME="gruvbox-dark"

# kaggle
export KAGGLE_CONFIG_DIR="$CONFIG/kaggle"
source "$HOME/.secrets/kaggle.txt" # username and key

# +--------+
# | PYTHON |
# +--------+

# pipx
export PIPX_HOME="$HOME/.local/pipx"
export PIPX_BIN_DIR="$LOCAL_BIN"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"

# # conda
# export CONDA_ROOT="$(brew --caskroom)/miniconda/base"
# export CONDA_PKGS_DIR="$CONDA_ROOT/pkgs"
# export CONDA_ENVS_PATH="$CONDA_ROOT/envs"
# 
# # CONDA_ROOT is the path for your `base` conda install.
# # CONDA_PREFIX is the path to the current active environment.
# # https://anaconda-project.readthedocs.io/en/latest/user-guide/tasks/work-with-variables.html

# +------------+
# | POSTGRESQL |
# +------------+

export PGDATA="/usr/local/var/postgres"

# +------+
# | PATH |
# +------+

export PATH="$MYBINS:$LOCAL_BIN:$PATH:$HOME/.local/jetbrains"

# # +----------------+
# # | R AND C++ MESS |
# # +----------------+

# # For compilers to find icu4c you may need to set:
# export LDFLAGS="-L/usr/local/opt/icu4c/lib"
# export CPPFLAGS="-I/usr/local/opt/icu4c/include"

# # For pkg-config to find icu4c you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"

# +-----------------+
# | OTHER ZSH STUFF |
# +-----------------+

# source colored icons for lf
source "$CONFIG/lf/.lf-icons"
