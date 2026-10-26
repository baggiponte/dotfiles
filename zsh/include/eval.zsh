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
# Even live, mise prepends its tool dirs ahead of everything on activation and
# on each prompt (hook-env): move Rex's back in front afterwards (precmd hooks
# run in order; see REX_BIN_DIR in .zshenv).
if [[ -n $REX_BIN_DIR ]]; then
	_rex_path_first () { path=("$REX_BIN_DIR" $path) }
	_rex_path_first
	add-zsh-hook precmd _rex_path_first
fi
_zsource zoxide   zoxide   zoxide init zsh --cmd=j # autojump with j
_zsource starship starship starship init zsh --print-full-init
