#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded | head -n 1)
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)


delete(){
deletecurrentwall() { \
  mv $CURRENT_WALL ~/.local/share/Trash/files/
  notify-send "wallpaper deleted"
  ~/.config/hypr/scripts/wallpaper.sh
}

movecurrentwall() { \
  mv $CURRENT_WALL ~/Pictures/wallpapers/move/
  notify-send "wallpaper moved"
  ~/.config/hypr/scripts/wallpaper.sh
}

timetochoose() { \
choice=$(printf "yes\\nno\\nmoveit" | dmenu -p "do you really want to delete this one?" -l 3)

case "$choice" in
  "yes")deletecurrentwall;;
  "moveit")movecurrentwall;;
  "no")

esac
}

timetochoose
}


# Get a random wallpaper that is not the current one
while [[ "$#" -gt 0 ]]; do
  case "$1" in
	-d|--dir) WALLPAPER_DIR="$2"; 
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)
	shift 
	;;
	-w) WALLPAPER="$2"; shift ;;
	-D)
		delete
		exit 0
		;;




	-h|--help|*) echo "Usage: $0 [-d wallpaper directory] [-D delete the current wallpaper] [-w specifies a wallpaper]"
exit 0
;;
    esac
    shift
done

hyprpaper
# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"
echo "$WALLPAPER"
wal -i $WALLPAPER


c1=$(grep "#" ~/.cache/wal/colors | sed -n '1p')
c2=$(grep "#" ~/.cache/wal/colors | sed -n '2p')
c3=$(grep "#" ~/.cache/wal/colors | sed -n '3p')
c4=$(grep "#" ~/.cache/wal/colors | sed -n '4p')
c5=$(grep "#" ~/.cache/wal/colors | sed -n '5p')
c6=$(grep "#" ~/.cache/wal/colors | sed -n '6p')
c7=$(grep "#" ~/.cache/wal/colors | sed -n '7p')
c8=$(grep "#" ~/.cache/wal/colors | sed -n '8p')
c9=$(grep "#" ~/.cache/wal/colors | sed -n '9p')
c10=$(grep "#" ~/.cache/wal/colors | sed -n '10p')
c11=$(grep "#" ~/.cache/wal/colors | sed -n '11p')
c12=$(grep "#" ~/.cache/wal/colors | sed -n '12p')
c13=$(grep "#" ~/.cache/wal/colors | sed -n '13p')
c14=$(grep "#" ~/.cache/wal/colors | sed -n '14p')
c15=$(grep "#" ~/.cache/wal/colors | sed -n '15p')
c16=$(grep "#" ~/.cache/wal/colors | sed -n '16p')



#BORDER=$(xrdb -query | grep '\*color1' | head -n1 | sed 's/.*#//')
#BORDER=$(grep '\*color1' ~/.Xresources | head -n1 | sed 's/.*#//')



if xrdb -query 2>/dev/null | grep -q '\*color1'; then
  BORDER=$(xrdb -query | grep '\*color1' | head -n1 | sed 's/.*#//')
fi

hyprctl keyword general:col.active_border "rgb($BORDER)"
#hyprctl keyword general:col.active_border "0xff$BORDER"
notify-send $WALLPAPER
#notify-send 0xff$BORDER

#send the color to kitty

#grep '\color1\b' ~/.cache/wal/colors.sh | cut -c10- | rev | cut -c2- | rev

#reload kitty color configs
kitty @ set-colors --all ~/.config/kitty/kitty.conf


#gtk

#oldgtkcolor=$(grep '@define-color theme_selected_bg_color_breeze' ~/.config/gtk-3.0/colors.css)

#gtkcolor=$'@define-color theme_selected_bg_color_breeze '
#newgtkcolor=$"$gtkcolor$c2$imbadatcoding"
#imbadatcoding=$";"
#sed -i "s/$oldgtkcolor/$newgtkcolor/" ~/.config/gtk-3.0/colors.css


oldgtkcolor=$(grep '@define-color theme_selected_bg_color_breeze' ~/.config/gtk-3.0/colors.css)
sed -i "s/$oldgtkcolor//" ~/.config/gtk-3.0/colors.css
