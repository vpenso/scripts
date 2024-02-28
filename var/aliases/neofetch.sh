command -v neofetch >/dev/null && {

        # default path to the user configuration
        config=$HOME/.config/neofetch/config.conf
        # link to this repository if missing
        test -L $config || ln -s $SCRIPTS/etc/neofetch/config.conf $config

        # speed up neofetch by storing its output once per day
        tmp=/tmp/$USER-neofetch.$(date +%Y%m%d)
        test -f $tmp && \cat $tmp || neofetch --off | tee $tmp

}
