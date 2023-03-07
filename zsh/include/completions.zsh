# +-------------+
# | COMPLETIONS |
# +-------------+

# $XDG_CACHE_HOME/zsh/zcompdump and run compinit
fpath=(${XDG_CACHE_HOME}/zsh/zfunc $fpath) # won't work if there are quotes

if [[ $(command -v pdm) && ! -s $XDG_CACHE_HOME/zsh/zfunc/_pdm ]]; then
	pdm completion zsh >"${XDG_CACHE_HOME}/zsh/zfunc/_pdm"
fi

if [[ $(command -v ruff) && ! -s $XDG_CACHE_HOME/zsh/zfunc/_ruff ]]; then
	ruff generate-shell-completion zsh >"${XDG_CACHE_HOME}/zsh/zfunc/_ruff"
fi

if [[ $(command -v arduino-cli) && ! -s $XDG_CACHE_HOME/zsh/zfunc/_arduino-cli ]]; then
	arduino-cli completion zsh >"${XDG_CACHE_HOME}/zsh/zfunc/_arduino-cli"
fi

if [[ $(command -v rustup) && ! -s $XDG_CACHE_HOME/zsh/zfunc/_rustup ]]; then
    rustup completions zsh >"${XDG_CACHE_HOME}/zsh/zfunc/_rustup"
fi

# comment out if using zim's completion zmodule
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
autoload -Uz bashcompinit && bashcompinit

# `eval` commands are run **after** compinit
# completions
command -v cz >/dev/null && eval "$(register-python-argcomplete cz)"                # conventional commits + semver + keep a changelog
command -v pipx >/dev/null && eval "$(register-python-argcomplete pipx)"            # autocompletion for pipx
command -v python >/dev/null && eval "$(python -m pip completion --zsh)"            # autocompletion for pip

# +-------+
# | HOOKS |
# +-------+

# hook binaries into zsh
# command -v pyenv >/dev/null && eval "$(pyenv init -)"                               # python version manager
# command -v pyenv-virtualenv-init >/dev/null && eval "$(pyenv virtualenv-init -)"    # virtualenv manager plugin for pyenv
command -v direnv >/dev/null && eval "$(direnv hook zsh)"                           # load project specific env variables
command -v rtx >/dev/null && eval "$(rtx activate zsh)"                             # hook rtx
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=j)"                   # autojump between directories; it's jump, not autojump!
