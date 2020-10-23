#
# https://github.com/sharkdp/bat/releases

command -v bat >&- && {
        export BAT_THEME=OneHalfLight
        alias b='bat --plain'
}
