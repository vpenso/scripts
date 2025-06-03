if command -v starship >/dev/null
then
    test -L ~/.config/starship.toml \
        || ln -sf $SCRIPTS/etc/starship.toml ~/.config/starship.toml
    eval "$(starship init bash)"
else
    # simple default shell prompt
    export PS1="\n\e[38;5;243m\u\e[0m@\e[38;5;233m\h\e[0m:\e[38;5;250m\w\e[0m \n\e[38;5;254m󱆃 󰜴\e[0m "
    # \e[<num>m     ASCI escape ANSI code
    # \u            user name
    # \h            hostname
    # \#            current command number
    # \j            background jobs
fi
