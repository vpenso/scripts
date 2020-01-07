#!/usr/bin/env bash

# Terminate already running bar instances
killall --quiet --user $USER polybar
killall --quiet --user $USER compton

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# find the first network interface matching $1
findiface() {
  ip a | grep '^[0-9]: ' | tr -d ' ' | cut -d: -f2 | grep $1 | head -1
}

#
# Environment variable used by the Polybar configuration
#

# check if a monitor is configured as primary
if xrandr | grep ' connected primary' &>/dev/null
then
        PRIMARY_DISPLAY=$(xrandr | grep ' connected primary' | cut -d' ' -f1 | head -1)
# otherwise use the first connected output display as primary
else
        PRIMARY_DISPLAY=$(xrandr | grep ' connected' | cut -d' ' -f1 | head -1)
fi
export PRIMARY_DISPLAY
echo PRIMARY_DISPLAY=$PRIMARY_DISPLAY

# find the Ethernet and Wifi network interface
export WLAN_INTERFACE=$(findiface wl)
export ETH_INTERFACE=$(findiface 'e[nt]')

# compton is required for transparency
compton -b &

# find an configuration file
config=
# global configuration
test -f /etc/polybar/config && config=/etc/polybar/config
# user configuration
test -f ~/.config/polybar/config && config=~/.config/polybar/config

echo "Polybar launch with $config"
polybar -c $config top &

command -v feh >&- && {
        # set wallpaper if available
        test -f /etc/wallpaper && feh --bg-scale /etc/wallpaper
}
