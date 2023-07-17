# +-------------+
# | COMPLETIONS |
# +-------------+

[[ -d "${XDG_CACHE_HOME}/zsh/zfunc" ]] || mkdir -p "${XDG_CACHE_HOME}/zsh/zfunc"

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

if [[ $(command -v rustup) && ! -s $XDG_CACHE_HOME/zsh/zfunc/_cargo ]]; then
	rustup completions zsh cargo >"${XDG_CACHE_HOME}/zsh/zfunc/_cargo"
fi

[ -f $ZDOTDIR/include/fzf.zsh ] && source "$ZDOTDIR/include/fzf.zsh"

# comment out if using zim's completion zmodule
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
autoload -Uz bashcompinit && bashcompinit

# `eval` commands are run **after** compinit
# completions
command -v cz >/dev/null && eval "$(register-python-argcomplete cz)"     # conventional commits + semver + keep a changelog
command -v pipx >/dev/null && eval "$(register-python-argcomplete pipx)" # autocompletion for pipx
command -v python >/dev/null && eval "$(python -m pip completion --zsh)" # autocompletion for pip

# +-------+
# | HOOKS |
# +-------+

# hook binaries into zsh
command -v direnv >/dev/null && eval "$(direnv hook zsh)"         # load project specific env variables
command -v rtx >/dev/null && eval "$(rtx activate zsh)"           # hook rtx
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=j)" # autojump between directories; it's jump, not autojump!
