#!/usr/bin/env bash

notify() {
  # if command -v swayosd-client >/dev/null 2>&1; then
  #   swayosd-client --custom-message "💧 Drink Water"
  # else
      notify-send "💧 Drink Water" "Hydration reminder" -t 5000
  # fi
}

notify
