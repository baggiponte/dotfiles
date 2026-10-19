# +-------------------+
# | DEFAULT VARIABLES |
# +-------------------+

# see https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# codex
export CODEX_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/codex"

# pi coding agent — keep config inside the dotfiles repo (see pi/.gitignore rules)
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi/agent"

export DISABLE_TELEMETRY=1
