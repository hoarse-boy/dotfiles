#!/usr/bin/env bash
set -uo pipefail

colors

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

SERVICE_NAME="openrgb.service"

log_separator
echo -e "${GREEN}🎨 setting up openrgb auto-load service...${NC}"
log_separator

--- load i2c modules ---

echo -e "${YELLOW}⚙️ loading i2c modules...${NC}"
sudo modprobe i2c-dev || fail_or_exit "failed to load i2c-dev"

detect cpu vendor for correct module

CPU_VENDOR=$(lscpu | grep "Vendor ID" | awk '{print $3}')

if [[ "$CPU_VENDOR" == "AuthenticAMD" ]]; then
sudo modprobe i2c-piix4 || fail_or_exit "failed to load i2c-piix4"
echo -e "${GREEN}✓ loaded AMD i2c module (i2c-piix4)${NC}"
elif [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
sudo modprobe i2c-i801 || fail_or_exit "failed to load i2c-i801"
echo -e "${GREEN}✓ loaded Intel i2c module (i2c-i801)${NC}"
else
echo -e "${YELLOW}⚠️ unknown CPU vendor, skipping platform-specific i2c module${NC}"
fi

log_separator
echo -e "${YELLOW}🔄 reloading and enabling openrgb systemd service...${NC}"

systemctl --user daemon-reload || fail_or_exit "failed to reload systemd"

if systemctl --user is-enabled "$SERVICE_NAME" &>/dev/null; then
echo -e "${GREEN}✓ service already enabled${NC}"
else
systemctl --user enable --now "$SERVICE_NAME" || fail_or_exit "failed to enable and start openrgb"
echo -e "${GREEN}✓ service enabled and started${NC}"
fi

log_separator
echo -e "${YELLOW}🔍 verifying service...${NC}"

if systemctl --user status "$SERVICE_NAME" &>/dev/null; then
echo -e "${GREEN}✓ openrgb service active${NC}"
else
fail_or_exit "openrgb service not active"
fi

log_separator
echo -e "${GREEN}✅ openrgb auto-load configured successfully!${NC}"
log_separator
