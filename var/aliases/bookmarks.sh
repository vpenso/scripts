# link to the bookmarks within this repository
test -L ~/.bookmarks || \
        ln -s $SCRIPTS/var/bookmarks ~/.bookmarks

# open a bookmark in the default web-browser
alias bm=bookmarks
# open Youtube in a browser and search...
alias youtube-search='bookmarks --open search youtube --append'
