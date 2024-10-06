# +---------------------------------------------------------------------+
# | Bindings                                                            |
# |                                                                     |
# | bind functions to keybindings                                       |
# | * https://thevaluable.dev/zsh-line-editor-configuration-mouseless/  |
# +---------------------------------------------------------------------+

# +-------------------------+
# | Edit command in $EDITOR |
# +-------------------------+

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# +-----------+
# | Live grep |
# +-----------+

zle -N live-grep
bindkey '^g' live-grep

# +------------------+
# | Fuzzy find files |
# +------------------+

zle -N fuzzy-file
bindkey '^f' fuzzy-file

zle -N fuzzy-dir
bindkey '^n' fuzzy-dir

# +------------------------+
# | Fuzzy find directories |
# +------------------------+

zle -N fuzzy-dir
bindkey '^a' fuzzy-dir
