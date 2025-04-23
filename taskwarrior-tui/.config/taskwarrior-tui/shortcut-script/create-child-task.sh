#!/usr/bin/env bash

{
  UUID="$1"

  echo "=== $(date) - Running child task script ==="
  echo "Input UUID: $UUID"

  if [ -z "$UUID" ]; then
    echo "❌ No UUID passed."
    exit 1
  fi

  PROJECT=$(task _get "${UUID}.project")
  TAGS_RAW=$(task _get "${UUID}.tags")

  echo "Parent project: $PROJECT"
  echo "Parent tags: $TAGS_RAW"

  # Prompt for new task description using rofi
  DESCRIPTION=$(
    rofi -dmenu \
      -p "📝" \
      -theme-str 'entry { placeholder: "Describe the new task..."; }'
  )

  # Handle cancel or empty input
  if [ $? -ne 0 ] || [ -z "$DESCRIPTION" ]; then
    echo "❌ Cancelled or no input provided. Exiting."
    notify-send "❌ Cancelled or no input provided. Exiting."
    exit 0
  fi

  TAG_ARGS=""
  for TAG in $TAGS_RAW; do
    TAG_ARGS+="+$TAG "
  done

  if task add "$DESCRIPTION" project:"$PROJECT" $TAG_ARGS depends:$UUID; then
    notify-send "✅ Created new child task" "task: $DESCRIPTION"
  else
    notify-send "❌ Failed to create task." "task: $DESCRIPTION"
  fi
} >/dev/null 2>&1
