alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'

# change into this repository directory
alias sd="cd $SCRIPTS"

# create a new directory and enter it
function mkd() {
        mkdir -p "$@" && cd "$_";
}
