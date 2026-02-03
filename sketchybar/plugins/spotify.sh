#!/usr/bin/env bash
# Source credit: adapted from SketchyBar "Share your plugins" Spotify example,
# then refactored for always-on center controls + marquee text:
# https://github.com/FelixKratz/SketchyBar/discussions/12

set -euo pipefail

action="${1:-status}"
MARQUEE_WIDTH=38
MARQUEE_STATE_FILE="/tmp/sketchybar_spotify_marquee_state"
TARGET_ITEM="${NAME:-spotify.nowplaying}"

run_apple_script() {
  osascript -e "$1" >/dev/null 2>&1 || true
}

sb_set() {
  sketchybar --set "$@" >/dev/null 2>&1 || true
}

is_spotify_running() {
  if pgrep -x Spotify >/dev/null 2>&1; then
    return 0
  fi

  local running
  running="$(osascript -e 'if application "Spotify" is running then' -e 'return "yes"' -e 'else' -e 'return "no"' -e 'end if' 2>/dev/null || echo "no")"
  [[ "$running" == "yes" ]]
}

spotify_metadata() {
  osascript \
    -e 'tell application "Spotify"' \
    -e 'set s to player state as string' \
    -e 'set t to name of current track' \
    -e 'set a to artist of current track' \
    -e 'return s & "|||" & a & "|||" & t' \
    -e 'end tell' 2>/dev/null || true
}

set_playpause_icon() {
  local state="$1"
  local icon="􀊄"
  if [[ "$state" == "playing" ]]; then
    icon="􀊆"
  fi
  sb_set spotify.playpause icon="$icon"
}

set_widget_icon_color() {
  local color="$1"
  sb_set spotify.logo icon.color="$color"
}

case "$action" in
  open)
    open -a Spotify >/dev/null 2>&1 || true
    exit 0
    ;;
  previous)
    run_apple_script 'tell application "Spotify" to previous track'
    exit 0
    ;;
  playpause)
    run_apple_script 'tell application "Spotify" to playpause'
    exit 0
    ;;
  next)
    run_apple_script 'tell application "Spotify" to next track'
    exit 0
    ;;
esac

if ! is_spotify_running; then
  set_playpause_icon "stopped"
  set_widget_icon_color "0xff928374"
  sb_set "$TARGET_ITEM" label="Not playing"
  : > "$MARQUEE_STATE_FILE"
  exit 0
fi

metadata="$(spotify_metadata)"
state="${metadata%%|||*}"
rest="${metadata#*|||}"
artist="${rest%%|||*}"
track="${rest#*|||}"

if [[ -z "$metadata" || "$metadata" == "$state" ]]; then
  set_playpause_icon "stopped"
  set_widget_icon_color "0xff928374"
  sb_set "$TARGET_ITEM" label="Spotify"
  exit 0
fi

set_playpause_icon "$state"
set_widget_icon_color "0xffa9b665"

if [[ -z "$track" ]]; then
  sb_set "$TARGET_ITEM" label="Spotify"
  exit 0
fi

if [[ -z "$artist" ]]; then
  label="$track"
else
  label="${artist} - ${track}"
fi

if (( ${#label} <= MARQUEE_WIDTH )); then
  sb_set "$TARGET_ITEM" label="$label"
  exit 0
fi

scroll_text="${label}   •   "
offset=0
previous_label=""

if [[ -f "$MARQUEE_STATE_FILE" ]]; then
  offset="$(sed -n '1p' "$MARQUEE_STATE_FILE" 2>/dev/null || echo 0)"
  previous_label="$(sed -n '2p' "$MARQUEE_STATE_FILE" 2>/dev/null || echo "")"
fi

if [[ "$previous_label" != "$label" || ! "$offset" =~ ^[0-9]+$ ]]; then
  offset=0
else
  offset=$(( (offset + 1) % ${#scroll_text} ))
fi

window="${scroll_text:offset:MARQUEE_WIDTH}"
if (( ${#window} < MARQUEE_WIDTH )); then
  window+="${scroll_text:0:$((MARQUEE_WIDTH - ${#window}))}"
fi

{
  echo "$offset"
  echo "$label"
} > "$MARQUEE_STATE_FILE"

sb_set "$TARGET_ITEM" label="$window"
