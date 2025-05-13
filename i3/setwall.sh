#!/bin/bash

WALLPAPER="$1"

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

echo "Setting wallpaper and generating theme with pywal..."
wal -i "$WALLPAPER" -q # -q for quiet

echo "Generating i3 color variables..."
~/.config/i3/generate_i3_wal_colors.sh

echo "Generating polywal color variables..."
~/.config/i3/generate_polybar_wal_colors.sh

echo "Loading Xresources..."
xrdb -merge ~/.cache/wal/colors.Xresources # <-- IMPORTANT: Load Xresources

# Update betterlockscreen cache with the new wallpaper
betterlockscreen -u "$WALLPAPER" --fx blur

wal -R

echo "Reloading i3..."
i3-msg reload > /dev/null 2>&1 & # Or i3-msg restart if needed for i3 colors

echo "Restarting Polybar..."
# ~/.config/polybar/launch.sh > /dev/null 2>&1 & # Relaunch Polybar using your script

echo "Wallpaper and theme updated!"
