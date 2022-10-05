# +---------+
# | General |
# +---------+

# trash files instead of `rm` them.
trash () { command mv "$@" ~/.Trash ; }

# make a directory and cd into it
take () { command mkdir -p "$1" && cd "$1"; }

# create a custom function to use gitignore.io to create .gitignore files
gi() { curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$1" ;}

# extract files
extract() {
 ex() {
    case $1 in
        *.tar.bz2)  tar xjf "$1"      ;;
        *.tar.gz)   tar xzf "$1"      ;;
        *.bz2)      bunzip2 "$1"      ;;
        *.gz)       gunzip "$1"       ;;
        *.tar)      tar xf "$1"       ;;
        *.tbz2)     tar xjf "$1"      ;;
        *.tgz)      tar xzf "$1"      ;;
        *.zip)      unzip "$1"        ;;
        *.7z)       7z x "$1"         ;; # require p7zip
        *.rar)      7z x "$1"         ;; # require p7zip
        *.iso)      7z x "$1"         ;; # require p7zip
        *.Z)        uncompress "$1"   ;;
        *)          echo "$1 cannot be extracted" ;;
    esac
    }

    for file in "$@"
    do
        if [ -f "$file" ]; then
            ex "$file"
        else
            echo "'$file' is not a valid file"
        fi
    done
}

generate-pw () {
    local num_char="${1:-32}"

    openssl rand -base64 "$num_char" | tee /dev/tty | pbcopy
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
            open -a Finder "$1"
        fi
    }
fi

# brew specific
if hash brew 2>/dev/null; then

    # update Homebrew
    brew-update () {
        brew update
        brew upgrade
    }

    # clean homebrew
    brew-cleanup () {

        echo "Removing unused formulae..." && brew leaves -p | parallel brew uninstall

        echo "Removing lockfiles and outdated downloads..." && brew cleanup -s

        # get the list of all files
        local download_dir="$HOME/Library/Caches/Homebrew/downloads"
        local files=("$download_dir"/*(N))

        # if the number of files is not 0, then remove them
        # see: https://unix.stackexchange.com/a/313187/402599
        if (($#files)); then
            echo "Removing downloads in $download_dir" && rm -- "${files[@]}"
        else
            echo "No downloads to remove"
        fi

        echo "Dumping formulae and casks to $(basename "$HOMEBREW_BUNDLE_FILE")..."
        if [ -s "$HOMEBREW_BUNDLE_FILE" ]; then
            mv "$HOMEBREW_BUNDLE_FILE" "$HOMEBREW_BUNDLE_FILE.bak"
        fi
        brew bundle dump --describe
    }
fi

# +----------------+
# | Other commands |
# +----------------+

# pretty print directory tree for git repos
if hash exa 2>/dev/null; then
    ls-tree() {
        local level="${1:-"1"}"

        exa --tree --level "$level" --group-directories-first --all --git-ignore --ignore-glob .git
    }
fi

if hash nvim 2>/dev/null; then
    # open telescope in the current folder
    n () {
        if [ "$1" = "" ]; then
            nvim .
        else
            nvim "$1"
        fi
    }

    alias nrc='n $CONFIG/nvim'
    alias nsh='n $ZDOTDIR'

    nvim-update () {
        echo "updating nvim plugins..."
        nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
        echo "done!"
    }
fi

if command -v zimfw &>/dev/null; then
    zim-update () {
        zimfw upgrade
        zimfw uninstall
        zimfw update
    }
fi
