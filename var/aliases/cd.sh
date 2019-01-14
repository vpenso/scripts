alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'

# create a new directory and enter it
function mkd() {
        mkdir -p "$@" && cd "$_";
}
