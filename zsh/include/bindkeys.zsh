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

__fzf_find_git_root() {
    local dir=$PWD

    for level in {0..5}; do
        if [[ -d "$dir/.git" || -f "$dir/.git" ]]; then
            printf '%s\n' "$dir"
            return 0
        fi

        [[ $dir == "/" ]] && break
        dir="${dir:h}"
    done

    return 1
}

fzf-worktree-widget () {
    local git_root selection

    if ! command -v git >/dev/null 2>&1; then
        print -u2 "git not installed."
        return 1
    fi

    if ! command -v fzf >/dev/null 2>&1; then
        print -u2 "fzf not installed."
        return 1
    fi

    git_root="$(__fzf_find_git_root)" || {
        print -u2 "Not inside a git worktree (searched up to 5 levels)."
        return 1
    }

    selection=$(git -C "$git_root" worktree list --porcelain 2>/dev/null | \
        awk '/^worktree /{sub(/^worktree /, ""); print}' | \
        fzf --tmux=90% --prompt='worktree> ')

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
