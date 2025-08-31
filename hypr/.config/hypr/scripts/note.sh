#!/usr/bin/env bash

folder=$HOME/Nextcloud/Vault/
TERMINAL=alacritty
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
	test="${folder}daily-notes/${today}.md"
	if [[ ! -f $test ]]; then
		createdaily
	fi
		setsid -f "$TERMINAL" -e "$editor" "$folder"/daily-notes/"$today".md >/dev/null 2>&1
}

getlastdaily () {
	#the script will check for the last daily note but in the last 30 days

	for lastday in {1..30}

	do
		lastfile=${folder}daily-notes/$(date -d "$lastday day ago" '+%Y-%m-%d').md
		if [ -f $lastfile ]; then
			#if the file exists
			lastdayfile=$lastfile
			break
		fi
	done

	if [ ! $lastdayfile ]; then
		notify-send "couldnt find last daily note to copy over"
		lastdayfile=${folder}projects/notes/daily-note-template.md
	fi

}


createdaily () {

	getlastdaily

	line=$(grep -n "# Journal" ${lastdayfile} | awk -F":" '{print $1}')

	#very bad code ahead
	if [ ! $line ]; then
		line=$(grep -n "---" ${lastdayfile} | awk -F":" '{print $1}')

		if [ ! $line ]; then
			line=$(grep -n "# daily note" ${lastdayfile} | awk -F":" '{print $1}')
			if [ ! $line ]; then
				line=$(grep -n "# diary" ${lastdayfile} | awk -F":" '{print $1}')
			fi
		fi
	fi

	head --lines ${line} ${lastdayfile} >> "$folder"/daily-notes/"$today".md

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
