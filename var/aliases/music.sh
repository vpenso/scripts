alias m=music
alias mute="amixer --quiet set Master toggle"

# pass the volume in percent as first argument
alias vol="amixer --quiet set Master"

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
