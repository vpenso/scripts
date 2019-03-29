# Cf. https://github.com/dylanaraps/pywal
if command -v wal |:
then
        alias walli='wal -l -i'

        test -L ~/.wallpaper && \
                wal -q -l -i ~/.wallpaper ||:
fi
