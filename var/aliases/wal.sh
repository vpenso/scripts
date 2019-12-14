# Cf. https://github.com/dylanaraps/pywal
#
# install the Python module on Debian
#       pip3 install pywal
command -v wal >&- && {

        alias walli='wal -l -i'

        # path to a wallpaper used by wal
        export WAL_WALLPAPER=~/.cache/wall/wallpaper
        # use the wallpaper if existing
        test -L $WAL_WALLPAPER && wal -e -q -l -i $WAL_WALLPAPER ||:

        # set a new wallpaper
        function wal-set() {
                local image=${1:?Path to image file missing!}
                ln -s $image $WAL_WALLPAPER
        }

        # remove the wal configuration
        function wal-clean() {
                rm -rvf ~/.cache/wal ~/.config/wal
        }

}
