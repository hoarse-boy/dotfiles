#!/usr/bin/env bash
set -euo pipefail

SERVICE="random-wallpaper.service"
TIMER="random-wallpaper.timer"

SYSTEMD_DIR="$HOME/.config/systemd/user"

# check unit files exist
[[ -f "$SYSTEMD_DIR/$SERVICE" ]] || {
  echo "missing $SYSTEMD_DIR/$SERVICE"
  exit 1
}

[[ -f "$SYSTEMD_DIR/$TIMER" ]] || {
  echo "missing $SYSTEMD_DIR/$TIMER"
  exit 1
}

# reload systemd user units
systemctl --user daemon-reload

# enable timer if not already enabled
if ! systemctl --user is-enabled --quiet "$TIMER"; then
  systemctl --user enable "$TIMER"
fi

# start timer if not running
if ! systemctl --user is-active --quiet "$TIMER"; then
  systemctl --user start "$TIMER"
fi

echo "random wallpaper timer enabled"
