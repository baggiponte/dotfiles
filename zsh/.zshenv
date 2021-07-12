#########################
### default variables ###
#########################

export EDITOR="/usr/local/bin/nvim"
export PAGER="/usr/local/bin/less"

####################################
### environment variables for cd ###
####################################

export DOC="$HOME/Documents"
export DEV="$DOC/dev"
export DESK="$HOME/Desktop"
export CACHE="$HOME/.cache"

# config files
export CONFIG="$HOME/.config"

# my binaries
export MYBINS="$HOME/.local/bin"

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

#############
### conda ###
#############

export CONDA_ROOT="/usr/local/Caskroom/miniconda/base"
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