command -v git >/dev/null && {

    alias g=git

    test -L ~/.gitconfig \
        || ln -s $SCRIPTS/etc/git/gitconfig ~/.gitconfig

    test -L ~/.gitignore_global \
        || ln -s $SCRIPTS/etc/git/gitignore_global ~/.gitignore_global

}
