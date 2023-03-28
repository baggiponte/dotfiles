# +-------------------------------------------+
# | Almost always require an external command |
# +-------------------------------------------+

_requires() {

	for cmd in "$@"; do
		if ! command -v "$cmd" &>/dev/null; then
			print "$cmd not installed"
			return 1
		fi
	done
}

# find files and pipe in fzf preview
_fuzzy-find() {
	_requires fd fzf bat

	local pattern="$1"

	fd -t=f -HI \
		-E .DS_Store \
		-E .git \
		-E .mypy_cache \
		-E .ruff_cache \
		-E .venv \
		-E __pycache__ \
		-E assets \
		-E raycast |
		fzf \
			--preview="bat --color=always --style='plain,changes' --line-range=:500 {}" \
			--query="$pattern"
}

fuzzy-find() {
	_requires nvim

	local pattern="$1"
	local file
	file="$(_fuzzy-find "$pattern")"

	if [ -z "$file" ]; then
		return 1
	else
		nvim -- "$file"
	fi
}

# grep string and pipe in fzf preview
_live-grep() {
	_requires rg fzf bat

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

live-grep() {
	_requires nvim

	local pattern="$1"
	local file
	file="$(_live-grep "$pattern" | cut -d : -f 1,2)"

	if [ -z "$file" ]; then
		return 1
	else
		nvim +"${file#*:}" -c "normal zz" -- "${file%:*}"
	fi
}

teal() {
	_requires tldr
	tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr
}

n() {
	_requires nvim

	if [ -z "$1" ]; then
		nvim -c 'Telescope find_files'
	elif [ -d "$1" ]; then
		nvim -c "Telescope find_files cwd=$1"
	else
		nvim -- "$1"
	fi
}

nn() {
	_requires nvim

	if [ -z "$1" ]; then
		nvim -c 'Telescope live-grep'
	elif [ -d "$1" ]; then
		nvim -c "Telescope live-grep cwd=$1"
	else
		nvim -c 'Telescope current_buffer_fuzzy-find' -- "$1"
	fi
}

# open zoxide dir

zoxide-interactive() {
	_requires zoxide

	local query="$1"
	local chosen_directory

	chosen_directory=$(
		zoxide query \
			--exclude "$PWD" \
			--list |
			fzf \
				--preview="exa --all --group-directories-first --icons --oneline --ignore-glob={.DS_Store,.git} {}" \
				--height 40% \
				--preview-window=down,40% \
				--preview-label=" content preview " \
				--query="$query"
	)

	cd -- "$chosen_directory" || return 1
}

zoxide-clean() {
	zoxide query --list |
		fzf --multi --sort |
		xargs -I % sh -c "rich --print 'deleting [blue]%[/]'; zoxide remove '%'"
}

tn() {
	_requires tmux zoxide

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
