#!/bin/bash

DND=$(swaync-client -D)

if [ "$DND" = "true" ]; then
  echo '{"text":"󰂛","class":"notifications-on"}'
else
  echo '{"text":"󰂚","class":"notifications-off"}'
fi
