#!/bin/bash

# Icons (requires a Nerd Font or similar for glyphs)
ICON_ON="󰂯"        # Bluetooth icon
ICON_OFF="󰂲"       # Bluetooth off icon
ICON_CON=""      # Connected device icon (can be same as ON or different)
ICON_DISCON=""   # Disconnected but Bluetooth on

# Get Bluetooth status
if bluetoothctl show | grep -q "Powered: yes"; then
    POWERED_ON=true
else
    POWERED_ON=false
fi

if $POWERED_ON; then
    # Get connected devices
    CONNECTED_DEVICE_INFO=$(bluetoothctl info | grep "Name:" | awk '{print $2}') # Simple name fetch, might need refinement

    if [ -n "$CONNECTED_DEVICE_INFO" ]; then
        # If a device is connected, try to get its alias
        DEVICE_ALIAS=$(bluetoothctl info | grep "Alias" | cut -d ' ' -f 2-)
        if [ -z "$DEVICE_ALIAS" ]; then
            DEVICE_ALIAS=$CONNECTED_DEVICE_INFO # Fallback to name if alias not found
        fi
        echo "%{F#2193ff}$ICON_CON%{F-} $DEVICE_ALIAS" # Blue icon when connected
    else
        echo "$ICON_DISCON Off" # Or some other status like "Discoverable"
    fi
else
    echo "$ICON_OFF Off"
fi

# Handle click actions (example)
case "$1" in
    --toggle-power)
        if $POWERED_ON; then
            bluetoothctl power off
        else
            bluetoothctl power on
        fi
        ;;
    --toggle-connect)
        # This is more complex: you'd typically want a menu to select a device
        # Consider using rofi-bluetooth or similar for this
        # Example: toggle connection for a specific, hardcoded device MAC
        # DEVICE_MAC="XX:XX:XX:XX:XX:XX"
        # if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        #     bluetoothctl disconnect "$DEVICE_MAC"
        # else
        #     bluetoothctl connect "$DEVICE_MAC"
        # fi
        # For a general solution, launch a Bluetooth manager or rofi script
        if command -v blueberry &> /dev/null; then
            blueberry &
        elif command -v blueman-manager &> /dev/null; then
            blueman-manager &
        elif command -v rofi-bluetooth &> /dev/null; then
            rofi-bluetooth &
        else
            # Fallback: notify user no simple connect toggle or manager found
            notify-send "Bluetooth" "No connection manager found for quick toggle."
        fi
        ;;
esac
