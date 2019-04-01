# link to the Termite configuration within this repository
test -L ~/.config/termite || \
        ln --symbolic \
           --verbose \
           $SCRIPTS/etc/termite ~/.config
