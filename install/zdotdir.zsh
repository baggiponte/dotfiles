# +-------------------+
# | configure ZDOTDIR |
# +-------------------+

zdotdir_line='export ZDOTDIR="$HOME/.config/zsh"'

if [[ -f "/etc/zshenv" ]]; then
	if ! grep -qF "$zdotdir_line" "/etc/zshenv"; then
		print "$zdotdir_line" | sudo tee -a "/etc/zshenv" >/dev/null
		print "✔︎ appended '$zdotdir_line' to '/etc/zshenv/'"
	fi
else
	print "$zdotdir_line" | sudo tee "/etc/zshenv" >/dev/null
	print "✔︎ created '/etc/zshenv' and appended the '$zdotdir_line' line."
fi
