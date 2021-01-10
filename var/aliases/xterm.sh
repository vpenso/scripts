command -v xrd >/dev/null && {
        test -n "$DISPLAY" && test -f $SCRIPTS/etc/Xresources.d/xterm && \
                xrdb -merge $SCRIPTS/etc/Xresources.d/xterm

        alias xterm='xterm -ti vt340 -sh 6'
}

