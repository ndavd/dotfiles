#!/bin/sh

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
# libinput Tapping Enabled
xinput set-prop 'ELAN0709:00 04F3:30A0 Touchpad' 370 1 &
# libinput Disable While Typing Enabled
xinput set-prop 'ELAN0709:00 04F3:30A0 Touchpad' 378 0 &

xsetroot -cursor_name left_ptr &
setxkbmap -option caps:escape &

exec bspwm
# exec xfce4-session
