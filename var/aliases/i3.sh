rm -rf ~/.config/i3

test -L ~/.i3 || \
        ln -s $SCRIPTS/etc/i3 ~/.i3
