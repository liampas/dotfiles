color3=$(jq -r '.colors.color3' ~/.cache/wal/colors.json)
jq --arg color "$color3" '.TitleBack = $color' /home/liam/.config/clipse/custom_theme.json > /home/liam/.config/clipse/custom_theme2.json
