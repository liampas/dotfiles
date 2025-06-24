#!/bin/bash


floatingmode=$(grep 'floatingmode' ~/.config/hypr/toggles.state | cut -d '=' -f 2)

if [ $floatingmode -eq 0 ]; then
    floatingmode2=$"tilling"

    else

    floatingmode2=$"floating"

fi

if pgrep -x "hyprsunset" > /dev/null; then
    night=$"Day"

    else

    night=$"Night"

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
    sed -i 's/floatingmode=0/floatingmode=1/' ~/.config/hypr/toggles.state
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
    sed -i 's/floatingmode=1/floatingmode=0/' ~/.config/hypr/toggles.state
    floatingmode=0

    #enables the snaping
    hyprctl keyword general:snap:enabled true

    exit
}


timetochoose() { \
    choice=$(printf "window mode: $floatingmode2\\nRandom Wallpaper\\nStart Waybar\\n$night Mode" | dmenu -c -l 20 -p "Quick Settings: ")
    case "$choice" in
        "window mode: floating") floating;;
        "window mode: tilling") tilling;;
        'Random Wallpaper') ~/.config/hypr/wallpaper.sh;;
        'Start Waybar') ~/.config/hypr/reload-waybar.sh;;
        'Night Mode') ~/.config/hypr/night-mode.sh;;
        'Day Mode') killall hyprsunset
    esac
}

timetochoose
