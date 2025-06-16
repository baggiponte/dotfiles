# +-------------------------------------------+
# | Almost always require an external command |
# +-------------------------------------------+

CMD_PREVIEW_EZA="eza --all --group-directories-first --icons --level=2 --tree --ignore-glob=\"$IGNORES_EZA\" -- {}"

# find files and pipe in sk/fzf preview with bat
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

path () { print "${PATH//:/\\n}" }

fpath () { print "${fpath}" | tr " " "\n" }

take () { command mkdir -p "$1" && cd "$1"; }

tmp () { cd "$(mktemp -t scratch --directory)" }

cleanup () { rm -rf * }

leave () {
    local here="${PWD}"
    cd .. || return 1
    rm -rf "$here"
}

zim-update () {
    print -- "\n🐚 $fg_bold[white]Let's fish some new shells!$reset_color 🐚"

    zimfw upgrade && zimfw uninstall && zimfw update
}
