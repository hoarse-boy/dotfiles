# # # #!/bin/bash

OUT_DIR="$HOME/Videos/Recordings"
mkdir -p "$OUT_DIR"

OUTPUT="$OUT_DIR/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"

PID_FILE="/tmp/gpu-record.pid"

# toggle stop
if [ -f "$PID_FILE" ]; then
    PGID=$(cat "$PID_FILE")

    echo "stopping pgid: $PGID"

    kill -TERM -"$PGID" 2>/dev/null
    sleep 0.7
    kill -KILL -"$PGID" 2>/dev/null

    rm -f "$PID_FILE"
    pkill -RTMIN+11 waybar
    exit 0
fi

USE_MIC=false
[[ "$1" == "--mic" ]] && USE_MIC=true

if $USE_MIC; then
    AUDIO="clean_mic"
else
    AUDIO="default_output"
fi

# notify start
if $USE_MIC; then
    notify-send "recording started (mic)" "$OUTPUT"
else
    notify-send "recording started (system)" "$OUTPUT"
fi

pkill -RTMIN+11 waybar

# start in new process group
setsid gpu-screen-recorder \
    -w screen \
    -f 60 \
    -a "$AUDIO" \
    -o "$OUTPUT" &

# save PGID
echo $! > "$PID_FILE"

# wait for process
wait

notify-send "recording finished" "$OUTPUT"
pkill -RTMIN+11 waybar

rm -f "$PID_FILE"
