command -v sway >/dev/null && {
        test -d ~/.config || mkdir -p ~/.config
        test -L ~/.config/sway || \
                ln -s $SCRIPTS/etc/sway ~/.config/sway
}
