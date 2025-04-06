#!/bin/bash
# Arch X Hyprland Dotfiles Installer bootstraped by ML4W

# -------------------------------
# Configuration
# -------------------------------
REPO_URL="https://github.com/hoarse-boy/dotfiles.git"
ML4W_INSTALL_URL="https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh"
INSTALL_DIR="$HOME/my-dotfiles"
BIN_DIR="$INSTALL_DIR/bin/.local/bin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# -------------------------------
# Functions
# -------------------------------

# -------------------------------
# Ensure ~/.local/bin is in PATH
# -------------------------------
ensure_local_bin_in_path() {
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
    echo -e "${YELLOW}➕ Adding ~/.local/bin to PATH in .bashrc...${NC}"
    echo '' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo -e "${GREEN}✅ .bashrc updated!${NC}"
  else
    echo -e "${GREEN}✅ ~/.local/bin already in PATH${NC}"
  fi

  # Source .bashrc to update the PATH in current session
  export PATH="$HOME/.local/bin:$PATH"
}

install_ml4w() {
  echo -e "\n${GREEN}🚀 Installing ML4W base system...${NC}"
  bash <(curl -s "$ML4W_INSTALL_URL") || {
    echo -e "${RED}❌ ML4W installation failed${NC}"
    exit 1
  }
}

clone_repo() {
  if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "\n${GREEN}📦 Cloning dotfiles repository...${NC}"
    git clone --recursive "$REPO_URL" "$INSTALL_DIR" || {
      echo -e "${RED}❌ Repository clone failed${NC}"
      exit 1
    }
  else
    echo -e "\n${YELLOW}ℹ️  Dotfiles already exist at $INSTALL_DIR${NC}"
    read -rp "Update repository? [y/N] " answer
    if [[ "$answer" =~ [yY] ]]; then
      cd "$INSTALL_DIR" || exit
      git pull && git submodule update --init --recursive
    fi
  fi
}

verify_binaries() {
  echo -e "\n${GREEN}🔍 Verifying installation binaries...${NC}"

  if [ ! -d "$BIN_DIR" ]; then
    echo -e "${RED}❌ Critical error: Binaries directory not found${NC}"
    exit 1
  fi

  cd "$BIN_DIR" || exit

  for script in stow-all manage-ml4w-config; do
    if [ ! -f "$script" ]; then
      echo -e "${RED}❌ Missing required script: $script${NC}"
      exit 1
    fi
    chmod +x "$script"
  done
}

# -------------------------------
# Installation Flow
# -------------------------------
clear
cat << "EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/
EOF
echo -e "${GREEN}Arch Hyprland Installer${NC}\n"

# Show installation plan
echo -e "${YELLOW}This will:${NC}"
echo "1. Install ML4W base system"
echo "2. Clone your dotfiles repository"
echo "3. Prepare your dotfiles binaries"
echo "4. Run system configuration"
echo -e "\n${YELLOW}Requirements:${NC}"
echo "- curl, git installed"
echo "- Internet connection"

echo ""
echo -e "\n${RED}WARNING:${NC}"
echo "Press 'no' when ML4W asks to reboot"
echo "But if accidently rebooted, just skip it to resume the next installation"
echo ""

# Confirm installation
read -rp $'\nDo you want to continue? [y/N] ' answer
if [[ ! "$answer" =~ [yY] ]]; then
  echo -e "${RED}❌ Installation canceled${NC}"
  exit 0
fi

# Run installation steps
install_ml4w
clone_repo
verify_binaries

# Add ~/.local/bin to PATH automatically
ensure_local_bin_in_path

# Execute configuration scripts
echo -e "\n${GREEN}⚙️  Running configuration...${NC}"
"$BIN_DIR/stow-all" && \
"$BIN_DIR/manage-ml4w-config" && \
"$INSTALL_DIR/arch-installation-script/arch-fresh-machine-setup"

echo -e "\n${GREEN}✅ Base installation complete!${NC}"

