#!/usr/bin/env bash

PFILE="$HOME/.config/polybar/colors.ini"
WFILE="$HOME/.cache/wal/colors.sh"
DESIRED_ALPHA="CC"

change_color() {
    # For the transparent background:
    # 1. Get the RGB part of the background by removing the leading '#'
    local bg_rgb_only="${BG#\#}"
    # 2. Construct the new ARGB color string
    local transparent_bg_val="#${DESIRED_ALPHA}${bg_rgb_only}"
    sed -i -e "s/background = #.*/background = $transparent_bg_val/g" "$PFILE"
    # sed -i -e "s/background = #.*/background = $BG/g" $PFILE
    sed -i -e "s/foregorund = #.*/foreground = $FG/g" $PFILE
    sed -i -e "s/primary = #.*/primary = $AC/g" $PFILE
    sed -i -e "s/color1 = #.*/color1 = $CC1/g" $PFILE
    sed -i -e "s/color2 = #.*/color2 = $CC2/g" $PFILE
    sed -i -e "s/color3 = #.*/color3 = $CC3/g" $PFILE
    sed -i -e "s/color4 = #.*/color4 = $CC4/g" $PFILE
    sed -i -e "s/color5 = #.*/color5 = $CC5/g" $PFILE
    sed -i -e "s/color6 = #.*/color6 = $CC6/g" $PFILE
    sed -i -e "s/color7 = #.*/color7 = $CC7/g" $PFILE
    sed -i -e "s/color8 = #.*/color8 = $CC8/g" $PFILE
    sed -i -e "s/color9 = #.*/color9 = $CC9/g" $PFILE
    sed -i -e "s/color10 = #.*/color10 = $CC10/g" $PFILE
    sed -i -e "s/color11 = #.*/color11 = $CC11/g" $PFILE
    sed -i -e "s/color12 = #.*/color12 = $CC12/g" $PFILE
    sed -i -e "s/color13 = #.*/color13 = $CC13/g" $PFILE
    sed -i -e "s/color14 = #.*/color14 = $CC14/g" $PFILE
}

if [[ -x "`which wal`" ]]; then
    if [[ -e "$WFILE" ]]; then
        . "$WFILE"
    else
        echo 'Color file does not exist. Exiting'
        exit 1
    fi

    BG=`printf "%s\n" "$background"`
    FG=`printf "%s\n" "$foreground"`
    AC=`printf "%s\n" $color1`
    CC1=`printf "%s\n" $color2`
    CC2=`printf "%s\n" $color3`
    CC3=`printf "%s\n" $color4`
    CC4=`printf "%s\n" $color5`
    CC5=`printf "%s\n" $color6`
    CC6=`printf "%s\n" $color7`
    CC7=`printf "%s\n" $color8`
    CC8=`printf "%s\n" $color9`
    CC9=`printf "%s\n" $color10`
    CC10=`printf "%s\n" $color11`
    CC11=`printf "%s\n" $color12`
    CC12=`printf "%s\n" $color13`
    CC13=`printf "%s\n" $color14`
    CC14=`printf "%s\n" $color15`

    change_color
else
    echo "! 'pywal' is not installed"
fi
