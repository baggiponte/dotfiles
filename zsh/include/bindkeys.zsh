# +---------------------------------------------------------------------+
# | Bindings                                                            |
# |                                                                     |
# | bind functions to keybindings                                       |
# | * https://thevaluable.dev/zsh-line-editor-configuration-mouseless/  |
# +---------------------------------------------------------------------+

zle -N live_grep
bindkey '^o' live_grep

zle -N fuzzy_find
bindkey '^p' fuzzy_find

# see: https://unix.stackexchange.com/a/703707/402599
_zle_zoxide() {
	zoxide-interactive
	zle -I
}

zle -N _zle_zoxide
bindkey '^j' _zle_zoxide
