#!/usr/bin/env bash
# podman rootless setup script

# configuration
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
  echo "$SCRIPT_NAME" >>/tmp/b-failed.txt
  exit 1
}

# --- main execution ---
log_separator
echo -e "${GREEN}🚀 setting up podman for rootless operation...${NC}"
log_separator

# --- kernel configuration ---
echo -e "${YELLOW}🐧 configuring kernel for rootless containers...${NC}"

sudo mkdir -p /etc/sysctl.d &&
  echo "kernel.unprivileged_userns_clone=1" | sudo tee /etc/sysctl.d/99-userns.conf >/dev/null &&
  sudo sysctl -p /etc/sysctl.d/99-userns.conf >/dev/null &&
  echo -e "${GREEN}✓ kernel namespaces configured${NC}" ||
  fail_or_exit "failed to configure kernel namespaces"

# --- user namespace setup ---
log_separator
echo -e "${YELLOW}👤 setting up subuids/subgids...${NC}"

sudo touch /etc/subuid /etc/subgid &&
  sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER" &&
  echo -e "${GREEN}✓ user namespace ranges configured${NC}" ||
  fail_or_exit "failed to configure user namespace ranges"

# --- storage configuration ---
log_separator
echo -e "${YELLOW}💾 configuring rootless storage...${NC}"

mkdir -p \
  ~/.config/containers \
  ~/.local/share/containers/storage &&
  echo 'driver = "overlay"' >~/.config/containers/storage.conf &&
  echo -e "${GREEN}✓ storage directories configured${NC}" ||
  fail_or_exit "failed to configure storage"

# --- service configuration ---
log_separator
echo -e "${YELLOW}⚙️  configuring user services...${NC}"

if ! command -v loginctl >/dev/null; then
  echo -e "${YELLOW}⚠️  systemd-logind not found - cannot enable linger${NC}"
else
  loginctl enable-linger "$USER" &&
    echo -e "${GREEN}✓ linger enabled for user services${NC}" ||
    fail_or_exit "failed to enable linger"
fi

# --- verification ---
log_separator
echo -e "${YELLOW}🔍 verifying setup...${NC}"

podman info --format '{{.Host.Security.Rootless}}' | grep -q "true" &&
  echo -e "${GREEN}✔ rootless mode configured successfully${NC}" ||
  fail_or_exit "rootless setup verification failed"

# --- completion ---
log_separator
echo -e "${GREEN}✅ podman rootless setup completed successfully!${NC}"

echo -e "\n${BLUE}next steps:${NC}"
echo "1. log out and back in for changes to take effect"
echo -e "2. test with: ${YELLOW}podman run --rm docker.io/library/hello-world${NC}"
echo -e "\n${YELLOW}note:${NC} you may need to reboot if user namespace changes don't take effect"
log_separator
