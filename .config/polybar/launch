#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
# polybar primary &

# For bspwm

if [[ $(xrandr -q | grep 'HDMI-0 connected') ]]; then
  polybar bspwm_version_secondary &
  polybar bspwm_version_primary &
else
  polybar bspwm_version_primary &
fi
