#!/usr/bin/env bash

# For Nvidia-Optimus
### just use the nvidia driver
# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto
#
# ### Optimus Manager
# /usr/bin/prime-offload

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

### Touchpad
xinput set-prop 'MSFT0001:00 06CB:CE2D Touchpad' 'libinput Tapping Enabled' 1 &
xinput set-prop 'MSFT0001:00 06CB:CE2D Touchpad' 'libinput Disable While Typing Enabled' 0 &

xsetroot -cursor_name left_ptr &
[[ -f ~/bin/keymaps ]] && ~/bin/keymaps

### Session
session=${1:-bspwm}
case $session in
  gnome          )
    # XORG-GNOME
    export XDG_SESSION_TYPE=x11
    export GDK_BACKEND=x11
    exec gnome-session
  ;;
  xfce|xfce4     ) exec xfce4-session ;;
  lxqt           ) exec startlxqt ;;
  bspwm          ) exec bspwm ;;
  *              ) exec "$1" ;;
esac
