# +-----------+
# | Functions |
# +-----------+

# open ntrw or nvim
n () {
    if [ "$1" = "" ]; then
        nvim .
    else
        nvim "$1"
    fi
}

alias nrc="n $CONFIG/nvim"

# trash files instead of `rm` them.
trash () { command mv "$@" ~/.Trash ; }

# make a directory and cd into it
take () { mkdir -p "$1" && cd "$1"; }

# create a custom function to use gitignore.io to create .gitignore files
gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/"$@" ;}

# open in Finder
f() {
    if [ "$1" = "" ]; then
        open -a Finder ./
    else
        open -a Finder $1
    fi
}

# pretty print directory tree for git repos
ls-tree() {
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

# create new kernel for jupyter notebooks
jupyter-kernel-install () {
    ipython kernel install --user --name "$1" --display-name "$2" --sys-prefix
}

jupyter-kerneldir-open () {
    f $JUPYTER_KERNEL_DIR
}
