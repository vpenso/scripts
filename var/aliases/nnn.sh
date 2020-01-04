
command -v nnn >&- && { 

        test -L ~/.config/nnn || {
                ln -sv $SCRIPTS/etc/nnn ~/.config/nnn
        }

        export NNN_PLUG='s:sxiv'
        export NNN_OPENER=mimeopen

}
