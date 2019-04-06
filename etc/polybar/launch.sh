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

# find the primary monitor
# Todo: check if primary monitor is connected, otherwise use the next connected
# device
export PRIMARY_DISPLAY=$(xrandr | grep ' connected' | cut -d' ' -f1 | head -1)
echo PRIMARY_DISPLAY=$PRIMARY_DISPLAY
# find the Ethernet and Wifi network interface
export WLAN_INTERFACE=$(findiface wl)
export ETH_INTERFACE=$(findiface en)

# required for transparency
compton &
polybar top &

echo "Bars launched..."
