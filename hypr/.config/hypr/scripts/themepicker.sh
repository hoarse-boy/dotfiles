#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR="$HOME/.config/matugen"
THEME_FILE="$CONFIG_DIR/theme.txt"
SKIP_FILE="$CONFIG_DIR/matugenskiposthook"
echo "dark" >"$THEME_FILE"
echo "1" >"$SKIP_FILE"

BASE_WALL_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
HYPRLOCK_SYMLINK="$HOME/.config/hypr/hyprlock_wallpaper"
ROFI_CONFIG="$HOME/.config/rofi/ts.rasi"

# list and select theme
THEME_FOLDERS=($(find "$BASE_WALL_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
THEME_NAMES=()
for folder in "${THEME_FOLDERS[@]}"; do
  THEME_NAMES+=("${folder##*-}")
done

SELECTED_NAME=$(printf "%s\n" "${THEME_NAMES[@]}" | rofi -dmenu -i -p "Select Theme" -config "$ROFI_CONFIG")
[ -z "$SELECTED_NAME" ] && exit 0

# find directory
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

# --- matugen wallpaper (jpg only) ---
MATUGEN_WALL=""

for pattern in "theme.jpg" "theme.jpeg" "00-*.jpg" "!*.jpg"; do
  matches=("$THEME_DIR"/$pattern)
  if [[ -f "${matches[0]}" ]]; then
    MATUGEN_WALL="${matches[0]}"
    break
  fi
done

if [[ -z "$MATUGEN_WALL" ]]; then
  MATUGEN_WALL=$(find "$THEME_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | sort | awk 'NR==1')
fi

[[ -z "$MATUGEN_WALL" ]] && {
  echo "❌ No wallpapers"
  exit 1
}

# --- hyprlock wallpaper (strict: theme.jpg only) ---
HYPRLOCK_WALL=""

for f in "$THEME_DIR/theme.jpg" "$THEME_DIR/theme.jpeg"; do
  if [[ -f "$f" ]]; then
    HYPRLOCK_WALL="$f"
    break
  fi
done

[[ -z "$HYPRLOCK_WALL" ]] && {
  echo "❌ No theme.jpg for hyprlock"
  exit 1
}

# apply matugen
matugen image "$MATUGEN_WALL"
swaync-client -rs

# ensure dirs exist
mkdir -p "$(dirname "$SYMLINK_PATH")"

# symlinks
ln -sf "$MATUGEN_WALL" "$SYMLINK_PATH"
ln -sf "$HYPRLOCK_WALL" "$HYPRLOCK_SYMLINK"

echo "✅ Theme '$SELECTED_NAME'"
echo "   matugen → $(basename "$MATUGEN_WALL")"
echo "   hyprlock → $(basename "$HYPRLOCK_WALL")"
