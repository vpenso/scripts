# apt install youtube-dl libav-tools
## get the latest version from
# https://github.com/rg3/youtube-dl

alias yt2mp3='youtube-dl --extract-audio --audio-format mp3'

# do not expand URL on Zsh

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

if command -v noglob >&-
then
        alias yt='noglob youtube'
else
        alias yt=youtube
fi
