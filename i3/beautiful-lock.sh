#!/bin/bash

# Beautiful lockscreen script with options for betterlockscreen or i3lock-color
# Usage: ./beautiful-lock.sh [betterlockscreen|i3lock]

MODE=${1:-"i3lock"}  # Default to i3lock-color
USER_LOGO="/extras/Pictures/logos/sreesmere-logo.png"

case "$MODE" in
    "betterlockscreen")
        # Use betterlockscreen
        EFFECT="blur"
        betterlockscreen -l $EFFECT
        ;;
    "i3lock"|*)
        # Use i3lock-color with beautiful customizations
        
        # Get current wallpaper
        WALLPAPER=$(cat ~/.fehbg 2>/dev/null | grep -o "'.*'" | head -1 | sed "s/'//g" || echo "$HOME/Pictures/wallpaper.jpg")
        
        # Create temporary blurred wallpaper
        TEMP_BG="/tmp/lockscreen_bg.png"
        convert "$WALLPAPER" -blur 0x8 -brightness-contrast -10x-5 "$TEMP_BG" 2>/dev/null || {
            TEMP_BG=""
        }
        
        # Check if user logo exists, fallback if not
        if [ ! -f "$USER_LOGO" ]; then
            USER_LOGO="/usr/share/pixmaps/archlinux.png"
        fi
        
        i3lock-color \
            --image="$TEMP_BG" \
            --clock \
            --time-str="%H:%M:%S" \
            --date-str="%A, %B %d" \
            --time-font="JetBrains Mono" \
            --date-font="JetBrains Mono" \
            --time-size=648 \
            --date-size=424 \
            --time-pos="ix:iy-80" \
            --date-pos="ix:iy-40" \
            --time-color="F5F5DCFF" \
            --date-color="F5F5DCFF" \
            --ring-color="00000000" \
            --ring-ver-color="88c0d0ff" \
            --ring-wrong-color="bf616aff" \
            --inside-color="2e344088" \
            --inside-ver-color="2e344088" \
            --inside-wrong-color="2e344088" \
            --key-hl-color="ebcb8bff" \
            --bs-hl-color="bf616aff" \
            --line-uses-ring \
            --separator-color="3b4252ff" \
            --verif-color="88c0d0ff" \
            --wrong-color="bf616aff" \
            --modif-color="ebcb8bff" \
            --layout-color="d8dee9ff" \
            --radius=120 \
            --ring-width=8 \
            --pointer=default \
            --show-failed-attempts \
            --blur=5 \
            --effect-blur=7x5 \
            --effect-vignette=0.5:0.5 \
            --keylayout=us \
            --ind-pos="ix:iy+250" \
            --logo="$USER_LOGO" \
            --logo-size=100
        
        # Clean up temp file
        [ -f "$TEMP_BG" ] && rm "$TEMP_BG"
        ;;
esac
