#!/usr/bin/env bash

# get mic mute state
state=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

if [ "$state" = "yes" ]; then
    echo '{"text":"","class":"muted"}'
else
    echo '{"text":"","class":"active"}'
fi
