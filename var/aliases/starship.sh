command -v starship >/dev/null && {
    test -L ~/.config/starship.toml \
        || ln -sf $SCRIPTS/etc/starship.toml ~/.config/starship.toml
    eval "$(starship init bash)"
}
