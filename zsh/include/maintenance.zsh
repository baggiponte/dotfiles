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
    print "${PATH//:/\\n}"
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

# update Homebrew
brew-update () {
    requires brew

    print -- "\n🍺 $fg_bold[white]Check out new bottles and casks from the brew!$reset_color 🍺"

    brew update && brew upgrade
}

zim-update () {
    requires zimfw

    print -- "\n🐚 $fg_bold[white]Let's fish some new shells!$reset_color 🐚"

    zimfw upgrade && zimfw uninstall && zimfw update
}

# clean homebrew
brew-cleanup () {
    
    print -- "\n🧹 $fg_bold[white]Cellar cleanup duties coming up!$reset_color 🧼"

    local brew_cachedir
    brew_cachedir="$(brew --cache)"
    local downloaddir="$brew_cachedir/downloads"
    local caskdir="$brew_cachedir/Cask"

    local formulaes=("$downloaddir"/*(N))
    local casks=("$caskdir"/*(N))
    local symlinks=("$brew_cachedir"/*(@N))

    # print "Removing unused formulae..." && brew leaves -p | parallel brew uninstall
    print -x 2 "\t* Removing unused formulae..." && brew autoremove
    print -x 2 "\t* Removing lockfiles and outdated downloads..." && brew cleanup -s

    print -x 2 "\t* Cleaning $brew_cachedir..."
    # if the number of formulaes is not 0, then remove them
    # see: https://unix.stackexchange.com/a/313187/402599
    if (($#formulaes)); then
        print -x 4 "\t* Removing formulae installers in $downloaddir" && rm -- "${formulaes[@]}"
    fi

    if (($#casks)); then
        print -x 4 "\t* Removing cask installers in $caskdir" && rm -- "${casks[@]}"
    fi

    if (($#symlinks)); then
        print -x 4 "\t* Removing symlinks in $brew_cachedir" && rm -- "${symlinks[@]}"
    fi

    print -x 2 "\t* Dump formulae and casks to $(basename "$HOMEBREW_BUNDLE_FILE")..."
    [ -s "$HOMEBREW_BUNDLE_FILE" ] && mv "$HOMEBREW_BUNDLE_FILE" "$HOMEBREW_BUNDLE_FILE.bak"
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
    requires exa
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
    requires fd

    local ext_old="$1"
    local ext_new="$2"

    fd -e "$ext_old" -x mv "{}" "{.}.$ext_new"
}
