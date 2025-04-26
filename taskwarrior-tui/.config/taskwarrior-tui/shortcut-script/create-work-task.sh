#!/usr/bin/env bash

clear
echo

# Header
gum style --border normal --padding "1 2" --foreground 14 "=== $(date) - Creating new +work task ==="
echo

# Prompt for new task description
DESCRIPTION=$(gum input --placeholder "Describe the new work task...")
DESCRIPTION="${DESCRIPTION%%$'\n'*}"  # Remove any trailing newline

# Handle cancel or empty input
if [ -z "$DESCRIPTION" ]; then
  gum style --foreground 9 "❌ Cancelled or no input provided. Exiting."
  notify-send "❌ Cancelled" "No input provided for work task."
  exit 0
fi

# Optional: Confirm before creating
gum style --foreground 14 "📝 Task description: $DESCRIPTION"
if ! gum confirm "Create this work task?"; then
  gum style --foreground 9 "❌ Cancelled by user."
  notify-send "❌ Cancelled by user."
  exit 0
fi

# Create the task
if gum spin --spinner dot --title "Creating work task..." -- task add "$DESCRIPTION" +work; then
  gum style --foreground 10 "✅ Created new work task: $DESCRIPTION"
  notify-send "✅ Created new work task" "$DESCRIPTION"
else
  gum style --foreground 9 "❌ Failed to create task: $DESCRIPTION"
  notify-send "❌ Failed to create task" "$DESCRIPTION"
fi
