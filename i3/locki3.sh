#!/usr/bin/env bash
magick /extras/Pictures/logos/sreesmere-logo-circle.png -resize 50% /tmp/sreelock.png && \
    i3lock -i /tmp/sreelock.png --color=00000000 -b -f -C -k -S 1 \
    --time-color=F5F5DCFF --time-size=65 --time-pos="w/2:h/2" --date-size=35 --date-color=F5F5DCFF
