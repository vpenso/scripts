#
# https://github.com/sharkdp/bat/releases

# Debian has rename bat due to a package name collision
command -v batcat >/dev/null && {
	alias bat=batcat
}

command -v bat >/dev/null && {

	export BAT_THEME=OneHalfLight
        alias cat=bat
        alias b='bat --plain'

        if [[ $SHELL == *zsh ]] ; then
                alias -s {js,json,env,md,html,css,toml}=bat
        fi

}
