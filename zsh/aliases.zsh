# Aliases

# list dirs
    alias d='dirs -v'

# exec $SHELL but faster
    alias e="exec $SHELL"

# utilities

    # alias ..="cd .." # not needed if setopt autocd
    alias ...="cd ../../"
    alias path='echo -e ${PATH//:/\\n}'

# cd laziness

    # for cloud storage
    # using parameter substitution is necessary to escape special characters and have it behave as expected
    # ${(q)} is typical to zsh, bash works differently
    alias onedrive="cd ${(q)ONEDRIVE}"
    alias gdrive="cd ${(q)GDRIVE_UNI}"
    alias cduni="cd $UNI"
    alias colab="cd ${(q)COLAB}"

# homebrew

    alias b=brew
    alias bi="b install"
    alias bic="bi --cask"
    
    alias bu="b uninstall"
    alias buc="bu --cask"

    alias bug="b upgrade --greedy"

    alias bcs="b cleanup -s" # scrub the cache

    alias bl="b list"
    alias blf="bl --formula"
    alias blc="bl --cask"
    
    alias bd="b doctor"
    alias bo="b outdated"

# open programs faster

    alias text="open -a TextEdit"
    alias rstudio="open -a RStudio"
    
    alias n="/usr/local/bin/nvim"
    alias nrc="n ${MYVIMRC}"

    alias jn="jupyter-notebook"
    alias jl="jupyter-lab"

# exa

    alias ls="exa --group-directories-first --icons"
    alias l="ls --all"

    alias ll="l --long --git"

# postgres 

    alias pgadmin="open -a pgAdmin\ 4"
    alias pgstart="pg_ctl start"
    alias pgstatus="pg_ctl status"
    alias pgstop="pg_ctl stop"