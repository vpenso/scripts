command -v alacritty >/dev/null && {
        test -L ~/.alacritty.yml || \
                ln --verbose \
                   --symbolic \
                   $SCRIPTS/etc/alacritty/alacritty.yml \
                   ~/.alacritty.yml
}
