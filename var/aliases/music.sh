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

