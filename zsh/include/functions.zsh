# +-------------------------------------------+
# | Almost always require an external command |
# +-------------------------------------------+

requires() {
	for cmd in "$@"; do
		if ! command -v "$cmd" &>/dev/null; then
			print "$cmd not installed"
			return 1
		fi
	done
}

zellij-switcher() {
    if [[ -v ZELLIJ ]]; then
        print "You are inside a zellij session. Currently zellij API does not allow switching sessions."
        print "You can use the session-switcher plugin, or exit the session and run this command again."
        return 1
    fi

    requires zellij sk

    local sessions
    sessions=($(zellij list-sessions --no-formatting --short))

    if [[ "${#sessions}" -eq 0 ]]; then
        print "No zellij sessions found."
        return 0
    fi

    local session
    session="$(sk --ansi --cmd="zellij list-sessions --short")"

    if [[ -z "$session" ]]; then
        return 1
    fi

    zellij attach "$session"

    return 0
}

zellij-sessionizer() {
    if [[ -v ZELLIJ ]]; then
        print "You are inside a zellij session. Currently zellij API does not allow switching sessions."
        print "You can use the session-switcher plugin, or exit the session and run this command again."
        return 1
    fi

    requires zellij sk zoxide

    local dir
    dir="$(sk --height=40% --preview-window=down,40% --cmd="zoxide query --list")"

    if [[ -z "$dir" ]]; then
        return 1
    fi

    zellij attach --create "$(basename "${dir}")" && cd "$dir"
}

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

teal() {
	requires tldr sk
	tldr --list | sk --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr
}

n() {
	requires nvim

	if [[ -z "$1" ]]; then
		nvim -c 'Telescope find_files'
	elif [[ -d "$1" ]]; then
		nvim -c "Telescope find_files cwd=$1"
	else
		nvim -- "$1"
	fi
}

nn() {
	requires nvim

	if [[ -z "$1" ]]; then
		nvim -c 'Telescope live-grep'
	elif [[ -d "$1" ]]; then
		nvim -c "Telescope live-grep cwd=$1"
	else
		nvim -c 'Telescope current_buffer_fuzzy_find' -- "$1"
	fi
}

nd() {
    requires nvim

    local filemanager_cmd="${NVIM_FILEMANAGER_CMD:-"NvimTreeToggle"}"

    if [[ -z "$1" ]]; then
        nvim -c "${filemanager_cmd}"
    elif [[ -d "$1" ]]; then
        nvim -c "${filemanager_cmd} $1"
    else
        print "'{$1}' is not a directory"
        return 1
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

zoxide-clean() {
    requires zoxide sk

    zoxide remove $(zoxide query --list | sk -m)
}
