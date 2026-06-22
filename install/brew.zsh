# +--------------+
# | install brew |
# +--------------+

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
