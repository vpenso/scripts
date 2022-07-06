#
# https://github.com/sharkdp/bat/releases

# Debian has rename bat due to a package name collision
command -v batcat >/dev/null && {
	alias bat=batcat
}

command -v bat >/dev/null && {

	export BAT_THEME=OneHalfLight
        export BAT_STYLE=plain,header,grid
        alias cat=bat
        alias dat='bat --style=full'

        if [[ $SHELL == *zsh ]] ; then
                alias -s {js,json,env,md,html,css,toml,yaml}=bat
        fi

}
