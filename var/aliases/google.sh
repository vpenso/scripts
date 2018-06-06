alias @gmail='$BROWSER -new-tab gmail.com'

function @google-translate() { 
  local lang=${1:-"en/de"}
  shift 2>-
  $BROWSER "http://translate.google.com/#$lang/$(uri-encode $@)" 
}

alias @g.t="@google-translate de/en"

function @google() { 
  local lang=${1:-"en"}
  shift 2>-
  $BROWSER "http://www.google.com/search?h1=$lang#q=$(uri-encode $@)"
}


alias @g="@google en"
alias @g.de="@google de"



