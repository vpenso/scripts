# Cf. https://github.com/dylanaraps/pywal
if command -v wal |:
then
        alias walli='wal -l -i'

        test -L ~/.wallpaper && \
                wal -e -q -l -i ~/.wallpaper ||:
fi

# install on Debian
# pip3 install pywal
