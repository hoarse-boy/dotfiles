#!/usr/bin/env bash

set -euo pipefail

PORT=7070

layer=$(
  printf '{"RequestCurrentLayerName":{}}\n' \
  | socat - TCP:localhost:$PORT \
  | jq -r 'select(.CurrentLayerName) | .CurrentLayerName.name'
)

printf '{"text":"%s"}\n' "$layer"

# #!/usr/bin/env bash

# set -euo pipefail

# PORT=7070

# while read -r line; do
#   layer=$(echo "$line" | jq -r '.LayerChange.new // empty')

#   if [[ -n "$layer" ]]; then
#     printf '{"text":"%s"}\n' "$layer"
#   fi

# done < <(socat - TCP:localhost:$PORT)
