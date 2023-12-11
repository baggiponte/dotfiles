# +-------------------------------------------+
# | Almost always require an external command |
# +-------------------------------------------+

IGNORES=(
    ".git"
    "assets"
    ".DS_Store"
    "raycast"
    ".idea"
    ".vscode"
    ".Rproj.user"
    "renv/"
    ".venv"
    "venv"
    ".ipynb_checkpoints"
    ".mypy_cache"
    ".pytest_cache"
    ".ruff_cache"
    "__pycache__"
    "debug/"
    "target/"
    ".terraform"
    "node_modules/"
)

# prepend "-E " to each element of ignores
IGNORES_FD=("${IGNORES[@]/#/-E=}")

# chain every ignore in `ignore1|ignore2` format
IGNORES_EXA="${(j:|:)IGNORES}"

CMD_PREVIEW_BAT="bat --color=always --style='plain,changes' --line-range=:500 -- {}"
CMD_PREVIEW_EXA="exa --all --group-directories-first --icons --level=2 --tree --ignore-glob=\"$IGNORES_EXA\" -- {}"

# find files and pipe in sk/fzf preview with bat
_fuzzy-file() {
	requires fd sk bat

	local pattern="$1"

    fd --type=file --unrestricted "${IGNORES_FD[@]}" |
        sk \
        --preview="$CMD_PREVIEW_BAT" \
        --query="$pattern"
}

# find directories and pipe in sk/fzf preview with exa
_fuzzy-dir() {
    requires fd sk bat

    local pattern="$1"

    # `sk --cmd` does not work with zle
    fd --type=directory --unrestricted "${IGNORES_FD[@]}" |
        sk \
        --preview="$CMD_PREVIEW_EXA" \
        --query="$pattern"
}

# live grep and pipe in sk/fzf preview with bat
_live-grep() {
	requires rg sk bat

	local pattern="$1"

	rg \
		--hidden \
		--color=always \
		--line-number \
		--no-heading \
		--smart-case "${*:-}" |
		sk \
			--ansi \
			--color "hl:-1:underline,hl+:-1:underline:reverse" \
			--delimiter : \
			--preview 'bat --color=always {1} --highlight-line {2} --plain' \
			--query "$pattern"
}

fuzzy-file() {
	requires nvim

	local pattern="$1"
	local file
	file="$(_fuzzy-file "$pattern")"

	if [[ -z "$file" ]]; then
		return 1
	else
		nvim -- "$file"
	fi
}

fuzzy-dir() {
    requires nvim

    local filemanager_cmd="${NVIM_FILEMANAGER_CMD:-"NvimTreeToggle"}"

    local pattern="$1"
    local dir
    dir="$(_fuzzy-dir "$pattern")"

    if [[ -z "$dir" ]]; then
        return 1
    else
        nvim -c "${filemanager_cmd} ${dir}"
    fi
}

live-grep() {
	requires nvim

	local pattern="$1"
	local file
	file="$(_live-grep "$pattern" | cut -d : -f 1,2)"

	if [[ -z "$file" ]]; then
		return 1
	else
		nvim +"${file#*:}" -c "normal zz" -- "${file%:*}"
	fi
}

zoxide-interactive() {
	requires zoxide sk

	local query="$1"
	local chosen_directory

	chosen_directory=$(
		zoxide query \
			--exclude "$PWD" \
			--list |
        sk \
            --preview="$CMD_PREVIEW_EXA" \
            --height 40% \
            --preview-window=down,40% \
            --query="$query"
	)

	cd -- "$chosen_directory" || return 1
}

# +-------+
# | Utils |
# +-------+

path() { print "${PATH//:/\\n}" }

fpath() { print "${fpath}" | tr " " "\n" }

take () { command mkdir -p "$1" && cd "$1"; }

tmp() {
    local dir="$1"
    local dest="/tmp/${dir}"
    mkdir -p "${dest}"

    cd "${dest}" || return 1
}

config() {
    local config_dir="${XDG_CONFIG_HOME-"$HOME/.config"}"

    if [[ "$#" -eq 0 ]]; then
        cd -- "$config_dir" || return 1
    else
        cd -- "$config_dir/${1}" || print "$1 is not a valid config directory."
    fi
}

zim-update () {
    print -- "\n🐚 $fg_bold[white]Let's fish some new shells!$reset_color 🐚"

    zimfw upgrade && zimfw uninstall && zimfw update
}
