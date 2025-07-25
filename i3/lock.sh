#!/bin/bash

# Script to lock screen with betterlockscreen

# Optional: Specify effect (blur, dim, pixel)
EFFECT="blur"

# Optional: Path to betterlockscreen executable if not in PATH
# BETTERLOCKSCREEN_CMD="/path/to/betterlockscreen/betterlockscreen"
BETTERLOCKSCREEN_CMD="betterlockscreen" # Assumes it's in your PATH
# Check if a cached image exists, if not, try to cache current pywal wallpaper
# This is a basic check; betterlockscreen has its own ways to manage this.
# Primarily, ensure you've run 'betterlockscreen -u <wallpaper>' at least once
# or after each wallpaper change.

# Lock the screen
# $BETTERLOCKSCREEN_CMD -l $EFFECT
# i3lock --color=00000000 --blur --keylayout=us
magick /extras/Pictures/logos/sreesmere-logo-circle.png -resize 50% /tmp/sreelock.png && \
    i3lock -i /tmp/sreelock.png \
    --color=00000000 -b -f -C -k -S 1 \
    --time-color=F5F5DCFF --time-size=65 --time-pos="w/2:h" \
    --date-size=35 --date-color=F5F5DCFF --ind-pos="w/2:h" \
    --color=00000000 \
    --keylayout=us

# Example of adding dimming before suspend (betterlockscreen handles suspend locking well with xss-lock)
# if [ "$1" = "suspend" ]; then
#    $BETTERLOCKSCREEN_CMD -s dim # or -s blur
# fi
