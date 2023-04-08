
if test -d /etc/keyd
then
        test ! -L /etc/keyd/default.conf \
                && sudo rm /etc/keyd/default.conf
        test -L /etc/keyd/default.conf \
                || sudo ln -s $SCRIPTS/etc/keyd/default.conf /etc/keyd/default.conf

        alias keyd-restart="sudo systemctl restart keyd"
fi

