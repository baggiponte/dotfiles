# +---------------------+
# | install xcode tools |
# +---------------------+

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
