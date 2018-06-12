alias m=music
alias mute="amixer --quiet set Master toggle"

# pass the volume in percent as first argument
alias volume="amixer --quiet set Master"

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
                # is part ffmpeg
                ffplay -nodisp $1 2>&1 >/dev/null &
                disown
        fi
}

##
# Stop playing a song
#
stop() { killall -s KILL ffplay ; }
