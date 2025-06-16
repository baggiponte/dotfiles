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
