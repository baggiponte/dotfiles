#!/usr/bin/env zsh

# copy pasted from: https://nikitabobko.github.io/AeroSpace/goodness#show-aerospace-workspaces-in-sketchybar

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi
