#!/bin/bash

# list of directories to stow inside hypr
STOW_FILES=(
  ".config/hypr/conf/keybindings"
  # add more paths as needed
)

# function to create target directory if it doesn't exist
ensure_dir_exists() {
  if [ ! -d "$1" ]; then
    echo "📁 Target directory $1 does not exist. Creating it..."
    mkdir -p "$1"
  fi
}

# function to stow all files
stow_all() {
  echo "Stowing all specified files..."
  for path in "${STOW_FILES[@]}"; do
    full_path="$HOME/my-dotfiles/hypr/$path"
    target="$HOME/$path"

    if [ -d "$full_path" ]; then
      ensure_dir_exists "$target"
      echo "→ Stowing $full_path -> $target"
      (cd "$full_path" && stow --target="$target" -v .)
    else
      echo "⚠ Skipping: $full_path does not exist."
    fi
  done
  echo "✅ Stowing complete!"
}

# function to unstow all files
unstow_all() {
  echo "Unstowing all specified files..."
  for path in "${STOW_FILES[@]}"; do
    full_path="$HOME/my-dotfiles/hypr/$path"
    target="$HOME/$path"

    if [ -d "$full_path" ]; then
      ensure_dir_exists "$target"
      echo "→ Unstowing $full_path -> $target"
      (cd "$full_path" && stow -D --target="$target" -v .)
    else
      echo "⚠ Skipping: $full_path does not exist."
    fi
  done
  echo "✅ Unstowing complete!"
}

# prompt the user
echo "What do you want to do?"
echo "1) Stow all"
echo "2) Unstow all"
echo "3) Exit"
read -rp "Choose an option [1-3]: " choice

case "$choice" in
  1) stow_all ;;
  2) unstow_all ;;
  3) echo "Exiting."; exit 0 ;;
  *) echo "Invalid option. Exiting." ;;
esac

