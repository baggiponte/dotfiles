# +-------------------+
# | default variables |
# +-------------------+

export EDITOR="/usr/local/bin/nvim"
export PAGER="/usr/bin/less"

# +--------------------------------+
# | environmental variables for cd | 
# +--------------------------------+

# unneded since I am using jump
# export DOCS="$HOME/Documents"
# export DEV="$DOCS/dev" 
# export DESK="$HOME/Desktop"

# export CACHE="$HOME/.cache"
# export CONFIG="$HOME/.config"
# export MYBINS="$HOME/.local/scripts"

# export PY_PROJS="$DEV/python-projects"
# export R_PROJS="$DEV/r-projects"
# export JULIA_PROJS="$DEV/julia-projects"

# +-------------+
# | config dirs |
# +-------------+

# nvim
# see: https://manpages.debian.org/testing/neovim-runtime/nvim.1.en.html
export MYVIMRC="$CONFIG/nvim/init.vim"

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
source "$HOME/.secrets/kaggle" # username and key

# pipx
export PIPX_HOME="$HOME/.local/pipx"
export PIPX_BIN_DIR="$HOME/.local/bin"
export PATH="$PATH:$PIPX_BIN_DIR"

# # conda
# export CONDA_ROOT="$(brew --caskroom)/miniconda/base"
# export CONDA_PKGS_DIR="$CONDA_ROOT/pkgs"
# export CONDA_ENVS_PATH="$CONDA_ROOT/envs"
# 
# # CONDA_ROOT is the path for your `base` conda install.
# # CONDA_PREFIX is the path to the current active environment.
# # https://anaconda-project.readthedocs.io/en/latest/user-guide/tasks/work-with-variables.html

# postgresql
export PGDATA="/usr/local/var/postgres"

# +------------------+
# | personal scripts |
# +------------------+

export PATH="$MYBINS:$PATH"
# add jetbrains path to scripts
export PATH="$PATH:$HOME/.local/jetbrains"

# # +----------------+
# # | R and C++ mess |
# # +----------------+

# # For compilers to find icu4c you may need to set:
# export LDFLAGS="-L/usr/local/opt/icu4c/lib"
# export CPPFLAGS="-I/usr/local/opt/icu4c/include"

# # For pkg-config to find icu4c you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"

# +-----------------+
# | other zsh stuff |
# +-----------------+

# source colored icons for lf
source "$CONFIG/lf/.lf-icons"
