# +---------+
# | General |
# +---------+

path () {
    echo -e "${PATH//:/\\n}"
}

fpath (){
    echo "${fpath}" | tr " " "\n"
}

td () {
    date +%Y-%m-%d
}

config () {
    local config_dir="${XDG_CONFIG_HOME-"$HOME/.config"}"

    if [[ "$#" -eq 0 ]]; then
        cd "$config_dir" || return 1
    else
        cd "$config_dir/${1}" || echo "$1 is not a valid config directory."
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
            echo -e "$fg\\t\\t$bg"
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
            echo "$cmd not installed"
            return 1
        fi
    done
}

tealdeer () {
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

    fzf --preview="bat --color=always --style='plain,changes' --line-range=:500 {}";
}

# find files and pipe in fzf preview
_ff () {
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

ff () { _ff "$1" | pbcopy; }

# grep string and pipe in fzf preview
_fg () {
    _check_is_installed rg

    rg "$1" --files-with-matches | _fzf_preview
}

fg () { _fg "$1" | pbcopy; }

# open telescope in the current folder
nvim-update () {
    _check_is_installed nvim

    echo "updating nvim plugins..."
    nvim --headless -c 'Lazy update | qall'
    echo "done!"
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

    nvim "$(_ff "$1")"
}

# open list of files that contain the match
ng () {
    _check_is_installed nvim

    nvim "$(_fg "$1")"
}

# open zoxide dir
j () {
    _check_is_installed nvim fzf zoxide

    local chosen_directory

    chosen_directory=$(zoxide query --list | fzf --sort)

    cd "$chosen_directory" || return 1

    nvim -c "Telescope find_files"
}

python-latest () {

    _check_is_installed rg sed

    local version="$1"
    local match
    match="$(pyenv install -l | sed 's/  //g' | rg "^${version}" | sort | tail --lines=1)"

    if [[ -n "$match" ]]; then
        print "$match"
    else
        echo "Python version ${match} does not exist."
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
        echo
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
            echo "Multiple *.Rproj files found."
        else
            echo "No .Rproj file found, just launching RStudio"
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

brew-graph () {
    brew list -1 --formula | while read -r cask; do
    echo -ne "\x1B[1;34m $cask \x1B[0m"
    brew uses "$cask" --installed | awk '{printf(" %s ", $0)}'
    echo ""
    done
}
