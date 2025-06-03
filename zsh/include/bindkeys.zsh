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

telescope-live-grep() {
    nvim -c "Telescope live_grep"
}

zle -N telescope-live-grep
bindkey '^g' telescope-live-grep

# +------------------+
# | Fuzzy find files |
# +------------------+

telescope-file() {
  nvim -c "Telescope find_files"
}

zle -N telescope-file
bindkey '^f' telescope-file
