command -v wofi >/dev/null && {
        test -d ~/.config || mkdir -p ~/.config
        test -L ~/.config/wofi || \
                ln -s $SCRIPTS/etc/wofi ~/.config/wofi
}
