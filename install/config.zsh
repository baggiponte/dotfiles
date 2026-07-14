# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

ln -sf "$HOME/.config/.gitconfig" "$HOME/.gitconfig"
ln -sf "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" "$HOME/icloud"

mkdir -p "$HOME/.local/bin"
for script in "$HOME/.config/bin"/*(N); do
    name="${script:t}"
    [[ "$name" == *.md ]] && continue
    [[ -d "$script" ]] && continue
    ln -sf "$script" "$HOME/.local/bin/$name"
done
