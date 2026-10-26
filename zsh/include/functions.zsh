# +-------+
# | Utils |
# +-------+

path () { print "${PATH//:/\\n}" }

fpath () { print "${fpath}" | tr " " "\n" }

take () { command mkdir -p "$1" && cd "$1"; }

tmp () { cd "$(mktemp -t scratch --directory)" }

# Delete everything in $PWD after listing it and asking once.
# Refuses to run in / or $HOME.
cleanup () {
	# (/|$HOME) is a glob alternation: matches either path exactly.
	if [[ $PWD == (/|$HOME) ]]; then
		print -u2 "cleanup: refusing to run in $PWD"
		return 1
	fi
	# *(N): (N) is a glob qualifier for null_glob, so an empty dir yields an
	# empty array instead of a "no matches found" error. glob_dots is set in
	# options.zsh, so * includes dotfiles (.git, .env, ...).
	local -a targets=( *(N) )
	(( $#targets )) || { print "cleanup: $PWD is already empty"; return 0 }
	# ${targets[1,20]}: array slice, first 20 entries.
	print -l -- ${targets[1,20]}
	(( $#targets > 20 )) && print "... and $(( $#targets - 20 )) more"
	# read -q: read one key; succeeds only on y/Y. "?..." is the prompt.
	read -q "?Delete these $#targets entries in $PWD? [y/N] " || { print; return 1 }
	print
	command rm -rf -- $targets
}

# Leave the current directory and delete it, after asking.
# Refuses to run in / or $HOME.
leave () {
	local here="${PWD}"
	if [[ $here == (/|$HOME) ]]; then
		print -u2 "leave: refusing to delete $here"
		return 1
	fi
	read -q "?Delete $here? [y/N] " || { print; return 1 }
	print
	cd .. && command rm -rf -- "$here"
}
