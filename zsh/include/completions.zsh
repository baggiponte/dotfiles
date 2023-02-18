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
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=j)"                    # autojump between directories; it's jump, not autojump!
command -v pyenv >/dev/null && eval "$(pyenv init -)"                                # python version manager
command -v pyenv-virtualenv-init >/dev/null && eval "$(pyenv virtualenv-init -)"
command -v python >/dev/null && eval "$(python -m pip completion --zsh)"             # autocompletion for pip
command -v pipx >/dev/null && eval "$(register-python-argcomplete pipx)"             # autocompletion for pipx
command -v direnv >/dev/null && eval "$(direnv hook zsh)"                            # load project specific env variables
