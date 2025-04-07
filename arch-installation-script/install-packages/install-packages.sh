#!/usr/bin/env bash
# Arch Linux Package Installer

# -------------------------------
# Configuration
# -------------------------------
set -uo pipefail  # Safer than set -e

# Directories
PKG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILES=(
  "${PKG_DIR}/packages-base.txt"
  "${PKG_DIR}/packages-dev.txt"
  "${PKG_DIR}/packages-app.txt"
)
LOG_DIR="${PKG_DIR}/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/package-install-$(date +%Y%m%d-%H%M%S).log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# -------------------------------
# Logging Setup
# -------------------------------
{
    echo -e "\n=== START: $(date) ==="
    echo "Package installation log: $LOG_FILE"
    
    # Save original stdout/stderr
    exec 3>&1 4>&2
    
    # Tee output to log file (without color codes)
    exec > >(
        tee -i >(
            while IFS= read -r line; do
                printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" \
                "$(echo "$line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")"
            done >> "$LOG_FILE"
        )
    ) 2>&1
}

# -------------------------------
# Functions
# -------------------------------
log_separator() {
    echo -e "\n${BLUE}══════════════════════════════════════════════════${NC}\n"
}

command_exists() {
  command -v "$1" &>/dev/null
}

install_yay() {
  log_separator
  echo -e "${YELLOW}🔧 Checking yay installation...${NC}"

  if ! command_exists yay; then
    echo -e "${BLUE}Installing yay...${NC}"
    
    if ! sudo pacman -S --needed git base-devel; then
      echo -e "${RED}❌ Failed to install prerequisites for yay${NC}"
      return 1
    fi
    
    if ! git clone https://aur.archlinux.org/yay.git /tmp/yay; then
      echo -e "${RED}❌ Failed to clone yay repository${NC}"
      return 1
    fi
    
    if ! (cd /tmp/yay && makepkg -si); then
      echo -e "${RED}❌ Failed to build yay${NC}"
      return 1
    fi
    
    rm -rf /tmp/yay
    echo -e "${GREEN}✓ yay installed successfully${NC}"
  else
    echo -e "${GREEN}✓ yay already installed${NC}"
  fi
}

is_package_installed() {
  yay -Qi "$1" &>/dev/null || yay -Qg "$1" &>/dev/null
}

install_package() {
  local package="$1"

  if is_package_installed "$package"; then
    echo -e "${GREEN}✓ ${package} (already installed)${NC}"
    return 0
  fi

  echo -e "${BLUE}⬇️ Installing ${package}...${NC}"
  if yay -S --noconfirm --needed "$package"; then
    echo -e "${GREEN}✓ Installed ${package}${NC}"
    return 0
  else
    echo -e "${YELLOW}⚠️ Failed to install ${package}${NC}"
    return 1
  fi
}

load_packages() {
  local package_files=("$@")
  local packages=()

  for file in "${package_files[@]}"; do
    if [[ ! -f "$file" ]]; then
      echo -e "${YELLOW}⚠️ Package file not found: ${file}${NC}"
      continue
    fi

    while IFS= read -r line; do
      [[ -z "$line" || "$line" =~ ^# ]] && continue
      packages+=("$line")
    done <"$file"
  done

  echo "${packages[@]}"
}

# -------------------------------
# Main Execution
# -------------------------------
main() {
  local total_packages=0
  local failed_packages=()
  local success_count=0

  log_separator
  echo -e "${GREEN}🛠️ Starting package installation...${NC}"
  log_separator

  # Install yay first if needed
  if ! install_yay; then
    echo -e "${RED}❌ Critical: yay installation failed${NC}"
    return 1
  fi

  # Update package databases
  echo -e "${BLUE}🔄 Updating package databases...${NC}"
  yay -Sy || echo -e "${YELLOW}⚠️ Package database update had issues${NC}"

  # Load packages from files
  echo -e "${BLUE}📦 Loading packages...${NC}"
  read -ra PACKAGES_TO_INSTALL <<<"$(load_packages "${PACKAGE_FILES[@]}")"
  total_packages=${#PACKAGES_TO_INSTALL[@]}

  if [[ $total_packages -eq 0 ]]; then
    echo -e "${YELLOW}⚠️ No packages found to install${NC}"
    return 1
  fi

  log_separator
  echo -e "${BLUE}📦 Installing ${total_packages} packages...${NC}"

  # Install each package
  for package in "${PACKAGES_TO_INSTALL[@]}"; do
    if install_package "$package"; then
      ((success_count++))
    else
      failed_packages+=("$package")
    fi
  done

  # Final report
  log_separator
  echo -e "${BLUE}==== Installation Summary ====${NC}"
  echo -e "${GREEN}✓ Successfully installed: ${success_count}/${total_packages} packages${NC}"

  if [[ ${#failed_packages[@]} -gt 0 ]]; then
    echo -e "${YELLOW}⚠️ Failed to install ${#failed_packages[@]} packages:${NC}"
    printf ' - %s\n' "${failed_packages[@]}"
    echo -e "\n${YELLOW}You can try installing these manually later.${NC}"
  fi

  log_separator
  echo -e "${BLUE}Log file: ${LOG_FILE}${NC}"
  
  return ${#failed_packages[@]}  # Return number of failures
}

# -------------------------------
# Run with proper logging
# -------------------------------
main
result=$?

# Restore original output
exec 1>&3 2>&4

# Final colored output
if [[ $result -eq 0 ]]; then
  echo -e "${GREEN}✅ All packages installed successfully!${NC}"
else
  echo -e "${YELLOW}⚠️ Completed with ${result} package installation failures${NC}"
  echo -e "View details: ${YELLOW}grep 'ERROR\\|FAIL' ${LOG_FILE}${NC}"
fi

exit $result
