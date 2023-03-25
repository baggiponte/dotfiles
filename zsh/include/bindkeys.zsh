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
