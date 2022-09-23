# +-----+
# | PDM |
# +-----+

if [ -n "$PYTHONPATH" ]; then
    export PYTHONPATH="$PIPX_HOME/venvs/pdm/lib/python3.10/site-packages/pdm/pep582":$PYTHONPATH
else
    export PYTHONPATH="$PIPX_HOME/venvs/pdm/lib/python3.10/site-packages/pdm/pep582"
fi

# +---------------+
# | CONDA & MAMBA |
# +---------------+

_CONDA_INIT_DIR="$(brew --caskroom)/miniconda/base"

# the following lines are managed by conda: do not edit!
__conda_setup="$("$_CONDA_INIT_DIR/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$_CONDA_INIT_DIR/etc/profile.d/conda.sh" ]; then
        . "$_CONDA_INIT_DIR/etc/profile.d/conda.sh"
    else
        export PATH="$_CONDA_INIT_DIR/bin:$PATH"
    fi
fi
unset __conda_setup

# setup mamba
if [ -f "$_CONDA_INIT_DIR/etc/profile.d/mamba.sh" ]; then
    . "$_CONDA_INIT_DIR/etc/profile.d/mamba.sh"
fi
