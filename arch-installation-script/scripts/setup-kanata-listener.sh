#!/usr/bin/env bash

set -euo pipefail

# colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

fail_or_exit() {
  local msg="$1"
  echo -e "${RED}❌ $msg${NC}"
  exit 1
}

log() {
  echo -e "${BLUE}➜ $1${NC}"
}

success() {
  echo -e "${GREEN}✔ $1${NC}"
}

# check nc (OpenBSD netcat)
if ! command -v nc >/dev/null; then
  log "installing openbsd-netcat"

  if command -v pacman >/dev/null; then
    sudo pacman -S --noconfirm openbsd-netcat || fail_or_exit "failed to install openbsd-netcat"
  else
    fail_or_exit "unsupported package manager"
  fi

  success "openbsd-netcat installed"
else
  success "nc already installed"
fi

# verify systemd unit exists
SERVICE="$HOME/.config/systemd/user/kanata-waybar-listener.service"

[[ -f "$SERVICE" ]] || fail_or_exit "systemd service not found: $SERVICE"

success "systemd service found"

# reload systemd
log "reloading systemd user daemon"
systemctl --user daemon-reload

# enable service
log "enabling kanata listener"
systemctl --user enable --now kanata-waybar-listener.service

success "kanata listener enabled"

log "service status"
systemctl --user status kanata-waybar-listener.service --no-pager
