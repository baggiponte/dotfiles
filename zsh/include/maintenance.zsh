# +-------+
# | Utils |
# +-------+

# create a custom function to use gitignore.io to create .gitignore files
gi() { curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$1" ;}

# open in Finder
f() {
    if [ "$1" = "" ]; then
        open -a Finder ./
    else
        open -a Finder "$1"
    fi
}

# make a directory and cd into it
take () { command mkdir -p "$1" && cd "$1"; }

# create a python package
mkpkg () { command mkdir -p "$1" ; touch "$1/__init__.py" ; }

path () {
    print -e "${PATH//:/\\n}"
}

fpath (){
    print "${fpath}" | tr " " "\n"
}

config () {
    local config_dir="${XDG_CONFIG_HOME-"$HOME/.config"}"

    if [[ "$#" -eq 0 ]]; then
        cd "$config_dir" || return 1
    else
        cd "$config_dir/${1}" || print "$1 is not a valid config directory."
    fi
}

# open telescope in the current folder
nvim-update () {
    _requires nvim

    print "updating nvim plugins..."
    nvim --headless -c 'Lazy update | qall'
    print "done!"
}

zim-update () {
    _requires zimfw

    zimfw upgrade
    zimfw uninstall
    zimfw update
}

# update Homebrew
brew-update () {
    brew update
    brew upgrade
}

# clean homebrew
brew-cleanup () {

    # print "Removing unused formulae..." && brew leaves -p | parallel brew uninstall
    print "🧼 Removing unused formulae..." && brew autoremove

    print "🧼 Removing lockfiles and outdated downloads..." && brew cleanup -s

    local brew_cachedir
    brew_cachedir="$(brew --cache)"

    print "\n🧹 Cleaning $brew_cachedir..."

    local downloaddir="$brew_cachedir/downloads"
    local caskdir="$brew_cachedir/Cask"

    local formulaes=("$downloaddir"/*(N))
    local casks=("$caskdir"/*(N))
    local symlinks=("$brew_cachedir"/*(@N))

    # if the number of formulaes is not 0, then remove them
    # see: https://unix.stackexchange.com/a/313187/402599
    if (($#formulaes)); then
        print "* 📦 Removing formulae installers in $downloaddir" && rm -- "${formulaes[@]}"
    else
        print "* No formulae installers to remove"
    fi

    if (($#casks)); then
        print "* 📦 Removing cask installers in $caskdir" && rm -- "${casks[@]}"
    else
        print "* No cask installers to remove"
    fi

    if (($#symlinks)); then
        print "* 🔗 Removing symlinks in $brew_cachedir" && rm -- "${symlinks[@]}"
    else
        print "* No symlinks to remove"
    fi

    print "\n💾 Dumping formulae and casks to $(basename "$HOMEBREW_BUNDLE_FILE")..."
    if [ -s "$HOMEBREW_BUNDLE_FILE" ]; then
        mv "$HOMEBREW_BUNDLE_FILE" "$HOMEBREW_BUNDLE_FILE.bak"
    fi
    brew bundle dump --describe
}

brew-graph () {
    brew list -1 --formula | while read -r cask; do
    print -ne "\x1B[1;34m $cask \x1B[0m"
    brew uses "$cask" --installed | awk '{printf(" %s ", $0)}'
    print ""
    done
}

# +-------------------+
# | Almost never used |
# +-------------------+

# pretty print directory tree for git repos
ls-tree() {
    _requires exa
    local level="${1:-"1"}"
    local dir="${2:-"."}"

    exa "$dir" --tree --level "$level" --group-directories-first --all --git-ignore --ignore-glob .git
}

if [ -x /Applications/RStudio.app ]; then
    rstudio () {
        # check if there is an .Rproj file
        local files=(*.Rproj(N))

        # if the number of files is not 0, then remove them
        if [ $(($#files)) -eq 1 ]; then
            open -a RStudio "${files[1]}"
        elif [ $(($#files)) -gt 1 ]; then
            print "Multiple *.Rproj files found."
        else
            print "No .Rproj file found, just launching RStudio"
            open -a RStudio
        fi
    }
fi

td () {
    date +%Y-%m-%d
}

# trash files instead of `rm` them.
trash () { command mv "$@" ~/.Trash ; }

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
        *)          print "$1 cannot be extracted" ;;
    esac
    }

    for file in "$@"
    do
        if [ -f "$file" ]; then
            ex "$file"
        else
            print "'$file' is not a valid file"
        fi
    done
}

generate-pw () {
    local num_char="${1:-32}"

    openssl rand -base64 "$num_char" | tee /dev/tty | pbcopy
}

colortest () {
    fg=""
    bg=""
    for i in {0..255}; do
        a=$(printf "\\x1b[38;5;%sm%3d\\e[0m " "$i" "$i")
        b=$(printf "\\x1b[48;5;%sm%3d\\e[0m " "$i" "$i")
        fg+="$a"
        bg+="$b"
        if (( "$i" % 5 ==0 )); then
            print -e "$fg\\t\\t$bg"
            fg=""
            bg=""
        else
            fg+="  "
            bg+="  "
        fi
    done
}

# bulk rename extensions
rename-ext() {
    _requires fd

    local ext_old="$1"
    local ext_new="$2"

    fd -e "$ext_old" -x mv "{}" "{.}.$ext_new"
}

# python-latest () {
#
#     _requires rg sed
#
#     local version="$1"
#     local match
#     match="$(pyenv install -l | sed 's/  //g' | rg "^${version}" | sort | tail --lines=1)"
#
#     if [[ -n "$match" ]]; then
#         print "$match"
#     else
#         print "Python version ${match} does not exist."
#         return 1
#     fi
# }
#
# pyenv-upgrade-pip () {
#     if [[ "$#" -eq 0 ]]; then
#         typeset -a pyenv_versions=( $(pyenv versions --bare | rg -v 'system') )
#     else
#         pyenv_versions=("$@")
#     fi
#
#
#     for version in "${pyenv_versions[@]}"; do
#         rich --print "[bold]Upgrading [cyan]${version}[/]"
#         pyenv shell "$version" && pip install --upgrade pip setuptools;
#         print
#     done
#
#     # go back to default pyenv python
#     pyenv shell --unset
# }
