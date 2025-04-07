#!/usr/bin/env bash
# Change default shell to Fish (idempotent version)

# Better error handling than set -e
set -uo pipefail

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to add visual separation in logs
log_separator() {
  echo -e "\n${YELLOW}══════════════════════════════════════════════════${NC}\n"
}

log_separator
echo -e "${GREEN}Starting Fish shell configuration...${NC}"

# 1. Verify Fish is installed (commented out as per original)
FISH_PATH="$(command -v fish || true)"
if [[ -z "$FISH_PATH" ]]; then
  echo -e "${RED}Error: Fish shell is not installed${NC}"
  echo -e "Uncomment the installation command in the script if needed"
  exit 1
else
  echo -e "${GREEN}Fish detected at: ${BLUE}$FISH_PATH${NC}"
fi

# 2. Add to /etc/shells if not present
if ! grep -qxF "$FISH_PATH" /etc/shells; then
  echo -e "${YELLOW}Adding Fish to /etc/shells...${NC}"
  if ! echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null; then
    echo -e "${RED}Failed to add Fish to /etc/shells${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓ Added to /etc/shells${NC}"
else
  echo -e "${GREEN}Fish already in /etc/shells${NC}"
fi

# 3. Change shell (only if different)
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != "$FISH_PATH" ]]; then
  echo -e "${YELLOW}Changing default shell to Fish...${NC}"
  if ! chsh -s "$FISH_PATH"; then
    echo -e "${RED}Failed to change shell to Fish${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓ Shell changed! Please log out and back in.${NC}"
else
  echo -e "${GREEN}Fish is already your default shell${NC}"
fi

# Verification
log_separator
echo -e "${BLUE}Verification:${NC}"
echo -e "Current session shell: ${YELLOW}$SHELL${NC}"
echo -e "Configured shell: ${YELLOW}$(getent passwd "$USER" | cut -d: -f7)${NC}"

# Final separation before next script runs
log_separator
