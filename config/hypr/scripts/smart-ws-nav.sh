# #!/usr/bin/env bash

set -euo pipefail

STATE_FILE="/tmp/hypr_last_numeric_ws"

action="${1:-}"
target_ws="${2:-}"

# cache monitors output (ONLY ONE CALL)
monitors="$(hyprctl monitors)"

# parse current + special from same data
read -r current_id current_name special_name < <(
  printf "%s\n" "$monitors" | awk '
    /active workspace:/ {
      id=$3
      match($0, /\(([^)]+)\)/, arr)
      name=arr[1]
    }
    /special workspace:/ {
      if ($3 != "0") {
        match($0, /\(([^)]+)\)/, arr)
        special=arr[1]
      }
    }
    END {
      print id, name, special
    }
  '
)

is_special=0
if [[ -n "${special_name:-}" ]]; then
  is_special=1
fi

# save last numeric workspace
if (( current_id > 0 )); then
  echo "$current_id" > "$STATE_FILE"
fi

get_last_numeric() {
  [[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || echo "1"
}

close_special_if_any() {
  if (( is_special == 1 )); then
    name="${special_name#special:}"
    hyprctl dispatch togglespecialworkspace "$name"
    return 0
  fi
  return 1
}

case "$action" in
toggle)
  # if special → go directly to named
  if (( is_special == 1 )); then
    hyprctl dispatch workspace "name:$target_ws"
    exit 0
  fi

  # if already in named → go back
  if [[ "$current_name" == "$target_ws" ]]; then
    hyprctl dispatch workspace "$(get_last_numeric)"
  else
    if (( current_id > 0 )); then
      echo "$current_id" > "$STATE_FILE"
    fi
    hyprctl dispatch workspace "name:$target_ws"
  fi
  ;;

left)
  if close_special_if_any; then exit 0; fi

  # preventing navigating to named workspace
  if (( current_id == 1 )); then exit 0; fi

  # named workspace behaves like special → go back only
  if (( current_id < 0 )); then
    hyprctl dispatch workspace "$(get_last_numeric)"
  else
    hyprctl dispatch workspace r-1
  fi
  ;;

right)
  if close_special_if_any; then exit 0; fi

  if (( current_id < 0 )); then
    hyprctl dispatch workspace "$(get_last_numeric)"
  else
    hyprctl dispatch workspace r+1
  fi
  ;;

down)
  if close_special_if_any; then exit 0; fi

  windows=$(hyprctl activeworkspace | awk '/windows:/ {print $2}')

  if [[ "$windows" == "0" ]]; then
    hyprctl dispatch workspace previous
  else
    hyprctl dispatch workspace empty
  fi
  ;;

*)
  echo "usage:"
  echo "  $0 toggle <name>"
  echo "  $0 left|right|down"
  exit 1
  ;;
esac
