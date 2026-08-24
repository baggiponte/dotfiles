print "📍 checking mise is installed..."

# the official installer drops the binary in ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

if ! command -v mise &>/dev/null; then
	print "🏗️ installing mise via the official installer..."
	curl https://mise.run | sh
fi

if ! command -v mise &>/dev/null; then
	print "🚨 unable to install mise, script $0 abort!"
	exit 2
fi

print "✔︎ mise installed: $(mise --version)"
