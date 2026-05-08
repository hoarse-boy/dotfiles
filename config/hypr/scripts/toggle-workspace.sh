#!/bin/bash

# Toggle workspace script for Hyprland
# Logic flow:
# 1. Get currently active special workspace on focused monitor
# 2. Based on argument:
#    - Special workspace name: toggle between special workspaces
#    - Number: close special workspace (if any) and switch to number
#    - left/right: close special workspace (if any) and stop (no workspace switch)
#    - down: close special workspace (if any) and run empty workspace script

# Close special workspace on the focused monitor if one is present
active=$(hyprctl -j monitors | jq --raw-output '.[] | select(.focused==true).specialWorkspace.name | split(":") | if length > 1 then .[1] else "" end')

if [[ ${#active} -gt 0 ]]; then
  hyprctl dispatch togglespecialworkspace "$active"

  # eww close special-ws

  # If moving to the left, right or down, inside a special workspace, close the special workspace and stop
  case "$1" in
  "left" | "right" | "down")
    exit 0
    ;;
  esac
fi

# Handle workspace switching based on input
case "$1" in
[[:digit:]]*) # If starts with a digit (number)
  hyprctl dispatch workspace "$1"
  ;;
"left")
  hyprctl dispatch workspace r-1
  ;;
"right")
  hyprctl dispatch workspace r+1
  ;;
"down")
  # hyprctl dispatch workspace empty
  # script below has the same effect when enabling hyprland's binds { workspace_back_and_forth = true } but only form empty workspaces.
  ~/.config/hypr/scripts/toggle-empty-ws.sh
  ;;
*)
  notify-send "Toggle-workspace-hyprland" "Invalid argument $1" -t 4000
  echo "Invalid argument: $1" >&2
  exit 1
  ;;
esac
