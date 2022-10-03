# +---------+
# | Aliases |
# +---------+

# hashes to cd faster into dirs without defining aliases
# see https://www.arp242.net/zshrc.html
hash -d julia="$HOME/Documents/dev/julia-projects"
hash -d python="$HOME/Documents/dev/python-projects"

alias e='exec $SHELL' # exec $SHELL but faster
alias lg=lazygit      # lazygit

if hash colordiff 2>/dev/null; then
    alias diff=colordiff
fi

if hash gawk 2>/dev/null; then
    alias awk=gawk
fi

if hash gmake 2>/dev/null; then
    alias make=gmake      # gnu-make (installed by homebrew)
fi

if [ -x "$(brew --prefix)/bin/gzip" ]; then
    alias zip=gzip
    alias gzip='$(brew --prefix)/bin/gzip'
fi

# utilities
alias ...="../../"
alias path='echo -e ${PATH//:/\\n}'
alias efpath='echo ${fpath} | tr " " "\n"'
alias td='echo $(date +%Y-%m-%d)'

# homebrew
alias b=brew
alias bi="b install"
alias bic="bi --cask"

alias bu="b uninstall"
alias buc="bu --cask"

alias bcs="b cleanup -s" # scrub the cache

alias bl="b list"
alias blf="bl --formula"
alias blc="bl --cask"

alias bd="b doctor"

# open programs faster
alias text="open -a TextEdit"

# exa
alias l="exa --all --group-directories-first --icons --oneline --ignore-glob .DS_Store"
alias lig="ls --git-ignore"
alias ll="l --long --git"
