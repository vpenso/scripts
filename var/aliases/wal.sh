# Cf. https://github.com/dylanaraps/pywal
command -v wal >&- && {
        alias walli='wal -l -i'

        test -L ~/.wallpaper && \
                wal -e -q -l -i ~/.wallpaper ||:
        }
# install on Debian
# pip3 install pywal
