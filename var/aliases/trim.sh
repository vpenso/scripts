
# Usage: trim_string "   example   string    "
trim_string() {
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

if [[ $SHELL == *zsh ]] ; then
	alias -g T='| trim_string'
fi
