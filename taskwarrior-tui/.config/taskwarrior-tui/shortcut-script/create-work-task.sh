#!/usr/bin/env bash

clear
echo

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "${CYAN}=== $(date) - Creating new +work task ===${RESET}"
echo

# Prompt for new task description using Bash
echo -e -n "${CYAN}📝 Describe the new work task: ${RESET}"
read -r DESCRIPTION

# Handle cancel or empty input
if [ -z "$DESCRIPTION" ]; then
  echo -e "${RED}❌ Cancelled or no input provided. Exiting.${RESET}"
  notify-send "❌ Cancelled" "No input provided for work task."
  exit 0
fi

# Create the task
if task add "$DESCRIPTION" +work; then
  echo -e "${GREEN}✅ Created new work task:${RESET} $DESCRIPTION"
  notify-send "✅ Created new work task" "$DESCRIPTION"
else
  echo -e "${RED}❌ Failed to create task.${RESET}"
  notify-send "❌ Failed to create task" "$DESCRIPTION"
fi

