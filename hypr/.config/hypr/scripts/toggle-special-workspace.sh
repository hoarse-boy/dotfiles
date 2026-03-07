#!/bin/bash

# Function to toggle an application window in a special workspace
# Usage: toggle_app_in_special_ws <command_to_run> <window_class> <special_ws_name>

# Example usage:
# toggle_app_in_special_ws "ghostty --class=g.s" "g.s" "term"
# toggle_app_in_special_ws "alacritty --class=myterm" "myterm" "myworkspace"


# it opens hyprland special workspace
# if app does not exist, spawn it wait and then focus.
# can be toggle
toggle_app_in_special_ws() {
  local cmd="$1"
  local class="$2"
  local ws_name="${3:-term}"
  local special_name="special:$ws_name"

  # check if window exists
  local win_exists
  win_exists=$(hyprctl clients -j | jq -e --arg class "$class" '.[] | select(.class == $class)' >/dev/null && echo yes || echo no)

  # check if special workspace is currently visible on this monitor
  local special_visible
  special_visible=$(hyprctl monitors -j | jq -e --arg ws "$special_name" '.[] | select(.specialWorkspace.name == $ws)' >/dev/null && echo yes || echo no)

  # --------------------------------------------------------
  # CASE 1: window exists
  # --------------------------------------------------------
  if [ "$win_exists" = "yes" ]; then
    if [ "$special_visible" = "yes" ]; then
      # special is visible → hide it
      hyprctl dispatch togglespecialworkspace "$ws_name"
    else
      # special hidden → show it
      hyprctl dispatch togglespecialworkspace "$ws_name"
      # sleep 0.05

      # this will always focus the window to target app.
      # causing maximised screen to be closed.
      # the behaviour should always focus to the previous window instead of target.
      # hyprctl dispatch focuswindow "class:$class" 
    fi
    return
  fi

  # --------------------------------------------------------
  # CASE 2: window does not exist
  # --------------------------------------------------------

  # show special workspace first
  if [ "$special_visible" = "no" ]; then
    hyprctl dispatch togglespecialworkspace "$ws_name"
    sleep 0.1
  fi

  # spawn app
  bash -c "$cmd" & disown

  # wait until window appears
  for _ in {1..60}; do
    if hyprctl clients -j | jq -e --arg class "$class" '.[] | select(.class == $class)' >/dev/null; then
      break
    fi
    sleep 0.05
  done

  # ensure focus
  hyprctl dispatch focuswindow "class:$class"
}

if [ $# -ge 2 ]; then
  toggle_app_in_special_ws "$1" "$2" "$3"
fi
