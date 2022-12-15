if test -z $BOOKMARKS_PATH
then
        export BOOKMARKS_PATH=$SCRIPTS/var/bookmarks
elif ! $(echo $BOOKMARKS_PATH | grep -q '\/scripts\/')
then
        export BOOKMARKS_PATH=$BOOKMARKS_PATH:$SCRIPTS/var/bookmarks
fi

# open a bookmark in the default web-browser
alias bl='bookmarks -l'
alias bo='bookmarks -o'

