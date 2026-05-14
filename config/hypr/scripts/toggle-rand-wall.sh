#!/usr/bin/env bash
set -euo pipefail

TOGGLE_FILE="$HOME/.config/hypr/random_wallpaper_enabled"

# initialize if missing
if [[ ! -f "$TOGGLE_FILE" ]]; then
  echo "0" > "$TOGGLE_FILE"
fi

CURRENT="$(cat "$TOGGLE_FILE")"

if [[ "$CURRENT" == "1" ]]; then
  echo "0" > "$TOGGLE_FILE"
  echo "random wallpaper: OFF"
  notify-send "random wallpaper: OFF"
else
  echo "1" > "$TOGGLE_FILE"
  echo "random wallpaper: ON"
  notify-send "random wallpaper: ON"
fi
