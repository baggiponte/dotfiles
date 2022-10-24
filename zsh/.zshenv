# +-------------------+
# | DEFAULT VARIABLES |
# +-------------------+

# see https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# in case it's not compatible with XDG dirs
# export CACHE="${XDG_CACHE_HOME:-"$HOME/.cache"}"
# export CONFIG="${XDG_CONFIG_HOME:-"$HOME/.config"}"
# export CONFIG_HOME="$CONFIG"
