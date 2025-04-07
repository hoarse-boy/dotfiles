#!/usr/bin/env bash

set -uo pipefail

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # no color

fail_or_exit() {
  local msg="$1"
  echo -e "${RED}❌ $msg${NC}"
  exit 1
}

log_separator() {
  echo -e "\n${BLUE}═══════════════════════════════════════════════${NC}\n"
}

TIMER_NAME="water-reminder.timer"

log_separator
echo -e "${GREEN}💧 setting up water reminder systemd timer...${NC}"
log_separator

# --- reload and enable timer ---
echo -e "${YELLOW}🔄 reloading and enabling systemd timer...${NC}"
systemctl --user daemon-reload || fail_or_exit "failed to reload systemd"

if systemctl --user is-enabled "$TIMER_NAME" &>/dev/null; then
  echo -e "${GREEN}✓ timer already enabled${NC}"
else
  systemctl --user enable --now "$TIMER_NAME" || fail_or_exit "failed to enable and start timer"
  echo -e "${GREEN}✓ timer enabled and started${NC}"
fi

# --- verification ---
echo -e "${YELLOW}🔍 verifying timer...${NC}"

if systemctl --user list-timers --all | grep -q "$TIMER_NAME"; then
  echo -e "${GREEN}✓ timer is listed and active${NC}"
else
  fail_or_exit "timer not found in list-timers"
fi

log_separator
echo -e "${GREEN}✅ water reminder activated successfully!${NC}"
log_separator
