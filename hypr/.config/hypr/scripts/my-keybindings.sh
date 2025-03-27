#!/bin/bash
# -----------------------------------------------------
# Single-line Hyprland keybinds display for rofi
# Format: "SUPER + KEY → Description" on one line
# -----------------------------------------------------

formatted=$(hyprctl binds -j | jq -r '
  .[] | select(.submap == "" and .modmask == 64) | 
  "SUPER + \(.key) → \(.description // "No description")"
')

rofi -dmenu -i -markup -p "󰌌 Keybinds" \
  -config ~/.config/rofi/config-compact.rasi <<< "$formatted"
