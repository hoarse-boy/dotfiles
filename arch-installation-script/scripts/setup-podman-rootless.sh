#!/usr/bin/env bash
# Podman Rootless Setup Script

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

# --- Main Execution ---
log_separator
echo -e "${GREEN}🚀 Setting up Podman for rootless operation...${NC}"
log_separator

# --- Kernel Configuration ---
echo -e "${YELLOW}🐧 Configuring kernel for rootless containers...${NC}"

if sudo mkdir -p /etc/sysctl.d && \
   echo "kernel.unprivileged_userns_clone=1" | sudo tee /etc/sysctl.d/99-userns.conf >/dev/null && \
   sudo sysctl -p /etc/sysctl.d/99-userns.conf >/dev/null; then
  echo -e "${GREEN}✓ Kernel namespaces configured${NC}"
else
  echo -e "${RED}❌ Failed to configure kernel namespaces${NC}"
  HAD_ERRORS=true
fi

# --- User Namespace Setup ---
log_separator
echo -e "${YELLOW}👤 Setting up subuids/subgids...${NC}"

if sudo touch /etc/subuid /etc/subgid && \
   sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"; then
  echo -e "${GREEN}✓ User namespace ranges configured${NC}"
else
  echo -e "${RED}❌ Failed to configure user namespace ranges${NC}"
  HAD_ERRORS=true
fi

# --- Storage Configuration ---
log_separator
echo -e "${YELLOW}💾 Configuring rootless storage...${NC}"

if mkdir -p \
   ~/.config/containers \
   ~/.local/share/containers/storage && \
   echo 'driver = "overlay"' > ~/.config/containers/storage.conf; then
  echo -e "${GREEN}✓ Storage directories configured${NC}"
else
  echo -e "${RED}❌ Failed to configure storage${NC}"
  HAD_ERRORS=true
fi

# --- Service Configuration ---
log_separator
echo -e "${YELLOW}⚙️  Configuring user services...${NC}"

if ! command -v loginctl >/dev/null; then
  echo -e "${YELLOW}⚠️  systemd-logind not found - cannot enable linger${NC}"
  HAD_ERRORS=true
elif loginctl enable-linger "$USER"; then
  echo -e "${GREEN}✓ Linger enabled for user services${NC}"
else
  echo -e "${RED}❌ Failed to enable linger${NC}"
  HAD_ERRORS=true
fi

# --- Verification ---
log_separator
echo -e "${YELLOW}🔍 Verifying setup...${NC}"

if podman info --format '{{.Host.Security.Rootless}}' | grep -q "true"; then
  echo -e "${GREEN}✔ Rootless mode configured successfully${NC}"
else
  echo -e "${RED}✖ Rootless setup verification failed${NC}"
  HAD_ERRORS=true
fi

# --- Completion ---
log_separator
if [ "$HAD_ERRORS" = true ]; then
  echo -e "${YELLOW}⚠️  Setup completed with some errors - check above messages${NC}"
else
  echo -e "${GREEN}✅ Podman rootless setup completed successfully!${NC}"
fi

echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Log out and back in for changes to take effect"
echo "2. Test with: ${YELLOW}podman run --rm docker.io/library/hello-world${NC}"
echo -e "\n${YELLOW}Note:${NC} You may need to reboot if user namespace changes don't take effect"
log_separator
