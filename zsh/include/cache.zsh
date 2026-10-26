# +-----------------------------------------------------------------+
# | GENERATED-SCRIPT CACHE                                          |
# | Regenerate a tool's completion/init output only when its        |
# | resolved binary (path or mtime) changes, e.g. after an upgrade. |
# +-----------------------------------------------------------------+

zmodload -F zsh/stat b:zstat

ZGEN_DIR="$XDG_CACHE_HOME/zsh/gen"
COMPDIR="$XDG_CACHE_HOME/zsh/zfunc"
[[ -d $ZGEN_DIR && -d $COMPDIR ]] || mkdir -p "$ZGEN_DIR" "$COMPDIR"

# _zgen <out-file> <binary> <command...>
# The cache key is the binary's resolved path (${bin:A}: absolute, symlinks
# resolved, so a Homebrew upgrade changes it) plus its mtime.
_zgen () {
	local out=$1 bin=${commands[$2]} key old
	shift 2
	[[ -n $bin ]] || return 1
	local -a mtime
	zstat -A mtime +mtime -- "${bin:A}" || return 1
	key="${bin:A} ${mtime[1]}"
	[[ -r $out.key ]] && old=$(<"$out.key")
	if [[ ! -s $out || $old != "$key" ]]; then
		"$@" >| "$out.tmp" 2>/dev/null && [[ -s $out.tmp ]] || { command rm -f "$out.tmp"; return 1 }
		command mv -f "$out.tmp" "$out"
		print -r -- "$key" >| "$out.key"
	fi
}

# _zsource <name> <binary> <command...>: cache an init script, then source it.
_zsource () {
	local f="$ZGEN_DIR/$1.zsh"
	shift
	_zgen "$f" "$@" && source "$f"
}
