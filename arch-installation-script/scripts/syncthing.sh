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

# #!/usr/bin/env bash
# set -euo pipefail

# # Configuration
# SYNC_DIR="$HOME/.config/syncthing"
# DOTFILES_DIR="$HOME/dotfiles"  # Change if your dotfiles are elsewhere

# # Verify stow has been run
# if [[ ! -f "$SYNC_DIR/config.xml" && ! -f "$DOTFILES_DIR/syncthing/.config/syncthing/config.xml" ]]; then
#     echo "Error: Neither stowed config nor dotfiles config found"
#     echo "Run 'stow syncthing' from your dotfiles first"
#     exit 1
# fi

# # 1. Stop running instances
# echo "[-] Stopping Syncthing..."
# systemctl --user stop syncthing.service 2>/dev/null || true
# pkill -u "$USER" -x syncthing 2>/dev/null || true

# # 2. Ensure directory exists
# mkdir -p "$SYNC_DIR"

# # 3. Conditional backup (only if certs exist)
# if [[ -f "$SYNC_DIR/key.pem" ]]; then
#     BACKUP_FILE="$HOME/syncthing-certs-$(date +%Y%m%d-%H%M%S).tar.gz"
#     echo "[+] Backing up existing certificates to $BACKUP_FILE..."
#     tar -czvf "$BACKUP_FILE" -C "$SYNC_DIR" {cert,key,https-*}.pem 2>/dev/null
# fi

# # 4. Install config (from stowed location or fresh from dotfiles)
# if [[ ! -f "$SYNC_DIR/config.xml" ]]; then
#     echo "[+] Installing fresh config.xml..."
#     cp "$DOTFILES_DIR/syncthing/.config/syncthing/config.xml" "$SYNC_DIR/"
# fi

# # 5. Generate certificates if missing
# if [[ ! -f "$SYNC_DIR/key.pem" ]]; then
#     echo "[+] Generating new device identity..."
#     syncthing generate --home="$SYNC_DIR"
# else
#     echo "[=] Using existing device identity"
# fi

# # 6. Set permissions
# echo "[-] Securing files..."
# chmod 600 "$SYNC_DIR"/{key,https-*}.pem 2>/dev/null || true
# chmod 644 "$SYNC_DIR/cert.pem" 2>/dev/null || true

# # 7. Restart service
# echo "[-] Restarting service..."
# systemctl --user daemon-reload
# systemctl --user restart syncthing.service

# # 8. Output status
# echo -e "\n[+] Migration complete"
# echo "Device ID: $(grep -oP '(?<=<device id=")[^"]+' "$SYNC_DIR/config.xml" 2>/dev/null || echo "Run 'syncthing generate' manually")"
# echo "Web UI: http://127.0.0.1:8384"
# echo "Verify: journalctl --user-unit syncthing.service -f"
