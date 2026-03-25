#!/usr/bin/env bash
set -euo pipefail

# ensure script runs as root
if [[ "$EUID" -ne 0 ]]; then
  echo "please run with sudo or as root"
  exit 1
fi

CONFIG_DIR="/etc/greetd"
CONFIG_FILE="/etc/greetd/config.toml"
BACKUP_FILE="/etc/greetd/config.toml.bak"

PAM_FILE="/etc/pam.d/greetd"
PAM_BACKUP_FILE="/etc/pam.d/greetd.bak"

echo "==> installing greetd and tuigreet"
pacman -S --needed --noconfirm greetd greetd-tuigreet

echo "==> disabling sddm (if present)"
if systemctl list-unit-files | grep -q "^sddm.service"; then
  systemctl disable sddm.service 2>/dev/null || true
fi

if pacman -Q sddm &>/dev/null; then
  pacman -Rns --noconfirm sddm
fi

echo "==> ensuring greetd config directory exists"
mkdir -p "$CONFIG_DIR"

if [[ -f "$CONFIG_FILE" ]]; then
  echo "existing greetd config found → creating backup"
  cp -n "$CONFIG_FILE" "$BACKUP_FILE"
fi

echo "==> writing greetd config"

cat >"$CONFIG_FILE" <<'EOF'
[terminal]
vt = 2

[default_session]
command = "tuigreet --time --asterisks --greeting 'AUTHORIZED PERSONNEL ONLY' --remember --remember-user-session --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot' --cmd start-hyprland"
user = "greeter"
EOF

echo "==> configuring PAM for keyring auto-unlock"

if [[ -f "$PAM_FILE" ]]; then
  echo "existing greetd PAM config found → creating backup"
  cp -n "$PAM_FILE" "$PAM_BACKUP_FILE"
fi

cat >"$PAM_FILE" <<'EOF'
#%PAM-1.0

auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start
EOF

echo "==> enabling greetd service"
systemctl enable greetd.service

echo "==> verifying greetd installation"

systemctl is-enabled --quiet greetd.service || {
  echo "greetd failed to enable"
  exit 1
}

echo "greetd enabled successfully (will start on next boot)"

systemctl is-active --quiet greetd.service || {
  echo "greetd is not running"
  systemctl status greetd.service --no-pager
  exit 1
}

echo "greetd enabled and running"
echo
echo "setup complete."
echo
echo "after reboot:"
echo "  tty1 → greetd + tuigreet login"
echo "  tty2 → Hyprland session"
echo "  keyring → auto-unlocks with login password"
echo
echo "reboot now to activate greetd"

# #!/usr/bin/env bash
# set -euo pipefail

# # ensure script runs as root
# if [[ "$EUID" -ne 0 ]]; then
#   echo "please run with sudo or as root"
#   exit 1
# fi

# CONFIG_DIR="/etc/greetd"
# CONFIG_FILE="/etc/greetd/config.toml"
# BACKUP_FILE="/etc/greetd/config.toml.bak"

# echo "==> installing greetd and tuigreet"
# pacman -S --needed --noconfirm greetd greetd-tuigreet

# echo "==> disabling sddm (if present)"
# if systemctl list-unit-files | grep -q "^sddm.service"; then
#   systemctl disable sddm.service 2>/dev/null || true
# fi

# if pacman -Q sddm &>/dev/null; then
#   pacman -Rns --noconfirm sddm
# fi

# echo "==> ensuring greetd config directory exists"
# mkdir -p "$CONFIG_DIR"

# if [[ -f "$CONFIG_FILE" ]]; then
#   echo "existing greetd config found → creating backup"
#   cp -n "$CONFIG_FILE" "$BACKUP_FILE"
# fi

# echo "==> writing greetd config"

# cat >"$CONFIG_FILE" <<'EOF'
# [terminal]
# vt = 2

# [default_session]
# command = "tuigreet --time --asterisks --greeting 'AUTHORIZED PERSONNEL ONLY' --remember --remember-user-session --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot' --cmd start-hyprland"
# user = "greeter"
# EOF

# echo "==> enabling greetd service"
# systemctl enable greetd.service

# echo "==> verifying greetd installation"

# systemctl is-enabled --quiet greetd.service || {
#   echo "greetd failed to enable"
#   exit 1
# }

# echo "greetd enabled successfully (will start on next boot)"

# systemctl is-active --quiet greetd.service || {
#   echo "greetd is not running"
#   systemctl status greetd.service --no-pager
#   exit 1
# }

# echo "greetd enabled and running"
# echo
# echo "setup complete."
# echo
# echo "after reboot:"
# echo "  tty1 → greetd + tuigreet login"
# echo "  tty2 → Hyprland session"
# echo
# echo "reboot now to activate greetd"
