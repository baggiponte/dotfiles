# +-----------------------+
# | aliases and functions |
# +-----------------------+

for FILE in "$ZDOTDIR"/*.zsh; do
    # `.` executes the code it reads from a file
    . "$FILE"
done

# +---------------+
# | init binaries |
# +---------------+

[ -f "$CONFIG/broot/launcher/bash/br" ] && . "$CONFIG/broot/launcher/bash/br"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(jump shell zsh)"

__conda_setup="$('$CONDA_ROOT/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
        . "$CONDA_ROOT/etc/profile.d/conda.sh" 
    else
        export PATH="$CONDA_ROOT/bin:$PATH"
    fi
fi
unset __conda_setup

# +---------+
# | plugins |
# +---------+

source "/usr/local/opt/zinit/zinit.zsh"

# load plugins
# see here: https://github.com/zdharma/fast-syntax-highlighting/
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit light ael-code/zsh-colored-man-pages
zinit light supercrabtree/k
zinit light b4b4r07/enhancd

# +--------+
# | prompt |
# +--------+

# option A: pure
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

# option B: starship
# eval "$(starship init zsh)" # starship is managed in $HOME/.config/starship.toml

# +-------------+
# | zsh setopts |
# +-------------+

# references:
# https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/
# https://linux.die.net/man/1/zshoptions

# cd without writing cd and cd into variables
setopt autocd cdablevars
# automatically push into stack; do not push duplicates
setopt autopushd pushdignoredups
# don't include duplicates in history, don't add to hist if preceeded by space
setopt histignoredups histignorespace
# case insensitive globbing
setopt nocaseglob
# lets files beginning with a . be matched without explicitly specifying the dot
setopt globdots
# complete from both ends
setopt completeinword

# +-----------------+
# | zsh completions |
# +-----------------+

# reference:
# https://thevaluable.dev/zsh-completion-guide-examples/
# https://stackoverflow.com/questions/67136714/how-to-properly-call-compinit-and-bashcompinit-in-zsh

zmodload zsh/complist

# enable completion menu
zstyle ':completion:*' menu select

# use cache for completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/.zcompcache"

# descriptors and corrections
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''

# case insensitivity and tab expansion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# load prompt
autoload -U promptinit; promptinit
prompt pure

# initialise the completion system 
autoload -Uz compinit && compinit
_comp_options+=(globdots)		# Include hidden files.

autoload -Uz bashcompinit && bashcompinit
eval "$(register-python-argcomplete pipx)"
