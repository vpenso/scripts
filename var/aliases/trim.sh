
# Usage: trim_string "   example   string    "
trim_string() {
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

sed-trim-blank-lines() { 
        sed -e '/^[[:blank:]]*$/d'
}

sed-trim-trailing-blanks() { 
        sed -i.bak 's/[[:blank:]]*$//' 
}


if [[ "$SHELL" == *"zsh" ]]
then
	alias -g TBL='| sed-trim-blank-lines'
fi
