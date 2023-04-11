# if Kitty terminal emulator is installed
command -v kitty >/dev/null && {

        # reference to the configuration in this repository
        test -d ~/.config/kitty && rm -rf ~/.config/kitty
        test -L ~/.config/kitty ||
               ln -s $SCRIPTS/etc/kitty ~/.config/kitty

        # required to propagate terminfo ...rrror opening terminal: xterm-kitty
        test "$TERM" = "xterm-kitty" && alias ssh="kitty +kitten ssh"

        # display images in the terminal cf. https://sw.kovidgoyal.net/kitty/kittens/icat
        alias icat="kitty +kitten icat --align left"

}
