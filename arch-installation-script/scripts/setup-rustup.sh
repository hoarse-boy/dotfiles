#!/bin/bash
# rust environment initialization script

# configuration
set -uo pipefail

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
  echo "$SCRIPT_NAME" >>/tmp/b-failed.txt
  exit 1
}

# initialize
CARGO_ENV="$HOME/.cargo/env"

# --- main execution ---
log_separator
echo -e "${GREEN}🦀 setting up rust environment...${NC}"
log_separator

# --- rustup installation ---
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

echo -e "${YELLOW}🔍 checking for rustup...${NC}"

if ! command_exists rustup; then
  echo -e "${YELLOW}⬇️ installing rustup...${NC}"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y ||
    fail_or_exit "rustup installation failed"

  # source cargo env if it exists
  if [ -f "$CARGO_ENV" ]; then
    source "$CARGO_ENV"
    echo -e "${GREEN}✓ sourced cargo environment${NC}"
  else
    fail_or_exit "cargo environment file not found"
  fi
else
  echo -e "${GREEN}✓ rustup already installed${NC}"
fi

# --- toolchain configuration ---
log_separator
echo -e "${YELLOW}⚙️ configuring toolchain...${NC}"

if command_exists rustup; then
  rustup default stable ||
    fail_or_exit "failed to set stable toolchain"

  rustup update ||
    fail_or_exit "failed to update toolchains"

  echo -e "${YELLOW}➕ adding components...${NC}"
  for component in rustfmt clippy; do
    rustup component add "$component" &&
      echo -e "${GREEN}✓ added $component${NC}" ||
      fail_or_exit "failed to add $component"
  done
else
  fail_or_exit "rustup not available for configuration"
fi

# --- verification ---
log_separator
echo -e "${YELLOW}🔍 verifying installation...${NC}"

if command_exists rustc && command_exists cargo; then
  echo -e "${BLUE}rustc version:${NC} $(rustc --version 2>/dev/null || echo "not found")"
  echo -e "${BLUE}cargo version:${NC} $(cargo --version 2>/dev/null || echo "not found")"
else
  fail_or_exit "rust tools not found in PATH"
fi

# --- completion ---
log_separator
echo -e "${GREEN}✅ rust environment setup completed successfully!${NC}"

echo -e "\n${BLUE}next steps:${NC}"
echo "1. open a new terminal to ensure environment is properly loaded"
echo -e "2. run ${YELLOW}cargo --version${NC} to verify installation"
echo -e "3. check ${YELLOW}~/.cargo/bin${NC} is in your PATH"
log_separator
