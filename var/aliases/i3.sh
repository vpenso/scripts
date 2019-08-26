
command -v i3 >&- && {

        command -v startx >&- && {
                
                i3-start() {
                        startx i3 -c $SCRIPTS/etc/i3/config 
                }
        
        }

}

