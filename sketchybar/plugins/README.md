# SketchyBar Plugins Notes

This README documents the Spotify widget plus the Swift-based audio routing widget used in this setup.

## Source Credit

- Original inspiration and patterns (Spotify item/plugin examples):
  - https://github.com/FelixKratz/SketchyBar/discussions/12
- SketchyBar docs used for item/event behavior:
  - https://felixkratz.github.io/SketchyBar/config/items
  - https://felixkratz.github.io/SketchyBar/config/events

## What Is Implemented

- Center Spotify control strip in `sketchybarrc`:
  - `spotify.logo` (Spotify icon)
  - `spotify.prev`
  - `spotify.playpause` (dynamic play/pause icon)
  - `spotify.next`
  - `spotify.nowplaying` (artist + track)
- Styling:
  - Rounded grouped bracket (`spotify.controls`)
  - Gruvbox-tinted colors and border
  - SF Symbols-like transport icons for cleaner controls
- Behavior:
  - Always visible controls (no popup)
  - Click logo to open/focus Spotify
  - Track text on the right of controls
  - Marquee scrolling for long labels
  - Automatic updates on:
    - timer (`update_freq`)
    - Spotify event `com.spotify.client.PlaybackStateChanged`

## Files and Responsibilities

- `plugins/spotify.sh`
  - Handles actions: `open`, `previous`, `playpause`, `next`, `status`
  - Reads Spotify metadata via AppleScript
  - Updates SketchyBar item states (`icon` + `label`)
  - Stores marquee offset in `/tmp/sketchybar_spotify_marquee_state`
- `sketchybarrc`
  - Declares Spotify items, event subscription, styling, grouping
  - Wires click scripts to `plugins/spotify.sh`
- `plugins/audio_route_swift.swift`
  - Implements audio route state + popup menu logic in Swift
  - Lists/selects output and input devices via `SwitchAudioSource`
  - Updates `audio.route` item label and popup menu entries
- `plugins/audio_route_swift.sh`
  - Lightweight launcher for SketchyBar
  - Builds the Swift binary into `/tmp/sketchybar-audio-route-swift` on demand
  - Rebuilds automatically when `audio_route_swift.swift` changes

## Why The Current Script Is Structured This Way

- Metadata is fetched in a single AppleScript call (`state`, `artist`, `track`) to reduce inconsistent partial reads.
- Running-state detection has fallback logic:
  - `pgrep -x Spotify` first (fast path)
  - AppleScript `application "Spotify" is running` second (reliable fallback)
- `sb_set()` wraps `sketchybar --set` and suppresses transient failures to avoid script crashes during rapid refresh/update cycles.
- Play/pause icon is set from real state each refresh, not assumed from click action.

## Reliability Issues Encountered (and Fixes)

1. **"Not Playing" stuck while Spotify was open**
   - Cause: brittle process/state checks in sandboxed execution contexts.
   - Fix: fallback AppleScript running check + robust metadata parsing.

2. **Text not appearing**
   - Cause: relying on stdout label output was inconsistent.
   - Fix: explicitly set label via `sketchybar --set "$TARGET_ITEM" label=...`.

3. **AppleScript syntax edge cases**
   - Cause: compact one-liner conditionals were error-prone.
   - Fix: multiline AppleScript statements and a single metadata return format.

4. **Long track names clipping awkwardly**
   - Cause: static width with plain truncation.
   - Fix: marquee window over full `Artist - Track` label.

## UI Decisions (Critical Review)

- Good:
  - Always-on controls are fast and predictable.
  - Grouped bracket reads clearly at a glance.
  - Track text to the right matches user expectation.
  - Dynamic play/pause state removes ambiguity.
- Tradeoffs:
  - Marquee updates every ~2s can feel jumpy for some users.
  - SF Symbols glyph availability depends on system font support.
  - No album art/progress bar yet (kept intentionally lightweight).

## Current Defaults

- Text width: `220`
- Marquee width in script: `38` chars
- Now playing refresh rate: `update_freq=2`
- Event-driven refresh: `spotify_change com.spotify.client.PlaybackStateChanged`

## Suggested Future Improvements

- Add optional album art thumbnail (cached in `/tmp`).
- Add elapsed/total time and a slim progress bar.
- Add hover or secondary click actions (open album/artist in Spotify).
- Add graceful fallback icon set if SF Symbols are unavailable.
- Replace `SwitchAudioSource` shell dependency with direct CoreAudio calls in Swift.

## Audio Widget Notes (Swift Replacement)

- `audio.route` now uses:
  - `script="${PLUGIN_DIR}/audio_route_swift.sh status"`
  - `click_script="${PLUGIN_DIR}/audio_route_swift.sh click"`
- Click behavior:
  - First click opens a popup attached to the widget
  - Popup contains **Output** and **Input** sections
  - Selecting an entry switches device and refreshes the label
- Current label format:
  - `Audio: <current output> ▾`
- Runtime dependencies:
  - `SwitchAudioSource` (`brew install switchaudio-osx`)
  - Xcode CLT / `xcrun swiftc` for on-demand build

## Debug Commands

Reload and trigger updates:

```bash
sketchybar --reload
sketchybar --trigger spotify_change
```

Run status script directly for manual checks:

```bash
NAME=spotify.nowplaying ~/.config/sketchybar/plugins/spotify.sh status
```

Test AppleScript connectivity:

```bash
osascript -e 'tell application "Spotify" to player state'
osascript -e 'tell application "Spotify" to name of current track'
osascript -e 'tell application "Spotify" to artist of current track'
```
