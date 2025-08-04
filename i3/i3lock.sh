#!/usr/bin/env bash

# --- Configuration ---
# The image to use as the lock screen icon
ICON="/extras/Pictures/logos/sreesmere-logo-circle.png"
# The vertical position for the time and date, as a percentage from the top (0-100)
TIME_Y_PERCENT=80
DATE_Y_PERCENT=85

# --- Dynamic Position Calculation ---
# Get the screen resolution (e.g., 1920x1080)
RESOLUTION=$(xdpyinfo | grep dimensions | awk '{print $2}')

# Split the resolution into width and height
SCREEN_W=$(echo "$RESOLUTION" | cut -d'x' -f1)
SCREEN_H=$(echo "$RESOLUTION" | cut -d'x' -f2)

# Calculate the pixel positions using integer arithmetic
# X position is always 50% of the screen width
POS_X=$((SCREEN_W / 2))

# Y positions are calculated based on the percentages defined above
TIME_POS_Y=$((SCREEN_H * TIME_Y_PERCENT / 100))
DATE_POS_Y=$((SCREEN_H * DATE_Y_PERCENT / 100))


# --- Image and Lock Execution ---
# A temporary file to store the processed image
TMP_IMG=$(mktemp /tmp/sreelock.XXXXXX.png)

# A trap to ensure the temporary file is deleted when the script exits
trap 'rm -f "$TMP_IMG"' EXIT

# Process the image with ImageMagick
magick "$ICON" -resize 50% "$TMP_IMG"

# Lock the screen with i3lock, using the dynamically calculated pixel coordinates
i3lock -i "$ICON" \
    --color=00000000 \
    -f -k \
    \
    --time-size=65 \
    --time-pos="${POS_X}:${TIME_POS_Y}" \
    --time-color=F5F5DCFF \
    --time-str="%H:%M" \
    \
    --date-size=35 \
    --date-pos="${POS_X}:${DATE_POS_Y}" \
    --date-color=F5F5DCFF \
    --date-str="%A, %B %d, %Y" \
    \
    --verif-text="Verifying..." \
    --verif-color=F5F5DCFF \
    \
    --wrong-text="Auth Failed" \
    --wrong-color=FF0000FF \
    \
    --keylayout 1

