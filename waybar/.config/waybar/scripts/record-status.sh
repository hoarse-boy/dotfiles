#!/usr/bin/env bash

if pgrep -f gpu-screen-recorder >/dev/null; then
    echo '{"text": "", "class": "recording"}'
else
    echo '{"text": ""}'
fi
