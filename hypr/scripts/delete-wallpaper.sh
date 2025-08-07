#!/usr/bin/env bash

CURRENT_WALL=$(hyprctl hyprpaper listloaded | head -n 1)

deletecurrentwall() { \
  mv $CURRENT_WALL ~/.local/share/Trash/files/
  notify-send "wallpaper deleted"
  ~/.config/hypr/scripts/wallpaper.sh

}

timetochoose() { \
choice=$(printf "yes\\nno" | dmenu -p "do you really want to delete this one?" -l 2)

case "$choice" in
  "yes")deletecurrentwall;;
  "no")

esac
}


timetochoose
