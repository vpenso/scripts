command -v bookmarks >/dev/null && {

    if test -z $BOOKMARKS_PATH
    then
            export BOOKMARKS_PATH=$SCRIPTS/var/bookmarks
    elif ! $(echo $BOOKMARKS_PATH | grep -q '/scripts/')
    then
            export BOOKMARKS_PATH=$BOOKMARKS_PATH:$SCRIPTS/var/bookmarks
    fi
    
    bo() {
            bookmarks -o $(bookmarks -l | cut -d' ' -f1 | fzf --exact --select-1 --query "$1") 
    }
}
