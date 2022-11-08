#!/usr/bin/env bash

pkill -fx "polybar (v||b)"
case $1 in
  b)
    case $2 in
      up)
        brightnessctl s 5%+
        ;;
      down)
        brightnessctl s 5%-
        ;;
    esac
    timeout 1s polybar b
    ;;
  v)
    case $2 in
      mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle > /dev/null
        ;;
      up)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null
        [ "$(wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f 2 | sed 's/\.//')" -lt 100 ] && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ > /dev/null
        ;;
      down)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- > /dev/null
        ;;
    esac
    timeout 1s polybar v
    ;;
esac
