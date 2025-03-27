#!/usr/bin/env bash

set -euo pipefail

SYNC_DIR="$HOME/.config/syncthing"
SERVICE_NAME="syncthing.service"

# 1. Stop if running (silent if not running)
if systemctl --user is-active "$SERVICE_NAME" &>/dev/null; then
    systemctl --user stop "$SERVICE_NAME"
fi
pkill -u "$USER" -x syncthing 2>/dev/null || true

# 2. Generate fresh certs if missing
if [[ ! -f "$SYNC_DIR/key.pem" ]]; then
    echo "Generating new Syncthing identity..."
    syncthing generate --home="$SYNC_DIR"
    chmod 600 "$SYNC_DIR"/{key,https-*}.pem
fi

# 3. Enable and start (will survive reboots)
echo "Enabling Syncthing to start at login..."
systemctl --user daemon-reload
systemctl --user enable "$SERVICE_NAME"  # Creates symlink for auto-start
systemctl --user start "$SERVICE_NAME"

# 4. Verification
echo -e "\nSyncthing Status:"
systemctl --user status "$SERVICE_NAME" --no-pager -l

echo -e "\nDevice ID: $(grep -oP '(?<=<device id=")[^"]+' "$SYNC_DIR/config.xml" 2>/dev/null || echo "Check Web UI")"
echo "Web UI: http://127.0.0.1:8384"

