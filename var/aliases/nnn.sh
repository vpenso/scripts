test -L ~/.config/nnn || {
        ln -sv $SCRIPTS/etc/nnn ~/.config/nnn
}
