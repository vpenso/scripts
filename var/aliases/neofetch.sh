command -v neofetch >/dev/null && {

        # default path to the user configuration
        config=$HOME/.config/neofetch/config.conf
        # link to this repository if missing
        test -L $config || ln -fs $SCRIPTS/etc/neofetch/config.conf $config

        # speed up neofetch by storing its output for one hour
        tmp=/tmp/$USER-neofetch.$(date +%Y%m%dT%H)
        test -f $tmp && \cat $tmp || neofetch --off | tee $tmp

}
