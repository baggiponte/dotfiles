# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

ln -sf "$HOME/.config/.gitconfig" "$HOME/.gitconfig"
ln -sf "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" "$HOME/icloud"
