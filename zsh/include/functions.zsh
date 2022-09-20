# +---------+
# | General |
# +---------+

# trash files instead of `rm` them.
trash () { command mv "$@" ~/.Trash ; }

# make a directory and cd into it
take () { command mkdir -p "$1" && command cd "$1"; }

# create a custom function to use gitignore.io to create .gitignore files
gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/"$@" ;}

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

# +-------+
# | macOS |
# +-------+

# open in Finder
if [ "$(sysctl -n kern.ostype)" = "Darwin" ]; then

    f() {
        if [ "$1" = "" ]; then
            open -a Finder ./
        else
            open -a Finder $1
        fi
    }
fi

# brew specific
if hash brew 2>/dev/null; then

    # update Homebrew
    brew-update () {
        brew update && brew upgrade
    }

    # clean homebrew
    brew-cleanup () {
        if [[ ! -v HOMEBREW_BUNDLE_FILE ]]; then
            echo "HOMEBREW_BUNDLE_FILE is not defined: exiting script"
            exit 1
        fi

        echo "Removing unused formulae..." && brew leaves -p | xargs -L 1 brew uninstall

        echo "Removing lockfiles and outdated downloads..." && brew cleanup -s

        echo "Removing downloads in ~/Library/Caches/Homebrew/downloads..." && rm -r ~/Library/Caches/Homebrew/downloads/*

        echo "Dumping formulae and casks to Brewfile..."

        pushd "$(dirname $HOMEBREW_BUNDLE_FILE)"
        mv Brewfile Brewfile.bak
        brew bundle dump --describe --no-upgrade
        popd
    }
fi

# +----------------+
# | Other commands |
# +----------------+

# pretty print directory tree for git repos
if command -v exa 2>/dev/null; then
    ls-tree() {
        local level="${1:-"1"}"

        exa --tree --level "$level" --group-directories-first --all --git-ignore --ignore-glob .git
    }
fi

if hash nvim 2>/dev/null; then
    # open ntrw or nvim
    n () {
        if [ "$1" = "" ]; then
            nvim .
        else
            nvim "$1"
        fi
    }

    alias nrc="n $CONFIG/nvim"
    alias nsh="n $ZDOTDIR"
fi
