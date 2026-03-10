#!/usr/bin/env bash
set -euo pipefail

SYMLINK="$HOME/.config/hypr/current_wallpaper"

# ensure symlink exists
[[ -e "$SYMLINK" ]] || exit 0

CURRENT_WALL="$(readlink -f "$SYMLINK")"
THEME_DIR="$(dirname "$CURRENT_WALL")"

# pick random image
WALL="$(find "$THEME_DIR" -maxdepth 1 -type f \
  \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
  | shuf -n1)"

[[ -n "$WALL" ]] || exit 0

swww img "$WALL" --transition-type any --transition-fps 75
ln -sf "$WALL" "$SYMLINK"
