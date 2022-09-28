# +------------------+
# | PLUGINS WITH ZIM |
# +------------------+

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

# +-------------------+
# | OTHER COMPLETIONS |
# +-------------------+

# NOTE: if autocompletion does not work, remove
# $XDG_CACHE_HOME/zsh/zcompdump and run compinit
fpath=($XDG_CACHE_HOME/zsh/zfunc $fpath)

if [ -s $XDG_CACHE_HOME/zsh/zfunc/_pdm ]; then
  pdm completion zsh > $XDG_CACHE_HOME/zsh/zfunc/_pdm
fi

if [ -s $XDG_CACHE_HOME/zsh/zfunc/_arduino-cli ]; then
  arduino-cli completion zsh > $XDG_CACHE_HOME/zsh/zfunc/_arduino-cli
fi

# +------------------------+
# | INITIALISE COMPLETIONS |
# +------------------------+

# compinit is to be run last, after loading modules with zmodload etc
# https://unix.stackexchange.com/a/391670/402599
autoload -Uz compinit && compinit -d $XDG_CACHE_HOME/zsh/zcompdump # comment if using zim's completion zmodule
autoload -Uz bashcompinit && bashcompinit

# `eval` commands are run **after** compinit
command -v jump >/dev/null && eval "$(jump shell zsh)"                               # autojump between directories; it's jump, not autojump!
command -v pyenv >/dev/null && eval "$(pyenv init --path)" && eval "$(pyenv init -)" # python version manager
command -v pyenv-virtualenv >/dev/null && eval "$(pyenv virtualenv-init -)"          # python virtualenv manager
command -v python >/dev/null && eval "$(python -m pip completion --zsh)"             # autocompletion for pip
command -v pipx >/dev/null && eval "$(register-python-argcomplete pipx)"             # autocompletion for pipx
command -v direnv >/dev/null && eval "$(direnv hook zsh)"                            # load project specific env variables
