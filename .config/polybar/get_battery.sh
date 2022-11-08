#!/usr/bin/env bash

battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)

if   [ $battery_status == "Charging" ]; then status="CHR"
elif [ $battery_status == "Full" ]; then status="FULL"
else status="BAT"; fi

case $1 in
  minimal)
    echo "$status $battery_capacity%"
    ;;
  emoji)
    if [ $battery_capacity -ge 30 ]; then level="🔋"; else level="🪫"; fi

    if [ $battery_status == "Charging" ]; then charging="⚡"; fi

    echo "$status $battery_capacity% $charging$level"
    ;;
esac
