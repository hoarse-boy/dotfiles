#!/usr/bin/env bash
# Ghostty Terminal Configuration Script

set -uo pipefail

# append to failed scripts list
SCRIPT_NAME="$(basename "$0")"

# Colors and logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_separator() {
  echo -e "\n${BLUE}══════════════════════════════════════════════════${NC}\n"
}

fail_or_exit() {
  echo -e "${RED}❌ $1${NC}"
  echo "$SCRIPT_NAME" >>/tmp/b-failed.txt
  exit 1
}

# Initialize
CONFIG_DIR="$HOME/.config/ghostty"
CONFIG_FILE="$CONFIG_DIR/other"

# --- Main Execution ---
log_separator
echo -e "${GREEN}👻 configuring ghostty terminal...${NC}"
log_separator

# --- Directory Setup ---
echo -e "${YELLOW}📂 setting up configuration directory...${NC}"
mkdir -p "$CONFIG_DIR" || fail_or_exit "failed to create configuration directory"
echo -e "${GREEN}✓ configuration directory ready${NC}"

# --- Configuration Creation ---
log_separator
echo -e "${YELLOW}⚙️  creating configuration file...${NC}"

if [[ -f "$CONFIG_FILE" ]]; then
  echo -e "${YELLOW}⚠️  configuration file already exists at:${NC}"
  echo -e "${BLUE}$CONFIG_FILE${NC}"
  echo -e "${YELLOW}skipping creation to avoid overwrite.${NC}"
else
  cat >"$CONFIG_FILE" <<EOF
font-size = 13
# font-family = JetBrains Mono NL Bold Nerd Font Complete Mono
background-opacity = 1
command = fish --login --interactive
EOF

  [[ $? -eq 0 ]] || fail_or_exit "failed to create configuration file"
  echo -e "${GREEN}✓ configuration file created successfully${NC}"
  echo -e "${BLUE}file location:${NC} $CONFIG_FILE"
fi

# --- Verification ---
log_separator
echo -e "${YELLOW}🔍 verifying configuration...${NC}"
[[ -f "$CONFIG_FILE" ]] || fail_or_exit "configuration file missing"

echo -e "${GREEN}✓ configuration file exists${NC}"
echo -e "\n${BLUE}current configuration:${NC}"
cat "$CONFIG_FILE"

# --- Completion ---
log_separator
echo -e "${GREEN}✅ ghostty configuration completed successfully!${NC}"
echo -e "\n${BLUE}next steps:${NC}"
echo "1. restart Ghostty to apply changes"
echo "2. customize your configuration further by editing:"
echo -e "   ${YELLOW}$CONFIG_FILE${NC}"
log_separator
