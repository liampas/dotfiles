#!/bin/bash

# variable for floating mode

reload_waybar(){
killall waybar
waybar
	
}

floatingmode=$(grep 'floatingmode' ~/.config/hypr/scripts/toggles.state | cut -d '=' -f 2)

if [ $floatingmode -eq 0 ]; then
    floatingmode2=$"tilling"
    else
    floatingmode2=$"floating"
fi

# variable for day mode
if pgrep -x "hyprsunset" > /dev/null; then
    night=$"day"
    else
    night=$"night"
fi


# variable for notification mode
DND=$(swaync-client -D)

if [ "$DND" = "true" ]; then
  DND=$"on"
else
  DND=$"off"
fi

# variable for power mode
power1=$(powerprofilesctl get)

if [ "$power1" = "power-saver" ]; then
  power=$"balanced"
fi

if [ "$power1" = "balanced" ]; then
  power=$"performance"
fi

if [ "$power1" = "performance" ]; then
  power=$"eco"
fi

#notificationmode=$()

tilling () { \
    #puts every oppened window into floating
    hyprctl clients -j | jq -r '.[] | select(.floating == true) | .address' | while read -r addr; do
        hyprctl dispatch togglefloating address:$addr
    done

    #new window will float
    hyprctl keyword windowrulev2 "unset,float,class:.*"

    #sets the floating mode
    sed -i 's/floatingmode=0/floatingmode=1/' ~/.config/hypr/scripts/toggles.state
    floatingmode=1

    hyprctl reload
    exit
}

floating () { \
    #puts every oppened window into tilled
    hyprctl clients -j | jq -r '.[] | select(.floating == false) | .address' | while read -r addr; do
        hyprctl dispatch togglefloating address:$addr
    done

    #new window will tile
    hyprctl keyword windowrulev2 "float,class:.*"

    #sets the floating mode
    sed -i 's/floatingmode=1/floatingmode=0/' ~/.config/hypr/scripts/toggles.state
    floatingmode=0

    #enables the snaping
    hyprctl keyword general:snap:enabled true

    exit
}


timetochoose() { \
    choice=$(printf "random wallpaper\\nwindow mode: $floatingmode2\\nstart waybar\\n$night mode\\nnotifications $DND\\npower: $power\\ndelete current wallpaper" | dmenu -c -l 20 -p "Quick Settings: ")
    case "$choice" in
        "window mode: floating") floating;;
        "window mode: tilling") tilling;;
        'random wallpaper') ~/.config/hypr/scripts/wallpaper.sh;;
        'start waybar') reload_waybar;;
        'night mode') ~/.config/hypr/scripts/night-mode.sh;;
        'day mode') killall hyprsunset;;
        'notifications on') swaync-client -df;;
        'notifications off') swaync-client -dn;;
        'power: eco') powerprofilesctl set power-saver;;
        'power: balanced') powerprofilesctl set balanced;;
        'power: performance') powerprofilesctl set performance;;
        'delete current wallpaper') ~/.config/hypr/scripts/delete-wallpaper.sh;;
    esac
}

timetochoose
