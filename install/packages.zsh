print "📍 Checking homebrew is installed..."

if ! command -v brew &>/dev/null; then
	print "🏗️ installing homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v brew &>/dev/null; then
	print "🚨 unable to install homebrew, script $0 abort!"
	exit 2
fi

brew bundle --file="$HOME/.config/Brewfile" || print "⚠️ some brew packages failed"

if command -v docker-compose &> /dev/null; then
	mkdir -p "$HOME/.docker/cli-plugins"
	ln -sfn "$(brew --prefix)/opt/docker-compose/bin/docker-compose" "$HOME/.docker/cli-plugins/docker-compose"

	cat > "$HOME/.docker/config.json" <<EOF
{
  "cliPluginsExtraDirs": [
    "/opt/homebrew/lib/docker/cli-plugins"
  ]
}
EOF
fi

if command -v docker-buildx &> /dev/null; then
	mkdir -p "$HOME/.docker/cli-plugins"
	ln -sfn "$(brew --prefix)/opt/docker-compose/bin/docker-buildx" "$HOME/.docker/cli-plugins/docker-buildx"
fi
