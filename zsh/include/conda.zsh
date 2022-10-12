# +---------------+
# | CONDA & MAMBA |
# +---------------+

export CONDA_ROOT
CONDA_ROOT="$(brew --caskroom)/miniconda/base"
export CONDA_PKGS_DIR="$CONDA_ROOT/pkgs"
export CONDA_ENVS_PATH="$CONDA_ROOT/envs"

# the following lines are managed by conda: do not edit!
__conda_setup="$("$CONDA_ROOT/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
        . "$CONDA_ROOT/etc/profile.d/conda.sh"
    else
        export PATH="$_CONDA_INIT_DIR/bin:$PATH"
    fi
fi
unset __conda_setup

# setup mamba
if [ -f "$CONDA_ROOT/etc/profile.d/mamba.sh" ]; then
    . "$CONDA_ROOT/etc/profile.d/mamba.sh"
fi
