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
