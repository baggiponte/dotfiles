# +---------+
# | Aliases |
# +---------+

# # hashes to cd faster into dirs without defining aliases
# # see https://www.arp242.net/zshrc.html
# hash -d julia="$HOME/Documents/dev/julia-projects"
# hash -d python="$HOME/Documents/dev/python-projects"

alias e='exec $SHELL' # exec $SHELL but faster

# utilities
alias ...="../../"
alias path='echo -e ${PATH//:/\\n}'
alias fpath='echo ${fpath} | tr " " "\n"'
alias td='echo $(date +%Y-%m-%d)'
alias text="open -a TextEdit"

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

# +-----------+
# | Optionals |
# +-----------+

if [ -x /Applications/quarto/bin/quarto ]; then
    alias quarto=/Applications/quarto/bin/quarto
fi

if hash arduino-cli 2>/dev/null; then
    alias ar=arduino-cli
fi

if hash zoxide 2>/dev/null; then
    alias j=z
fi

if hash lazygit 2>/dev/null; then
    alias lg=lazygit
fi

if hash gsed 2>/dev/null; then
    alias sed=gsed        # gnu-sed (installed by homebrew)
fi

if hash gawk 2>/dev/null; then
    alias awk=gawk        # gnu-awk (installed by homebrew)
fi

if hash gmake 2>/dev/null; then
    alias make=gmake      # gnu-make (installed by homebrew)
fi

if hash dust 2>/dev/null; then
    alias dust="dust --reverse"
fi

if [ -x "$(brew --prefix)/bin/gzip" ]; then
    alias zip=gzip
    alias gzip='$(brew --prefix)/bin/gzip'
fi

if hash exa 2>/dev/null; then
    alias l="exa --all --group-directories-first --icons --oneline --ignore-glob .DS_Store"
    alias lig="ls --git-ignore"
    alias ll="l --long --git"
fi
