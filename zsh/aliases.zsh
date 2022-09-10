# +---------+
# | Aliases |
# +---------+

# hashes to cd faster into dirs without defining aliases
# see https://www.arp242.net/zshrc.html
    hash -d julia=$HOME/Documents/dev/julia-projects
    hash -d python=$HOME/Documents/dev/python-projects
    hash -d R=$HOME/Documents/dev/r-projects
    hash -d oai=$HOME/Documents/dev/oai

# exec $SHELL but faster
    alias e="exec $SHELL"

# lazygit
    alias lg=lazygit


# nnn (file browser)
    alias nnn"nnn -H"

# gnu-make
# the one installed by homebrew is gnumake
    alias make=gmake

# utilities
    alias ...="../../"
    alias path='echo -e ${PATH//:/\\n}'
    alias fpath='echo ${fpath} | tr " " "\n"'
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
    alias rstudio="open -a RStudio"
    alias pgadmin="open -a pgAdmin\ 4"

# exa
    alias ls="exa --oneline --group-directories-first --icons --ignore-glob .DS_Store"
    alias l="ls --all"
    alias lig="ls --git-ignore"

    alias ll="l --long --git"

# bat
    alias bat="bat --plain"
