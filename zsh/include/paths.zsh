# +-------------------------+
# | MUST ADD TO $PATH FIRST |
# +-------------------------+

export PATH="$HOME/.local/bin:$PATH"

# MUST be before any "hash" call!
if [ "$(sysctl -n machdep.cpu.brand_string)" = "Apple M1" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/Brewfile.M1"
else
	eval "$(/usr/local/bin/brew shellenv)"
	export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/Brewfile.Intel"
fi


