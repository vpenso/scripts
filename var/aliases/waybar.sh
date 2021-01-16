# if waybar is installed
command -v waybar >/dev/null && {
        # link to the configuration within this repository
        test -L ~/.config/waybar ||
                ln --verbose --symbolic $SCRIPTS/etc/waybar ~/.config/waybar
}
