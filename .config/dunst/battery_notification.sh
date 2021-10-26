#!/bin/sh

pidfile=/tmp/myscript.pid
trap "rm -f $pidfile; exit 2" QUIT TERM INT KILL
if [[ -f $pidfile ]]; then
  printf 'the script is running already: %d\n' "$(cat "$pidfile")" 1>&2
  exit 1
fi
echo "$$" >$pidfile

get_battery_capacity() {
  cat /sys/class/power_supply/BAT1/capacity
}

get_battery_status() {
  cat /sys/class/power_supply/BAT1/status
}

send_notification() {
  if [ $(get_battery_capacity) -le 15 ] && [ $(get_battery_status) == "Discharging" ]; then
    notify-send -u critical -i $HOME/.config/dunst/icons/battery_low.png \
    "Critical Battery Warning ($(get_battery_capacity)%)" "I'm hungry :[" \
    & mpv $HOME/.config/dunst/bottle.mp3
  fi
}

while true; do
  send_notification
  sleep 300
done
