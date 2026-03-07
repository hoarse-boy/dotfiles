#!/usr/bin/env bash

set -euo pipefail

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

fail_or_exit() {
  local msg="$1"
  echo -e "${RED}❌ $msg${NC}"
  exit 1
}

log_separator() {
  echo -e "\n${BLUE}═══════════════════════════════════════════════${NC}\n"
}

SYSTEMD_DIR="$HOME/.config/systemd/user"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$SYSTEMD_DIR"

#################################
# verify scripts exist
#################################

for script in water-reminder.sh standup-reminder.sh eye-break.sh; do
    if [[ ! -x "$BIN_DIR/$script" ]]; then
        fail_or_exit "$BIN_DIR/$script not found or not executable"
    fi
done

#################################
# services
#################################

cat > "$SYSTEMD_DIR/water-reminder.service" <<EOF
[Unit]
Description=Water Reminder

[Service]
Type=oneshot
ExecStart=$BIN_DIR/water-reminder.sh
EOF

cat > "$SYSTEMD_DIR/standup-reminder.service" <<EOF
[Unit]
Description=Stand Up Reminder

[Service]
Type=oneshot
ExecStart=$BIN_DIR/standup-reminder.sh
EOF

cat > "$SYSTEMD_DIR/eye-break.service" <<EOF
[Unit]
Description=Eye Break Reminder

[Service]
Type=oneshot
ExecStart=$BIN_DIR/eye-break.sh
EOF

#################################
# timers
#################################

cat > "$SYSTEMD_DIR/water-reminder.timer" <<EOF
[Unit]
Description=Water Reminder Timer

[Timer]
OnBootSec=15m
OnUnitActiveSec=45m
Unit=water-reminder.service

[Install]
WantedBy=timers.target
EOF

cat > "$SYSTEMD_DIR/standup-reminder.timer" <<EOF
[Unit]
Description=Stand Up Reminder Timer

[Timer]
OnBootSec=10m
OnUnitActiveSec=30m
Unit=standup-reminder.service

[Install]
WantedBy=timers.target
EOF

cat > "$SYSTEMD_DIR/eye-break.timer" <<EOF
[Unit]
Description=Eye Break Timer

[Timer]
OnBootSec=5m
OnUnitActiveSec=2h
Unit=eye-break.service

[Install]
WantedBy=timers.target
EOF

#################################
# enable timers
#################################

systemctl --user daemon-reload || fail_or_exit "systemd reload failed"

systemctl --user enable --now water-reminder.timer
systemctl --user enable --now standup-reminder.timer
systemctl --user enable --now eye-break.timer

log_separator
echo -e "${GREEN}✓ ergonomic reminder timers installed${NC}"
log_separator
