#
# Copyright 2012 Victor Penso
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# move cursor one word left/right using Ctrl instead of Esc
bindkey '^B' backward-word
bindkey '^F' forward-word

# stdin is exported as environment variable
function exp() { read n; export $1=$n }
# export working directory to path
function exwd() { export PATH=$PATH:$PWD }
# Encode URLs before using them with a browser
function uri-encode() { echo -ne $@ | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g' ; }

export BROWSER=${BROWSER:-"firefox"}

# quick export NODES environment variable
function NODES() {
  if [ $# -lt 1 ]
  then
    : ${NODES:?}
    echo $NODES
  else
    export NODES=$@
  fi
}
# pipe into the NODES environment variable
alias -g NS='| exp NODES'

alias a+x="chmod a+x"
alias go-="chmod go-rwx"
alias 0=clear
alias x=exit
alias v=vim
alias m=music
alias _=" sudo"
alias _!=" sudo !!"
alias __=noglob
alias ls='ls -Fh --color=always'
alias l='ls -1'
alias ll='ls -l'
alias l.='ls -lA -d .*'
alias g=git
alias t=tmux
alias tl="tmux list-sessions"
alias ta="tmux attach-session"
alias man="MANWIDTH=80 MANPAGER=less man"
alias npm="nocorrect npm"
alias less="less -R"
# List all directories in path
alias path='echo -e ${PATH//:/\\n}'
# Show CPU info
alias cpu=lscpu
# List all ports
alias ports='netstat -tulanp'
# Print seconds since epoch
alias epoch="date +%s"
# Download a file
alias get="curl -C - -O"
alias usage="du -k * | sort -nr | cut -f2 | xargs -d '\n' du -sh"
alias ascii="man ascii"
alias mute="amixer --quiet set Master toggle"
alias volume="amixer --quiet set Master"
alias suspend="sudo true ; xscreensaver-command -lock ; sudo pm-suspend"


calc() { echo "$*" | bc -l ; }

