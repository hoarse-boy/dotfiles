#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}ERROR: Please run this script as a regular user (not root)${NC}"
  exit 1
fi

echo -e "${GREEN}Setting up Kanata permissions and systemd integration...${NC}"

# --- Permission Setup ---
NEEDS_REBOOT=false

# 1. Ensure uinput group exists
if ! getent group uinput >/dev/null; then
  echo -e "${YELLOW}Creating uinput group...${NC}"
  sudo groupadd uinput || {
    echo -e "${RED}Failed to create uinput group${NC}"
    exit 1
  }
fi

# 2. Add user to required groups
for group in input uinput; do
  if ! groups | grep -q "\b$group\b"; then
    echo -e "${YELLOW}Adding user to $group group...${NC}"
    sudo usermod -aG "$group" "$USER" || {
      echo -e "${RED}Failed to add user to $group group${NC}"
      exit 1
    }
    NEEDS_REBOOT=true
  fi
done

# 3. Configure udev rules
UDEV_RULE='KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"'
UDEV_FILE="/etc/udev/rules.d/99-uinput.rules"

if [ ! -f "$UDEV_FILE" ] || ! grep -qF "$UDEV_RULE" "$UDEV_FILE" 2>/dev/null; then
  echo -e "${YELLOW}Configuring udev rules...${NC}"
  echo "$UDEV_RULE" | sudo tee "$UDEV_FILE" >/dev/null || {
    echo -e "${RED}Failed to write udev rules${NC}"
    exit 1
  }
  sudo udevadm control --reload-rules && sudo udevadm trigger || {
    echo -e "${RED}Failed to reload udev rules${NC}"
    exit 1
  }
  NEEDS_REBOOT=true
fi

# 4. Ensure uinput module is loaded
if ! lsmod | grep -q uinput; then
  echo -e "${YELLOW}Loading uinput kernel module...${NC}"
  sudo modprobe uinput || {
    echo -e "${RED}Failed to load uinput module${NC}"
    exit 1
  }
fi

# Ensure module loads at boot
MODULE_LOAD_FILE="/etc/modules-load.d/uinput.conf"
if [ ! -f "$MODULE_LOAD_FILE" ]; then
  echo -e "${YELLOW}Configuring uinput to load at boot...${NC}"
  echo "uinput" | sudo tee "$MODULE_LOAD_FILE" >/dev/null || {
    echo -e "${RED}Failed to configure uinput autoload${NC}"
    exit 1
  }
fi

# --- Systemd Service Verification ---
SERVICE_NAME="kanata.service"
SERVICE_FILE="$HOME/.config/systemd/user/$SERVICE_NAME"

# Verify service file exists
if [ ! -f "$SERVICE_FILE" ]; then
  echo -e "${RED}Error: Service file not found at $SERVICE_FILE${NC}"
  echo -e "Please create your systemd service file first"
  exit 1
fi

# Enable lingering for user services to start at boot
if ! loginctl show-user "$USER" | grep -q 'Linger=yes'; then
  echo -e "${YELLOW}Enabling linger for user services...${NC}"
  sudo loginctl enable-linger "$USER" || {
    echo -e "${RED}Failed to enable linger${NC}"
    exit 1
  }
fi

# Enable the service
echo -e "${YELLOW}Configuring systemd service...${NC}"
systemctl --user daemon-reload || {
  echo -e "${RED}Failed to reload systemd user units${NC}"
  exit 1
}

if ! systemctl --user is-enabled "$SERVICE_NAME" >/dev/null 2>&1; then
  systemctl --user enable "$SERVICE_NAME" || {
    echo -e "${RED}Failed to enable kanata service${NC}"
    exit 1
  }
fi

# --- Final Instructions ---
echo -e "\n${GREEN}Setup completed successfully!${NC}"

if [ "$NEEDS_REBOOT" = true ]; then
  echo -e "\n${YELLOW}IMPORTANT: You MUST reboot for all changes to take effect!${NC}"
else
  echo -e "\n${YELLOW}Note: Some changes may require a reboot to take effect${NC}"
fi

echo -e "\n${GREEN}After reboot, Kanata will start automatically.${NC}"
echo -e "\n${GREEN}Service management commands:${NC}"
echo -e "  Check status: ${YELLOW}systemctl --user status $SERVICE_NAME${NC}"
echo -e "  View logs:    ${YELLOW}journalctl --user -u $SERVICE_NAME -f${NC}"
echo -e "  Start now:    ${YELLOW}systemctl --user start $SERVICE_NAME${NC}"
echo -e "  Stop:         ${YELLOW}systemctl --user stop $SERVICE_NAME${NC}"
