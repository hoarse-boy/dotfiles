#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config/mpd/mpd.conf"

echo "== MPD User Service Setup =="

# 1. ensure config exists
if [[ ! -f "$CONFIG" ]]; then
    echo "ERROR: mpd.conf not found at $CONFIG"
    exit 1
fi

# 2. check if system mpd is running (conflict prevention)
if systemctl is-active --quiet mpd.service; then
    echo "ERROR: system-wide mpd.service is running."
    echo "Disable it first with:"
    echo "  sudo systemctl stop mpd.service"
    echo "  sudo systemctl stop mpd.socket"
    exit 1
fi

# 3. create required directories (safe if already exist)
mkdir -p "$HOME/.config/mpd/playlists"

# 4. enable user service (idempotent)
if ! systemctl --user is-enabled --quiet mpd.service; then
    echo "Enabling user mpd.service..."
    systemctl --user enable mpd.service
fi

# 5. restart cleanly (idempotent-safe)
if systemctl --user is-active --quiet mpd.service; then
    echo "Restarting mpd.service..."
    systemctl --user restart mpd.service
else
    echo "Starting mpd.service..."
    systemctl --user start mpd.service
fi

# 6. verify
if systemctl --user is-active --quiet mpd.service; then
    echo "MPD user service is running."
else
    echo "ERROR: MPD failed to start."
    exit 1
fi

echo
echo "You can now run: mpc update"
