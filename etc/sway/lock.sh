#!/bin/sh
# Times the screen off and puts it to background
swayidle \
    timeout 10 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &

if command -v swaylock >/dev/null ; then
        swaylock --color 000000 \
                 --indicator-radius 100
elif command -v physlock >/dev/null ; then
        physlock
else
        echo 'No screen lock program available'
fi

# Kills last background task so idle timer doesn't keep running
killall swayidle
