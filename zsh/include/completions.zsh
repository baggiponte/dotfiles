# +-------------+
# | COMPLETIONS |
# +-------------+

COMPDIR="${XDG_CACHE_HOME}/zsh/zfunc"

[[ -d "${COMPDIR}" ]] || mkdir -p "${COMPDIR}"

# $XDG_CACHE_HOME/zsh/zcompdump and run compinit
fpath=(${COMPDIR} $fpath) # won't work if there are quotes

# python

if [[ $(command -v rye) && ! -s ${COMPDIR}/_rye ]]; then
    rye self completion -s zsh > "${COMPDIR}/_rye"
fi

if [[ $(command -v pdm) && ! -s ${COMPDIR}/_pdm ]]; then
	pdm completion zsh >"${COMPDIR}/_pdm"
fi

if [[ $(command -v pixi) && ! -s ${COMPDIR}/_pixi ]]; then
    pixi completion --shell zsh >"${COMPDIR}/_pixi"
fi

if [[ $(command -v ruff) && ! -s ${COMPDIR}/_ruff ]]; then
	ruff generate-shell-completion zsh >"${COMPDIR}/_ruff"
fi

if [[ $(command -v uv) && ! -s ${COMPDIR}/_uv ]]; then
	uv generate-shell-completion=zsh >"${COMPDIR}/_uv"
    uvx --generate-completion=zsh >"${COMPDIR}/_uvx"
fi

if [[ $(command -v pipx) && ! -s ${COMPDIR}/_pipx ]]; then
    register-python-argcomplete pipx >"${COMPDIR}/_pipx"
fi

if [[ $(command -v cz) && ! -s ${COMPDIR}/_cz ]]; then
    register-python-argcomplete cz >"${COMPDIR}/_cz"
fi

# rust

if [[ $(command -v rustup) && ! -s ${COMPDIR}/_rustup ]]; then
	rustup completions zsh >"${COMPDIR}/_rustup"
fi

if [[ $(command -v rustup) && ! -s ${COMPDIR}/_cargo ]]; then
	rustup completions zsh cargo >"${COMPDIR}/_cargo"
fi

# misc

if [[ $(command -v runpodctl) && ! -s ${COMPDIR}/_runpodctl ]]; then
    runpodctl completion zsh >"${COMPDIR}/_runpodctl"
fi

if [[ $(command -v az) && ! -s ${COMPDIR}/_az ]]; then
    register-python-argcomplete az >"${COMPDIR}/_az"
fi

if [[ $(command -v zellij) && ! -s ${COMPDIR}/_zellij ]]; then
	zellij setup --generate-completion zsh >"${COMPDIR}/_zellij"
fi

if [[ $(command -v devpod) && ! -s ${COMPDIR}/_devpod ]]; then
    devpod completion zsh >"${COMPDIR}/_devpod"
fi

if [[ $(command -v arduino-cli) && ! -s ${COMPDIR}/_arduino-cli ]]; then
	arduino-cli completion zsh >"${COMPDIR}/_arduino-cli"
fi

# comment out if using zim's completion zmodule
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
autoload -Uz bashcompinit && bashcompinit
