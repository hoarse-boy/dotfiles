#!/usr/bin/env bash

# Get script directory (absolute path)
PKG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configuration - now uses local paths
PACKAGE_FILES=(
  "${PKG_DIR}/packages-base.txt"
  "${PKG_DIR}/packages-dev.txt"
  "${PKG_DIR}/packages-app.txt"
)

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global variables
declare -a FAILED_PACKAGES

# Function to check if a command exists
command_exists() {
  command -v "$1" &>/dev/null
}

# Function to install yay if not present
install_yay() {
  if ! command_exists yay; then
    echo -e "${YELLOW}yay is not installed. Installing yay...${NC}"
    sudo pacman -S --needed git base-devel || return 1
    git clone https://aur.archlinux.org/yay.git /tmp/yay || return 1
    (cd /tmp/yay && makepkg -si) || return 1
    rm -rf /tmp/yay
    echo -e "${GREEN}yay installed successfully!${NC}"
  else
    echo -e "${BLUE}yay is already installed.${NC}"
  fi
}

# Function to check if a package is installed
is_package_installed() {
  yay -Qi "$1" &>/dev/null || yay -Qg "$1" &>/dev/null
}

# Function to install a package if not already installed
install_package() {
  local package="$1"

  if is_package_installed "$package"; then
    echo -e "${GREEN}✓ ${package} is already installed${NC}"
    return 0
  fi

  echo -e "${BLUE}Installing ${package}...${NC}"
  if yay -S --noconfirm --needed "$package"; then
    echo -e "${GREEN}✓ Successfully installed ${package}${NC}"
    return 0
  else
    echo -e "${RED}✗ Failed to install ${package}${NC}"
    FAILED_PACKAGES+=("$package")
    return 1
  fi
}

# Function to load packages from files
load_packages() {
  local package_files=("$@")
  local packages=()

  for file in "${package_files[@]}"; do
    if [[ ! -f "$file" ]]; then
      echo -e "${YELLOW}Warning: Package file ${file} not found${NC}"
      continue
    fi

    # Read packages, ignore comments and empty lines
    while IFS= read -r line; do
      [[ -z "$line" || "$line" =~ ^# ]] && continue
      packages+=("$line")
    done <"$file"
  done

  echo "${packages[@]}"
}

# Main installation function
main() {
  # Install yay first if needed
  install_yay || {
    echo -e "${RED}Failed to install yay. Cannot continue.${NC}"
    exit 1
  }

  # Update package databases
  echo -e "${BLUE}Updating package databases...${NC}"
  yay -Sy

  # Load packages from files
  echo -e "${BLUE}Loading packages...${NC}"
  read -ra PACKAGES_TO_INSTALL <<<"$(load_packages "${PACKAGE_FILES[@]}")"

  if [[ ${#PACKAGES_TO_INSTALL[@]} -eq 0 ]]; then
    echo -e "${YELLOW}No packages found to install.${NC}"
    return
  fi

  # Install each package
  echo -e "${BLUE}Installing ${#PACKAGES_TO_INSTALL[@]} packages...${NC}"
  for package in "${PACKAGES_TO_INSTALL[@]}"; do
    install_package "$package"
  done

  # Show summary
  echo -e "\n${BLUE}==== Installation Summary ====${NC}"
  echo -e "${GREEN}Successfully installed: $((${#PACKAGES_TO_INSTALL[@]} - ${#FAILED_PACKAGES[@]})) packages${NC}"

  if [[ ${#FAILED_PACKAGES[@]} -gt 0 ]]; then
    echo -e "${RED}Failed to install ${#FAILED_PACKAGES[@]} packages:${NC}"
    printf ' - %s\n' "${FAILED_PACKAGES[@]}"
    echo -e "\n${YELLOW}You can try installing these manually later.${NC}"
  fi
}

# Run the main function
main
