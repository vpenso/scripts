
function man() {
        LESS_TERMCAP_mb=$'\e'"[1;31m" \
        LESS_TERMCAP_md=$'\e'"[1;31m" \
        LESS_TERMCAP_me=$'\e'"[0m" \
        LESS_TERMCAP_se=$'\e'"[0m" \
        LESS_TERMCAP_so=$'\e'"[1;44;33m" \
        LESS_TERMCAP_ue=$'\e'"[0m" \
        LESS_TERMCAP_us=$'\e'"[1;32m" \

        MANWIDTH=80 
        MANPAGER=less
        command man "$@"
}

function mancx() {
        ${BROWSER:-firefox} https://man.cx/${1}
}
