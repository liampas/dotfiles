#!/usr/bin/env bash

folder=$HOME/Nextcloud/Vault/
TERMINAL=kitty
editor=nvim

newnote () { \
  name="$(echo "" | dmenu -c -sb "#a3be8c" -nf "#d8dee9" -p "Enter a name: " <&-)" || exit 0
  : "${name:=$(date +%F_%T | tr ':' '-')}"
  setsid -f "$TERMINAL" -e "$editor" $folder$name".md" >/dev/null 2>&1
}
imbadatcoding () {
if [[ $choice ]]; then

#does the same thing as newnote but with another variable because I'm not good enough to know how to do it cleanly
	setsid -f "$TERMINAL" -e "$editor" $folder$choice".md" >/dev/null 2>&1
else
	exit
fi

}
daily () {
	today=$(date +"%Y-%m-%d")
#	kitty "$editor" "$folder"/daily-notes/"$today".md
setsid -f "$TERMINAL" -e "$editor" "$folder"/daily-notes/"$today".md >/dev/null 2>&1

}

selected() {
    choice=$(echo -e "New\nDaily\n$(
        cd "$folder" || exit
        find . -type f -print0 \
        | while IFS= read -r -d '' file; do
            #skip dotfiles 
            [[ "$file" =~ /\. ]] && continue
            mtime=$(stat -c '%Y' "$file")
            echo "$mtime $file"
        done \
        | sort -nr \
        | cut -d' ' -f2- \
        | sed 's|^\./||'
    )" | dmenu -c -l 15 -i -p "Choose note or create new:" )

    case "$choice" in
        New) newnote ;;
        Daily) daily ;;
        *.md) setsid -f "$TERMINAL" -e "$editor" "$folder/$choice" >/dev/null 2>&1 ;;
        *) imbadatcoding ;;
    esac
}

selected
