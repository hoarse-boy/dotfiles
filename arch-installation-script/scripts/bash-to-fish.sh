#!/usr/bin/env bash
# Change default shell to Fish (idempotent version)
set -euo pipefail

# 1. Install Fish if missing
# if ! command -v fish &>/dev/null; then
#   echo "Installing Fish shell..."
#   sudo pacman -S --needed --noconfirm fish
# fi

# 2. Get Fish path
FISH_PATH="$(command -v fish)"
echo "Fish detected at: $FISH_PATH"

# 3. Add to /etc/shells if not present
if ! grep -qxF "$FISH_PATH" /etc/shells; then
  echo "Adding Fish to /etc/shells..."
  echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
else
  echo "Fish already in /etc/shells"
fi

# 4. Change shell (only if different)
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != "$FISH_PATH" ]]; then
  echo "Changing default shell to Fish..."
  chsh -s "$FISH_PATH"
  echo "Shell changed! Please log out and back in."
else
  echo "Fish is already your default shell."
fi

# Verification
echo -e "\nVerification:"
echo "Current shell: $SHELL"
echo "Configured shell: $(getent passwd "$USER" | cut -d: -f7)"
