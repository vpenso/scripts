redshift-off() {
        # make sure to kill running instances
        killall -w -u $USER redshift 2>/dev/null
}

redshift-on() {
        redshift-off
        redshift 1>/dev/null 2>/dev/null &
        disown
}

alias night=redshift-on
alias day=redshift-off
