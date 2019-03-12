VOL_ALIAS_HELP="\
-                     decrease volume bu 5%
+                     increase volume by 5%
0                     toggle mute
% <percent>           adjust volume to percentage
"


command -v amixer >&- && {

        function vol-amixer() {
        
                local command=$1
                # remove first argument if present
                [[ $# -ne 0 ]] && shift

                case "$command" in
                        -)                 amixer set Master 5%- ;;
                        +)                 amixer set Master 5%+ ;;
                        0)                 amixer --quiet set Master toggle ;;
                        %)                 amixer --quiet set Master $1 ;;
                        *)                 echo -n $VOL_ALIAS_HELP ;;
                esac
        }

        alias vl=vol-amixer
}

MPC_ALIAS_HELP="\
@,  crop                Remove songs except current from playlist
+,  next                Play next song in playlist
-,  prev                Play previous song in playlist
~                       Remove current song from playlist
1                       Toggles looping
a,  add PATH            Adds directory to playlist
c,  clear               Remove all songs from playlist
    conf                Show MPD configuration
d,  delete NUMS         Remove songs from playlist
k,  kill                Kill MPD daemon
l,  list                List library
pl, playlist            Show current playlist
p,  play [NUM]          Plays playlist
s,  stop                Stop playing music
u,  update              Update database
"

command -v mpd >&- && command -v mpc >&- && {
        MPD_PORT=6666
        MPD_CONF=$SCRIPTS/etc/mpdconf
        MPD_PLAYLISTS=$HOME/.mpd/playlists
        MUSIC_DIR=/srv/music
        
        export MPD_PORT \
               MPD_CONF \
               MPD_PLAYLISTS \
               MUSIC_DIR

        alias mpc="mpc -p $MPD_PORT"

        if [ -d $MUSIC_DIR ]
        then
                # if MPD is not running
                if ! pgrep -u $USER mpd &>/dev/null
                then
                        [[ -d $MPD_PLAYLISTS ]] || mkdir -p $MPD_PLAYLISTS
                        # start MPD
                        mpd $MPD_CONF
                        # update music index
                        mpc -w update
                        echo mpd started
                fi
        fi

        function mpc-alias() {
        
                local command=$1
                # remove first argument if present
                [[ $# -ne 0 ]] && shift
                # for given command...
                case "$command" in
                        add|a)          mpc add $@ ;;
                        clear|c)        mpc -q clear ;;
                        conf)           tail -n+1 $MPD_CONF ;;
                        del|d)          mpc del $@ ;;
                        kill|k)         killall -u $USER mpd ;;
                        next|-)         mpc next ;;
                        list|l)         mpc ls $@ ;;
                        play|p)         mpc play $1 ;;
                        playlist|pl)    mpc --format '[%position%] %file%' playlist ;;
                        prev|+)         mpc prev ;;
                        stop|s)         mpc stop ;;
                        update|u)       mpc update ;;
                        ~)              mpc del 0 ;;
                        0)              mpc current ;;
                        1)              mpc repeat ;;
                        @)              mpc crop ;;
                        *)              echo -n $MPC_ALIAS_HELP ;;
                esac
        
        }

        alias m=mpc-alias

        # if the ncurses client is installed
        if [ -f /usr/sbin/ncmpc ]
        then
                alias n=ncmpc -p $MPD_PORT
        fi
}


pulse-restart() {
        pulseaudio --kill
        pulseaudio --start
}

##
# Play a single song given as the first argument
#
play() { 
        # show the song played
        if [[ $# -eq 0 ]]
        then
                ps -C ffplay -o command=
        # start playing song
        else
                # part of the ffmpeg package
                ( ffplay -loglevel quiet -nodisp $1 & ) \
                        2>&1 >/dev/null
        fi
}

##
# Stop playing a song
#
stop() { killall -s KILL ffplay ; }
