#!/usr/bin/env bash

# toggle microphone mute
pactl set-source-mute @DEFAULT_SOURCE@ toggle

# check state
state=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

if [ "$state" = "yes" ]; then
    notify-send -u low -t 2000 "Microphone" "Muted 🎤"
else
    notify-send -u low -t 2000 "Microphone" "Unmuted 🎤"
fi

# refresh waybar module
pkill -SIGRTMIN+8 waybar 2>/dev/null
