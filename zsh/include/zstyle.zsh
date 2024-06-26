# +-----------------+
# | COMPLETION MENU |
# +-----------------+

zmodload zsh/complist

# colors for print
autoload -Uz colors && colors

# use vim keys to navigate the menu selection
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# type of completion, e.g. suggests correction if there's a typo
zstyle ':completion:*' completer _extensions _complete _approximate

# enable completion menu
zstyle ':completion:*' menu select

# syntax highlight for file completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --tree --level=2 --group-directories-first $realpath'
zstyle ':fzf-tab:complete:j:*' fzf-preview 'eza --color=always --tree --level=2 --group-directories-first $realpath'

# use cache for tab completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
# use only if you use zmodule completion in your .zimrc: https://github.com/zimfw/completion#settings
# zstyle ':zim:completion' dumpfile "$XDG_CACHE_HOME/zsh/zcompdump"

# descriptors and corrections
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''

# case insensitivity and tab expansion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
