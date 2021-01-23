alias _=" sudo"
alias 0=clear
alias a=alias
alias g=git
alias q=exit
alias x=session

alias a+x="chmod a+x"
alias go-="chmod go-rwx"

# get the permissions on a file in octal form
alias octperm="stat -c '%A %a %n'"

alias _!=" sudo !!"
alias __=noglob
# List all directories in path
alias path='echo -e ${PATH//:/\\n}'
# Show CPU info
alias cpu=lscpu
# List all ports
alias ports='netstat -tulanp'
# Print seconds since epoch
alias epoch="date +%s"
alias stamp="date +%Y/%m/%dT%R:%S"

# Download a file
alias get="curl -C - -O"
alias usage="du -k * | sort -nr | cut -f2 | xargs -d '\n' du -sh"
alias ascii="man ascii"
alias suspend="sudo true ; xscreensaver-command -lock ; sudo pm-suspend"


##
# pagers
#
alias less="less -R"
alias less-trim="less --quit-on-intr --chop-long-lines"

##
# permissions
#
alias perms="stat -c '%A %a %U %u %G %g'"

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

# export working directory to path
exwd() { export PATH=$PATH:$PWD ; }

# Encode URLs before using them with a browser
uri-encode() { 
  echo -ne $@ | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g' 
}

calc() { echo "$*" | bc -l ; }
