# +-------------------+
# | DEFAULT VARIABLES |
# +-------------------+

export EDITOR="/usr/local/bin/nvim"
export PAGER="/usr/local/bin/bat --plain"

export CACHE="$HOME/.cache"
export CONFIG="$HOME/.config"
export CONFIG_HOME="$CONFIG"
export LOCAL_BIN="$HOME/.local/bin"
export MYBINS="$HOME/.local/scripts"

# export XDG_CONFIG_HOME=$HOME/.config
# export XDG_CACHE_HOME=$HOME/.cache
# export XDG_DATA_HOME=$HOME/.local/share
# export XDG_STATE_HOME=$HOME/.local/state

# +-------------+
# | CONFIG DIRS |
# +-------------+

# nvim https://manpages.debian.org/testing/neovim-runtime/nvim.1.en.html
export MYVIMRC="$CONFIG/nvim/init.lua"

# zsh plugin manager zim: https://github.com/zimfw/zimfw
export ZIM_HOME="$CONFIG/.zim"

# cookiecutter
export COOKIECUTTER_CONFIG="$CONFIG/cookiecutter.yaml"

# brew & brewfiles
export HOMEBREW_BUNDLE_FILE="$CONFIG/Brewfile"

# jupyter
# JUPYTER_CONFIG_DIR for config file location
# JUPYTER_CONFIG_PATH for config file locations
# JUPYTER_PATH for datafile directory locations
# JUPYTER_DATA_DIR for data file location
# JUPYTER_RUNTIME_DIR for runtime file location
export JUPYTER_CONFIG_DIR="$HOME/.jupyter"
export JUPYTER_DATA_DIR="$HOME/.local/share/jupyter/"
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

export PGDATA="/usr/local/var/postgres@14"
export PGDATABASE="postgres"

# +------+
# | PATH |
# +------+

export PATH="$MYBINS:$LOCAL_BIN:$PATH:$HOME/.local/jetbrains"

# # llvm
# # llvm 9 for llvmlite
# export PATH="/usr/local/opt/llvm@9/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/llvm@9/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm@9/include"

# # openblas
# export LDFLAGS="-L/usr/local/opt/openblas/lib"
# export CPPFLAGS="-I/usr/local/opt/openblas/include"
# export PKG_CONFIG_PATH="/usr/local/opt/openblas/lib/pkgconfig"

# # +----------------+
# # | R AND C++ MESS |
# # +----------------+

# # For compilers to find icu4c you may need to set:
# export LDFLAGS="-L/usr/local/opt/icu4c/lib"
# export CPPFLAGS="-I/usr/local/opt/icu4c/include"

# # For pkg-config to find icu4c you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"
