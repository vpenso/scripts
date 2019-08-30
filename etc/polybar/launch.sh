#!/usr/bin/env bash


# Terminate already running bar instances
killall -q polybar

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

# required for transparency
compton -b &
polybar top &

echo "Bars launched..."
