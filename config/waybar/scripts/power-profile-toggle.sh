#!/usr/bin/env bash
set -euo pipefail

# cycle through power profiles

current=$(powerprofilesctl get)


notify-send "Power profile test" # DEL: . DELETE LINES LATER

case "$current" in
  power-saver)
    powerprofilesctl set balanced
    ;;
  balanced)
    powerprofilesctl set performance
    ;;
  performance)
    powerprofilesctl set power-saver
    ;;
esac

pkill -RTMIN+8 waybar
