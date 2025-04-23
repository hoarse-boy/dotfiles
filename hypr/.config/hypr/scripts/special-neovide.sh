#!/bin/bash

# WARN: DEPRECATED

# check if the Neovide quick-note window already exists
if ! hyprctl clients -j | jq -e '.[] | select(.class == "nv-note")' >/dev/null; then
  # if not running, launch it
  neovide --wayland_app_id nv-note ~/jho-notes/quick-note.md &
  
  # Wait for the window to appear
  for i in {1..10}; do
    if hyprctl clients -j | jq -e '.[] | select(.class == "nv-note")' >/dev/null; then
      break
    fi
    sleep 0.1
  done
fi

# switch to the special workspace (if not already there)
hyprctl dispatch togglespecialworkspace quick-note
