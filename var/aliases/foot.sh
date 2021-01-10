command -v foot >/dev/null && {
        test -d ~/.config/foot || mkdir -p ~/.config/foot
        test -L ~/.config/foot/foot.ini || \
                ln -s $SCRIPTS/etc/foot/foot.ini ~/.config/foot/foot.ini
}
