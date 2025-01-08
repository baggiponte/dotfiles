autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
autoload -Uz bashcompinit && bashcompinit

# +-------------+
# | COMPLETIONS |
# +-------------+

COMPDIR="${XDG_CACHE_HOME}/zsh/zfunc"

[[ -d "${COMPDIR}" ]] || mkdir -p "${COMPDIR}"

# $XDG_CACHE_HOME/zsh/zcompdump and run compinit
fpath=(${COMPDIR} $fpath) # won't work if there are quotes


# python
command -v python >/dev/null && eval "$(python -m pip completion --zsh)" # autocompletion for pip

command -v uv >/dev/null && uv generate-shell-completion zsh > "${COMPDIR}/_uv"
command -v uvx >/dev/null && uvx --generate-shell-completion=zsh > "${COMPDIR}/_uvx"
command -v ruff >/dev/null && ruff generate-shell-completion zsh > "${COMPDIR}/_ruff"

command -v sky >/dev/null && source ~/.sky/.sky-complete.zsh
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
command -v sk >/dev/null && compdef _gnu_generic sk

if command -v fzf >/dev/null; then
    eval "$(fzf --zsh)"
    compdef _gnu_generic fzf
fi

# unused
command -v rye >/dev/null && rye self completion -s zsh > "${COMPDIR}/_rye"
command -v pdm >/dev/null &&  pdm completion zsh > "${COMPDIR}/_pdm"
command -v pixi >/dev/null &&  pixi completion --shell zsh > "${COMPDIR}/_pixi"
command -v pipx >/dev/null && register-python-argcomplete pipx > "${COMPDIR}/_pipx"

# +-------+
# | HOOKS |
# +-------+

# hook binaries into zsh
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd=j)" # autojump with j

if command -v starship >/dev/null; then
	export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
	eval "$(starship init zsh)"
fi

# unused
command -v direnv >/dev/null && eval "$(direnv hook zsh)"         # autoload dotenv files
command -v mise >/dev/null && eval "$(mise activate zsh)"         # hook mise
