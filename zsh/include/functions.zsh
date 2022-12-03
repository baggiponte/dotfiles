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
        cd "$config_dir" || exit
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
# +----------------+
# | Other commands |
# +----------------+

# see: https://ipython.readthedocs.io/en/stable/install/kernel_install.html#kernels-for-different-environments

if hash python 2>/dev/null; then

    pyenv-upgrade-pip () {
        if [[ "$#" -eq 0 ]]; then
            declare -a pyenv_versions=($(pyenv versions --bare | grep -E --invert-match '/envs/'))
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

    jupyter-kernel-install () {
        if [ -z "${VIRTUAL_ENV}" ]; then
            echo "'VIRTUAL_ENV' is unset. Either activate a virtual environment or set a local python version with 'pyenv local <env-name>'."
            exit 1
        fi

        local kernel_name="$1"
        local display_name="$2"
        python -m ipykernel install --user --name "$kernel_name" --display-name "$display_name"
    }

    ipython-kernel-install () {
        if [ -z "${VIRTUAL_ENV}" ]; then
            echo "'VIRTUAL_ENV' is unset. Either activate a virtual environment or set a local python version with 'pyenv local <env-name>'."
            exit 1
        fi

        local kernel_name="$1"
        local display_name="$2"

        # do not use XDG_DATA_HOME because ipython will create a `share` directory anyway
        local kernel_prefix="${HOME}/.local"
        local kernel_dir="${JUPYTER_DATA_DIR:-"${kernel_prefix}/share/jupyter"}/kernels"
        local kernel="${kernel_dir}/${kernel_name}/kernel.json"

        local python_path="${VIRTUAL_ENV}/bin/python"

        "$PIPX_BIN_DIR/ipython" kernel install \
            --name="$kernel_name" \
            --display-name="$display_name" \
            --prefix="$kernel_prefix"


        jq --arg p "${python_path}" '.argv[0] |= $p' "${kernel}" > "${kernel}.bak"

        rm "${kernel}" && mv "${kernel}.bak" "${kernel}"

        echo "kernel installed. In order to work, 'ipykernel' must be installe in the virtuale environment."
    }
fi

# navigate history
if hash fzf 2>/dev/null; then
    hist () { history 1 | fzf | pbcopy ; }
fi

# bulk rename extensions
if hash fd 2>/dev/null; then
    rename-ext() {
        local ext_old="$1"
        local ext_new="$2"

        fd -e "$ext_old" -x mv "{}" "{.}.$ext_new"
}
fi

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
            nvim -c "Telescope zoxide list"
        elif [ -d "$1" ]; then
            nvim -c "Telescope find_files" "$1"
        else
            nvim "$1"
        fi
    }
    nvim-update () {
        echo "updating nvim plugins..."
        nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
        echo "done!"
    }
fi

# has to use command -v as zimfw is actually sourced
if command -v zimfw &>/dev/null; then
    zim-update () {
        zimfw upgrade
        zimfw uninstall
        zimfw update
    }
fi

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

    brew-graph () {
        brew list -1 --formula | while read -r cask; do
        echo -ne "\x1B[1;34m $cask \x1B[0m"
        brew uses "$cask" --installed | awk '{printf(" %s ", $0)}'
        echo ""
        done
    }
fi
