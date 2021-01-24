# if Sway is installed
command -v sway >/dev/null && {

        # load the configuration from this repository
        test -d ~/.config || mkdir -p ~/.config
        test -L ~/.config/sway || \
                ln -s $SCRIPTS/etc/sway ~/.config/sway

        # Set a background wallpaper
        function sway-wallpaper() {
                local img=${1:?Missing image file as first command-line argument}
                rm ~/.cache/wallpaper
                ln -s $img ~/.cache/wallpaper
                swaymsg reload
        }
}
