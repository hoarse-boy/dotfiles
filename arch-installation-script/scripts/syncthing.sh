#!/usr/bin/env bash

SYNC_DIR="$HOME/.config/syncthing"

# Stop Syncthing
systemctl --user stop syncthing.service 2>/dev/null || true
pkill -u "$USER" -x syncthing 2>/dev/null || true

# Generate fresh certs if missing
[[ ! -f "$SYNC_DIR/key.pem" ]] && {
  syncthing generate --home="$SYNC_DIR"
  chmod 600 "$SYNC_DIR"/{key,https-*}.pem
}

# Restart
systemctl --user daemon-reload
systemctl --user restart syncthing.service

# Output device ID
grep -oP '(?<=<device id=")[^"]+' "$SYNC_DIR/config.xml"

echo "Web UI: http://127.0.0.1:8384"
echo "Verify: journalctl --user-unit syncthing.service -f"

