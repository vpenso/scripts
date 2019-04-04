test -L ~/.config/kitty || {
        rm -rf ~/.config/kitty &>/dev/null
        ln -sv $SCRIPTS/etc/kitty ~/.config/kitty
}
