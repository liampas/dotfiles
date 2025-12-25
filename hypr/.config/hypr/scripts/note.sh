#!/usr/bin/env bash

folder=$HOME/Nextcloud/notes/
TERMINAL=$'kitty --class note'
TERMINAL_daily=$'kitty --class daily'
editor=nvim

newnote () { \
	name="$(echo "" | dmenu -c -sb "#a3be8c" -nf "#d8dee9" -p "Enter a name: " <&-)" || exit 0
: "${name:=$(date +%F_%T | tr ':' '-')}"


setsid -f "kitty --class note" -e "$editor" $folder$name".md" >/dev/null 2>&1
}
imbadatcoding () {
	if [[ $choice ]]; then

	#does the same thing as newnote but with another variable because I'm not good enough to know how to do it cleanly
	setsid -f $TERMINAL -e "$editor" $folder$choice".md" >/dev/null 2>&1
else
	exit
	fi

}
daily () {
	today=$(date +"%Y-%m-%d")
	dailypath="${folder}daily-notes/${today}.md"
	if [[ ! -f $dailypath ]]; then

		echo "the daily doesnt exist, either cry, wait until it does or go on the server and use the creation script"
	fi
		setsid -f $TERMINAL_daily -e "$editor" "$dailypath" >/dev/null 2>&1
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

	linestart=$(grep -n "\---" ${lastdayfile} | awk -F":" 'NR==1 {print $1}')
	lineend=$(grep -n "\---" ${lastdayfile} | awk -F":" 'NR==2 {print $1}')

	if [ ! $linestart ]; then
		notify-send "could'nt find something to bring over to the daily"

	fi

	echo "#daily-note " >> "$folder"/daily-notes/"$today".md
	echo "" >> "$folder"/daily-notes/"$today".md

	echo "# Today's events" >> "$folder"/daily-notes/"$today".md
	calcurse -d today >> "$folder"/daily-notes/"$today".md
	# here I replace all the courses by link to their respecting folder for quick navigation
	sed -i -e 's|Introduction à la programmation|[Introduction à la programmation](../school/programmation/index)|' "$folder"/daily-notes/"$today".md
	sed -i -e 's|Calcul différentiel|[Calcul différentiel](../school/Calcul_differentiel/index)|' "$folder"/daily-notes/"$today".md
	sed -i -e 's|Communication, langue et littérature|[Communication, langue et littérature](../school/Communication_langue_et_litterature/index)|' "$folder"/daily-notes/"$today".md
	sed -i -e 's|Mathématiques discrètes|[Mathématiques discrètes](../school/Mathematiques_discretes/index)|' "$folder"/daily-notes/"$today".md
	sed -i -e 's|Philosophie et rationalité|[Philosophie et rationalité](../school/Philosophie/index)|' "$folder"/daily-notes/"$today".md
	sed -i -e 's|Volley-ball (mixte)|[Volley-ball (mixte)](../school/Volley-ball/index)|' "$folder"/daily-notes/"$today".md
	
	echo "" >> "$folder"/daily-notes/"$today".md
	sed -n ${linestart},${lineend}p ${lastdayfile} >> "$folder"/daily-notes/"$today".md
	
	echo "" >> "$folder"/daily-notes/"$today".md
	echo "# Log" >> "$folder"/daily-notes/"$today".md
	echo "" >> "$folder"/daily-notes/"$today".md
	echo "# Journal" >> "$folder"/daily-notes/"$today".md
	echo "" >> "$folder"/daily-notes/"$today".md
}

selected() {
	choice=$(echo -e "Daily\nNew\n$(
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
		Daily) daily ;;
		New) newnote ;;
		*.md) setsid -f $TERMINAL -e "$editor" "$folder/$choice" >/dev/null 2>&1 ;;
		*) imbadatcoding ;;
	esac
}

selected
