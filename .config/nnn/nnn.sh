#!/usr/bin/env bash

alias n="GUI=1 BIN=1 nnn -dcu -P p"

export NNN_FIFO="/tmp/nnn.fifo"
export NNN_PLUG="g:-!git diff;p:preview-tui;d:dragdrop"
export NNN_ICONLOOKUP=1
export NNN_BATTHEME="Coldark-Dark"
export NNN_OPENER="$HOME/.config/nnn/plugins/nuke"
