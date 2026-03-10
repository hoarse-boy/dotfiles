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

#################################
# verify scripts exist
#################################

for script in water-reminder.sh standup-reminder.sh eye-break.sh; do
  [[ -x "$BIN_DIR/$script" ]] || \
    fail_or_exit "$BIN_DIR/$script not found or not executable"
done

#################################
# verify systemd units exist (stowed)
#################################

for unit in \
  water-reminder.service \
  water-reminder.timer \
  standup-reminder.service \
  standup-reminder.timer \
  eye-break.service \
  eye-break.timer
do
  [[ -f "$SYSTEMD_DIR/$unit" ]] || \
    fail_or_exit "$SYSTEMD_DIR/$unit not found (did you stow systemd?)"
done

#################################
# reload systemd
#################################

systemctl --user daemon-reload || \
  fail_or_exit "systemd reload failed"

#################################
# enable timers
#################################

for timer in \
  water-reminder.timer \
  standup-reminder.timer \
  eye-break.timer
do
  if ! systemctl --user is-enabled --quiet "$timer"; then
    systemctl --user enable "$timer"
  fi

  if ! systemctl --user is-active --quiet "$timer"; then
    systemctl --user start "$timer"
  fi
done

log_separator
echo -e "${GREEN}✓ ergonomic reminder timers enabled${NC}"
log_separator
