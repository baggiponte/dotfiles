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

fzf-live-widget () {
    fzf-live
}
zle -N fzf-live-widget
bindkey -M viins '^g' fzf-live-widget
bindkey -M vicmd '^g' fzf-live-widget

# +------------------+
# | Fuzzy find files |
# +------------------+

fzf-file-widget () {
    fzf-file
}
zle -N fzf-file-widget

bindkey -M vicmd '^f' fzf-file-widget
bindkey -M viins '^f' fzf-file-widget

# +------------------------+
# | Fuzzy find directories |
# +------------------------+

yazi-dir-widget () {
    local dir
    dir=$(fd --hidden --exclude=.git | fzf)

    yazi "${dir:-.}"
}
zle -N yazi-dir-widget

bindkey -M vicmd '^o' yazi-dir-widget
bindkey -M viins '^o' yazi-dir-widget

# +--------------------+
# | Zoxide interactive |
# +--------------------+

zi-widget () {
    cd "$(fzf-zoxide)"
}
zle -N zi-widget

bindkey -M vicmd '^n' zi-widget
bindkey -M viins '^n' zi-widget
