# +-----------+
# | VI KEYMAP |
# +-----------+

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Cursor: block in normal mode, beam in insert mode.
# See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursors
zle-keymap-select () {
	if [[ $KEYMAP == vicmd ]]; then
		print -n '\e[2 q'
	else
		print -n '\e[6 q'
	fi
}
zle-line-init () { print -n '\e[6 q' }
zle -N zle-keymap-select
zle -N zle-line-init

# add vi text-objects for brackets and quotes, i.e. can be used with `a` (around) and `i` (inside)
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
# () { ... }: anonymous function, so km and c stay local.
# ${(s..)^:-'abc'}: split the literal into characters, and ^ makes {a,i}
# combine with each one (ab, ib, a(, i(, ...).
() {
	local km c
	for km in viopp visual; do
		bindkey -M $km -- '-' vi-up-line-or-history
		for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
			bindkey -M $km $c select-quoted
		done
		for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
			bindkey -M $km $c select-bracketed
		done
	done
}

# emulation of vim-surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround
