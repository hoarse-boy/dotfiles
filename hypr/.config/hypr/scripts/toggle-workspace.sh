#!/bin/bash

# Close special workspace on the focused monitor if one is present
active=$(hyprctl -j monitors | jq --raw-output '.[] | select(.focused==true).specialWorkspace.name | split(":") | if length > 1 then .[1] else "" end')

if [[ ${#active} -gt 0 ]]; then
  hyprctl dispatch togglespecialworkspace "$active"

  # If moving left or right, stop after hiding Quick-note
  if [[ "$1" == "left" || "$1" == "right" ]]; then
    exit 0
  fi
fi

# If a specific workspace is given, switch to it
if [[ "$1" =~ ^[0-9]+$ ]]; then
  hyprctl dispatch workspace "$1"
elif [[ "$1" == "left" ]]; then
  hyprctl dispatch workspace r-1
elif [[ "$1" == "right" ]]; then
  hyprctl dispatch workspace r+1
fi
