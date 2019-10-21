MPC_ALIAS_HELP="\
@,  crop                Remove songs except current from playlist
+,  next                Play next song in playlist
-,  prev                Play previous song in playlist
~                       Remove current song from playlist
1                       Toggles looping
a,  add PATH            Adds directory to playlist
c,  clear               Remove all songs from playlist
    conf                Show MPD configuration
d,  delete <num>        Remove songs from playlist
k,  kill                Kill MPD daemon
l,  list                List library
pl, playlist            Show current playlist
p,  play <num>          Plays playlist
s,  stop                Stop playing music
sa                      search in music dir and add to playlist
sr                      search in music dir and replace playlist
u,  update              Update database
v,  volume [+-]<num>     Adjust volume between 0-100 (+- for relative numbers)
"

command -v mpc >&- && {

        function mpc-fzf() {
                if command -v fzf >&-
                then
                        echo C^a to select all filtered entries
                        mpc add $(mpc listall | fzf -m --bind 'ctrl-a:select-all+accept' | sort)
                else
                        echo fzf command missing!
                fi
        }

        function mpc-playlist() {
                mpc --format '[%position%] %file%' playlist
        }

        alias mpc='mpc --host 127.0.0.1 -p $MPD_PORT'

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
                        sa)    
                                # search songs, and add to playlist
                                mpc-fzf 
                                ;;
                        sr)             
                                # clear playlist
                                mpc -q clear
                                # search songs, and add to playlist
                                mpc-fzf
                                # play first song
                                mpc play
                                ;;
                        help|h)         echo -n $MPC_ALIAS_HELP ;;
                        kill|k)         killall -u $USER mpd ;;
                        next|-)         mpc prev ;;
                        list|l)         mpc ls $@ ;;
                        play|p)         mpc play $1 ;;
                        playlist|pl)    mpc-playlist;;
                        prev|+)         mpc next ;;
                        stop|s)         mpc stop ;;
                        update|u)       mpc update ;;
                        volume|v)       mpc volume $1 ;;
                        ~)              mpc del 0 ;;
                        0)              mpc current ;;
                        1)              mpc repeat ;;
                        @)              mpc crop ;;
                        *)              mpc-playlist ;;
                esac
        
        }

        alias m=mpc-alias

}

# if the ncurses client is installed
command -v ncmpc >&- && {
	alias n="ncmpc --host 127.0.0.1 --port $MPD_PORT"
}

