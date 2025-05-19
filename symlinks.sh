#!/bin/bash

#some apps have configuration files outside .config, this script makes a link between those location.


## obsidian ##


#move the files to a folder in .config

#moves the old config out of the way by making it a backup
mv ~/Documents/Obsidian-Vault/.obsidian/ ~/Documents/Obsidian-Vault/.obsidian-BKP/

#make the symlink
ln -s ~/.config/.obsidian/ ~/Documents/Obsidian-Vault/



## firefox ##


#find the folder for the profile config
profile_default_folder=$(grep -E 'Default=' ~/.mozilla/firefox/profiles.ini | head -n1 | cut -d= -f2)
profile_default_path="$HOME/.mozilla/firefox/$profile_default_folder"


#enable .css injection in firefox settings
echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$profile_default_path/prefs.js"

#make the symlink
ln -s ~/.config/firefox/default/chrome/ "$profile_default_path/"

echo "pls restart firefox for the css to be injected"



