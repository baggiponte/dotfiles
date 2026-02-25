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

# rust
command -v rustup >/dev/null && rustup completions zsh > "${COMPDIR}/_rustup"
command -v cargo >/dev/null && rustup completions zsh cargo > "${COMPDIR}/_cargo"

# misc
command -v az >/dev/null && register-python-argcomplete az > "${COMPDIR}/_az"

autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
autoload -Uz bashcompinit && bashcompinit

if command -v fzf >/dev/null; then
    eval "$(fzf --zsh)"
    compdef _gnu_generic fzf
fi

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
if command -v but >/dev/null 2>&1; then eval "$(command but completions zsh)"; fi
if comand -v mole >/dev/null 2>&1; then eval "$(command mole completions zsh)"; fi

# hook binaries into zsh
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=j)" # autojump with j

if command -v starship >/dev/null; then
	export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
	eval "$(starship init zsh)"
fi
