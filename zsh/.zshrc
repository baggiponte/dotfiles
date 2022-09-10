# +-------------------------------------------------------------------------+
# | REFERENCES                                                              |
# | * https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/  |
# | * https://linux.die.net/man/1/zshoptions                                |
# | * https://thevaluable.dev/zsh-completion-guide-examples/                |
# +-------------------------------------------------------------------------+

# +-----------------------+
# | ALIASES AND FUNCTIONS |
# +-----------------------+

## stuff in $ZDOTDIR/include
sources=(
  "aliases"
  "functions"
  "vim"
  "completions"
)

for s in "${sources[@]}"; do
  source $ZDOTDIR/include/${s}.zsh
done

# # +-----+
# # | PDM |
# # +-----+

# if [ -n "$PYTHONPATH" ]; then
#     export PYTHONPATH="$PIPX_HOME/venvs/pdm/lib/python3.10/site-packages/pdm/pep582":$PYTHONPATH
# else
#     export PYTHONPATH="$PIPX_HOME/venvs/pdm/lib/python3.10/site-packages/pdm/pep582"
# fi

# # +---------------+
# # | CONDA & MAMBA |
# # +---------------+
#
# _CONDA_INIT_DIR="$(brew --caskroom)/miniconda/base"
#
# # the following lines are managed by conda: do not edit!
# __conda_setup="$("$_CONDA_INIT_DIR/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "$_CONDA_INIT_DIR/etc/profile.d/conda.sh" ]; then
#         . "$_CONDA_INIT_DIR/etc/profile.d/conda.sh"
#     else
#         export PATH="$_CONDA_INIT_DIR/bin:$PATH"
#     fi
# fi
# unset __conda_setup
#
# # setup mamba
# if [ -f "$_CONDA_INIT_DIR/etc/profile.d/mamba.sh" ]; then
#     . "$_CONDA_INIT_DIR/etc/profile.d/mamba.sh"
# fi

# +------------------+
# | PLUGINS WITH ZIM |
# +------------------+

# NOTE: if autocompletion does not work, remove
# $XDG_CACHE_HOME/zsh/zcompdump and run compinit
fpath+=$XDG_CACHE_HOME/zsh/zfunc

# download zimfw plugin manager if missing
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# install missing modules, and update ${zim_home}/init.zsh if missing or outdated
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

source ${ZIM_HOME}/init.zsh

# +-------------+
# | COMPLETIONS |
# +-------------+

# compinit is to be run last, after loading modules with zmodload etc
# https://unix.stackexchange.com/a/391670/402599
autoload -Uz compinit && compinit -d $XDG_CACHE_HOME/zsh/zcompdump # uncomment if using zim's completion zmodule
autoload -Uz bashcompinit && bashcompinit

# `eval` commands are run **after** compinit
command -v jump >/dev/null && eval "$(jump shell zsh)"                               # autojump between directories; it's jump, not autojump!
command -v pyenv >/dev/null && eval "$(pyenv init --path)" && eval "$(pyenv init -)" # python version manager
command -v pyenv-virtualenv >/dev/null && eval "$(pyenv virtualenv-init -)"          # python virtualenv manager
command -v python >/dev/null && eval "$(python -m pip completion --zsh)"             # autocompletion for pip
command -v pipx >/dev/null && eval "$(register-python-argcomplete pipx)"             # autocompletion for pipx
command -v direnv >/dev/null && eval "$(direnv hook zsh)"                            # load project specific env variables
