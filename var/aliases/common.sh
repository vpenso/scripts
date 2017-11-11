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

# export working directory to path
function exwd() { export PATH=$PATH:$PWD }
# Encode URLs before using them with a browser
function uri-encode() { echo -ne $@ | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g' ; }

export BROWSER=${BROWSER:-"firefox"}

alias a+x="chmod a+x"
alias go-="chmod go-rwx"

# get the permissions on a file in octal form
alias octperm="stat -c '%A %a %n'"

alias a=alias
alias 0=clear
alias x=exit
alias _=" sudo"
alias _!=" sudo !!"
alias __=noglob
alias g=git
alias t=tmux
alias tl="tmux list-sessions"
alias ta="tmux attach-session"
alias man="MANWIDTH=80 MANPAGER=less man"
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
alias suspend="sudo true ; xscreensaver-command -lock ; sudo pm-suspend"

alias -g G='|grep'
alias -g GV='|grep -v'   # --invert-match
alias -g X='|xargs'
alias -g CF1='| cut -d" " -f1'

calc() { echo "$*" | bc -l ; }

##
# pagers
#
alias less="less -R"
alias less-trim="less --quit-on-intr --chop-long-lines"
alias -g L='|less'
alias -g LT='|less-trim'

##
# directory listings
#
alias ls='ls -Fh --color=always'
alias l='ls -1'
alias ll='ls -l'
alias l.='ls -lA -d .*'
alias el='exa -l --git'
alias eG='exa -lG --git'
alias eT='exa -lT --git --group-directories-first -@ -L 2'

##
# process listing
#
# List of all processes including their hierarchy
alias psa='ps -AfH'
# Comprehensive inspection of the process tree
alias pstree='pstree -lpu'
# Print a sorted list of all processes by CPU utilization
alias pscpu="ps -A -o ruser,pcpu,time,state,args --sort pcpu"
# Continuously updated list of all running processes
alias prun="watch -n1 ps r -AL -o stat,pid,user,psr,pcpu,pmem,args"
# include cgroup
alias psc='ps xawf -eo pid,user,cgroup,args'

##
# Vim text editor 
#

export EDITOR=vim
alias v=vim
alias vim-cheat='vim-cheat | less'


