#!/usr/bin/env bash

set -euo pipefail

SYMLINK="$HOME/.config/hypr/current_wallpaper"
TOGGLE_FILE="$HOME/.config/hypr/random_wallpaper_enabled"

# default: disabled if file missing
# [[ -f "$TOGGLE_FILE" ]] || exit 0

# create file if missing and default to enabled
[[ -f "$TOGGLE_FILE" ]] || echo "1" > "$TOGGLE_FILE"

# read toggle value
ENABLED="$(cat "$TOGGLE_FILE" 2>/dev/null || echo 0)"

# only run if enabled = 1
[[ "$ENABLED" == "1" ]] || exit 0

# ensure symlink exists
[[ -e "$SYMLINK" ]] || exit 0

CURRENT_WALL="$(readlink -f "$SYMLINK")"
THEME_DIR="$(dirname "$CURRENT_WALL")"

# pick random image
WALL="$(find "$THEME_DIR" -maxdepth 1 -type f \
  \( -iname "*.avif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
  | shuf -n1)"

[[ -n "$WALL" ]] || exit 0

awww img "$WALL" --transition-type any --transition-fps 75
ln -sf "$WALL" "$SYMLINK"
