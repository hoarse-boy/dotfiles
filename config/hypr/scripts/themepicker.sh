#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR="$HOME/.config/matugen"
THEME_FILE="$CONFIG_DIR/theme.txt"
SKIP_FILE="$CONFIG_DIR/matugenskiposthook"

# overwrite theme and skip file
echo "dark" >"$THEME_FILE"
echo "1" >"$SKIP_FILE"
# create files if they don't exist. uncomment above if using checking file logic
# [[ -f "$THEME_FILE" ]] || echo "dark" > "$THEME_FILE"
# [[ -f "$SKIP_FILE" ]] || echo "1" > "$SKIP_FILE"

BASE_WALL_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
HYPRLOCK_SYMLINK="$HOME/.config/hypr/hyprlock_wallpaper"
ROFI_CONFIG="$HOME/.config/rofi/ts.rasi"
HYPR_CONFIG="$HOME/.config/hypr/conf/dynamic-var.conf"

# Default opacity values
# this is lean toward light theme
DEFAULT_BLACK_OPACITY="0.9"
DEFAULT_OPACITY="0.93"
DEFAULT_DARKER="0.97"

# # list and select theme
# THEME_FOLDERS=($(find "$BASE_WALL_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
# THEME_NAMES=()
# for folder in "${THEME_FOLDERS[@]}"; do
#   THEME_NAMES+=("${folder##*-}")
# done

mapfile -t THEME_FOLDERS < <(find "$BASE_WALL_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n")

THEME_NAMES=("${THEME_FOLDERS[@]}")

SELECTED_NAME=$(printf "%s\n" "${THEME_NAMES[@]}" | rofi -dmenu -i -p "Select Theme" -config "$ROFI_CONFIG")
[ -z "$SELECTED_NAME" ] && exit 0

# find directory
# THEME_DIR=""
# for folder in "${THEME_FOLDERS[@]}"; do
#   if [[ "${folder##*-}" == "$SELECTED_NAME" ]]; then
#     THEME_DIR="$BASE_WALL_DIR/$folder"
#     break
#   fi
# done

# [[ -z "$THEME_DIR" ]] && {
#   echo "❌ Theme not found"
#   exit 1
# }

THEME_DIR="$BASE_WALL_DIR/$SELECTED_NAME"

[[ ! -d "$THEME_DIR" ]] && {
  echo "❌ Theme not found"
  exit 1
}

# --- Check for opacity config in theme dir ---
OPACITY_CONFIG="$THEME_DIR/opacity.conf"
BLACK_OPACITY="$DEFAULT_BLACK_OPACITY"
OPACITY="$DEFAULT_OPACITY"
DARKER="$DEFAULT_DARKER"

if [[ -f "$OPACITY_CONFIG" ]]; then
  echo "📄 Found opacity config: $OPACITY_CONFIG"

  # Parse key=value pairs
  while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$key" ]] && continue

    # Trim whitespace
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)

    case "$key" in
    blackThemedOpacity) BLACK_OPACITY="$value" ;;
    opacityValue) OPACITY="$value" ;;
    opacityDarker) DARKER="$value" ;;
    esac
  done <"$OPACITY_CONFIG"

  echo "   blackThemedOpacity=$BLACK_OPACITY"
  echo "   opacityValue=$OPACITY"
  echo "   opacityDarker=$DARKER"
else
  echo "📄 No opacity config found, using defaults"
fi

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

# --- Update Hyprland config with new opacity values ---
echo "🔄 Updating Hyprland opacity variables..."

# Use sed to replace the variable definitions
# Handle both commented and uncommented versions
sed -i "s/^\(\s*\$blackThemedOpacity\s*=\s*\)[0-9.]\+/\1$BLACK_OPACITY/" "$HYPR_CONFIG"
sed -i "s/^\(\s*\$opacityValue\s*=\s*\)[0-9.]\+/\1$OPACITY/" "$HYPR_CONFIG"
sed -i "s/^\(\s*\$opacityDarker\s*=\s*\)[0-9.]\+/\1$DARKER/" "$HYPR_CONFIG"

# change background and change symlink to new wallpaper before running matugen
# to avoid delay on wallpaper and rofi list of wallpapers
awww img "$MATUGEN_WALL" --transition-type "any" --transition-fps 75 &

# ensure dirs exist
mkdir -p "$(dirname "$SYMLINK_PATH")"

# symlinks
ln -sf "$MATUGEN_WALL" "$SYMLINK_PATH"
ln -sf "$HYPRLOCK_WALL" "$HYPRLOCK_SYMLINK"

# run matugen
echo "🎨 Generating theme colors..."
matugen image "$MATUGEN_WALL"

swaync-client -rs

# Reload Hyprland to apply new opacity values
echo "🔄 Reloading Hyprland..."
hyprctl reload

echo "✅ Theme '$SELECTED_NAME'"
echo "   matugen → $(basename "$MATUGEN_WALL")"
echo "   hyprlock → $(basename "$HYPRLOCK_WALL")"
echo "   opacity → black:$BLACK_OPACITY | normal:$OPACITY | darker:$DARKER"

notify-send "opacity
black:$BLACK_OPACITY
normal:$OPACITY
darker:$DARKER"
