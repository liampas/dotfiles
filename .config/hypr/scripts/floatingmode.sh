#!/usr/bin/env sh

floatingmode=$(grep 'floatingmode' ~/.config/hypr/toggles.state | cut -d '=' -f 2)

if [ $floatingmode -eq 0 ]; then
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
    else
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
fi
hyprctl reload
