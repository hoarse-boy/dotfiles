#!/usr/bin/env bash
set -euo pipefail

PORT=7070
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id - u)}"
PIPE="${RUNTIME_DIR}/kanata-layer.pipe"

mkdir -p "$(dirname "$PIPE")"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"

last_layer=""

while true; do
  echo "Connecting to Kanata on port $PORT..." >&2

  # Wait for kanata to be ready (port open)
  for i in {1..30}; do
    if nc -z localhost $PORT 2>/dev/null; then
      break
    fi
    echo "Waiting for kanata to be ready... ($i)" >&2
    sleep 1
  done

  # Check if port is actually open
  if ! nc -z localhost $PORT 2>/dev/null; then
    echo "Kanata port not available, retrying outer loop..." >&2
    sleep 2
    continue
  fi

  stdin_fifo="/tmp/kanata-stdin-$$"
  [[ -p "$stdin_fifo" ]] || mkfifo "$stdin_fifo"

  (
    echo '{"RequestCurrentLayerName":{}}'
    while true; do
      sleep 5
      echo ""
    done
  ) >"$stdin_fifo" &
  feeder_pid=$!

  # Use timeout to prevent hanging forever
  timeout 3600 nc -q -1 localhost $PORT <"$stdin_fifo" |
    while IFS= read -r line; do

      [[ -z "$line" ]] && continue

      layer=""
      if [[ "$line" == *'"LayerChange"'* ]]; then
        layer="${line#*\"new\":\"}"
        layer="${layer%%\"*}"
      fi
      if [[ "$line" == *'"CurrentLayerName"'* ]]; then
        layer="${line#*\"name\":\"}"
        layer="${layer%%\"*}"
      fi

      if [[ -n "$layer" && "$layer" != "$last_layer" ]]; then
        last_layer="$layer"
        printf '%s\n' "$layer" >"$PIPE" 2>/dev/null || true
        pkill -x -RTMIN+10 waybar 2>/dev/null || true
      fi

    done || echo "Inner loop exited" >&2

  kill "$feeder_pid" 2>/dev/null || true
  rm -f "$stdin_fifo"

  echo "Connection lost, reconnecting in 5s..." >&2
  sleep 5
done
