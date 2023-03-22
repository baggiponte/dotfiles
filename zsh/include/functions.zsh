# +---------+
# | General |
# +---------+

path () {
    print -e "${PATH//:/\\n}"
}

fpath (){
    print "${fpath}" | tr " " "\n"
}

td () {
    date +%Y-%m-%d
}

config () {
    local config_dir="${XDG_CONFIG_HOME-"$HOME/.config"}"

    if [[ "$#" -eq 0 ]]; then
        cd "$config_dir" || return 1
    else
        cd "$config_dir/${1}" || print "$1 is not a valid config directory."
    fi
}

# trash files instead of `rm` them.
trash () { command mv "$@" ~/.Trash ; }

# make a directory and cd into it
take () { command mkdir -p "$1" && cd "$1"; }

# create a python package
mkpkg () { command mkdir -p "$1" ; touch "$1/__init__.py" ; }

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

# create a custom function to use gitignore.io to create .gitignore files
gi() { curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$1" ;}

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
# +--------------------------------------------------+
# | functions that require something to be installed |
# +--------------------------------------------------+

_check_is_installed () {

    for cmd in "$@"; do
        if ! command -v "$cmd" &>/dev/null; then
            print "$cmd not installed"
            return 1
        fi
    done
}

teal () {
    _check_is_installed tldr
    tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr
}

# pretty print directory tree for git repos
ls-tree() {
    _check_is_installed exa
    local level="${1:-"1"}"
    local dir="${2:-"."}"

    exa "$dir" --tree --level "$level" --group-directories-first --all --git-ignore --ignore-glob .git
}

# navigate history
hist () {
    _check_is_installed fzf

    fc -ln 0 | fzf --tac
}

# bulk rename extensions
rename-ext() {
    _check_is_installed fd

    local ext_old="$1"
    local ext_new="$2"

    fd -e "$ext_old" -x mv "{}" "{.}.$ext_new"
}

# fuzzy find preview
_fzf_preview () {
    _check_is_installed fzf

    fzf --preview="bat --color=always --style='plain,changes' --line-range=:500 {}"
}

# find files and pipe in fzf preview
_fuzzy_find_file () {
    _check_is_installed fd

    local pattern="${1:-"."}"

    fd -t=f "$pattern" -HI \
        -E .DS_Store \
        -E .git \
        -E .mypy_cache \
        -E .ruff_cache \
        -E .venv \
        -E __pycache__ \
        -E assets \
        -E raycast \
        -E tmux/plugins \
        | _fzf_preview
}

ff () { _fuzzy_find_file "$1" | pbcopy; }

# grep string and pipe in fzf preview
_fg () {
    _check_is_installed rg

    rg "$1" --files-with-matches | _fzf_preview
}

fg () { _fg "$1" | pbcopy; }

# open telescope in the current folder
nvim-update () {
    _check_is_installed nvim

    print "updating nvim plugins..."
    nvim --headless -c 'Lazy update | qall'
    print "done!"
}

n () {
    _check_is_installed nvim

    if [ "$1" = "" ]; then
        nvim -c 'Telescope find_files'
    elif [ -d "$1" ]; then
        nvim -c "Telescope find_files cwd=$1"
    else
        nvim "$1"
    fi
}

# open list of files with match
nn () {
    _check_is_installed nvim

    nvim "$(_fuzzy_find_file "$1")"
}

# open list of files that contain the match
ng () {
    _check_is_installed nvim

    nvim "$(_fg "$1")"
}

zoxide-clean () {
    zoxide query --list | fzf --multi --sort | xargs -I % sh -c "rich --print 'deleting [blue]%[/]'; zoxide remove %"
}

# open zoxide dir

_zoxide_with_preview () {
    _check_is_installed nvim zoxide

        local query="$1"
        local chosen_directory

        chosen_directory=$(
            zoxide query --list | fzf \
                --preview="exa --all --group-directories-first --icons --oneline --ignore-glob={.DS_Store,.git} {}" \
                --preview-window=down,40% \
                --preview-label=" content preview " \
                --query="$query"
        )

        cd "$chosen_directory" || return 1
}

jj () {
    _zoxide_with_preview "$1"
    nvim -c "Telescope find_files"
}

jk () {
    _zoxide_with_preview "$1"
    nvim -c "Telescope live_grep"
}

tn () {
    _check_is_installed tmux zoxide

    local zoxide_result
    zoxide_result=$(zoxide query "$1")

    if [ "$zoxide_result" = "" ]; then
        exit 1
    fi

    local target_folder
    target_folder=$(basename "$zoxide_result")

    local session_name
    session_name=$(print "$target_folder" | tr ' ' '_' | tr '.' '_' | tr ':' '_')

    local session
    session=$(tmux list-sessions -F '#S' | grep "^$session_name$")

    if [ "$TMUX" = "" ]; then
        if [ "$session" = "" ]; then
            cd "$zoxide_result" || exit 1
            tmux new-session -s "$session_name"
        else
            tmux attach -t "$session"
        fi
    else
        if [ "$session" = "" ]; then
            cd "$zoxide_result" || exit 1
            tmux new-session -d -s "$session_name"
            tmux switch-client -t "$session_name"
        else
            tmux switch-client -t "$session"
        fi
    fi
}

python-latest () {

    _check_is_installed rg sed

    local version="$1"
    local match
    match="$(pyenv install -l | sed 's/  //g' | rg "^${version}" | sort | tail --lines=1)"

    if [[ -n "$match" ]]; then
        print "$match"
    else
        print "Python version ${match} does not exist."
        return 1
    fi
}

pyenv-upgrade-pip () {
    if [[ "$#" -eq 0 ]]; then
        typeset -a pyenv_versions=( $(pyenv versions --bare | rg -v 'system') )
    else
        pyenv_versions=("$@")
    fi


    for version in "${pyenv_versions[@]}"; do
        rich --print "[bold]Upgrading [cyan]${version}[/]"
        pyenv shell "$version" && pip install --upgrade pip setuptools;
        print
    done

    # go back to default pyenv python
    pyenv shell --unset
}

zim-update () {
    _check_is_installed zimfw

    zimfw upgrade
    zimfw uninstall
    zimfw update
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

# +-------+
# | macOS |
# +-------+

# open in Finder
f() {
    if [ "$1" = "" ]; then
        open -a Finder ./
    else
        open -a Finder "$1"
    fi
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
