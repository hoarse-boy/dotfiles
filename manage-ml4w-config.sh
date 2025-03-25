#!/bin/bash

# Configuration
DOTFILES_ROOT="$HOME/my-dotfiles"
STOW_OPERATIONS=(
  "hypr/.config/hypr/conf/keybindings:~/.config/hypr/conf/keybindings"
  ".ml4w-hyprland:~/.ml4w-hyprland"
  # Add more as: "package_path:target_path"
)

# Unified stow/unstow function
stow_operation() {
  local mode=$1 # "stow" or "unstow"

  echo "${mode^}ing items..."

  for operation in "${STOW_OPERATIONS[@]}"; do
    IFS=':' read -r package_rel_path target_path <<<"$operation"
    local package_path="$DOTFILES_ROOT/$package_rel_path"
    local stow_flags=""

    if [ "$mode" = "unstow" ]; then
      stow_flags="-D"
    fi

    if [ -d "$package_path" ]; then
      echo "→ ${mode^}ing $package_rel_path to $target_path"
      (cd "$(dirname "$package_path")" &&
        stow $stow_flags --target="${target_path/#\~/$HOME}" -v "$(basename "$package_path")")
    else
      echo "⚠ Skipping: $package_path does not exist"
    fi
  done

  echo "✅ ${mode^}ing complete!"
}

# Main menu
while true; do
  echo ""
  echo "Dotfiles Manager"
  echo "1) Stow all"
  echo "2) Unstow all"
  echo "3) Exit"
  read -rp "Choose an option [1-3]: " choice

  case "$choice" in
  1) stow_operation "stow" ;;
  2) stow_operation "unstow" ;;
  3) exit 0 ;;
  *) echo "Invalid option" ;;
  esac
done
