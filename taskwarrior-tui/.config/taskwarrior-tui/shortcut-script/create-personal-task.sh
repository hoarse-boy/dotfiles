#!/usr/bin/env bash

{
  echo "=== $(date) - Creating new +personal task ==="

  # Prompt for new task description using rofi
  DESCRIPTION=$(
    rofi -dmenu \
      -p "📝" \
      -theme-str 'entry { placeholder: "Describe the new personal task..."; }'
  )

  # Handle cancel or empty input
  if [ $? -ne 0 ] || [ -z "$DESCRIPTION" ]; then
    echo "❌ Cancelled or no input provided. Exiting."
    notify-send "❌ Cancelled" "No input provided for personal task."
    exit 0
  fi

  # Create the task
  if task add "$DESCRIPTION" +personal; then
    echo "✅ Created new personal task"
    notify-send "✅ Created new personal task" "$DESCRIPTION"
  else
    echo "❌ Failed to create task."
    notify-send "❌ Failed to create task" "$DESCRIPTION"
  fi
} >/dev/null 2>&1
