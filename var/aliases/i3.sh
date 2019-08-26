
command -v i3 >&- && {

        command -v startx >&- && {
                
                i3-start() {
                        startx /usr/bin/i3 -c $SCRIPTS/etc/i3/config 
                }
        
        }

	test -L /usr/bin/i3exit || {
		sudo ln -sfv $SCRIPTS/bin/i3exit /usr/bin/i3exit
	}

}

