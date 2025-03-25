#!/bin/bash

# set error handling
set -e

# define script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# function to check for ml4w dotfiles
check_ml4w_dotfiles() {
  if [[ ! -d "$HOME/.ml4w-hyprland/hook.sh" ]]; then
    echo "⚠️  WARNING: ml4w dotfiles not found!"
    echo "Expected directory or file : ~/.ml4w-hyprland/hook.sh"
    echo ""
    echo "This setup is designed to work with ml4w dotfiles configuration."
    echo "Run bash scripts in root of 'my-dotfiles' to create '~/.ml4w-hyprland/hook.sh' symlink and others."
    echo ""
    echo "Continuing without it may cause unexpected behavior."
    echo ""

    while true; do
      read -p "Choose action:
1) Continue anyway (not recommended)
2) Abort and setup dotfiles first
Your choice [1/2]: " choice

      case "$choice" in
        1)
          echo "Continuing without ml4w dotfiles..."
          return 0
          ;;
        2)
          echo "Aborting. Please set up 'ml4w' first."
          exit 1
          ;;
        *)
          echo "Invalid choice. Please enter 1 or 2."
          ;;
      esac
    done
  else
    echo "✅ Found ml4w dotfiles at: ~/.ml4w-hyprland"
  fi
}

# function to source environment scripts
source_scripts() {
  for script in "$SCRIPT_DIR/scripts/"*.sh; do
    if [[ -f "$script" ]]; then
      echo "🔹 Sourcing: $(basename "$script")"
      source "$script"
    fi
  done
}

# function to execute setup scripts
run_scripts() {
  for script in "$SCRIPT_DIR/scripts/"*.sh; do
    if [[ -f "$script" && -x "$script" ]]; then
      echo "🚀 Running: $(basename "$script")"
      bash "$script" || {
        if [ $? -eq 0 ]; then
          echo "🟡 Skipping $(basename "$script")"
          continue
        else
          exit $?
        fi
      }
    fi
  done
}

echo "🔧 Starting setup..."
check_ml4w_dotfiles  # verify dotfiles exist
source_scripts       # source scripts (e.g., env variables)
run_scripts          # run scripts (e.g., install packages)
echo "✅ Setup complete!"
