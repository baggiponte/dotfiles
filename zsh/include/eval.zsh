# +-------------+
# | COMPLETIONS |
# +-------------+

COMPDIR="${XDG_CACHE_HOME}/zsh/zfunc"

[[ -d "${COMPDIR}" ]] || mkdir -p "${COMPDIR}"

# $XDG_CACHE_HOME/zsh/zcompdump and run compinit
fpath=(${COMPDIR} $fpath) # won't work if there are quotes

# python
command -v uv >/dev/null && uv generate-shell-completion zsh > "${COMPDIR}/_uv"
command -v uvx >/dev/null && uvx --generate-shell-completion=zsh > "${COMPDIR}/_uvx"
command -v ruff >/dev/null && ruff generate-shell-completion zsh > "${COMPDIR}/_ruff"

command -v cz >/dev/null && register-python-argcomplete cz > "${COMPDIR}/_cz"

# rust
command -v rustup >/dev/null && rustup completions zsh > "${COMPDIR}/_rustup"
command -v cargo >/dev/null && rustup completions zsh cargo > "${COMPDIR}/_cargo"

# misc
command -v runpodctl >/dev/null && runpodctl completion zsh > "${COMPDIR}/_runpodctl"
command -v az >/dev/null && register-python-argcomplete az > "${COMPDIR}/_az"
command -v zellij >/dev/null && zellij setup --generate-completion zsh > "${COMPDIR}/_zellij"
command -v devpod >/dev/null && devpod completion zsh > "${COMPDIR}/_devpod"
command -v arduino-cli >/dev/null && arduino-cli completion zsh > "${COMPDIR}/_arduino-cli"

autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
autoload -Uz bashcompinit && bashcompinit

# these require compdef
command -v python >/dev/null && eval "$(python -m pip completion --zsh)"
command -v sk >/dev/null && compdef _gnu_generic sk

if command -v sky >/dev/null; then
    if [[ -s ~/.sky/.sky-complete.zsh ]]; then
        source ~/.sky/.sky-complete.zsh
    elif ! [[ -s ~/.sky/.sky-complete.zsh ]]; then
        echo "skypilot compdef not found. Run 'sky --install-shell-completion' to install"
    fi
fi

if command -v fzf >/dev/null; then
    eval "$(fzf --zsh)"
    compdef _gnu_generic fzf
fi

# +-------+
# | HOOKS |
# +-------+

# hook binaries into zsh
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=j)" # autojump with j

if command -v starship >/dev/null; then
	export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
	eval "$(starship init zsh)"
fi
