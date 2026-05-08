#!/bin/bash

# file to save last non-empty workspace
SAVEFILE="/tmp/hypr_last_non_empty_ws"

# get active workspace ID
CURRENT_WS=$(hyprctl activeworkspace -j | jq '.id')

# check if current workspace has any clients
HAS_CLIENTS=$(hyprctl clients -j | jq --argjson ws "$CURRENT_WS" '[.[] | select(.workspace.id == $ws)] | length')

if [[ "$HAS_CLIENTS" -gt 0 ]]; then
  # save this workspace
  echo "$CURRENT_WS" > "$SAVEFILE"
  # switch to empty
  hyprctl dispatch workspace empty
else
  # read saved workspace
  if [[ -f "$SAVEFILE" ]]; then
    SAVED_WS=$(cat "$SAVEFILE")
    if [[ "$SAVED_WS" =~ ^[0-9]+$ && "$SAVED_WS" -ne "$CURRENT_WS" ]]; then
      hyprctl dispatch workspace "$SAVED_WS"
    fi
  fi
fi
