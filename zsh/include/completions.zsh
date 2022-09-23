# +-------------+
# | ZSH SETOPTS |
# +-------------+

setopt complete_in_word         # tab completion works from both sides
setopt extended_glob            # use extended globbing syntax.
setopt no_case_glob             # case insentive globbing
setopt glob_dots                # match dotfiles without specifying the dot

setopt auto_cd                  # go to folder path without using cd.
setopt cdable_vars              # change directory to a path stored in a variable.

setopt auto_pushd               # push the old directory onto the stack on cd.
setopt pushd_ignore_dups        # do not store duplicates in the stack.
setopt pushd_silent             # do not print the directory stack after pushd or popd.

setopt extended_history         # write the history file in the ':start:elapsed;command' format.
setopt share_history            # share history between all sessions.
setopt hist_expire_dups_first   # expire a duplicate event first when trimming history.
setopt hist_ignore_dups         # do not record an event that was just recorded again.
setopt hist_ignore_all_dups     # delete an old recorded event if a new event is a duplicate.
setopt hist_find_no_dups        # do not display a previously found event.
setopt hist_ignore_space        # do not record an event starting with a space.
setopt hist_save_no_dups        # do not write a duplicate event to the history file.
setopt hist_verify              # do not execute immediately upon history expansion.
setopt hist_reduce_blanks       # remove blank lines

# +---------------------+
# | ZSH COMPLETION MENU |
# +---------------------+

zmodload zsh/complist

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

# +-------------------+
# | OTHER COMPLETIONS |
# +-------------------+

# NOTE: if autocompletion does not work, remove
# $XDG_CACHE_HOME/zsh/zcompdump and run compinit
fpath=($XDG_CACHE_HOME/zsh/zfunc $fpath)

if [ -s $XDG_CACHE_HOME/zsh/zfunc/_pdm ]; then
  pdm completion zsh > $XDG_CACHE_HOME/zsh/zfunc/_pdm
fi
