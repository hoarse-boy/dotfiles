#!/usr/bin/env bash

clear
echo

UUID="$1"

gum style --border normal --padding "1 2" --foreground 14 "=== $(date) - Running child task script ==="
gum style --foreground 11 "Input UUID: $UUID"

if [ -z "$UUID" ]; then
  gum style --foreground 9 "❌ No UUID passed."
  exit 1
fi

PROJECT=$(task _get "${UUID}.project")
TAGS_RAW=$(task _get "${UUID}.tags")

gum style --foreground 11 "Parent project: $PROJECT"
gum style --foreground 11 "Parent tags: $TAGS_RAW"

# Ask for child task description
DESCRIPTION=$(gum input --placeholder "Describe the new child task...")
DESCRIPTION="${DESCRIPTION%%$'\n'*}"

if [ -z "$DESCRIPTION" ]; then
  gum style --foreground 9 "❌ Cancelled or no input provided. Exiting."
  notify-send "❌ Cancelled or no input provided. Exiting."
  exit 0
fi

# Optional: Confirm before creating
# gum style --foreground 14 "📝 New task description: $DESCRIPTION"
# if ! gum confirm "Create this child task?"; then
#   gum style --foreground 9 "❌ Cancelled by user."
#   notify-send "❌ Cancelled by user."
#   exit 0
# fi

# Build tags
TAG_ARGS=""
for TAG in $TAGS_RAW; do
  TAG_ARGS+="+$TAG "
done

# Add the new child task
if task add "$DESCRIPTION" project:"$PROJECT" $TAG_ARGS depends:$UUID; then
  gum style --foreground 10 "✅ Created new child task: $DESCRIPTION"
  notify-send "✅ Created new child task" "task: $DESCRIPTION"
else
  gum style --foreground 9 "❌ Failed to create task: $DESCRIPTION"
  notify-send "❌ Failed to create task." "task: $DESCRIPTION"
fi

