#!/usr/bin/env bash

# mic source
MIC="alsa_input.pci-0000_00_1f.3.analog-stereo"

# remove existing clean_mic if already loaded
EXISTING=$(pactl list short modules | grep echo-cancel | awk '{print $1}')

if [ -n "$EXISTING" ]; then
    pactl unload-module "$EXISTING"
fi

# create clean mic (noise suppression)
pactl load-module module-echo-cancel \
    source_name=clean_mic \
    source_master="$MIC" \
    aec_method=webrtc \
    aec_args="noise_suppression=1"

# set volume to 100%
pactl set-source-volume clean_mic 100%

echo "clean mic ready"
