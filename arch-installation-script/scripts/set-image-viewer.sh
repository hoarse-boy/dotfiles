#!/usr/bin/env bash

# image mime types
types=(
image/png
image/jpeg
image/jpg
image/gif
image/webp
image/bmp
image/tiff
image/x-portable-pixmap
image/x-portable-bitmap
image/x-portable-graymap
image/avif
image/heic
image/heif
image/svg+xml
)

for t in "${types[@]}"; do
    xdg-mime default imv.desktop "$t"
done
