function @wikipedia() {
  local lang=${1:-"en"}
  shift 2>-
  $BROWSER "http://$lang.wikipedia.org/w/index.php?search=$(uri-encode $@)"
}

alias @w="@wikipedia en"
alias @w.de="@wikipedia de"
