#!/bin/bash
# NPM User Setup Script (Idempotent)

# Configuration
set -uo pipefail  # Safer than set -e

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
HAD_ERRORS=false
NPM_GLOBAL_DIR="$HOME/.npm-global"

# --- Main Execution ---
log_separator
echo -e "${GREEN}🛠️  Setting up npm with user permissions...${NC}"
log_separator

# --- Directory Setup ---
echo -e "${YELLOW}📂 Configuring npm directories...${NC}"

# Create global directory
if mkdir -p "$NPM_GLOBAL_DIR"; then
  echo -e "${GREEN}✓ Created npm global directory${NC}"
  if npm config set prefix "$NPM_GLOBAL_DIR" >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Set npm prefix${NC}"
  else
    echo -e "${RED}❌ Failed to set npm prefix${NC}"
    HAD_ERRORS=true
  fi
else
  echo -e "${RED}❌ Failed to create npm global directory${NC}"
  HAD_ERRORS=true
fi

# Fix cache permissions
if [ "$(stat -c '%U' ~/.npm 2>/dev/null)" != "$USER" ]; then
  echo -e "${YELLOW}🔧 Fixing npm cache permissions...${NC}"
  if sudo chown -R "$USER:$USER" ~/.npm; then
    echo -e "${GREEN}✓ Fixed npm cache permissions${NC}"
  else
    echo -e "${RED}❌ Failed to fix cache permissions${NC}"
    HAD_ERRORS=true
  fi
else
  echo -e "${GREEN}✓ npm cache permissions already correct${NC}"
fi

# --- Package Installation ---
log_separator
echo -e "${YELLOW}📦 Installing global packages...${NC}"

install_if_missing() {
  if ! npm list -g "$1" --depth=0 >/dev/null 2>&1; then
    echo -e "${YELLOW}⬇️  Installing $1...${NC}"
    if "$NPM_GLOBAL_DIR/bin/npm" install -g "$1"; then
      echo -e "${GREEN}✓ Installed $1${NC}"
    else
      echo -e "${RED}❌ Failed to install $1${NC}"
      HAD_ERRORS=true
      return 1
    fi
  else
    echo -e "${GREEN}✅ $1 already installed${NC}"
  fi
}

# Core packages
install_if_missing czg
install_if_missing npm-check-updates
install_if_missing yarn

# --- Verification ---
log_separator
echo -e "${YELLOW}🔍 Verifying setup...${NC}"

echo -e "${BLUE}npm prefix:${NC} $(npm config get prefix)"
echo -e "${BLUE}Global packages:${NC}"
"$NPM_GLOBAL_DIR/bin/npm" list -g --depth=0 | grep -v "├──" | grep -v "└──"

# --- Completion ---
log_separator
if [ "$HAD_ERRORS" = true ]; then
  echo -e "${YELLOW}⚠️  Setup completed with some errors${NC}"
else
  echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
fi

echo -e "\n${BLUE}You can now:${NC}"
echo "- Use 'npm install -g' without sudo"
echo "- Global binaries are in ~/.npm-global/bin"
echo "- Add ~/.npm-global/bin to your PATH if not already present"

echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Restart your shell"
echo "2. Or run: source ~/.bashrc (or equivalent for your shell)"
log_separator
