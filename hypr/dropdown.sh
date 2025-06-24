#!/bin/bash

# Find kitty dropdown window
addr=$(hyprctl clients -j | jq -r '.[] | select(.class == "dropdown") | .address')

if [ -n "$addr" ]; then
    # Get current active workspace
    wsp=$(hyprctl activeworkspace -j | jq -r '.id')

    # Get the current workspace of the window
    current_workspace=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$addr\") | .workspace.name")

    if [[ "$current_workspace" == "special:dropdown" ]]; then
        # Pull from special:dropdown to active workspace
        hyprctl dispatch movetoworkspacesilent "$wsp,address:$addr"
        hyprctl dispatch focuswindow address:$addr
    elif [[ "$current_workspace" != "$wsp" ]]; then
        # Pull from any other workspace to active workspace
        hyprctl dispatch movetoworkspacesilent "$wsp,address:$addr"
        hyprctl dispatch focuswindow address:$addr
    else
        # Already here: push back to special:dropdown
        hyprctl dispatch movetoworkspacesilent "special:dropdown,address:$addr"
    fi
else
    # Not running: launch kitty
    hyprctl dispatch exec "kitty --class dropdown"
    sleep 0.5
    newaddr=$(hyprctl clients -j | jq -r '.[] | select(.class == "dropdown") | .address')
fi

