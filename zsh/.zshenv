# +-------------------------------------------------------------------+
# | ENVIRONMENT FOR EVERY SHELL                                       |
# | Read by interactive, login, and non-interactive shells alike      |
# | (scripts, `zsh -c`, editors, agents). Keep it to assignments.     |
# +-------------------------------------------------------------------+

# see https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# pi coding agent — keep config inside the dotfiles repo (see pi/.gitignore rules)
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi/agent"

export DISABLE_TELEMETRY=1

# +------+
# | PATH |
# +------+

# -U: keep only the first occurrence of each entry, so prepending never duplicates.
typeset -gU path fpath

# Our PATH, highest priority first. Also re-applied by .zprofile, because
# macOS path_helper (/etc/zprofile) moves /usr/bin & co. ahead of it in login shells.
# Rex terminals export REX_BIN_DIR, the dir of the server's `rex`; keep it first
# (https://www.superlogical.com/rex/docs/automate/cli#path). Empty outside Rex: adds nothing.
zsh_path=(
	${REX_BIN_DIR:+"$REX_BIN_DIR"}
	"$XDG_DATA_HOME/mise/shims" # mise tools outside interactive shells; `mise activate` takes over in .zshrc
	/opt/homebrew/bin
	/opt/homebrew/sbin
	/Applications/Obsidian.app/Contents/MacOS
	"$HOME/.local/bin"
	/usr/local/bin
	/usr/bin
	/bin
	/usr/sbin
	/sbin
)

# Build PATH once per process tree: HOMEBREW_PREFIX is exported by brew shellenv,
# so child shells keep the PATH they inherit (e.g. a venv or `mise exec` entry
# added by the parent) instead of having it overwritten. Rebuild anyway if
# Homebrew is missing from PATH: ${path[(Ie)x]} is the index of the exact
# element x, 0 when absent.
if [[ -z $HOMEBREW_PREFIX ]] || (( ! ${path[(Ie)/opt/homebrew/bin]} )); then
	[[ -n $HOMEBREW_PREFIX ]] || eval "$(/opt/homebrew/bin/brew shellenv zsh)"
	path=($zsh_path)
	export PATH
fi
# Inherited PATH may have entries ahead of Rex's; -U drops the later duplicate.
path=(${REX_BIN_DIR:+"$REX_BIN_DIR"} $path)

# +-------+
# | TOOLS |
# +-------+

# NOTE: an EDITOR containing "vi" makes zle default to the vi keymap.
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export MYVIMRC="$XDG_CONFIG_HOME/nvim/init.lua"

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/.npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export DOCKER_HOST="unix://$XDG_CONFIG_HOME/colima/default/docker.sock"
