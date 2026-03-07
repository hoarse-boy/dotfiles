#!/usr/bin/env bash

idle=$(loginctl show-session "$XDG_SESSION_ID" -p IdleHint --value 2>/dev/null || echo no)

if [[ "$idle" == "yes" ]]; then
  exit 0
fi

# if command -v swayosd-client >/dev/null 2>&1; then
#   swayosd-client --custom-message "👀 Eye Break — 20 seconds"
# else
  notify-send "👀 Eye Break" "Look away for 20 seconds" -t 5000
# fi
