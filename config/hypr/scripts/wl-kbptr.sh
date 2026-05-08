#!/usr/bin/env bash

# hardcoded because kanata.service doesn't set it. need to find a way to know the wayland display env.
# restarting kanata.service after login to hyprland fix the issue.
export WAYLAND_DISPLAY="wayland-1" 

set -euo pipefail

mode="${1:-click}"

# toggle pointer mode
if pgrep wl-kbptr >/dev/null; then
  pkill wl-kbptr
else
  wl-kbptr

  # only click if default mode
  if [[ "$mode" == "click" ]]; then
    wlrctl pointer click left
  fi
fi
