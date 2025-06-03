if command -v starship >/dev/null
then
    test -L ~/.config/starship.toml \
        || ln -sf $SCRIPTS/etc/starship.toml ~/.config/starship.toml
    eval "$(starship init bash)"
else
    # simple default shell prompt
    export PS1="\n\e[32m\u\e[0m@\e[34m\h\e[0m:\e[31m\w\e[0m \n󱆃 󰜴 "
    # \e[<num>m     ASCI escape ANSI code
    # \u            user name
    # \h            hostname
    # \#            current command number
    # \j            background jobs
fi
