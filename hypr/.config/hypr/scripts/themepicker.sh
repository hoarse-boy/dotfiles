#!/usr/bin/env bash

set -euo pipefail
CONFIG_DIR="$HOME/.config/matugen"
THEME_FILE="$CONFIG_DIR/theme.txt"
SKIP_FILE="$CONFIG_DIR/matugenskiposthook"
echo "dark" >"$THEME_FILE"
echo "1" >"$SKIP_FILE"

BASE_WALL_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
ROFI_CONFIG="$HOME/.config/rofi/ts.rasi"

# List and select theme (same as before)
THEME_FOLDERS=($(find "$BASE_WALL_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
THEME_NAMES=()
for folder in "${THEME_FOLDERS[@]}"; do
  THEME_NAMES+=("${folder##*-}")
done

SELECTED_NAME=$(printf "%s\n" "${THEME_NAMES[@]}" | rofi -dmenu -i -p "Select Theme" -config "$ROFI_CONFIG")
[ -z "$SELECTED_NAME" ] && exit 0

# Find directory
THEME_DIR=""
for folder in "${THEME_FOLDERS[@]}"; do
  if [[ "${folder##*-}" == "$SELECTED_NAME" ]]; then
    THEME_DIR="$BASE_WALL_DIR/$folder"
    break
  fi
done

[[ -z "$THEME_DIR" ]] && {
  echo "❌ Theme not found"
  exit 1
}

# --- OPTIMIZED: Use specific filename first (O(1)) ---
# Try these in order: theme.jpg, 00-*.jpg, then fall back to first file
MATUGEN_WALL=""

# NOTE: . matugen cannot generate from avif
# Option 1: Specific filename (fastest - just checks if file exists)
for pattern in "theme.jpg" "theme.jpeg" "00-*.jpg" "!*.jpg"; do
  # Use nullglob to handle no-match case
  matches=("$THEME_DIR"/$pattern)
  if [[ -f "${matches[0]}" ]]; then
    MATUGEN_WALL="${matches[0]}"
    break
  fi
done

# Fallback: First alphabetical (only if no convention file found)
if [[ -z "$MATUGEN_WALL" ]]; then
  MATUGEN_WALL=$(find "$THEME_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | sort | awk 'NR==1')
fi

[[ -z "$MATUGEN_WALL" ]] && {
  echo "❌ No wallpapers"
  exit 1
}

# Apply
matugen image "$MATUGEN_WALL"
swaync-client -rs

mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$MATUGEN_WALL" "$SYMLINK_PATH"

echo "✅ Theme '$SELECTED_NAME' with $(basename "$MATUGEN_WALL")"
