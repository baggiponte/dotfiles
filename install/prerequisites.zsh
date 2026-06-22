print "📍 checking xcode tools are installed..."

if ! xcode-select --print-path &>/dev/null; then
	print "🏗️ installing xcode command line tools..."
	xcode-select --install &>/dev/null

	until xcode-select --print-path &>/dev/null; do
		sleep 10
	done

	print "✔︎ xcode command line tools installed!"

	sudo xcodebuild -license accept
fi

print "📍 configuring ZDOTDIR..."

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
