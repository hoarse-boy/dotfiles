#!/usr/bin/env bash
# Ghostty Terminal Configuration Script

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
CONFIG_DIR="$HOME/.config/ghostty"
CONFIG_FILE="$CONFIG_DIR/other"
HAD_ERRORS=false

# --- Main Execution ---
log_separator
echo -e "${GREEN}👻 Configuring Ghostty Terminal...${NC}"
log_separator

# --- Directory Setup ---
echo -e "${YELLOW}📂 Setting up configuration directory...${NC}"

if mkdir -p "$CONFIG_DIR"; then
  echo -e "${GREEN}✓ Configuration directory ready${NC}"
else
  echo -e "${RED}❌ Failed to create configuration directory${NC}"
  exit 1
fi

# --- Configuration Creation ---
log_separator
echo -e "${YELLOW}⚙️  Creating configuration file...${NC}"

if [[ -f "$CONFIG_FILE" ]]; then
  echo -e "${YELLOW}⚠️  Configuration file already exists at:${NC}"
  echo -e "${BLUE}$CONFIG_FILE${NC}"
  echo -e "${YELLOW}Backing up existing file...${NC}"
  cp "$CONFIG_FILE" "$CONFIG_FILE.bak" &&
    echo -e "${GREEN}✓ Backup created: ${CONFIG_FILE}.bak${NC}"
fi

cat >"$CONFIG_FILE" <<EOF
font-size = 13
# font-family = JetBrains Mono NL Bold Nerd Font Complete Mono
background-opacity = 0.93
EOF

if [[ $? -eq 0 ]]; then
  echo -e "${GREEN}✓ Configuration file created successfully${NC}"
  echo -e "${BLUE}File location:${NC} $CONFIG_FILE"
else
  echo -e "${RED}❌ Failed to create configuration file${NC}"
  HAD_ERRORS=true
fi

# --- Verification ---
log_separator
echo -e "${YELLOW}🔍 Verifying configuration...${NC}"

if [[ -f "$CONFIG_FILE" ]]; then
  echo -e "${GREEN}✓ Configuration file exists${NC}"
  echo -e "\n${BLUE}Current configuration:${NC}"
  cat "$CONFIG_FILE"
else
  echo -e "${RED}❌ Configuration file missing${NC}"
  HAD_ERRORS=true
fi

# --- Completion ---
log_separator
if [[ "$HAD_ERRORS" = true ]]; then
  echo -e "${YELLOW}⚠️  Setup completed with some errors${NC}"
else
  echo -e "${GREEN}✅ Ghostty configuration completed successfully!${NC}"
fi

echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Restart Ghostty to apply changes"
echo "2. Customize your configuration further by editing:"
echo -e "   ${YELLOW}$CONFIG_FILE${NC}"
log_separator
