#
# https://github.com/sharkdp/bat/releases

command -v bat >&- && {
        export BAT_THEME=OneHalfLight
        export PAGER=bat
        alias b=bat
        alias bp='bat --plain'
}
