# +------+
# | TMUX |
# +------+

# Exit unless this is an interactive terminal without an existing tmux session.
# $- exposes the current shell flags; "i" is set when the shell is interactive.
[[ $- == *i* ]] || return
[[ -t 1 ]] || return
[[ -n "${TMUX:-}" ]] && return
command -v tmux >/dev/null 2>&1 || return

# Allow opt-out per shell by exporting DISABLE_AUTO_TMUX=1.
[[ -n "${DISABLE_AUTO_TMUX:-}" ]] && return

# Skip tmux auto-start in integrated terminals
case "${TERM_PROGRAM:-}" in
	vscode|zed|*code*|*Code*) return ;;
esac

if tmux list-sessions >/dev/null 2>&1; then
	if command -v tmux-switcher >/dev/null 2>&1; then
		tmux-switcher
	else
		tmux attach || tmux new
	fi
else
	tmux
fi
