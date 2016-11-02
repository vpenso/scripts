

function sed-trim-blank-lines() { sed -e '/^[[:blank:]]*$/d' }
function sed-trim-trailing-blanks() { sed -i.bak 's/[[:blank:]]*$//' }

alias -g TBL='| sed-trim-blank-lines'
