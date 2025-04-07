#!/usr/bin/env bash
# Syncthing Systemd Service Setup

# Configuration
set -uo pipefail

# Colors and logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_separator() {
  echo -e "\n${BLUE}══════════════════════════════════════════════════${NC}\n"
}

# Initialize
SYNC_DIR="$HOME/.config/syncthing"
SERVICE_NAME="syncthing.service"
HAD_ERRORS=false

# --- Main Execution ---
log_separator
echo -e "${GREEN}🔄 Setting up Syncthing systemd service...${NC}"
log_separator

# --- Service Stop ---
echo -e "${YELLOW}🛑 Stopping existing Syncthing instances...${NC}"

if systemctl --user is-active "$SERVICE_NAME" &>/dev/null; then
  if systemctl --user stop "$SERVICE_NAME"; then
    echo -e "${GREEN}✓ Stopped systemd service${NC}"
  else
    echo -e "${RED}❌ Failed to stop systemd service${NC}"
    HAD_ERRORS=true
  fi
fi

if pkill -u "$USER" -x syncthing 2>/dev/null; then
  echo -e "${GREEN}✓ Stopped any running Syncthing processes${NC}"
else
  echo -e "${GREEN}✓ No running Syncthing processes found${NC}"
fi

# --- Certificate Generation ---
log_separator
echo -e "${YELLOW}🔐 Checking Syncthing certificates...${NC}"

if [[ ! -f "$SYNC_DIR/key.pem" ]]; then
  echo -e "${YELLOW}🆕 Generating new Syncthing identity...${NC}"
  if syncthing generate --home="$SYNC_DIR" &&
    chmod 600 "$SYNC_DIR"/{key,https-*}.pem; then
    echo -e "${GREEN}✓ Generated new certificates${NC}"
  else
    echo -e "${RED}❌ Failed to generate certificates${NC}"
    HAD_ERRORS=true
  fi
else
  echo -e "${GREEN}✓ Existing certificates found${NC}"
fi

# --- Service Setup ---
log_separator
echo -e "${YELLOW}⚙️ Configuring Syncthing service...${NC}"

if systemctl --user daemon-reload; then
  echo -e "${GREEN}✓ Systemd units reloaded${NC}"

  if systemctl --user enable "$SERVICE_NAME"; then
    echo -e "${GREEN}✓ Service enabled for auto-start${NC}"

    if systemctl --user start "$SERVICE_NAME"; then
      echo -e "${GREEN}✓ Service started successfully${NC}"
    else
      echo -e "${RED}❌ Failed to start service${NC}"
      HAD_ERRORS=true
    fi
  else
    echo -e "${RED}❌ Failed to enable service${NC}"
    HAD_ERRORS=true
  fi
else
  echo -e "${RED}❌ Failed to reload systemd${NC}"
  HAD_ERRORS=true
fi

# --- Verification ---
log_separator
echo -e "${YELLOW}🔍 Verifying setup...${NC}"

echo -e "${BLUE}Service status:${NC}"
systemctl --user status "$SERVICE_NAME" --no-pager -l || HAD_ERRORS=true

DEVICE_ID=$(grep -oP '(?<=<device id=")[^"]+' "$SYNC_DIR/config.xml" 2>/dev/null ||
  echo -e "${YELLOW}⚠️  Could not extract device ID - check Web UI${NC}")

echo -e "\n${BLUE}Device ID:${NC} ${DEVICE_ID}"
echo -e "${BLUE}Web UI:${NC} http://127.0.0.1:8384"

# --- Completion ---
log_separator
if [ "$HAD_ERRORS" = true ]; then
  echo -e "${YELLOW}⚠️  Setup completed with some errors - check above messages${NC}"
else
  echo -e "${GREEN}✅ Syncthing setup completed successfully!${NC}"
fi

echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Access the Web UI to complete setup"
echo "2. Configure your folders and devices"
echo "3. The service will automatically start on login"
log_separator
