#!/usr/bin/env sh

LOG_FILE_BASE="/tmp/polybar"
LAUNCH_LOG="${LOG_FILE_BASE}_launch.log"

# Clear previous global launch log
>"${LAUNCH_LOG}"

echo "--- Polybar Launch Script Started at $(date) ---" | tee -a "${LAUNCH_LOG}"

# Terminate already running bar instances
echo "Terminating existing Polybar instances..." | tee -a "${LAUNCH_LOG}"
killall -q polybar
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do
    echo "Waiting for existing Polybar instances to shut down..." | tee -a "${LAUNCH_LOG}"
    sleep 0.5
done
echo "All Polybar instances terminated." | tee -a "${LAUNCH_LOG}"

PRIMARY_MONITOR="DP-2" # Your primary monitor

if type "xrandr" >/dev/null 2>&1; then
  MONITOR_LIST=$(xrandr --query | grep " connected" | cut -d" " -f1)
  echo "Raw list of connected monitors from xrandr: ${MONITOR_LIST}" | tee -a "${LAUNCH_LOG}"

  for m in $MONITOR_LIST; do
    # Ensure $m is not empty
    if [ -z "$m" ]; then
      echo "Warning: Detected an empty monitor name in list, skipping." | tee -a "${LAUNCH_LOG}"
      continue
    fi

    MONITOR_LOG_FILE="${LOG_FILE_BASE}_${m}.log"
    >"${MONITOR_LOG_FILE}" # Clear previous log for this monitor

    echo "Processing monitor: '$m'" | tee -a "${LAUNCH_LOG}"
    if [ "$m" = "$PRIMARY_MONITOR" ]; then
      echo "Launching 'primary' bar for '$m' (Primary Monitor)" | tee -a "${LAUNCH_LOG}"
      MONITOR=$m polybar --reload primary -c ~/.config/polybar/config.ini >> "${MONITOR_LOG_FILE}" 2>&1 &
    else
      echo "Launching 'secondary' bar for '$m' (Secondary Monitor)" | tee -a "${LAUNCH_LOG}"
      MONITOR=$m polybar --reload secondary -c ~/.config/polybar/config.ini >> "${MONITOR_LOG_FILE}" 2>&1 &
    fi
    echo "Launched Polybar for '$m' with PID $!. Log: ${MONITOR_LOG_FILE}" | tee -a "${LAUNCH_LOG}"
  done
else
  echo "ERROR: xrandr command not found. Attempting to launch single 'primary' Polybar." | tee -a "${LAUNCH_LOG}"
  MONITOR_LOG_FILE="${LOG_FILE_BASE}_single_primary.log"
  >"${MONITOR_LOG_FILE}"
  polybar --reload primary -c ~/.config/polybar/config.ini >> "${MONITOR_LOG_FILE}" 2>&1 &
  echo "Launched single 'primary' bar (PID $!). Log: ${MONITOR_LOG_FILE}" | tee -a "${LAUNCH_LOG}"
fi

echo "--- Polybar Launch Script Finished ---" | tee -a "${LAUNCH_LOG}"
