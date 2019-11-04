command -v youtube-dl >&- && {
        alias yt2mp3='youtube-dl --extract-audio --audio-format mp3'
}

function youtube() {
        if [[ $# -eq 1 ]]
        then
                youtube-dl -F "$@"
                return
        fi

        if [[ $# -eq 2 ]]
        then
                youtube-dl -f $2 "$1"
        fi
}
