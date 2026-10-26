print "📍 applying macOS defaults..."
# Declared in mise/conf.d/macos-defaults.toml. mise writes only the values that
# differ and restarts Dock, Finder, Stage Manager, and the menu bar via a hook.
# Preview with: mise bootstrap --only macos-defaults --dry-run
# Use the home directory so the caller's project config cannot affect bootstrap.
mise --cd "$HOME" bootstrap --only macos-defaults --yes

# Bat theme.
if command -v bat &> /dev/null; then
	bat cache --build
fi

print "✔︎ done. Some settings may require logging out and back in."
