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

    alias blf="b list --formula"
    alias blc="b list --cask"
    
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

# git

    # dont use these: they will prevent you from learning git the right way
    # alias gst="git status"
    # alias gsti="gst --ignored"
    # alias ga="git add"
    # alias gc="git commit"
    # alias gpom="git push origin main"

    # I know you will be looking for this:
    # git remote add origin [repo-url]
    # to change it:
    # git remote set-url origin [repo-url]

# conda

    # conda is terrible because it does not have autocompletion on its own:
    # so one day I will have to set this up: https://github.com/esc/conda-zsh-completion
    # in the meantime: https://www.anaconda.com/wp-content/uploads/2019/03/2019-Conda-Cheatsheet.pdf

    # # deactivating because they prevent you from learning the right commands
    # alias c="conda"
    # alias cca="c clean --all" # clean tarballs
    # alias cer="c env remove" # remove env; -n <env-name>
    # alias cua="c update --all" # update packages; -n <env-name> 
    
    # # activate and deactivate envs
    # alias ca="c activate"
    # alias cda="c deactivate"
    
    # # packages; can always specify `--name/-n ENVNAME` to execute in a specific env
    # alias ci="c install"
    # alias cu="c uninstall"

    # # for environments
    # alias cinfo="c info" # info about conda
    # # cie and cel are equivalent
    # alias cel="conda env list" # list environments
    # alias cie="cinfo --envs" # list environments

    # # list packages
    # alias cl="c list" # list packages
    # alias cle="cl --export" # list packages as requirements
