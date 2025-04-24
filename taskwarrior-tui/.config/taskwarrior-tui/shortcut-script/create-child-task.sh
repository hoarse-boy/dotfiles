#!/usr/bin/env bash

clear
echo

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"

UUID="$1"

echo -e "${CYAN}=== $(date) - Running child task script ===${RESET}"
echo -e "${YELLOW}Input UUID:${RESET} $UUID"

if [ -z "$UUID" ]; then
  echo -e "${RED}❌ No UUID passed.${RESET}"
  exit 1
fi

PROJECT=$(task _get "${UUID}.project")
TAGS_RAW=$(task _get "${UUID}.tags")

echo -e "${YELLOW}Parent project:${RESET} $PROJECT"
echo -e "${YELLOW}Parent tags:${RESET} $TAGS_RAW"

# Prompt for new task description using Bash
echo
echo -e -n "${CYAN}📝 Describe the new child task: ${RESET}"
read -r DESCRIPTION

# Handle cancel or empty input
if [ -z "$DESCRIPTION" ]; then
  echo -e "${RED}❌ Cancelled or no input provided. Exiting.${RESET}"
  notify-send "❌ Cancelled or no input provided. Exiting."
  exit 0
fi

# Build tags
TAG_ARGS=""
for TAG in $TAGS_RAW; do
  TAG_ARGS+="+$TAG "
done

# Add the new child task
if task add "$DESCRIPTION" project:"$PROJECT" $TAG_ARGS depends:$UUID; then
  echo -e "${GREEN}✅ Created new child task: ${RESET}$DESCRIPTION"
  notify-send "✅ Created new child task" "task: $DESCRIPTION"
else
  echo -e "${RED}❌ Failed to create task.${RESET}"
  notify-send "❌ Failed to create task." "task: $DESCRIPTION"
fi
