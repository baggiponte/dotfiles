# +-------------+
# | COMPLETIONS |
# +-------------+

source "$ZDOTDIR/include/cache.zsh"

# Completion files, autoloaded from fpath. Regenerated only when the tool's
# binary changes (upgrade), not on every startup.
_zgen "$COMPDIR/_uv"  uv  uv generate-shell-completion zsh
_zgen "$COMPDIR/_uvx" uvx uvx --generate-shell-completion=zsh
_zgen "$COMPDIR/_az"  az  register-python-argcomplete az
# ruff runs through uv: use an installed `uv tool` binary if there is one,
# otherwise `uvx ruff` (keyed on uv, so it refreshes when uv is upgraded).
if (( $+commands[ruff] )); then
	_zgen "$COMPDIR/_ruff" ruff ruff generate-shell-completion zsh
else
	_zgen "$COMPDIR/_ruff" uv uvx ruff generate-shell-completion zsh
fi

# Register generated completions before compinit runs.
fpath=("${COMPDIR}" "${fpath[@]}")

autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
autoload -Uz bashcompinit && bashcompinit

# +-------+
# | HOOKS |
# +-------+

# Init scripts: cached under $XDG_CACHE_HOME/zsh/gen, then sourced.
# `command` bypasses shell functions these scripts define (e.g. `wt`).
_zsource fzf      fzf      fzf --zsh && compdef _gnu_generic fzf
_zsource wt       wt       command wt config shell init zsh
_zsource mole     mole     command mole completion zsh
_zsource mise     mise     command mise activate zsh
_zsource zoxide   zoxide   zoxide init zsh --cmd=j # autojump with j
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
_zsource starship starship starship init zsh --print-full-init
