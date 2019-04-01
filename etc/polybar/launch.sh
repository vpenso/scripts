#!/usr/bin/env bash


# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# find the first network interface matching $1
findiface() {
  ip a | grep '^[0-9]: ' | tr -d ' ' | cut -d: -f2 | grep $1 | head -1
}

# variables used within the polybar config
export WLAN_INTERFACE=$(findiface wl)
export ETH_INTERFACE=$(findiface en)

# required for transparency
compton &
polybar top &

echo "Bars launched..."
