#!/bin/bash
# NPM User Setup Script (Idempotent)

# Configuration
set -uo pipefail # safer than set -e

# append to failed scripts list
SCRIPT_NAME="$(basename "$0")"

# colors and logging
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

# initialize
NPM_GLOBAL_DIR="$HOME/.npm-global"

# --- main execution ---
log_separator
echo -e "${GREEN}🛠️  setting up npm with user permissions...${NC}"
log_separator

# --- directory setup ---
echo -e "${YELLOW}📂 configuring npm directories...${NC}"

# create global directory
mkdir -p "$NPM_GLOBAL_DIR" || fail_or_exit "failed to create npm global directory"

npm config set prefix "$NPM_GLOBAL_DIR" >/dev/null 2>&1 \
  || fail_or_exit "failed to set npm prefix"

echo -e "${GREEN}✓ npm global directory and prefix configured${NC}"

# fix cache permissions
if [ "$(stat -c '%U' ~/.npm 2>/dev/null)" != "$USER" ]; then
  echo -e "${YELLOW}🔧 fixing npm cache permissions...${NC}"
  sudo chown -R "$USER:$USER" ~/.npm \
    || fail_or_exit "failed to fix npm cache permissions"
  echo -e "${GREEN}✓ fixed npm cache permissions${NC}"
else
  echo -e "${GREEN}✓ npm cache permissions already correct${NC}"
fi

# --- package installation ---
log_separator
echo -e "${YELLOW}📦 installing global packages...${NC}"

install_if_missing() {
  if ! npm list -g "$1" --depth=0 >/dev/null 2>&1; then
    echo -e "${YELLOW}⬇️  installing $1...${NC}"
    npm install -g "$1" \
      && echo -e "${GREEN}✓ installed $1${NC}" \
      || fail_or_exit "failed to install $1"
  else
    echo -e "${GREEN}✅ $1 already installed${NC}"
  fi
}

# core packages
install_if_missing czg
install_if_missing npm-check-updates
install_if_missing yarn

# --- verification ---
log_separator
echo -e "${YELLOW}🔍 verifying setup...${NC}"

echo -e "${BLUE}npm prefix:${NC} $(npm config get prefix)"
echo -e "${BLUE}global packages:${NC}"
npm list -g --depth=0

# --- completion ---
log_separator
echo -e "${GREEN}🎉 setup completed successfully!${NC}"

echo -e "\n${BLUE}you can now:${NC}"
echo "- use 'npm install -g' without sudo"
echo "- global binaries are in ~/.npm-global/bin"
echo "- add ~/.npm-global/bin to your PATH if not already present"

echo -e "\n${YELLOW}next steps:${NC}"
echo "1. restart your shell"
echo "2. or run: source ~/.bashrc (or equivalent for your shell)"
log_separator
