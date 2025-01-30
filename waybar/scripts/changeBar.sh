#!/bin/bash

killall waybar

WAYBAR=~/.config/waybar
BAR=$(ls $WAYBAR/bars/ | fuzzel -d)

CONFIG=$WAYBAR/bars/$BAR/config
STYLE=$WAYBAR/bars/$BAR/style.css

ln -fs $CONFIG $WAYBAR/config
ln -fs $STYLE $WAYBAR/style.css

waybar &1> /dev/null
