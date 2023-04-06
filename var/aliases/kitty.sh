command -v kitty >/dev/null && {
        test -L ~/.config/kitty ||
               ln -s $SCRIPTS/etc/kitty ~/.config/kitty
}
