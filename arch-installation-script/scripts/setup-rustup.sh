#!/bin/bash
# Rust Environment Initialization Script

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
HAD_ERRORS=false
CARGO_ENV="$HOME/.cargo/env"

# --- Main Execution ---
log_separator
echo -e "${GREEN}🦀 Setting up Rust environment...${NC}"
log_separator

# --- rustup Installation ---
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

echo -e "${YELLOW}🔍 Checking for rustup...${NC}"

if ! command_exists rustup; then
  echo -e "${YELLOW}⬇️ Installing rustup...${NC}"
  if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
    echo -e "${GREEN}✓ rustup installed successfully${NC}"

    # Source cargo env if it exists
    if [ -f "$CARGO_ENV" ]; then
      source "$CARGO_ENV"
      echo -e "${GREEN}✓ Sourced cargo environment${NC}"
    else
      echo -e "${YELLOW}⚠️ Cargo environment file not found${NC}"
      HAD_ERRORS=true
    fi
  else
    echo -e "${RED}❌ rustup installation failed${NC}"
    HAD_ERRORS=true
  fi
else
  echo -e "${GREEN}✓ rustup already installed${NC}"
fi

# --- Toolchain Configuration ---
log_separator
echo -e "${YELLOW}⚙️ Configuring toolchain...${NC}"

if command_exists rustup; then
  # Set stable toolchain
  if rustup default stable; then
    echo -e "${GREEN}✓ Stable toolchain set as default${NC}"
  else
    echo -e "${RED}❌ Failed to set stable toolchain${NC}"
    HAD_ERRORS=true
  fi

  # Update toolchains
  if rustup update; then
    echo -e "${GREEN}✓ Toolchains updated${NC}"
  else
    echo -e "${RED}❌ Failed to update toolchains${NC}"
    HAD_ERRORS=true
  fi

  # Add components
  echo -e "${YELLOW}➕ Adding components...${NC}"
  for component in rustfmt clippy; do
    if rustup component add "$component"; then
      echo -e "${GREEN}✓ Added $component${NC}"
    else
      echo -e "${RED}❌ Failed to add $component${NC}"
      HAD_ERRORS=true
    fi
  done
else
  echo -e "${RED}❌ rustup not available for configuration${NC}"
  HAD_ERRORS=true
fi

# --- Verification ---
log_separator
echo -e "${YELLOW}🔍 Verifying installation...${NC}"

if command_exists rustc && command_exists cargo; then
  echo -e "${BLUE}rustc version:${NC} $(rustc --version 2>/dev/null || echo "Not found")"
  echo -e "${BLUE}cargo version:${NC} $(cargo --version 2>/dev/null || echo "Not found")"
else
  echo -e "${RED}❌ Rust tools not found in PATH${NC}"
  HAD_ERRORS=true
fi

# --- Completion ---
log_separator
if [ "$HAD_ERRORS" = true ]; then
  echo -e "${YELLOW}⚠️  Rust environment setup completed with some errors${NC}"
else
  echo -e "${GREEN}✅ Rust environment setup completed successfully!${NC}"
fi

echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Open a new terminal to ensure environment is properly loaded"
echo "2. Run ${YELLOW}cargo --version${NC} to verify installation"
echo "3. Check ${YELLOW}~/.cargo/bin${NC} is in your PATH"
log_separator
