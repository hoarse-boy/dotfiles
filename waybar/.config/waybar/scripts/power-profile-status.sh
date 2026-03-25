#!/usr/bin/env bash
set -euo pipefail

profile=$(powerprofilesctl get)

notify-send "Power profile status: $profile"

case "$profile" in
  power-saver)
    echo '{"text":"󰾆","class":"low","tooltip-text":"Power Saver"}'
    ;;
  balanced)
    echo '{"text":"󰾅","class":"balanced","tooltip-text":"Balanced"}'
    ;;
  performance)
    echo '{"text":"󰓅","class":"high","tooltip-text":"Performance"}'
    ;;
esac

