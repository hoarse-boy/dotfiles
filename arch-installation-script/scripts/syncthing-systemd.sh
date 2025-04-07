#!/usr/bin/env bash
# syncthing systemd service setup

set -uo pipefail

# append to failed scripts list
SCRIPT_NAME="$(basename "$0")"

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # no color

log_separator() {
  echo -e "\n${BLUE}══════════════════════════════════════════════════${NC}\n"
}

fail_or_exit() {
  local msg="$1"
  echo -e "${RED}❌ $msg${NC}"
  echo "$SCRIPT_NAME" >> /tmp/b-failed.txt
  exit 1
}

# initialize
SYNC_DIR="$HOME/.config/syncthing"
SERVICE_NAME="syncthing.service"

# --- main ---
log_separator
echo -e "${GREEN}🔄 setting up syncthing systemd service...${NC}"
log_separator

# --- early check: already enabled and running? ---
if systemctl --user is-enabled "$SERVICE_NAME" &>/dev/null && systemctl --user is-active "$SERVICE_NAME" &>/dev/null; then
  echo -e "${GREEN}✓ syncthing service is already enabled and running — skipping setup${NC}"
  log_separator
  exit 0
fi

# --- stop service ---
echo -e "${YELLOW}🛑 stopping existing syncthing instances...${NC}"

if systemctl --user is-active "$SERVICE_NAME" &>/dev/null; then
  systemctl --user stop "$SERVICE_NAME" || fail_or_exit "failed to stop systemd service"
  echo -e "${GREEN}✓ stopped systemd service${NC}"
fi

if pkill -u "$USER" -x syncthing 2>/dev/null; then
  echo -e "${GREEN}✓ stopped any running syncthing processes${NC}"
else
  echo -e "${GREEN}✓ no running syncthing processes found${NC}"
fi

# --- cert generation ---
log_separator
echo -e "${YELLOW}🔐 checking syncthing certificates...${NC}"

if [[ ! -f "$SYNC_DIR/key.pem" ]]; then
  echo -e "${YELLOW}🆕 generating new syncthing identity...${NC}"
  syncthing generate --home="$SYNC_DIR" &&
  chmod 600 "$SYNC_DIR"/{key,https-*}.pem || fail_or_exit "failed to generate certificates"
  echo -e "${GREEN}✓ generated new certificates${NC}"
else
  echo -e "${GREEN}✓ existing certificates found${NC}"
fi

# --- service setup ---
log_separator
echo -e "${YELLOW}⚙️ configuring syncthing service...${NC}"

systemctl --user daemon-reload || fail_or_exit "failed to reload systemd"
echo -e "${GREEN}✓ systemd units reloaded${NC}"

if systemctl --user is-enabled "$SERVICE_NAME" &>/dev/null; then
  echo -e "${GREEN}✓ service already enabled${NC}"
else
  systemctl --user enable "$SERVICE_NAME" || fail_or_exit "failed to enable service"
  echo -e "${GREEN}✓ service enabled for auto-start${NC}"
fi

if systemctl --user is-active "$SERVICE_NAME" &>/dev/null; then
  echo -e "${GREEN}✓ service already running${NC}"
else
  systemctl --user start "$SERVICE_NAME" || fail_or_exit "failed to start service"
  echo -e "${GREEN}✓ service started successfully${NC}"
fi

# --- verification ---
log_separator
echo -e "${YELLOW}🔍 verifying setup...${NC}"

echo -e "${BLUE}service status:${NC}"
if ! systemctl --user status "$SERVICE_NAME" --no-pager -l; then
  echo -e "${YELLOW}⚠️  service status may contain warnings or errors${NC}"
fi

DEVICE_ID=$(grep -oP '(?<=<device id=")[^"]+' "$SYNC_DIR/config.xml" 2>/dev/null || true)

if [[ -n "$DEVICE_ID" ]]; then
  echo -e "\n${BLUE}device ID:${NC} ${DEVICE_ID}"
else
  echo -e "\n${YELLOW}⚠️  could not extract device ID — check Web UI${NC}"
fi

echo -e "${BLUE}web UI:${NC} http://127.0.0.1:8384"

# --- done ---
log_separator
echo -e "${GREEN}✅ syncthing setup completed successfully!${NC}"

echo -e "\n${BLUE}next steps:${NC}"
echo "1. access the Web UI to complete setup"
echo "2. configure your folders and devices"
echo "3. the service will automatically start on login"
log_separator

