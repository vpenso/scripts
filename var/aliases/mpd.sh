
command -v mpd >&- && {

        MPD_CONF=$SCRIPTS/etc/mpdconf
        # read the port from the configuration file
        MPD_PORT=$(grep ^port $MPD_CONF | cut -d'"' -f2)
        MPD_PLAYLISTS=$HOME/.mpd/playlists
        MUSIC_DIR=$(grep ^music $MPD_CONF | cut -d'"' -f2)
        mkdir -p $MPD_PLAYLISTS $MUSIC_DIR |:
        
        export MPD_PORT \
               MPD_CONF \
               MPD_PLAYLISTS \
               MUSIC_DIR

        if [ -d $MUSIC_DIR ]
        then
                # if MPD is not running
                if ! pgrep -u $USER mpd &>/dev/null
                then
                        [[ -d $MPD_PLAYLISTS ]] || mkdir -p $MPD_PLAYLISTS
                        # start MPD
                        mpd $MPD_CONF 2>&-
                        # update music index
                        mpc -w update
                        echo mpd started
                fi
        fi

}
