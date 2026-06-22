# +----------------------+
# | install dependencies |
# +----------------------+

read -r -p "❓ install dependencies from Brewfile? [Y/n] " response
if [[ -z "$response" || "$response" =~ ^[Yy](es)?$ ]]; then

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
else
	print "⚠️ skipped brew package installs"
fi
