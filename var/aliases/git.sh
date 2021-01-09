
test -L ~/.gitconfig || \
        ln -s $SCRIPTS/etc/gitconfig ~/.gitconfig

test -L ~/.gitignore_global || \
        ln -s $SCRIPTS/etc/gitignore_global ~/.gitignore_global
