# +---------------------------------------------------------------------+
# | Bindings                                                            |
# |                                                                     |
# | bind functions to keybindings                                       |
# | * https://thevaluable.dev/zsh-line-editor-configuration-mouseless/  |
# +---------------------------------------------------------------------+

zle -N live_grep
bindkey '^g' live_grep

zle -N fuzzy_find
bindkey '^f' fuzzy_find

# see: https://unix.stackexchange.com/a/703707/402599
_zle_zoxide() {
	zoxide-interactive
	zle -I
}

zle -N _zle_zoxide
bindkey '^w' _zle_zoxide

_zle_zoxide_live_grep() {
	zoxide-interactive
	zle -I
	live_grep
}

zle -N _zle_zoxide_live_grep
bindkey '^O' _zle_zoxide_live_grep

_zle_zoxide_fuzzy_find() {
	zoxide-interactive
	zle -I
	fuzzy_find
}

zle -N _zle_zoxide_fuzzy_find
bindkey '^P' _zle_zoxide_fuzzy_find
