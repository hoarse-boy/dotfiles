#!/usr/bin/env bash
# change default shell to fish (idempotent version)

# better error handling than set -e
set -uo pipefail

# append to failed scripts list
SCRIPT_NAME="$(basename "$0")"

# colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # no color

# log helpers
log_separator() {
  echo -e "\n${YELLOW}══════════════════════════════════════════════════${NC}\n"
}

fail_or_exit() {
  echo -e "${RED}❌ $1${NC}"
  echo "$SCRIPT_NAME" >>/tmp/b-failed.txt
  exit 1
}

log_separator
echo -e "${GREEN}starting fish shell configuration...${NC}"

# 1. verify fish is installed
FISH_PATH="$(command -v fish || true)"
[[ -z "$FISH_PATH" ]] && fail_or_exit "fish shell is not installed. uncomment install command if needed"
echo -e "${GREEN}fish detected at: ${BLUE}$FISH_PATH${NC}"

# 2. add to /etc/shells if not present
if ! grep -qxF "$FISH_PATH" /etc/shells; then
  echo -e "${YELLOW}adding fish to /etc/shells...${NC}"
  echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null ||
    fail_or_exit "failed to add fish to /etc/shells"
  echo -e "${GREEN}✓ added to /etc/shells${NC}"
else
  echo -e "${GREEN}fish already in /etc/shells${NC}"
fi

# 3. change shell (only if different)
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != "$FISH_PATH" ]]; then
  echo -e "${YELLOW}changing default shell to fish...${NC}"
  chsh -s "$FISH_PATH" || fail_or_exit "failed to change shell to fish"
  echo -e "${GREEN}✓ shell changed! please log out and back in.${NC}"
else
  echo -e "${GREEN}fish is already your default shell${NC}"
fi

# verification
log_separator
echo -e "${BLUE}verification:${NC}"
echo -e "current session shell: ${YELLOW}$SHELL${NC}"
echo -e "configured shell: ${YELLOW}$(getent passwd "$USER" | cut -d: -f7)${NC}"
log_separator
