#!/usr/bin/env bash

### just use the nvidia driver
# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto

### Optimus Manager
/usr/bin/prime-offload

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

### Touchpad
xinput set-prop 'ELAN0709:00 04F3:30A0 Touchpad' 'libinput Tapping Enabled' 1 &
xinput set-prop 'ELAN0709:00 04F3:30A0 Touchpad' 'libinput Disable While Typing Enabled' 0 &

xsetroot -cursor_name left_ptr &
setxkbmap -option caps:escape &

### Session
session=${1:-bspwm}
case $session in
  xfce|xfce4     ) exec xfce4-session ;;
  lxqt           ) exec startlxqt ;;
  bspwm          ) exec bspwm ;;
  *              ) exec $1 ;;
esac
