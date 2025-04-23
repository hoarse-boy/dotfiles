#!/bin/bash

# Function to toggle an application window in a special workspace
# Usage: toggle_app_in_special_ws <command_to_run> <window_class> <special_ws_name>
toggle_app_in_special_ws() {
  local cmd="$1"
  local class="$2"
  local ws_name="${3:-term}" # Default to "term" if not specified

  # Check if the application is already running
  if ! hyprctl clients -j | jq -e --arg class "$class" '.[] | select(.class == $class)' >/dev/null; then
    # If not running, launch it
    eval "$cmd" &

    # Wait for the window to appear
    for _ in {1..10}; do
      if hyprctl clients -j | jq -e --arg class "$class" '.[] | select(.class == $class)' >/dev/null; then
        break
      fi
      sleep 0.1
    done
  fi

  # Switch to the special workspace
  hyprctl dispatch togglespecialworkspace "$ws_name"

  # eww open --toggle special-ws
}

# Example usage:
# toggle_app_in_special_ws "ghostty --class=g.s" "g.s" "term"
# toggle_app_in_special_ws "alacritty --class=myterm" "myterm" "myworkspace"

# Main script execution - use command line arguments if provided
if [ $# -ge 2 ]; then
  toggle_app_in_special_ws "$1" "$2" "$3"
else
  echo "Usage: $0 <command_to_run> <window_class> [special_ws_name]"
  echo "Example: $0 'ghostty --class=g.s' g.s term"
fi
