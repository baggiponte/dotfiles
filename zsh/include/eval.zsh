# +-------+
# | HOOKS |
# +-------+

# Init scripts: cached under $XDG_CACHE_HOME/zsh/gen, then sourced (_zsource
# is in cache.zsh). `command` bypasses shell functions these scripts define.
_zsource fzf      fzf      fzf --zsh && compdef _gnu_generic fzf
_zsource wt       wt       command wt config shell init zsh
_zsource mise     mise     command mise activate zsh
# mise prepends its tool dirs on activation and on each prompt: move Rex's back
# in front afterwards (precmd hooks run in order; see REX_BIN_DIR in .zshenv).
if [[ -n $REX_BIN_DIR ]]; then
	_rex_path_first () { path=("$REX_BIN_DIR" $path) }
	_rex_path_first
	add-zsh-hook precmd _rex_path_first
fi
_zsource zoxide   zoxide   zoxide init zsh --cmd=j # autojump with j
_zsource starship starship starship init zsh --print-full-init
