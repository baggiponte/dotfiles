#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

sid="$1"

app_icon() {
  case "$1" in
    "Ghostty") echo ":ghostty:" ;;
    "Arc"|"Browser") echo ":arc:" ;;
    "Zed") echo ":zed:" ;;
    "Codex") echo ":code:" ;;
    "Cursor") echo ":cursor:" ;;
    "Notion") echo ":notion:" ;;
    "Obsidian") echo ":obsidian:" ;;
    "Discord") echo ":discord:" ;;
    "Slack") echo ":slack:" ;;
    "Spotify") echo ":spotify:" ;;
    *) echo "" ;;
  esac
}

workspace_icons() {
  local ws="$1"
  local icons=""
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    token="$(app_icon "$app")"
    [ -z "$token" ] && continue
    case " $icons " in
      *" $token "*) ;;
      *) icons="${icons:+$icons  }$token" ;;
    esac
  done < <(aerospace list-windows --workspace "$ws" --format '%{app-name}' 2>/dev/null)
  echo "$icons"
}

focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null || true)}"
label="$(workspace_icons "$sid")"

if [ "$sid" = "$focused" ]; then
  sketchybar --set "$NAME" \
    background.color=0xffffffff \
    background.border_width=0 \
    background.border_color=0x00000000 \
    icon.color=0xff2b2b2b \
    label.string="$label" \
    label.color=0xff2b2b2b
else
  sketchybar --set "$NAME" \
    background.color=0xaa3c3836 \
    background.border_width=0 \
    background.border_color=0x00000000 \
    icon.color=0xffffffff \
    label.string="$label" \
    label.color=0xffffffff
fi
