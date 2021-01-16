
#
# Depending on the Linux distribution...
#
command -v systemctl >/dev/null && {
        if systemctl is-enabled --quiet mpd 2>/dev/null
        then
                echo Stop/disable mpd service
                sudo systemctl disable --now mpd.service
        fi
}

command -v mpd >/dev/null && {

        MPD_CONF=$SCRIPTS/etc/mpdconf
        # read the port from the configuration file
        MPD_PORT=$(grep ^port $MPD_CONF | cut -d'"' -f2)
        MPD_PLAYLISTS=$HOME/.mpd/playlists
        MUSIC_DIR=$HOME/music
        
        export MPD_PORT \
               MPD_CONF \
               MPD_PLAYLISTS \
               MUSIC_DIR

        mkdir -p $MPD_PLAYLISTS

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
