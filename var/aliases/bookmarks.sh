# link to the bookmarks within this repository
test -L ~/.bookmarks || \
        ln -s $SCRIPTS/var/bookmarks ~/.bookmarks

# open a bookmark in the default web-browser
alias bm=bookmarks
