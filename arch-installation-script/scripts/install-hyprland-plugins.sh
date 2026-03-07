#!/usr/bin/env bash

set -euo pipefail

repo_url="https://github.com/hyprwm/hyprland-plugins"

plugins=(
  hyprfocus
  hyprscrolling
)

# ensure hyprpm exists
command -v hyprpm >/dev/null || {
  echo "hyprpm not installed"
  exit 1
}

echo "updating hyprpm headers..."
hyprpm update >/dev/null

# add repo if missing
if ! hyprpm list | grep -q "Repository hyprland-plugins"; then
  echo "adding hyprland plugins repo"
  hyprpm add "$repo_url"
fi

# enable plugins idempotently
for plugin in "${plugins[@]}"; do
  if hyprpm list | grep -A1 "Plugin $plugin" | grep -q "enabled: true"; then
    echo "plugin $plugin already enabled"
  else
    echo "enabling $plugin"
    hyprpm enable "$plugin"
  fi
done

echo "reloading hyprland"
hyprctl reload || true

echo "done"
