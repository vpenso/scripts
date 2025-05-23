command -v bat >/dev/null && {
	export BAT_THEME=OneHalfLight
    export BAT_STYLE=plain,header,grid
    alias cat=bat
    alias dat='bat --style=full'
}
