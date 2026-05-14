#!/usr/bin/env bash

LAST_SONG=""

while true; do
    mpc idle player > /dev/null

    # small delay prevents race condition
    sleep 0.1

    FILE=$(mpc current -f "%file%")

    [[ -z "$FILE" ]] && continue

    if [[ "$FILE" != "$LAST_SONG" ]]; then
        LAST_SONG="$FILE"

        TITLE=$(mpc current -f "%title%")
        ARTIST=$(mpc current -f "%artist%")
        ALBUM=$(mpc current -f "%album%")

        # trim whitespace
        TITLE="$(echo "$TITLE" | xargs)"
        ARTIST="$(echo "$ARTIST" | xargs)"
        ALBUM="$(echo "$ALBUM" | xargs)"

        # fallback to filename if no title
        if [[ -z "$TITLE" ]]; then
            BASENAME=$(basename "$FILE")
            TITLE="${BASENAME%.*}"
        fi

        # build subtitle only if needed
        SUBTEXT=""
        [[ -n "$ARTIST" ]] && SUBTEXT="$ARTIST"
        [[ -n "$ALBUM" ]] && SUBTEXT="${SUBTEXT:+$SUBTEXT — }$ALBUM"

        # find cover art
        MUSIC_DIR="$HOME/Music"
        DIR=$(dirname "$MUSIC_DIR/$FILE")
        ART_PATH=""

        for name in cover.jpg cover.png folder.jpg folder.png; do
            if [[ -f "$DIR/$name" ]]; then
                ART_PATH="$DIR/$name"
                break
            fi
        done

        # send notification safely
        if [[ -n "$SUBTEXT" ]]; then
            notify-send "🎵 $TITLE" "$SUBTEXT" -i "$ART_PATH"
        else
            notify-send "🎵 $TITLE" -i "$ART_PATH"
        fi
    fi
done
