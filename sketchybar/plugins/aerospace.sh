#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

set -euo pipefail

sid="$1"
pill="space.${sid}.pill"
num_item="space.${sid}.num"

get_windows_for_workspace() {
  aerospace list-windows --workspace "$1" --format '%{app-name}' 2>/dev/null || true
}

is_app_open() {
  local windows="$1"
  local pattern="$2"
  printf '%s\n' "$windows" | grep -Eq "$pattern"
}

set_app_color() {
  local item="$1"
  local color="$2"
  sketchybar --set "$item" icon.color="$color"
}

windows="$(get_windows_for_workspace "$sid")"
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null || true)}"

if [ "$sid" = "$focused" ]; then
  pill_bg="0xffffffff"
  num_color="0xff2b2b2b"
  open_color="0xff2b2b2b"
  closed_color="0xff8f949e"
else
  pill_bg="0xaa3c3836"
  num_color="0xffffffff"
  open_color="0xffffffff"
  closed_color="0xff8f949e"
fi

sketchybar --set "$pill" \
  background.color="$pill_bg" \
  background.border_width=0 \
  background.border_color=0x00000000

sketchybar --set "$num_item" icon.color="$num_color"

case "$sid" in
  1)
    if is_app_open "$windows" '^Ghostty$'; then
      set_app_color "space.1.app.ghostty" "$open_color"
    else
      set_app_color "space.1.app.ghostty" "$closed_color"
    fi
    ;;
  2)
    if is_app_open "$windows" '^(Arc|Browser)$'; then
      set_app_color "space.2.app.arc" "$open_color"
    else
      set_app_color "space.2.app.arc" "$closed_color"
    fi
    ;;
  3)
    if is_app_open "$windows" '^(Codex|Cursor)$'; then
      set_app_color "space.3.app.code" "$open_color"
    else
      set_app_color "space.3.app.code" "$closed_color"
    fi

    if is_app_open "$windows" '^Zed$'; then
      set_app_color "space.3.app.zed" "$open_color"
    else
      set_app_color "space.3.app.zed" "$closed_color"
    fi
    ;;
  4)
    if is_app_open "$windows" '^Obsidian$'; then
      set_app_color "space.4.app.obsidian" "$open_color"
    else
      set_app_color "space.4.app.obsidian" "$closed_color"
    fi

    if is_app_open "$windows" '^Notion$'; then
      set_app_color "space.4.app.notion" "$open_color"
    else
      set_app_color "space.4.app.notion" "$closed_color"
    fi
    ;;
  5)
    if is_app_open "$windows" '^Discord$'; then
      set_app_color "space.5.app.discord" "$open_color"
    else
      set_app_color "space.5.app.discord" "$closed_color"
    fi

    if is_app_open "$windows" '^Slack$'; then
      set_app_color "space.5.app.slack" "$open_color"
    else
      set_app_color "space.5.app.slack" "$closed_color"
    fi

    if is_app_open "$windows" '^Microsoft Teams'; then
      set_app_color "space.5.app.teams" "$open_color"
    else
      set_app_color "space.5.app.teams" "$closed_color"
    fi

    if is_app_open "$windows" '^Spotify$'; then
      set_app_color "space.5.app.spotify" "$open_color"
    else
      set_app_color "space.5.app.spotify" "$closed_color"
    fi
    ;;
esac
