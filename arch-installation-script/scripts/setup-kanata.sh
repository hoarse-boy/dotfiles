#!/usr/bin/env bash
# Kanata Keyboard Remapper Setup Script

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

# Initialize tracking variables
NEEDS_REBOOT=false
HAD_ERRORS=false

# --- Main Execution ---
log_separator
echo -e "${GREEN}🚀 Starting Kanata Keyboard Remapper Setup${NC}"
log_separator

# --- Pre-flight Checks ---
echo -e "${YELLOW}🔍 Running pre-flight checks...${NC}"

if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}❌ ERROR: Please run this script as a regular user (not root)${NC}"
  exit 1
fi

if ! command -v kanata >/dev/null; then
  echo -e "${YELLOW}⚠️  Kanata not found in PATH. Ensure it's installed first.${NC}"
  HAD_ERRORS=true
fi

# --- Permission Setup ---
log_separator
echo -e "${GREEN}🔧 Configuring system permissions...${NC}"

# 1. Ensure uinput group exists
if ! getent group uinput >/dev/null; then
  echo -e "${YELLOW}➕ Creating uinput group...${NC}"
  if sudo groupadd uinput; then
    echo -e "${GREEN}✓ Created uinput group${NC}"
  else
    echo -e "${RED}❌ Failed to create uinput group${NC}"
    HAD_ERRORS=true
  fi
fi

# 2. Add user to required groups
for group in input uinput; do
  if ! groups | grep -q "\b$group\b"; then
    echo -e "${YELLOW}➕ Adding user to $group group...${NC}"
    if sudo usermod -aG "$group" "$USER"; then
      echo -e "${GREEN}✓ Added to $group group${NC}"
      NEEDS_REBOOT=true
    else
      echo -e "${RED}❌ Failed to add to $group group${NC}"
      HAD_ERRORS=true
    fi
  else
    echo -e "${GREEN}✓ Already in $group group${NC}"
  fi
done

# 3. Configure udev rules
UDEV_RULE='KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"'
UDEV_FILE="/etc/udev/rules.d/99-uinput.rules"

if [ ! -f "$UDEV_FILE" ] || ! grep -qF "$UDEV_RULE" "$UDEV_FILE" 2>/dev/null; then
  echo -e "${YELLOW}➕ Configuring udev rules...${NC}"
  if echo "$UDEV_RULE" | sudo tee "$UDEV_FILE" >/dev/null && \
     sudo udevadm control --reload-rules && \
     sudo udevadm trigger; then
    echo -e "${GREEN}✓ Udev rules configured${NC}"
    NEEDS_REBOOT=true
  else
    echo -e "${RED}❌ Failed to configure udev rules${NC}"
    HAD_ERRORS=true
  fi
else
  echo -e "${GREEN}✓ Udev rules already configured${NC}"
fi

# 4. Kernel module setup
log_separator
echo -e "${GREEN}🐧 Configuring kernel module...${NC}"

if ! lsmod | grep -q uinput; then
  echo -e "${YELLOW}➕ Loading uinput module...${NC}"
  if sudo modprobe uinput; then
    echo -e "${GREEN}✓ Module loaded${NC}"
  else
    echo -e "${RED}❌ Failed to load uinput module${NC}"
    HAD_ERRORS=true
  fi
else
  echo -e "${GREEN}✓ Module already loaded${NC}"
fi

MODULE_LOAD_FILE="/etc/modules-load.d/uinput.conf"
if [ ! -f "$MODULE_LOAD_FILE" ]; then
  echo -e "${YELLOW}➕ Configuring autoload...${NC}"
  if echo "uinput" | sudo tee "$MODULE_LOAD_FILE" >/dev/null; then
    echo -e "${GREEN}✓ Autoload configured${NC}"
  else
    echo -e "${RED}❌ Failed to configure autoload${NC}"
    HAD_ERRORS=true
  fi
else
  echo -e "${GREEN}✓ Autoload already configured${NC}"
fi

# --- Systemd Service Setup ---
log_separator
echo -e "${GREEN}⚙️  Configuring systemd service...${NC}"

SERVICE_NAME="kanata.service"
SERVICE_FILE="$HOME/.config/systemd/user/$SERVICE_NAME"

if [ ! -f "$SERVICE_FILE" ]; then
  echo -e "${RED}❌ Error: Service file not found at $SERVICE_FILE${NC}"
  echo -e "Please create your systemd service file first"
  HAD_ERRORS=true
else
  # Enable lingering
  if ! loginctl show-user "$USER" | grep -q 'Linger=yes'; then
    echo -e "${YELLOW}➕ Enabling linger...${NC}"
    if sudo loginctl enable-linger "$USER"; then
      echo -e "${GREEN}✓ Linger enabled${NC}"
    else
      echo -e "${RED}❌ Failed to enable linger${NC}"
      HAD_ERRORS=true
    fi
  else
    echo -e "${GREEN}✓ Linger already enabled${NC}"
  fi

  # Reload and enable service
  echo -e "${YELLOW}🔄 Reloading systemd...${NC}"
  if systemctl --user daemon-reload; then
    echo -e "${GREEN}✓ Systemd reloaded${NC}"
    
    if ! systemctl --user is-enabled "$SERVICE_NAME" >/dev/null 2>&1; then
      echo -e "${YELLOW}➕ Enabling service...${NC}"
      if systemctl --user enable "$SERVICE_NAME"; then
        echo -e "${GREEN}✓ Service enabled${NC}"
      else
        echo -e "${RED}❌ Failed to enable service${NC}"
        HAD_ERRORS=true
      fi
    else
      echo -e "${GREEN}✓ Service already enabled${NC}"
    fi
  else
    echo -e "${RED}❌ Failed to reload systemd${NC}"
    HAD_ERRORS=true
  fi
fi

# --- Completion ---
log_separator
if [ "$HAD_ERRORS" = true ]; then
  echo -e "${YELLOW}⚠️  Setup completed with some errors${NC}"
else
  echo -e "${GREEN}✅ Setup completed successfully!${NC}"
fi

if [ "$NEEDS_REBOOT" = true ]; then
  echo -e "\n${RED}🔄 IMPORTANT: You MUST reboot for all changes to take effect!${NC}"
else
  echo -e "\n${YELLOW}💡 Note: Some changes may require a reboot to take effect${NC}"
fi

echo -e "\n${GREEN}After reboot, Kanata will start automatically.${NC}"

# Service management help
log_separator
echo -e "${GREEN}🛠️  Service management commands:${NC}"
echo -e "  Check status: ${YELLOW}systemctl --user status $SERVICE_NAME${NC}"
echo -e "  View logs:    ${YELLOW}journalctl --user -u $SERVICE_NAME -f${NC}"
echo -e "  Start now:    ${YELLOW}systemctl --user start $SERVICE_NAME${NC}"
echo -e "  Stop:         ${YELLOW}systemctl --user stop $SERVICE_NAME${NC}"
echo -e "  Restart:      ${YELLOW}systemctl --user restart $SERVICE_NAME${NC}"
log_separator
