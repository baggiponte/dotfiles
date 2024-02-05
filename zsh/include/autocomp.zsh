# +-------------+
# | COMPLETIONS |
# +-------------+

COMPDIR="${XDG_CACHE_HOME}/zsh/zfunc"

[[ -d "${COMPDIR}" ]] || mkdir -p "${COMPDIR}"

# $XDG_CACHE_HOME/zsh/zcompdump and run compinit
fpath=(${COMPDIR} $fpath) # won't work if there are quotes

if [[ $(command -v rye) && ! -s ${COMPDIR}/_rye ]]; then
    rye self completion -s zsh > "${COMPDIR}/_rye"
fi

if [[ $(command -v pdm) && ! -s ${COMPDIR}/_pdm ]]; then
	pdm completion zsh >"${COMPDIR}/_pdm"
fi

if [[ $(command -v ruff) && ! -s ${COMPDIR}/_ruff ]]; then
	ruff generate-shell-completion zsh >"${COMPDIR}/_ruff"
fi

if [[ $(command -v arduino-cli) && ! -s ${COMPDIR}/_arduino-cli ]]; then
	arduino-cli completion zsh >"${COMPDIR}/_arduino-cli"
fi

if [[ $(command -v rustup) && ! -s ${COMPDIR}/_rustup ]]; then
	rustup completions zsh >"${COMPDIR}/_rustup"
fi

if [[ $(command -v rustup) && ! -s ${COMPDIR}/_cargo ]]; then
	rustup completions zsh cargo >"${COMPDIR}/_cargo"
fi

if [[ $(command -v zellij) && ! -s ${COMPDIR}/_zellij ]]; then
	zellij setup --generate-completion zsh >"${COMPDIR}/_zellij"
fi

[ -f $ZDOTDIR/include/fzf.zsh ] && source "$ZDOTDIR/include/fzf.zsh"

# comment out if using zim's completion zmodule
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
autoload -Uz bashcompinit && bashcompinit
