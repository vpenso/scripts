command -v flatpak >/dev/null && {
        test -d /var/lib/flatpak/exports/bin \
                && export PATH=$PATH:/var/lib/flatpak/exports/bin
}
