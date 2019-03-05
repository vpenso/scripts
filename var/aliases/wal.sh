# Cf. https://github.com/dylanaraps/pywal

if command -v wal |:
then

        if [ -f ~/.cache/wal/sequences ]
        then
                # import colorschema from pywal
                (cat ~/.cache/wal/sequences &)
        fi

        alias walli='wal -l -i'
fi
