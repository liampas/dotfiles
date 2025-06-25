#!/usr/bin/env bash

CURRENT_WALL=$(hyprctl hyprpaper listloaded | head -n 1)

deletecurrentwall() { \
  rm $CURRENT_WALL
  notify-send "wallpaper deleted"
  ~/.config/hypr/wallpaper.sh

}

timetochoose() { \
choice=$(printf "Yes\\nNo" | dmenu -p "do you really want to delete this one?" -l 2)

case "$choice" in
  "Yes")deletecurrentwall;;
  "No")

esac
}


timetochoose
