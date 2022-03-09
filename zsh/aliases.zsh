# +---------+
# | Aliases |
# +---------+

# hashes to cd faster into dirs without defining aliases
# see https://www.arp242.net/zshrc.html

    hash -d julia=$HOME/Documents/dev/julia-projects
    hash -d python=$HOME/Documents/dev/python-projects
    hash -d R=$HOME/Documents/dev/r-projects
    hash -d oai=$HOME/Documents/dev/oai
    hash -d dropbox="$HOME/Occupy AI Dropbox"

# exec $SHELL but faster
    alias e="exec $SHELL"

# utilities

    alias ...="cd ../../"
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
    
    alias n="/usr/local/bin/nvim"
    alias nrc="n $MYVIMRC"

# exa

    alias ls="exa --oneline --group-directories-first --icons --ignore-glob .DS_Store"
    alias l="ls --all"
    alias lig="ls --git-ignore"

    alias ll="l --long --git"

# bat
    alias bat="bat --plain"

# +-----------+
# | Functions |
# +-----------+

# trash files instead of `rm` them.
trash () { command mv "$@" ~/.Trash ; }

# make a directory and cd into it
take () { mkdir -p "$1" && cd "$1"; }

# create a custom function to use gitignore.io to create .gitignore files
gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}

# open in Finder
f() { 
    if [ "$1" = "" ]; then
        open -a Finder ./
    else 
        open -a Finder $1
    fi
}

# pretty print directory tree for git repos
tree-git() {
    local level="${1:-"1"}"

    exa --tree --level "$level" --group-directories-first --all --git-ignore --ignore-glob .git
}

# extract files
extract() {
 ex() {
    case $1 in
        *.tar.bz2)  tar xjf $1      ;;
        *.tar.gz)   tar xzf $1      ;;
        *.bz2)      bunzip2 $1      ;;
        *.gz)       gunzip $1       ;;
        *.tar)      tar xf $1       ;;
        *.tbz2)     tar xjf $1      ;;
        *.tgz)      tar xzf $1      ;;
        *.zip)      unzip $1        ;;
        *.7z)       7z x $1         ;; # require p7zip
        *.rar)      7z x $1         ;; # require p7zip
        *.iso)      7z x $1         ;; # require p7zip
        *.Z)        uncompress $1   ;;
        *)          echo "'$1' cannot be extracted" ;;
    esac
    }

    for file in "$@"
    do
        if [ -f $file ]; then
            ex $file
        else
            echo "'$file' is not a valid file"
        fi
    done
}

