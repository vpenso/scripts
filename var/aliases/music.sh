alias m=music
alias mute="amixer --quiet set Master toggle"
alias volume="amixer --quiet set Master"

pulserestart() {
  pulseaudio --kill
  pulseaudio --start
}

##
# Play a single song given as the first argument
#
play() { 
  # show the song played
  if [[ $# -eq 0 ]] ; then
    ps -C ffplay -o command=
  # start playing song
  else
    ffplay -nodisp $1 2>&- >&- & ; disown
  fi
}

##
# Stop playing a song
#
stop() { killall -s KILL ffplay }
