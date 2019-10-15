# Cf. https://github.com/dylanaraps/pywal
command -v wal >&- && {
        alias walli='wal -l -i'

        test -L ~/.wallpaper && \
                wal -e -q -l -i ~/.wallpaper ||:

        function wal-clean() {
                rm -rvf ~/.cache/wal ~/.config/wal
        }

}
# install on Debian
# pip3 install pywal
