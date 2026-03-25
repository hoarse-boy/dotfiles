#!/usr/bin/env bash

set -euo pipefail

PIPE="${XDG_RUNTIME_DIR}/kanata-layer.pipe"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"

layer="$(cat "$PIPE")"

# Add class based on layer name
css_class="$layer"

printf '{"text":"%s","class":"%s"}\n' "$layer" "$css_class"
