mkdir -p ~/.config |:

test -L ~/.config/rofi || \
        ln -s $SCRIPTS/etc/rofi ~/.config/rofi
