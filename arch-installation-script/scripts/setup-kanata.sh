#!/usr/bin/env bash
# kanata keyboard remapper setup script

set -uo pipefail

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
  echo -e "${RED}❌ $1${NC}"
  echo "$SCRIPT_NAME" >> /tmp/b-failed.txt
  exit 1
}

NEEDS_REBOOT=false

# --- main execution ---
log_separator
echo -e "${GREEN}🚀 starting kanata keyboard remapper setup${NC}"
log_separator

# --- pre-flight checks ---
echo -e "${YELLOW}🔍 running pre-flight checks...${NC}"

[[ "$EUID" -eq 0 ]] && fail_or_exit "please run this script as a regular user (not root)"

command -v kanata >/dev/null || echo -e "${YELLOW}⚠️  kanata not found in path. ensure it's installed first.${NC}"

# --- permission setup ---
log_separator
echo -e "${GREEN}🔧 configuring system permissions...${NC}"

# 1. uinput group
if ! getent group uinput >/dev/null; then
  echo -e "${YELLOW}➕ creating uinput group...${NC}"
  sudo groupadd uinput || fail_or_exit "failed to create uinput group"
  echo -e "${GREEN}✓ created uinput group${NC}"
fi

# 2. add to groups
for group in input uinput; do
  if ! groups | grep -q "\b$group\b"; then
    echo -e "${YELLOW}➕ adding user to $group group...${NC}"
    sudo usermod -aG "$group" "$USER" || fail_or_exit "failed to add to $group group"
    echo -e "${GREEN}✓ added to $group group${NC}"
    NEEDS_REBOOT=true
  else
    echo -e "${GREEN}✓ already in $group group${NC}"
  fi
done

# 3. udev rules
UDEV_RULE='KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"'
UDEV_FILE="/etc/udev/rules.d/99-uinput.rules"

if [ ! -f "$UDEV_FILE" ] || ! grep -qF "$UDEV_RULE" "$UDEV_FILE" 2>/dev/null; then
  echo -e "${YELLOW}➕ configuring udev rules...${NC}"
  echo "$UDEV_RULE" | sudo tee "$UDEV_FILE" >/dev/null || fail_or_exit "failed to write udev rule"
  sudo udevadm control --reload-rules || fail_or_exit "failed to reload udev rules"
  sudo udevadm trigger || fail_or_exit "failed to trigger udev rules"
  echo -e "${GREEN}✓ udev rules configured${NC}"
  NEEDS_REBOOT=true
else
  echo -e "${GREEN}✓ udev rules already configured${NC}"
fi

# 4. kernel module
log_separator
echo -e "${GREEN}🐧 configuring kernel module...${NC}"

if ! lsmod | grep -q uinput; then
  echo -e "${YELLOW}➕ loading uinput module...${NC}"
  sudo modprobe uinput || fail_or_exit "failed to load uinput module"
  echo -e "${GREEN}✓ module loaded${NC}"
else
  echo -e "${GREEN}✓ module already loaded${NC}"
fi

MODULE_LOAD_FILE="/etc/modules-load.d/uinput.conf"
if [ ! -f "$MODULE_LOAD_FILE" ]; then
  echo -e "${YELLOW}➕ configuring autoload...${NC}"
  echo "uinput" | sudo tee "$MODULE_LOAD_FILE" >/dev/null || fail_or_exit "failed to configure autoload"
  echo -e "${GREEN}✓ autoload configured${NC}"
else
  echo -e "${GREEN}✓ autoload already configured${NC}"
fi

# --- systemd setup ---
log_separator
echo -e "${GREEN}⚙️  configuring systemd service...${NC}"

SERVICE_NAME="kanata.service"
SERVICE_FILE="$HOME/.config/systemd/user/$SERVICE_NAME"

[[ -f "$SERVICE_FILE" ]] || fail_or_exit "error: service file not found at $SERVICE_FILE. please create it first."

# enable lingering
if ! loginctl show-user "$USER" | grep -q 'Linger=yes'; then
  echo -e "${YELLOW}➕ enabling linger...${NC}"
  sudo loginctl enable-linger "$USER" || fail_or_exit "failed to enable linger"
  echo -e "${GREEN}✓ linger enabled${NC}"
else
  echo -e "${GREEN}✓ linger already enabled${NC}"
fi

# reload and enable
echo -e "${YELLOW}🔄 reloading systemd...${NC}"
systemctl --user daemon-reload || fail_or_exit "failed to reload systemd"

if ! systemctl --user is-enabled "$SERVICE_NAME" >/dev/null 2>&1; then
  echo -e "${YELLOW}➕ enabling service...${NC}"
  systemctl --user enable "$SERVICE_NAME" || fail_or_exit "failed to enable service"
  echo -e "${GREEN}✓ service enabled${NC}"
else
  echo -e "${GREEN}✓ service already enabled${NC}"
fi

# --- completion ---
log_separator
echo -e "${GREEN}✅ setup completed successfully!${NC}"

if [ "$NEEDS_REBOOT" = true ]; then
  echo -e "\n${RED}🔄 important: you must reboot for all changes to take effect!${NC}"
else
  echo -e "\n${YELLOW}💡 note: some changes may require a reboot to take effect${NC}"
fi

echo -e "\n${GREEN}after reboot, kanata will start automatically.${NC}"

# --- systemd management help ---
log_separator
echo -e "${GREEN}🛠️  service management commands:${NC}"
echo -e "  check status: ${YELLOW}systemctl --user status $SERVICE_NAME${NC}"
echo -e "  view logs:    ${YELLOW}journalctl --user -u $SERVICE_NAME -f${NC}"
echo -e "  start now:    ${YELLOW}systemctl --user start $SERVICE_NAME${NC}"
echo -e "  stop:         ${YELLOW}systemctl --user stop $SERVICE_NAME${NC}"
echo -e "  restart:      ${YELLOW}systemctl --user restart $SERVICE_NAME${NC}"
log_separator
