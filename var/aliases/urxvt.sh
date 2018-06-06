if [[ "$TERM" = "rxvt-unicode"* ]]
then
	# Install using the Pacman package manager
	if [ -f /usr/bin/pacman ]
	then
		# if the Inconsolata font is missing
		if ! [ -f /usr/share/fonts/TTF/Inconsolata-Regular.ttf ]
		then
			sudo pacman -Sy --noconfirm ttf-inconsolata
		fi	
	fi

	# append custom config to X init
	user_resources=$SCRIPTS/etc/Xdefaults
        user_script="[ -f $user_resources ] && xrdb -merge $user_resources"
	grep -q -F "$user_script" ~/.xinitrc || \
		echo -e "\n$user_script" >> ~/.xinitrc


	# list configurable resources
	urxvt-resources() {
		urxvt --help 2>&1| sed -n '/:  /s/^ */! URxvt*/gp'
	}

	# list resources with description
	urxvt-resource-descriptions() {
		man -Pcat urxvt |\
		  sed -n '/th: b/,/^B/p'|\
		  sed '$d'|\
		  sed '/^ \{7\}[a-z]/s/^ */^/g' |\
		  sed -e :a -e 'N;s/\n/@@/g;ta;P;D' |\
		  sed 's,\^\([^@]\+\)@*[\t ]*\([^\^]\+\),! \2\n! URxvt*\1\n\n,g' |\
		  sed 's,@@\(  \+\),\n\1,g' |\
		  sed 's,@*$,,g' |\
		  sed '/^[^!]/d' |\
		  tr -d "'\`"
	}

fi
