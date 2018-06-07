if [[ "$TERM" = "rxvt-unicode"* ]]
then

	# append X custom config to Xresources
	resources="#include \"$SCRIPTS/etc/Xresources.d/urxvt\""
	grep -q -F "$resources" ~/.Xresources || \
		echo -e "\n$resources" >> ~/.Xresources
        # this modification will not effect running X applications

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
