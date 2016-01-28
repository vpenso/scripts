alias m=music
alias mute="amixer --quiet set Master toggle"
alias volume="amixer --quiet set Master"

play() { mpg123 $1 2>&- 1>&- & ; disown }
stop() { killall mpg123 }
