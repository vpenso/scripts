test -L ~/.config/terminator || {
        rm -rfv ~/.config/terminator
        ln -sv $SCRIPTS/etc/terminator ~/.config
}
