#!/bin/bash
# A script to toggle a floating, scratchpad window chosen by the user via rofi.

# The mark used to identify the special window.
MARK="_floating_launcher_app"

# Check if jq is installed, as it's required for parsing i3's JSON output.
if ! command -v jq &> /dev/null;
    i3-nagbar -t error -m "'jq' is not installed. Please install it to use this script."
    exit 1
fi

# Find the window ID of the window with our mark.
# We parse the i3 tree to find a container with the specified mark.
ID=$(i3-msg -t get_tree | jq -r ".. | select(.marks? and .marks[] == \"$MARK\") | .id")

# If a window with the mark already exists, just toggle its visibility.
# 'scratchpad show' on a marked container will show it if hidden,
# and hide it if it's currently visible and focused.
if [ -n "$ID" ]; then
    i3-msg "[con_mark=$MARK] scratchpad show"
    exit 0
fi

# If no such window exists, we'll create one.
# We start a listener in the background to catch the *next* new window.
# This listener will then mark and configure the window.
(
    i3-msg -t subscribe -m '["window"]' | jq --unbuffered -r 'select(.change == "new") | .container.id' | head -n 1 | \
    xargs -I{} i3-msg "[con_id={}] mark --add $MARK; [con_id={}] floating enable; [con_id={}] move to scratchpad; [con_id={}] scratchpad show"
) &
LISTENER_PID=$!

# Ensure the listener is killed when this script exits.
# This prevents it from accidentally capturing a window later if the user cancels rofi.
trap "kill $LISTENER_PID" EXIT

# Run rofi to let the user select an application.
# Rofi will launch the selected app, triggering the 'new' window event our listener is waiting for.
rofi -show drun
