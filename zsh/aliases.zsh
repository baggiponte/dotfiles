# Aliases

# hashes to cd faster into dirs without defining aliases
# see https://www.arp242.net/zshrc.html

    hash -d julia=$HOME/Documents/dev/julia-projects
    hash -d python=$HOME/Documents/dev/python-projects
    hash -d R=$HOME/Documents/dev/r-projects
    hash -d oai=$HOME/Documents/dev/oai

# exec $SHELL but faster
    alias e="exec $SHELL"

# utilities

    alias ...="cd ../../"
    alias path='echo -e ${PATH//:/\\n}'
    alias fpath='echo ${fpath} | tr " " "\n"'
    alias td='echo $(date +%Y-%m-%d)'

# mamba
    alias mamba='mamba --no-banner' # avoid banner when executing commands

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
    
    alias n="/usr/local/bin/nvim"
    alias nrc="n $MYVIMRC"

# exa

    alias ls="exa --group-directories-first --icons --ignore-glob .DS_Store"
    alias l="ls --all"

    alias ll="l --long --git"
