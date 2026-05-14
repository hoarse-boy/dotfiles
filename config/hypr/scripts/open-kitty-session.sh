#!/bin/bash
# set defaults
DEFAULT_CLASS="kitty"
DEFAULT_SESSION="kitty.session"

# use args or fallback to defaults
CLASS="${1:-$DEFAULT_CLASS}"
SESSION_NAME="${2:-$DEFAULT_SESSION}"
SESSION_FILE="$HOME/.config/kitty/sessions/$SESSION_NAME"

if [[ -f "$SESSION_FILE" ]]; then
    # file exists, use it
    nohup kitty --class "$CLASS" --session "$SESSION_FILE" >/dev/null 2>&1 &
else
    # fallback to just class if file missing
    nohup kitty --class "$CLASS" >/dev/null 2>&1 &
fi

disown
