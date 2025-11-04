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

fzf-dir-widget () {
    fzf-dir
}
zle -N fzf-dir-widget

bindkey -M vicmd '^o' fzf-dir-widget
bindkey -M viins '^o' fzf-dir-widget

# +--------------------+
# | Zoxide interactive |
# +--------------------+

zi-widget () {
    cd "$(fzf-zoxide)"
}
zle -N zi-widget

bindkey -M vicmd '^n' zi-widget
bindkey -M viins '^n' zi-widget

# +-------------------------+
# | Git worktree navigator  |
# +-------------------------+

fzf-worktree-widget () {
    local selection exit_code

    if ! command -v fzf-git-worktrees >/dev/null 2>&1; then
        print -u2 "fzf-git-worktrees script not found in PATH."
        return 1
    fi

    selection=$(fzf-git-worktrees "$PWD")
    exit_code=$?

    if (( exit_code == 130 )); then
        return 0
    fi

    if (( exit_code != 0 )); then
        return $exit_code
    fi

    [[ -n $selection ]] || return 0

    if ! cd "$selection"; then
        print -u2 "Failed to change directory to $selection"
        return 1
    fi

    zle reset-prompt
}
zle -N fzf-worktree-widget

bindkey -M vicmd '^w' fzf-worktree-widget
bindkey -M viins '^w' fzf-worktree-widget
