#########################
### default variables ###
#########################

export EDITOR="/usr/local/bin/nvim"
export PAGER="/usr/bin/less"

####################################
### environment variables for cd ###
####################################

export DOC="$HOME/Documents"
export DEV="$DOC/dev"
export DESK="$HOME/Desktop"

export CACHE="$HOME/.cache"
export CONFIG="$HOME/.config"
export MYBINS="$HOME/.local/scripts"

# see: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# $XDG_DATA_HOME defines the base directory relative to which user-specific data files should be stored.
# If $XDG_DATA_HOME is either not set or empty, a default equal to $HOME/.local/share should be used.
# $XDG_CONFIG_HOME defines the base directory relative to which user-specific configuration files should be stored.
# If $XDG_CONFIG_HOME is either not set or empty, a default equal to $HOME/.config should be used.
# $XDG_STATE_HOME defines the base directory relative to which user-specific state files should be stored.
# If $XDG_STATE_HOME is either not set or empty, a default equal to $HOME/.local/state should be used.

# coding projects directories
export PY="$DEV/python-projects"
export R="$DEV/r-projects"

# cloud storage services

# using parameter substitution is necessary to escape special characters and have it behave as expected
# ${(q)} is typical to zsh, bash works differently
export ONEDRIVE="$HOME/OneDrive - Università degli Studi di Milano"
export GDRIVE="$HOME/Google Drive/My Drive"
export UNI="${(q)ONEDRIVE}/uni"
export COLAB="$GDRIVE/Colab Notebooks"

#########################
### zsh related stuff ###
#########################

# for directory where I install plugins for zsh
export ZSH_PLUGIN_DIR="/usr/local/share"
# zsh & zsh plugins | actually suggested by package manager Homebrew
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="/usr/local/share/zsh-syntax-highlighting/highlighters"
export DYLD_FALLBACK_LIBRARY_PATH="$HOME/lib:/usr/local/lib:/usr/lib:/lib"

####################
### config paths ###
####################

# nvim
# see: https://manpages.debian.org/testing/neovim-runtime/nvim.1.en.html
export MYVIMRC="$CONFIG/nvim/init.vim"

# jupyter
export JUPYTER_CONFIG_DIR="$CONFIG/jupyter"

# matplotlib
export MPLCONFIGDIR="$CONFIG/matplotlib"
export MATPLOTLIBRC="$MPLCONFIGDIR/matplotlibrc"

# bat
export BAT_CONFIG_PATH=$CONFIG/bat
export BAT_THEME="gruvbox-dark"

# kaggle
export KAGGLE_CONFIG_DIR="$CONFIG/kaggle"
source "$HOME/.secrets/kaggle" # username and key

# pyenv
export PYENV_ROOT="$HOME/.pyenv"

# pipx
export PIPX_HOME="$HOME/.local/pipx"
export PIPX_BIN_DIR="$HOME/.local/bin"

# conda
export CONDA_ROOT="$PYENV_ROOT/versions/miniconda3-latest"
export CONDA_PKGS_DIR="$CONDA_ROOT/pkgs"
export CONDA_ENVS_PATH="$CONDA_ROOT/envs"

# CONDA_ROOT is the path for your `base` conda install.
# CONDA_PREFIX is the path to the current active environment.
# https://anaconda-project.readthedocs.io/en/latest/user-guide/tasks/work-with-variables.html

#################
### posgresql ###
#################

export PGDATA="/usr/local/var/postgres"

#######################
### echo formatting ###
#######################

# source color variables to modify format output of commands such as echo.
source "$ZDOTDIR/colors.zsh"

###########################
### source icons for lf ###
###########################

source "$CONFIG/lf/.lf-icons"
