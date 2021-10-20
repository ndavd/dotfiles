#!/usr/bin/env bash

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
        amixer -D pulse set Master 1+ toggle > /dev/null
        ;;
      up)
        amixer -D pulse set Master on > /dev/null
        amixer -D pulse sset Master 5%+ > /dev/null
        ;;
      down)
        amixer -D pulse set Master on > /dev/null
        amixer -D pulse sset Master 5%- > /dev/null
        ;;
    esac
    timeout 1s polybar v
    ;;
esac
