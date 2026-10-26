# +-------+
# | HOOKS |
# +-------+

# Init scripts: cached under $XDG_CACHE_HOME/zsh/gen, then sourced (_zsource
# is in cache.zsh). `command` bypasses shell functions these scripts define.
_zsource fzf      fzf      fzf --zsh && compdef _gnu_generic fzf
_zsource wt       wt       command wt config shell init zsh
# mise is evaluated live, never cached: `mise activate` embeds the PATH of the
# moment it ran (export PATH=..., __MISE_ORIG_PATH), so a cached copy would
# reset every new shell to a stale PATH and drop entries from the parent env.
(( $+commands[mise] )) && eval "$(command mise activate zsh)"
_zsource zoxide   zoxide   zoxide init zsh --cmd=j # autojump with j
_zsource starship starship starship init zsh --print-full-init
