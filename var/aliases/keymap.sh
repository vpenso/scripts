# toggle English/German keyboard with alt+shift
[[ -f /usr/sbin/setxkbmap ]] && \
        setxkbmap -option grp:alt_shift_toggle us,de
