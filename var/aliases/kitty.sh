command -v kitty >/dev/null && {
        test -d ~/.config/kitty && rm -rf ~/.config/kitty
        test -L ~/.config/kitty ||
               ln -s $SCRIPTS/etc/kitty ~/.config/kitty
}
