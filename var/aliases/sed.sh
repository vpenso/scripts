

function sed-trim-blank-lines() { sed -e '/^[[:blank:]]*$/d' }

alias -g TBL='| sed-trim-blank-lines'
