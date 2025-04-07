#!/bin/bash
# Arch X Hyprland Dotfiles Installer bootstrapped by ML4W

# -------------------------------
# Configuration
# -------------------------------
REPO_URL="https://github.com/hoarse-boy/dotfiles.git"
ML4W_INSTALL_URL="https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh"
INSTALL_DIR="$HOME/my-dotfiles"
BIN_DIR="$INSTALL_DIR/bin/.local/bin"

LOG_FILE="$INSTALL_DIR/installation.log"
MAX_LOG_SIZE=1048576 # 1MB

# -------------------------------
# Log Rotation
# -------------------------------
if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -gt $MAX_LOG_SIZE ]; then
  mv "$LOG_FILE" "$LOG_FILE.old"
fi

echo -e "\n\n=== Installation started $(date) ===\n" >>"$LOG_FILE"

# -------------------------------
# Colors
# -------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# -------------------------------
# Global Error Log
# -------------------------------
ERROR_LOG=""

log_separator() {
  echo -e "\n${YELLOW}══════════════════════════════════════════════════${NC}\n"
}

# -------------------------------
# Functions
# -------------------------------
ensure_local_bin_in_path() {
  if ! grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' "$HOME/.bashrc"; then
    echo -e "${YELLOW}➕ Adding ~/.local/bin to PATH in .bashrc...${NC}"
    echo '' >>"$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.bashrc"
    echo -e "${GREEN}✅ .bashrc updated!${NC}"
  else
    echo -e "${GREEN}✅ ~/.local/bin already in PATH${NC}"
  fi

  export PATH="$HOME/.local/bin:$PATH"
}

install_ml4w() {
  echo -e "\n${GREEN}🚀 Installing ML4W base system...${NC}"
  bash <(curl -s "$ML4W_INSTALL_URL")
}

clone_repo() {
  if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "\n${GREEN}📦 Cloning dotfiles repository...${NC}"
    git clone --recursive "$REPO_URL" "$INSTALL_DIR"
  else
    echo -e "\n${YELLOW}ℹ️  Dotfiles already exist at $INSTALL_DIR${NC}"
    read -rp "Update repository? [y/N] " answer
    if [[ "$answer" =~ [yY] ]]; then
      cd "$INSTALL_DIR" || return 1
      git pull && git submodule update --init --recursive
    fi
  fi
}

verify_binaries() {
  echo -e "\n${GREEN}🔍 Verifying installation binaries...${NC}"

  if [ ! -d "$BIN_DIR" ]; then
    echo -e "${RED}❌ Critical error: Binaries directory not found${NC}"
    return 1
  fi

  cd "$BIN_DIR" || return 1

  for script in stow-all manage-ml4w-config; do
    if [ ! -f "$script" ]; then
      echo -e "${RED}❌ Missing required script: $script${NC}"
      return 1
    fi
    chmod +x "$script"
  done
}

# -------------------------------
# Installer Entry Point
# -------------------------------
clear
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/
EOF
echo -e "${GREEN}Arch Hyprland Installer${NC}\n"

echo -e "${YELLOW}This will:${NC}"
echo "1. Install ML4W base system"
echo "2. Clone your dotfiles repository"
echo "3. Prepare your dotfiles binaries"
echo "4. Run system configuration"
echo -e "\n${YELLOW}Requirements:${NC}"
echo "- curl, git installed"
echo "- Internet connection"

echo -e "\n${RED}WARNING:${NC}"
echo "Press 'no' when ML4W asks to reboot"
echo "But if accidentally rebooted, just skip it to resume the next installation by following these steps:"
echo "1. Press 'y' to continue"
echo "2. Press 'n' to cancel the 'ML4W Dotfiles for Hyprland' to skip it"

read -rp $'\nDo you want to continue? [y/N] ' answer
if [[ ! "$answer" =~ [yY] ]]; then
  echo -e "${RED}❌ Installation canceled${NC}"
  exit 0
fi

# -------------------------------
# Run Each Step with Error Capture
# -------------------------------
if ! install_ml4w; then
  ERROR_LOG+="❌ ML4W installation failed\n"
fi
log_separator

if ! clone_repo; then
  ERROR_LOG+="❌ Failed to clone or update dotfiles repo\n"
fi
log_separator

if ! verify_binaries; then
  ERROR_LOG+="❌ Required binaries missing or setup failed\n"
fi
log_separator

if ! ensure_local_bin_in_path; then
  ERROR_LOG+="❌ Failed to update PATH with ~/.local/bin\n"
fi
log_separator

echo -e "\n${GREEN}⚙️  Running configuration...${NC}"

if ! "$BIN_DIR/stow-all"; then
  ERROR_LOG+="❌ Failed running stow-all\n"
fi

if ! "$BIN_DIR/manage-ml4w-config"; then
  ERROR_LOG+="❌ Failed running manage-ml4w-config\n"
fi

if ! "$INSTALL_DIR/arch-installation-script/arch-fresh-machine-setup"; then
  ERROR_LOG+="❌ Failed running arch-fresh-machine-setup\n"
fi

# also include failed scripts from arch-fresh-machine-setup
if [[ -f /tmp/b-failed.txt ]]; then
  mapfile -t FAILED_B_SCRIPTS </tmp/b-failed.txt
  ERROR_LOG+="\n❌ Failed scripts inside arch-fresh-machine-setup:\n"
  for failed_script in "${FAILED_B_SCRIPTS[@]}"; do
    ERROR_LOG+="  - $failed_script\n"
  done
fi

# -------------------------------
# Final Summary
# -------------------------------
if [[ -n "$ERROR_LOG" ]]; then
  echo -e "\n${RED}❌ Installation finished with errors:${NC}"
  echo -e "$ERROR_LOG"
  echo -e "$ERROR_LOG" >>"$LOG_FILE"
else
  echo -e "\n${GREEN}✅ All components installed successfully!${NC}"
fi
# -------------------------------
