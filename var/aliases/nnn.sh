test -L ~/.config/nnn || {
        ln -sv $SCRIPTS/etc/nnn ~/.config/nnn
}

# custom file opener
NNN_OPENER=mimeopen
