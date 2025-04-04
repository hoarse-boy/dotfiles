#!/bin/bash

# Idempotent npm Initialization Script for Arch Linux
# Safe to run multiple times - won't reinstall existing packages

echo "🛠️  Setting up npm with user permissions..."

# 1. Create safe npm global directory (idempotent)
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global >/dev/null 2>&1

# 2. Update Fish shell configuration (idempotent)
# FISH_CONFIG=~/.config/fish/config.fish
# NPM_PATH_LINE="set -gx PATH ~/.npm-global/bin \$PATH"

# if [ ! -f "$FISH_CONFIG" ] || ! grep -Fxq "$NPM_PATH_LINE" "$FISH_CONFIG"; then
#   mkdir -p ~/.config/fish
#   echo "$NPM_PATH_LINE" >>"$FISH_CONFIG"
#   echo "🐟 Added npm path to Fish config"
# else
#   echo "ℹ️  Fish config already contains npm path"
# fi

# 3. Fix npm cache permissions (idempotent)
if [ "$(stat -c '%U' ~/.npm)" != "$USER" ]; then
  sudo chown -R $USER:$USER ~/.npm
  echo "🔒 Fixed npm cache permissions"
fi

# 4. Install only missing global packages
install_if_missing() {
  if ! npm list -g "$1" --depth=0 >/dev/null 2>&1; then
    echo "📦 Installing $1..."
    ~/.npm-global/bin/npm install -g "$1"
  else
    echo "✅ $1 already installed"
  fi
}

# list of global packages to install
install_if_missing czg
install_if_missing npm-check-updates
install_if_missing yarn

# 5. Set up Commitizen if not configured
if [ ! -f ~/.czrc ]; then
  echo '{ "path": "cz-customizable" }' >~/.czrc
  echo "✏️  Created ~/.czrc for Commitizen"
fi

# 6. Verify setup
echo "\n✅ Verification:"
echo "npm prefix: $(npm config get prefix)"
echo "git-cz: $(which git-cz 2>/dev/null || echo "Not in PATH")"
echo "Global packages:"
npm list -g --depth=0 | grep -v "├──" | grep -v "└──"

echo "\n🎉 Setup complete! You can now:"
echo "- Use 'npm install -g' without sudo"
echo "- Run 'git cz' for interactive commits"
echo "- Global binaries are in ~/.npm-global/bin"
echo "\nRestart your shell or run: source ~/.config/fish/config.fish"
