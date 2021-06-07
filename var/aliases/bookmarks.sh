if test -z $BOOKMARKS_PATH
then
        export BOOKMARKS_PATH=$SCRIPTS/var/bookmarks
elif ! $(echo $BOOKMARKS_PATH | grep -q '\/scripts\/')
then
        export BOOKMARKS_PATH=$BOOKMARKS_PATH:$SCRIPTS/var/bookmarks
fi

# open a bookmark in the default web-browser
alias bm='bookmarks --open search'

command -v brave-browser >/dev/null && \
        alias bmb='bookmarks --open --browser brave-browser search'

command -v chromium >/dev/null && \
        alias bmc='bookmarks --open --browser chromium search'

command -v firefox >/dev/null && \
        alias bmf='bookmarks --open --browser firefox search'
