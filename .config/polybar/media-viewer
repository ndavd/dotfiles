#!/usr/bin/env bash

is_mute() {
  [[ -n $( wpctl get-volume @DEFAULT_SINK@ | grep MUTED ) ]]
}
get_volume() {
  bc <<< "$(wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f 2) * 100" | cut -d . -f 1
}
get_brightness() {
  cat /sys/class/backlight/nvidia_0/brightness | cut -d '.' -f 1
}
progress_bar() {
  echo -n "$1 "
  for (( i=0; i < $2; i+=5 )); do echo -n '▪'; done
  for (( i=0; i < 100-$2; i+=5 )); do echo -n '▫'; done
  printf " %-3d\n" $2
}


case $1 in
  b)
    progress_bar "💻" $(get_brightness)
    ;;
  v)
    if is_mute; then
      echo -n "🔇 muted"
    else
      vol=$(get_volume)
      if [[ $vol -ge 50 ]]; then icon="🔊"
      elif [[ $vol -gt 0 ]]; then icon="🔉"; else icon="🔈"; fi
      progress_bar $icon $vol
    fi
    ;;
esac
