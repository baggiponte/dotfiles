# +-------------+
# | COMPLETIONS |
# +-------------+

# Completion files, autoloaded from fpath. Regenerated only when the tool's
# binary changes (upgrade), not on every startup. _zgen is in cache.zsh.
_zgen "$COMPDIR/_uv"  uv  uv generate-shell-completion zsh
_zgen "$COMPDIR/_uvx" uvx uvx --generate-shell-completion=zsh
_zgen "$COMPDIR/_az"  az  register-python-argcomplete az # native #compdef, no bashcompinit needed
# ruff runs through uv: use an installed `uv tool` binary if there is one,
# otherwise `uvx ruff` (keyed on uv, so it refreshes when uv is upgraded).
if (( $+commands[ruff] )); then
	_zgen "$COMPDIR/_ruff" ruff ruff generate-shell-completion zsh
else
	_zgen "$COMPDIR/_ruff" uv uvx ruff generate-shell-completion zsh
fi

# Register completion dirs before compinit runs. Homebrew's is also added by
# `brew shellenv`, but only in the shell that built PATH (see .zshenv).
fpath=("$COMPDIR" /opt/homebrew/share/zsh/site-functions $fpath)

# compinit audits fpath for insecure dirs and rescans it on every start.
# `compinit -C` trusts the existing dump instead. Use -C unless the dump is
# missing or older than a day, fpath changed, or an fpath dir changed since
# the dump was written (e.g. `brew install` added a completion).
autoload -Uz compinit
() {
	local dump="$XDG_CACHE_HOME/zsh/zcompdump" sig="${(j.:.)fpath}" d old
	local -a flags=(-C)
	[[ -r $dump.fpath ]] && old=$(<"$dump.fpath")
	# (#q...) applies glob qualifiers inside [[ ]]: N = no error if no match,
	# . = plain file, mh-24 = modified less than 24 hours ago. Empty = stale.
	if [[ ! -s $dump || -z ${dump}(#qN.mh-24) || $old != "$sig" ]]; then
		flags=()
	else
		for d in $fpath; do
			[[ $d -nt $dump ]] && { flags=(); break }
		done
	fi
	compinit $flags -d "$dump"
	(( $#flags )) || { touch "$dump"; print -r -- "$sig" >| "$dump.fpath" }
	# Compile the dump in the background (&! = disown) for faster loading.
	[[ $dump.zwc -nt $dump ]] || zcompile "$dump" &!
}

# `uvx ruff …`: _uvx only completes files after the command name, so hand
# the words from `ruff` on to _ruff (generated above).
_uvx_ruff () {
	if (( CURRENT > 2 )) && [[ $words[2] == ruff ]]; then
		shift words
		(( CURRENT-- ))
		_ruff
	else
		_uvx
	fi
}
compdef _uvx_ruff uvx

# Completions that must be registered after compinit (they call compdef).
_zsource mole mole command mole completion zsh
