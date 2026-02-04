#!/usr/bin/env bash

set -euo pipefail

TARGET_ITEM="${NAME:-audio.route}"
PLUGIN_DIR="${HOME}/.config/sketchybar/plugins"
SWITCH_AUDIO_BIN="$(command -v SwitchAudioSource || true)"
MENU_PREFIX="audio.route.menu"
ARROW="▾"

sb_set() {
  sketchybar --set "$@" >/dev/null 2>&1 || true
}

trim() {
  sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

list_devices() {
  local kind="$1"
  "$SWITCH_AUDIO_BIN" -a -t "$kind" 2>/dev/null | trim
}

current_device() {
  local kind="$1"
  "$SWITCH_AUDIO_BIN" -c -t "$kind" 2>/dev/null | trim
}

set_device() {
  local kind="$1"
  local device="$2"
  [[ -n "$device" ]] || return 1
  "$SWITCH_AUDIO_BIN" -s "$device" -t "$kind" >/dev/null 2>&1
}

compact_name() {
  local device="$1"
  device="${device//(Bluetooth)/}"
  device="${device//(AirPlay)/}"
  device="${device//MacBook Pro Microphone/Mac Mic}"
  device="${device//MacBook Pro Speakers/Mac Speakers}"
  device="${device//MacBook Pro/Mac}"
  device="$(printf "%s" "$device" | trim)"
  if (( ${#device} > 22 )); then
    printf "%s" "${device:0:22}…"
  else
    printf "%s" "$device"
  fi
}

popup_is_open() {
  sketchybar --query "$TARGET_ITEM" 2>/dev/null \
    | python3 -c 'import json,sys; print(json.load(sys.stdin).get("popup", {}).get("drawing", "off"))' 2>/dev/null \
    | grep -q '^on$'
}

clear_popup_menu() {
  sketchybar --remove "/${MENU_PREFIX//./\\.}\..*/" >/dev/null 2>&1 || true
}

add_popup_item() {
  local idx="$1"
  local device="$2"
  local current="$3"
  local item click_script escaped

  item="${MENU_PREFIX}.${idx}"
  escaped="$(printf '%q' "$device")"
  click_script="${PLUGIN_DIR}/audio_route.sh select ${escaped}"

  sketchybar --add item "$item" "popup.${TARGET_ITEM}" \
             --set "$item" \
                   icon="$([[ "$device" == "$current" ]] && echo "􀆅" || echo "")" \
                   icon.color="0xffa9b665" \
                   icon.padding_left=6 \
                   icon.padding_right=4 \
                   label="$device" \
                   label.align=left \
                   label.max_chars=46 \
                   label.padding_left=2 \
                   label.padding_right=6 \
                   background.corner_radius=6 \
                   background.height=22 \
                   click_script="$click_script"
}

build_output_popup() {
  local devices current idx line

  clear_popup_menu

  devices="$(list_devices output)"
  current="$(current_device output)"
  idx=0

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    idx=$((idx + 1))
    add_popup_item "$idx" "$line" "$current"
  done <<< "$devices"
}

set_status_label() {
  local out label
  out="$(current_device output)"

  if [[ -z "$out" ]]; then
    sb_set "$TARGET_ITEM" label="Audio n/a ${ARROW}" icon.color="0xff928374"
    return
  fi

  label="Output: $(compact_name "$out") ${ARROW}"
  sb_set "$TARGET_ITEM" icon.color="0xff89b482" label="$label"
}

if [[ -z "$SWITCH_AUDIO_BIN" ]]; then
  sb_set "$TARGET_ITEM" label="Install SwitchAudioSource ${ARROW}" icon.color="0xff928374"
  exit 0
fi

case "${1:-status}" in
  click)
    if popup_is_open; then
      sb_set "$TARGET_ITEM" popup.drawing=off
      exit 0
    fi
    build_output_popup
    sb_set "$TARGET_ITEM" popup.drawing=on
    ;;
  select)
    set_device output "${2:-}" || true
    sb_set "$TARGET_ITEM" popup.drawing=off
    set_status_label
    ;;
  status|*)
    set_status_label
    ;;
esac
