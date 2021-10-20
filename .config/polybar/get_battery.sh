#!/usr/bin/env bash

battery_capacity=$(cat /sys/class/power_supply/BAT1/capacity)
battery_status=$(cat /sys/class/power_supply/BAT1/status)

case $1 in
  minimal)
    if   [ $battery_status == "Charging" ]; then charging="CHR "
    elif [ $battery_status == "Full" ]; then charging="FULL "
    else charging="BAT "; fi

    echo "$charging$battery_capacity%"
    ;;
  emoji)
    if [ $battery_capacity -ge 98 ]; then level=""
    elif [ $battery_capacity -ge 90 ]; then level=""
    elif [ $battery_capacity -ge 80 ]; then level=""
    elif [ $battery_capacity -ge 70 ]; then level=""
    elif [ $battery_capacity -ge 60 ]; then level=""
    elif [ $battery_capacity -ge 50 ]; then level=""
    elif [ $battery_capacity -ge 40 ]; then level=""
    elif [ $battery_capacity -ge 30 ]; then level=""
    elif [ $battery_capacity -ge 20 ]; then level=""
    elif [ $battery_capacity -ge 10 ]; then level=""
    else level=""; fi

    if [ $battery_status == "Charging" ]; then charging="⚡ "; else charging=" "; fi

    echo "$level$charging$battery_capacity%"
    ;;
esac
