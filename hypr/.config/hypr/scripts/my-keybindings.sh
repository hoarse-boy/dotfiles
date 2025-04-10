#!/bin/bash
# -----------------------------------------------------
# Hyprland keybinds with decoded modifiers
# -----------------------------------------------------

decode_modmask() {
  local mask=$1
  local mods=()

  (( mask & 1 )) && mods+=("SHIFT")
  (( mask & 4 )) && mods+=("CTRL")
  (( mask & 64 )) && mods+=("SUPER")
  (( mask & 8 )) && mods+=("ALT")

  IFS=' + ' ; echo "${mods[*]}"
}

formatted=$(
  hyprctl binds -j | jq -r '
    .[] 
    | select(.submap == "") 
    | "\(.modmask)|\(.key)|\(.description // "No description")"
  ' | while IFS='|' read -r modmask key desc; do
    mods=$(decode_modmask "$modmask")
    echo "${mods} + ${key} → ${desc}"
  done
)

if [ -n "$formatted" ]; then
  echo "[INFO] Showing in rofi..."
  rofi -dmenu -i -markup -p "󰌌 Keybinds" \
    -config ~/.config/rofi/config-compact.rasi <<< "$formatted"
else
  echo "[WARN] No keybinds found."
fi



