# link to the configuration in this terminal
test -L ~/.config/kitty || {
        rm -rf ~/.config/kitty &>/dev/null
        ln -sv $SCRIPTS/etc/kitty ~/.config/kitty
}

# display an image, alignment left
alias icat="kitty +kitten icat --align left"
