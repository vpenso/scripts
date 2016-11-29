alias m=music
alias mute="amixer --quiet set Master toggle"
alias volume="amixer --quiet set Master"

##
# Play a single song given as the first argument
#
play() { 
  # show the song played
  if [[ $# -eq 0 ]] ; then
    ps -C mpg123 -o command=
  # start playing song
  else
    mpg123 $1 2>&- 1>&- & ; disown 
  fi
}

##
# Stop playing a song
#
stop() { killall mpg123 }
