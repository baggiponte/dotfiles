# +-------------------------------------------+
# | Almost always require an external command |
# +-------------------------------------------+

IGNORES=(
    "*.egg-info"
    ".DS_Store"
    ".Rproj.user"
    ".coverage"
    ".git/"
    ".idea/"
    ".ipynb_checkpoints/"
    ".jj/"
    ".mypy_cache/"
    ".pytest_cache/"
    ".ruff_cache/"
    ".terraform"
    ".venv/"
    ".vscode/"
    "__pycache__/"
    "assets/"
    "coverage.xml"
    "debug/"
    "htmlcov/"
    "node_modules/"
    "renv/"
    "target/"
    "venv/"
)

# prepend "-E " to each element of ignores
IGNORES_FD=("${IGNORES[@]/#/-E=}")

# chain every ignore in `ignore1|ignore2` format
IGNORES_EZA="${(j:|:)IGNORES}"

CMD_PREVIEW_BAT="bat --color=always --style='plain,changes' --line-range=:500 -- {}"
CMD_PREVIEW_EZA="eza --all --group-directories-first --icons --level=2 --tree --ignore-glob=\"$IGNORES_EZA\" -- {}"

# find files and pipe in sk/fzf preview with bat
_fuzzy-file() {
	requires fd fzf bat

	local pattern="$1"

    fd --type=file --unrestricted "${IGNORES_FD[@]}" |
        fzf \
        --preview="$CMD_PREVIEW_BAT" \
        --query="$pattern"
}

# find directories and pipe in sk/fzf preview with eza
_fuzzy-dir() {
    requires fd fzf bat

    local pattern="$1"

    # `sk --cmd` does not work with zle
    fd --type=directory --unrestricted "${IGNORES_FD[@]}" |
        fzf \
        --preview="$CMD_PREVIEW_EZA" \
        --query="$pattern"
}

# live grep and pipe in sk/fzf preview with bat
_live-grep() {
	requires rg fzf bat

	local pattern="$1"

	rg \
		--hidden \
		--color=always \
		--line-number \
		--no-heading \
		--smart-case "${*:-}" |
		fzf \
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

    local filemanager_cmd="${NVIM_FILEMANAGER_CMD:-"Neotree"}"

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
	requires zoxide fzf

	local query="$1"
	local chosen_directory

	chosen_directory=$(
		zoxide query \
			--exclude "$PWD" \
			--list |
        fzf \
            --preview="$CMD_PREVIEW_EZA" \
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

tmp() { cd "$(mktemp -t scratch --directory)" }

cleanup() { rm -rf * }

leave() {
    local here="${PWD}"
    cd .. || return 1
    rm -rf "$here"
}

zim-update () {
    print -- "\n🐚 $fg_bold[white]Let's fish some new shells!$reset_color 🐚"

    zimfw upgrade && zimfw uninstall && zimfw update
}
