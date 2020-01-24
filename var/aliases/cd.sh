alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'

# change into this repository directory
alias sd="cd $SCRIPTS"

# create a new directory and enter it
cdmk() {
        mkdir -p "$@" && cd "$_";
}

# change directory in a newly created unique directory in /tmp
cdtmp() {
        cd $(mktemp -d)
}
