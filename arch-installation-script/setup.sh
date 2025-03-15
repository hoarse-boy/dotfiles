#!/bin/bash

# set error handling
set -e

# define script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
source_scripts # source scripts (e.g., env variables)
run_scripts    # run scripts (e.g., install packages)
echo "✅ Setup complete!"
