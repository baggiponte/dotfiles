# +-------+
# | HOOKS |
# +-------+

# Init scripts: cached under $XDG_CACHE_HOME/zsh/gen, then sourced (_zsource
# is in cache.zsh). `command` bypasses shell functions these scripts define.
_zsource fzf      fzf      fzf --zsh && compdef _gnu_generic fzf
_zsource wt       wt       command wt config shell init zsh
_zsource mise     mise     command mise activate zsh
_zsource zoxide   zoxide   zoxide init zsh --cmd=j # autojump with j
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
_zsource starship starship starship init zsh --print-full-init
