#
# https://github.com/sharkdp/bat/releases

# Debian has rename bat due to a package name collision
command -v batcat >/dev/null && {
	alias bat=batcat
}

command -v bat >/dev/null && {
	export BAT_THEME=OneHalfLight
        alias b='bat --plain'
}
