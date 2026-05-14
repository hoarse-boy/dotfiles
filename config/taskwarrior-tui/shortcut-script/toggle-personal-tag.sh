#!/usr/bin/env bash

{
  for UUID in "$@"; do
    echo "=== Toggling +personal on task: $UUID ==="

    # Get description for better notifications
    DESCRIPTION=$(task _get "${UUID}.description")

    if task _get "${UUID}.tags" | grep -qw personal; then
      echo "🔁 Removing +personal"
      task rc.bulk=0 rc.confirmation=off rc.dependency.confirmation=off rc.recurrence.confirmation=off "$UUID" modify -personal
      notify-send "Removed +personal" "task: $DESCRIPTION"
    else
      echo "🔁 Adding +personal"
      task rc.bulk=0 rc.confirmation=off rc.dependency.confirmation=off rc.recurrence.confirmation=off "$UUID" modify +personal
      notify-send "Added +personal" "task: $DESCRIPTION"
    fi
  done
} >/dev/null 2>&1
