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

bindkey -s '^g' "~/.local/bin/fzf-live\n"

# +------------------+
# | Fuzzy find files |
# +------------------+

bindkey -s '^f' "~/.local/bin/fzf-file\n"
bindkey -s '^F' "nvim -c 'Telescope find_files'\n"
