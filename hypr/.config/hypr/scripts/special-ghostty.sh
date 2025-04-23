#!/bin/bash

# WARN: DEPRECATED

if ! hyprctl clients -j | jq -e '.[] | select(.class == "g.s")' >/dev/null; then
  # if not running, launch it
  ghostty --class=g.s &

  # Wait for the window to appear
  for _ in {1..10}; do
    if hyprctl clients -j | jq -e '.[] | select(.class == "g.s")' >/dev/null; then
      break
    fi
    sleep 0.1
  done
fi

# switch to the special workspace (if not already there)
hyprctl dispatch togglespecialworkspace term
