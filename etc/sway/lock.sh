#!/bin/sh
# Times the screen off and puts it to background
swayidle \
    timeout 10 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &
# Locks the screen immediately
swaylock --color 000000 \
         --indicator-radius 100
# Kills last background task so idle timer doesn't keep running
kill %%
